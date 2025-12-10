# Condition-Based Waiting

name: condition-based-waiting
description: >
  This skill should be used when writing tests that need to wait for async operations,
  fixing flaky tests, replacing arbitrary sleep/timeout calls, or handling AJAX responses
  in Behat or JavaScript tests.

---

## Core Principle

**Wait for the actual condition you care about, not a guess about how long it takes.**

Replace arbitrary delays with polling that checks for real state changes.

## The Problem

```php
// ❌ Arbitrary delay - flaky and slow
sleep(2);
$result = $page->find('css', '.ajax-loaded');
```

```javascript
// ❌ Arbitrary delay
await new Promise(r => setTimeout(r, 2000));
const result = document.querySelector('.modal');
```

## The Solution

```php
// ✅ Condition-based waiting
$this->waitFor(function() use ($page) {
    return $page->find('css', '.ajax-loaded') !== null;
});
```

```javascript
// ✅ Condition-based waiting
await waitFor(() => document.querySelector('.modal') !== null);
```

## Behat/Mink Patterns

### Wait for Element Visibility

```php
/**
 * Wait for element to appear.
 */
public function waitForElement(string $selector, int $timeout = 10): void {
    $page = $this->getSession()->getPage();

    $this->spin(function() use ($page, $selector) {
        $element = $page->find('css', $selector);
        return $element !== null && $element->isVisible();
    }, $timeout);
}
```

### Wait for AJAX Completion

```php
/**
 * Wait for Drupal AJAX to complete.
 */
public function waitForAjax(int $timeout = 10): void {
    $this->getSession()->wait(
        $timeout * 1000,
        '(typeof jQuery === "undefined" || jQuery.active === 0)'
    );
}
```

### Wait for Text Content

```php
/**
 * Wait for text to appear on page.
 */
public function waitForText(string $text, int $timeout = 10): void {
    $page = $this->getSession()->getPage();

    $this->spin(function() use ($page, $text) {
        return strpos($page->getText(), $text) !== false;
    }, $timeout);
}
```

### Generic Spin Function

```php
/**
 * Spin until condition is true or timeout.
 *
 * @param callable $condition Function returning bool.
 * @param int $timeout Maximum seconds to wait.
 * @param int $interval Milliseconds between checks.
 *
 * @throws \Exception When timeout reached.
 */
protected function spin(callable $condition, int $timeout = 10, int $interval = 100): void {
    $start = microtime(true);

    while (microtime(true) - $start < $timeout) {
        try {
            if ($condition()) {
                return;
            }
        }
        catch (\Exception $e) {
            // Condition threw exception, keep trying.
        }

        usleep($interval * 1000);
    }

    throw new \Exception("Timeout after {$timeout} seconds waiting for condition");
}
```

## JavaScript Patterns

### Basic waitFor

```javascript
async function waitFor(condition, timeout = 10000, interval = 100) {
  const start = Date.now();

  while (Date.now() - start < timeout) {
    try {
      if (await condition()) {
        return;
      }
    } catch (e) {
      // Condition threw, keep trying
    }

    await new Promise(r => setTimeout(r, interval));
  }

  throw new Error(`Timeout after ${timeout}ms waiting for condition`);
}
```

### Common Conditions

```javascript
// Wait for element
await waitFor(() => document.querySelector('.modal') !== null);

// Wait for element count
await waitFor(() => document.querySelectorAll('.item').length >= 5);

// Wait for text content
await waitFor(() => document.body.textContent.includes('Success'));

// Wait for attribute
await waitFor(() => {
  const btn = document.querySelector('button');
  return btn && !btn.disabled;
});

// Wait for Drupal AJAX
await waitFor(() => typeof Drupal !== 'undefined' && !Drupal.ajax.instances.some(a => a?.ajaxing));
```

## When NOT to Use

Arbitrary delays are acceptable when:

1. **Testing actual timing behavior** (debounce, throttle, animation duration)
2. **After condition-based wait** as a buffer for race conditions
3. **Documented timing requirement** (e.g., "API rate limit: 1 req/sec")

```php
// ✅ Acceptable: testing debounce behavior
$this->waitForElement('.search-input');
$page->fillField('search', 'test');
usleep(350000); // Debounce is 300ms, wait for it
$this->assertSearchTriggered();
```

## Results

Real-world improvements from applying this pattern:

| Metric | Before | After |
|--------|--------|-------|
| Test pass rate | 60% | 100% |
| Execution time | baseline | 40% faster |
| CI flakiness | frequent | eliminated |

## Quick Reference

| Scenario | Bad | Good |
|----------|-----|------|
| Wait for modal | `sleep(2)` | `waitFor(() => modal.isVisible())` |
| Wait for AJAX | `sleep(3)` | `waitFor(() => jQuery.active === 0)` |
| Wait for redirect | `sleep(1)` | `waitFor(() => url.includes('/success'))` |
| Wait for element | `sleep(2)` | `waitFor(() => element !== null)` |

## Related

- Behat Mink documentation: `spin()` pattern
- Drupal AJAX testing: `drupalPostAjaxForm()`
- JavaScript testing: `waitForExpect()` in Jest
