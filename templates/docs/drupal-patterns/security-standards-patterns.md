# Drupal Security & Standards Patterns

Reference documentation for Drupal security and compliance validation. **Read when you need security examples.**

## Coding Standards Validation

### PHP_CodeSniffer
```bash
# Run coding standards check
./vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom/MODULE_NAME/

# Expected output: 0 errors, 0 warnings

# Fix automatically
./vendor/bin/phpcbf --standard=Drupal web/modules/custom/MODULE_NAME/
```

### PHPStan (Static Analysis)
```bash
# Run PHPStan for type safety
./vendor/bin/phpstan analyse web/modules/custom/MODULE_NAME/

# With specific level
./vendor/bin/phpstan analyse --level 6 web/modules/custom/MODULE_NAME/

# Expected: No errors
```

### drupal-check (Deprecation Detection)
```bash
# Check for deprecated code
drupal-check web/modules/custom/MODULE_NAME/

# Expected: No deprecated code usage
```

## SQL Injection Prevention

### ✅ CORRECT: Entity API
```php
// Use Entity Query with conditions
$nodes = \Drupal::entityQuery('node')
  ->condition('type', $type)
  ->condition('title', $title)
  ->accessCheck(TRUE)
  ->execute();

// Load entities
$nodes = \Drupal::entityTypeManager()
  ->getStorage('node')
  ->loadMultiple($nids);
```

### ✅ CORRECT: Database API with Placeholders
```php
// Named placeholders
$result = \Drupal::database()->query(
  'SELECT * FROM {node} WHERE type = :type',
  [':type' => $type]
);

// Multiple placeholders
$query = \Drupal::database()->select('node', 'n')
  ->fields('n', ['nid', 'title'])
  ->condition('type', $type)
  ->condition('status', 1)
  ->execute();
```

### ❌ INCORRECT: SQL Injection Vulnerability
```php
// NEVER do this - SQL injection risk
$query = "SELECT * FROM node WHERE type = '$type'";
db_query($query);

// NEVER concatenate user input
$query = "SELECT * FROM {users} WHERE name = '" . $username . "'";
```

## XSS Prevention

### ✅ CORRECT: Twig Auto-Escaping
```twig
{# Twig automatically escapes variables #}
{{ content.field_title }}
{{ node.label }}
{{ user.getDisplayName() }}

{# Render arrays are safe #}
{{ content }}
```

### ✅ CORRECT: PHP Sanitization
```php
use Drupal\Component\Utility\Html;
use Drupal\Component\Utility\Xss;

// Escape HTML entities
$safe_title = Html::escape($user_input);

// Filter allowed HTML tags
$safe_html = Xss::filter($user_input);

// Filter with allowed tags
$safe_html = Xss::filter($user_input, ['a', 'em', 'strong']);
```

### ✅ CORRECT: Render Arrays
```php
// Use #plain_text for user input
$build = [
  '#plain_text' => $user_input,
];

// Use #markup with sanitization
$build = [
  '#markup' => Html::escape($user_input),
];
```

### ❌ INCORRECT: XSS Vulnerability
```php
// NEVER output unescaped user input
echo $user_input;
print $user_input;

// NEVER use raw filter without validation
{{ user_input|raw }}

// NEVER trust user input
$build = ['#markup' => $user_input];  // DANGEROUS
```

## Access Control

### ✅ CORRECT: Entity Access Checks
```php
// Check entity access
if ($node->access('edit')) {
  // Allow editing
}

if ($node->access('delete', $account)) {
  // Allow deletion for specific user
}

// Always use access check in queries
$query = \Drupal::entityQuery('node')
  ->accessCheck(TRUE)  // REQUIRED
  ->condition('type', 'article')
  ->execute();
```

### ✅ CORRECT: Route Access
```yaml
# In *.routing.yml
my_module.admin:
  path: '/admin/my-module'
  defaults:
    _controller: '\Drupal\my_module\Controller\AdminController::dashboard'
  requirements:
    _permission: 'administer my module'
    # OR
    _role: 'administrator'
    # OR custom access check
    _custom_access: '\Drupal\my_module\Access\CustomAccess::check'
```

### ✅ CORRECT: Custom Access Control
```php
namespace Drupal\my_module\Access;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Session\AccountInterface;

class CustomAccess {

  public function check(AccountInterface $account) {
    // Custom logic
    if ($account->hasPermission('access content')) {
      return AccessResult::allowed();
    }
    return AccessResult::forbidden();
  }
}
```

### ❌ INCORRECT: Broken Access Control
```php
// NEVER skip access checks
$query = \Drupal::entityQuery('node')
  ->accessCheck(FALSE);  // DANGEROUS - bypasses access control

// NEVER assume user has access
$node->delete();  // Should check access first
```

## Input Sanitization

### ✅ CORRECT: Form Validation
```php
// Use built-in form element types
$form['email'] = [
  '#type' => 'email',  // Validates email format
  '#required' => TRUE,
];

$form['number'] = [
  '#type' => 'number',  // Validates numeric input
  '#min' => 0,
  '#max' => 100,
];

// Custom validation
public function validateForm(array &$form, FormStateInterface $form_state) {
  $value = $form_state->getValue('custom_field');
  if (!preg_match('/^[a-zA-Z0-9]+$/', $value)) {
    $form_state->setErrorByName('custom_field', $this->t('Invalid format.'));
  }
}
```

### ✅ CORRECT: URL Validation
```php
use Drupal\Component\Utility\UrlHelper;

// Validate external URL
if (!UrlHelper::isValid($url, TRUE)) {
  // Invalid URL
}

// Sanitize URL
$safe_url = UrlHelper::stripDangerousProtocols($url);
```

