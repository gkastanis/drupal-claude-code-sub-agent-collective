# Drupal PHPUnit Testing Patterns

Reference documentation for PHPUnit testing in Drupal. **Read this using the Read tool when you need specific examples.**

## Test Type Matrix

| Type | Bootstrap | Database | Speed | Use Case |
|------|-----------|----------|-------|----------|
| **Unit** | None | No | Fast | Pure logic, calculations |
| **Kernel** | Minimal | Yes | Medium | Services, plugins, queries |
| **Functional** | Full | Yes | Slow | Complete features, forms |
| **FunctionalJavascript** | Full + Browser | Yes | Slowest | JavaScript, AJAX |

## Unit Tests

### Basic Structure
```php
namespace Drupal\Tests\my_module\Unit;
use Drupal\Tests\UnitTestCase;

class MyServiceTest extends UnitTestCase {
  protected $service;

  protected function setUp(): void {
    parent::setUp();
    $this->service = new MyService();
  }

  public function testCalculateTotal() {
    $items = [['price' => 10.00, 'quantity' => 2]];
    $this->assertEquals(20.00, $this->service->calculateTotal($items));
  }
}
```

### Mocking Dependencies
```php
public function testGetRecentArticles() {
  $entity_type_manager = $this->createMock(EntityTypeManagerInterface::class);
  $storage = $this->createMock('\Drupal\node\NodeStorageInterface');

  $entity_type_manager->expects($this->once())
    ->method('getStorage')
    ->with('node')
    ->willReturn($storage);

  $service = new ArticleService($entity_type_manager);
}
```

### Data Providers
```php
/**
 * @dataProvider emailProvider
 */
public function testValidateEmail($email, $expected) {
  $this->assertEquals($expected, $this->service->validateEmail($email));
}

public function emailProvider() {
  return [
    ['user@example.com', TRUE],
    ['invalid-email', FALSE],
  ];
}
```

## Kernel Tests

### Basic Setup
```php
namespace Drupal\Tests\my_module\Kernel;
use Drupal\KernelTests\KernelTestBase;

class NodeOperationsTest extends KernelTestBase {
  protected static $modules = ['system', 'user', 'node', 'my_module'];

  protected function setUp(): void {
    parent::setUp();
    $this->installEntitySchema('user');
    $this->installEntitySchema('node');
    $this->installSchema('node', ['node_access']);
  }
}
```

### Testing Services
```php
public function testFindFeaturedArticles() {
  // Get service from container
  $this->articleManager = $this->container->get('my_module.article_manager');

  // Create test data
  $this->createArticle('Article 1', TRUE);
  $this->createArticle('Article 2', FALSE);

  // Test
  $featured = $this->articleManager->getFeaturedArticles();
  $this->assertCount(1, $featured);
}
```

### Testing Plugins
```php
public function testBlockBuild() {
  $block = $this->container
    ->get('plugin.manager.block')
    ->createInstance('recent_articles_block', []);

  $build = $block->build();
  $this->assertIsArray($build);
  $this->assertArrayHasKey('#theme', $build);
}
```

## Functional Tests

### Form Submission
```php
namespace Drupal\Tests\my_module\Functional;
use Drupal\Tests\BrowserTestBase;

class CustomFormTest extends BrowserTestBase {
  protected $defaultTheme = 'stark';
  protected static $modules = ['my_module', 'node'];

  public function testFormSubmission() {
    $user = $this->drupalCreateUser(['access custom form']);
    $this->drupalLogin($user);

    $this->drupalGet('/admin/config/my-module/form');
    $this->submitForm(['setting_name' => 'Test'], 'Save');

    $this->assertSession()->pageTextContains('Configuration saved');
  }
}
```

### Access Control
```php
public function testAnonymousAccessDenied() {
  $this->drupalGet('/admin/my-module/dashboard');
  $this->assertSession()->statusCodeEquals(403);
}

public function testAuthorizedAccess() {
  $user = $this->drupalCreateUser(['access dashboard']);
  $this->drupalLogin($user);
  $this->drupalGet('/admin/my-module/dashboard');
  $this->assertSession()->statusCodeEquals(200);
}
```

### REST API Testing
```php
public function testGetEndpoint() {
  $url = '/api/articles/' . $node->id();
  $response = $this->drupalGet($url, [], ['Accept' => 'application/json']);

  $this->assertSession()->statusCodeEquals(200);
  $data = json_decode($response, TRUE);
  $this->assertEquals('Test Title', $data['title']);
}
```

## FunctionalJavascript Tests

### AJAX Testing
```php
use Drupal\FunctionalJavascriptTests\WebDriverTestBase;

class AjaxTest extends WebDriverTestBase {
  public function testAjaxSubmission() {
    $page = $this->getSession()->getPage();
    $page->fillField('search', 'test');
    $page->pressButton('Search');

    $this->assertSession()->assertWaitOnAjaxRequest();
    $this->assertSession()->elementExists('css', '.ajax-results');
  }
}
```

### Autocomplete
```php
public function testAutocomplete() {
  $page = $this->getSession()->getPage();
  $field = $page->findField('search');
  $field->setValue('drup');

  $this->assertSession()->waitForElementVisible('css', '.ui-autocomplete');
  $this->assertSession()->elementTextContains('css', '.ui-autocomplete', 'Drupal');
}
```

## JavaScript Unit Testing (Jest)

```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  roots: ['<rootDir>/tests/js'],
  testMatch: ['**/*.test.js'],
};

// Test Drupal behaviors
global.Drupal = { behaviors: {}, t: (str) => str };
require('../../js/my-behavior.js');

test('behavior attaches', () => {
  Drupal.behaviors.myBehavior.attach(document);
  expect(document.querySelector('.processed')).toBeTruthy();
});
```

## Coverage & Configuration

### PHPUnit Commands
```bash
# Run tests
./vendor/bin/phpunit --testsuite=unit
./vendor/bin/phpunit --testsuite=kernel
./vendor/bin/phpunit --filter=testCalculateTotal

# Coverage
./vendor/bin/phpunit --coverage-html coverage-report
./vendor/bin/phpunit --coverage-text
```

### PHPUnit Configuration
```xml
<phpunit bootstrap="web/core/tests/bootstrap.php" colors="true">
  <testsuites>
    <testsuite name="unit">
      <directory>web/modules/custom/*/tests/src/Unit</directory>
    </testsuite>
  </testsuites>
  <coverage>
    <include>
      <directory>web/modules/custom/*/src</directory>
    </include>
  </coverage>
</phpunit>
```

## Quality Standards

- ✅ 80%+ code coverage
- ✅ Proper test isolation (setUp/tearDown)
- ✅ Mock external dependencies
- ✅ One test class per production class
- ✅ @group and @covers annotations
- ✅ Tests are fast and deterministic
