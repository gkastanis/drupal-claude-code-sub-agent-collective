# Drupal Coding Standards

name: drupal-coding-standards
description: >
  PHPCS, PHPStan, naming conventions, and code style enforcement for
  Drupal 10/11. Use when checking coding standards, running static analysis,
  or enforcing code quality.

---

## Validation Commands

```bash
# Check coding standards.
./vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom/my_module/

# Auto-fix standards issues.
./vendor/bin/phpcbf --standard=Drupal web/modules/custom/my_module/

# Static analysis.
./vendor/bin/phpstan analyse web/modules/custom/my_module/

# Deprecation check.
drupal-check web/modules/custom/my_module/

# Security audit.
composer audit
```

## Required Code Patterns

### File Headers

```php
<?php

declare(strict_types=1);

namespace Drupal\my_module;
```

### Class Declaration

```php
/**
 * Manages content operations.
 */
final class ContentManager implements ContentManagerInterface {
```

### Constructor

```php
public function __construct(
  private readonly EntityTypeManagerInterface $entityTypeManager,
  private readonly LoggerInterface $logger,
) {}
```

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Local variables | `$snake_case` | `$user_name` |
| Class properties | `$lowerCamelCase` | `$this->entityManager` |
| Classes | `PascalCase` | `ContentManager` |
| Interfaces | `PascalCase` + `Interface` | `ContentManagerInterface` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Services | `module.service_name` | `my_module.content_manager` |
| Hooks | `module_hook_name` | `my_module_form_alter` |

## Anti-Patterns to Report

| Anti-Pattern | Fix |
|---|---|
| `foreach` with nested `if/break/continue` | `array_filter`/`array_map`/`array_reduce` |
| Deep nesting (3+ levels) | Guard clauses, early returns |
| Non-final classes without reason | Declare `final` by default |
| Getters/setters where `public readonly` works | Use `public readonly` |
| `\Drupal::` calls in classes | Constructor dependency injection |
| PHP `json_encode/decode` | `\GuzzleHttp\Utils::jsonDecode/jsonEncode` |
| "Service" namespace | Use logical groupings |
| Catching `\Exception` | Catch narrowest exception type |

## PHPDoc Standards

```php
/**
 * Loads articles by category.
 *
 * @param int $category_id
 *   The taxonomy term ID.
 * @param int $limit
 *   Maximum number of results.
 *
 * @return \Drupal\node\NodeInterface[]
 *   Array of article nodes.
 *
 * @throws \Drupal\Component\Plugin\Exception\InvalidPluginDefinitionException
 */
public function loadByCategory(int $category_id, int $limit = 10): array {
```

## Module Structure

```
modules/custom/my_module/
  my_module.info.yml
  my_module.module
  my_module.services.yml
  my_module.routing.yml
  my_module.permissions.yml
  config/
    install/
    schema/
  src/
    Controller/
    Form/
    Plugin/
      Block/
    EventSubscriber/
  tests/
    src/
      Unit/
      Kernel/
      Functional/
```

## Drush Generators (Non-Interactive)

Use `--answers` for scripted, non-interactive code generation.

### Common Generators

```bash
# Generate a module.
drush generate module --answers='{"name":"My Module","machine_name":"my_module","description":"Module description.","package":"Custom","dependencies":"drupal:node","install_file":true}'

# Generate a controller.
drush generate controller --answers='{"module":"my_module","class":"MyController","route_name":"my_module.page","route_path":"/my-module/page","route_title":"My Page"}'

# Generate a simple form.
drush generate form-simple --answers='{"module":"my_module","class":"MyForm","form_id":"my_module_my_form","route":"yes","route_name":"my_module.my_form","route_path":"/admin/config/my-module","route_title":"My Form","route_permission":"administer site configuration"}'

# Generate a config form.
drush generate form-config --answers='{"module":"my_module","class":"SettingsForm","form_id":"my_module_settings","route":"yes","route_name":"my_module.settings","route_path":"/admin/config/my-module/settings","route_title":"Settings","route_permission":"administer site configuration"}'

# Generate a block plugin.
drush generate plugin:block --answers='{"module":"my_module","plugin_id":"my_block","admin_label":"My Block","class":"MyBlock","category":"Custom"}'

# Generate a service.
drush generate service --answers='{"module":"my_module","service_name":"my_module.my_service","class":"MyService"}'

# Generate a field.
drush field:create node article --field-name=field_subtitle --field-type=string
```

### Tips

- Use `--dry-run` to discover required answer keys without generating files.
- Always run `drush cex -y` after CLI changes to export config.
- Run `drush cr` after generating new plugins or services.

### Common Field Types

| Type | Machine name |
|---|---|
| Text (plain) | `string` |
| Text (long) | `text_long` |
| Text (formatted, long) | `text_long` |
| Boolean | `boolean` |
| Integer | `integer` |
| Decimal | `decimal` |
| Float | `float` |
| Email | `email` |
| Link | `link` |
| Entity reference | `entity_reference` |
| Image | `image` |
| File | `file` |
| Date | `datetime` |
| Timestamp | `timestamp` |
| List (text) | `list_string` |
| List (integer) | `list_integer` |

## Deprecated APIs

Replace legacy function calls with their modern service equivalents.

| Deprecated | Replacement |
|---|---|
| `drupal_set_message()` | `\Drupal::messenger()->addMessage()` |
| `format_date()` | `\Drupal::service('date.formatter')->format()` |
| `entity_load()` | `\Drupal::entityTypeManager()->getStorage()->load()` |
| `entity_load_multiple()` | `\Drupal::entityTypeManager()->getStorage()->loadMultiple()` |
| `db_select()` / `db_query()` | `\Drupal::database()->select()` / `->query()` |
| `drupal_render()` | `\Drupal::service('renderer')->render()` |
| `\Drupal::l()` | `Link::fromTextAndUrl()` |
| `drupal_get_path()` | `\Drupal::service('extension.list.module')->getPath()` |
| `file_create_url()` | `\Drupal::service('file_url_generator')->generateAbsoluteString()` |
| `unicode_strlen()` | `mb_strlen()` |

Use `drupal-check` to scan for deprecated API usage: `drupal-check web/modules/custom/my_module/`.