### ✅ CORRECT: File Upload Validation
```php
$form['upload'] = [
  '#type' => 'managed_file',
  '#upload_validators' => [
    'file_validate_extensions' => ['jpg jpeg png gif pdf'],
    'file_validate_size' => [5 * 1024 * 1024],  // 5MB
  ],
];
```

## CSRF Protection

### ✅ CORRECT: Form API (Automatic)
```php
// Form API provides automatic CSRF protection
public function submitForm(array &$form, FormStateInterface $form_state) {
  // Form token is automatically validated
  // Safe to process form data here
}
```

### ✅ CORRECT: Custom Routes with Token
```php
use Drupal\Core\Access\CsrfTokenGenerator;

// Generate token
$token = \Drupal::service('csrf_token')->get('my_action');

// Validate token
$is_valid = \Drupal::service('csrf_token')->validate($token, 'my_action');
```

### ❌ INCORRECT: Missing CSRF Protection
```php
// NEVER process state-changing actions without CSRF protection
public function deleteContent(Request $request) {
  $nid = $request->query->get('nid');
  $node = Node::load($nid);
  $node->delete();  // DANGEROUS - no CSRF protection
}
```

## Accessibility Compliance (WCAG 2.1 AA)

### Required Checks

**Semantic HTML**:
```html
<!-- ✅ CORRECT: Proper heading hierarchy -->
<h1>Page Title</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>

<!-- ❌ INCORRECT: Skipped heading level -->
<h1>Page Title</h1>
  <h3>Subsection</h3>
```

**Image Alt Text**:
```html
<!-- ✅ CORRECT: Meaningful alt text -->
<img src="logo.png" alt="Company Name Logo">

<!-- ✅ CORRECT: Decorative images -->
<img src="decoration.png" alt="">

<!-- ❌ INCORRECT: Missing alt text -->
<img src="photo.jpg">
```

**Form Labels**:
```html
<!-- ✅ CORRECT: Proper label association -->
<label for="email">Email Address</label>
<input type="email" id="email" name="email">

<!-- ✅ CORRECT: Drupal Form API (automatic) -->
$form['email'] = [
  '#type' => 'email',
  '#title' => $this->t('Email Address'),
];

<!-- ❌ INCORRECT: Missing label -->
<input type="text" placeholder="Enter email">
```

**Keyboard Navigation**:
```html
<!-- ✅ CORRECT: Keyboard accessible -->
<button type="submit">Submit</button>
<a href="/page">Link</a>

<!-- ❌ INCORRECT: Mouse-only interaction -->
<div onclick="doSomething()">Click me</div>
```

**Color Contrast**:
- Text: ≥4.5:1 contrast ratio
- Large text (18pt+): ≥3:1 contrast ratio
- UI components: ≥3:1 contrast ratio

**ARIA Attributes**:
```html
<!-- ✅ CORRECT: Appropriate ARIA usage -->
<button aria-label="Close dialog" aria-pressed="false">
  <span aria-hidden="true">×</span>
</button>

<nav aria-label="Main navigation">
  <!-- navigation links -->
</nav>
```

## Security Checklist

### Critical (Must Fix)
- ✅ No SQL injection vulnerabilities (use Entity API or parameterized queries)
- ✅ XSS protection implemented (Twig auto-escape, Html::escape)
- ✅ Access control on all routes and entities
- ✅ Input sanitization proper (Form API validation)
- ✅ No hardcoded credentials or sensitive data
- ✅ CSRF protection via Form API

### Important (Should Fix)
- ✅ Dependency injection used (no `\Drupal::` in classes)
- ✅ Proper error handling (no sensitive data in errors)
- ✅ Configuration exportable
- ✅ No deprecated code (drupal-check)
- ✅ File upload validation (extensions, size, MIME type)
- ✅ Rate limiting on forms (if applicable)
- ✅ Session management secure
- ✅ Permissions properly defined

### Code Quality
- ✅ PHPCS passes with Drupal,DrupalPractice standards
- ✅ PHPStan analysis passes
- ✅ No deprecated API usage
- ✅ Proper PHPDoc comments
- ✅ Type declarations on all methods
- ✅ Strict types enabled: `declare(strict_types=1);`

## Common Security Vulnerabilities

### Insecure Direct Object Reference
```php
// ❌ INCORRECT: No access check
Route::create('/node/{nid}/delete', function($nid) {
  Node::load($nid)->delete();
});

// ✅ CORRECT: Access check required
public function delete(NodeInterface $node) {
  if (!$node->access('delete')) {
    throw new AccessDeniedHttpException();
  }
  $node->delete();
}
```

### Mass Assignment
```php
// ❌ INCORRECT: Accepts all user input
$node = Node::create($request->request->all());

// ✅ CORRECT: Whitelist allowed fields
$node = Node::create([
  'type' => 'article',
  'title' => $form_state->getValue('title'),
  'body' => $form_state->getValue('body'),
]);
```

### Sensitive Data Exposure
```php
// ❌ INCORRECT: Exposes sensitive data
catch (Exception $e) {
  drupal_set_message($e->getMessage());
}

// ✅ CORRECT: Generic error message
catch (Exception $e) {
  \Drupal::logger('my_module')->error($e->getMessage());
  drupal_set_message($this->t('An error occurred.'));
}
```

## Composer Security

```bash
# Check for vulnerabilities
composer audit

# Update dependencies
composer update --with-all-dependencies

# Check for outdated packages
composer outdated --direct
```

## Security Update Commands

```bash
# Check for security updates
drush pm:security

# Update Drupal core
composer update drupal/core --with-all-dependencies

# Update specific module
composer update drupal/module_name

# Apply security updates
drush pm:security-php
```
