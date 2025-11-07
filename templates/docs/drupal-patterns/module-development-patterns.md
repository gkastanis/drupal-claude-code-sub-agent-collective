# Drupal Module Development Patterns

Reference documentation for Drupal custom module development. **Read when you need module examples.**

## Module Structure

```
modules/custom/my_module/
├── my_module.info.yml
├── my_module.module
├── my_module.services.yml
├── my_module.routing.yml
├── my_module.permissions.yml
├── config/
│   ├── install/
│   │   └── my_module.settings.yml
│   └── schema/
│       └── my_module.schema.yml
└── src/
    ├── Plugin/
    │   └── Block/
    │       └── MyBlock.php
    ├── Controller/
    │   └── MyController.php
    ├── Form/
    │   └── MyForm.php
    └── Service/
        └── MyService.php
```

## Essential Files

### my_module.info.yml
```yaml
name: My Module
type: module
description: 'Custom functionality for my site'
core_version_requirement: ^10 || ^11
package: Custom
dependencies:
  - drupal:node
  - drupal:views
```

### my_module.services.yml
```yaml
services:
  my_module.my_service:
    class: Drupal\my_module\Service\MyService
    arguments: ['@entity_type.manager', '@logger.channel.my_module']
```

## Block Plugin Example

```php
namespace Drupal\my_module\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides a 'Recent Articles' block.
 *
 * @Block(
 *   id = "recent_articles_block",
 *   admin_label = @Translation("Recent Articles"),
 *   category = @Translation("Custom")
 * )
 */
class RecentArticlesBlock extends BlockBase implements ContainerFactoryPluginInterface {

  protected $nodeStorage;

  public function __construct(array $configuration, $plugin_id, $plugin_definition, $node_storage) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->nodeStorage = $node_storage;
  }

  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager')->getStorage('node')
    );
  }

  public function build() {
    $nids = $this->nodeStorage->getQuery()
      ->condition('type', 'article')
      ->condition('status', 1)
      ->sort('created', 'DESC')
      ->range(0, 5)
      ->accessCheck(TRUE)
      ->execute();

    $nodes = $this->nodeStorage->loadMultiple($nids);

    return [
      '#theme' => 'item_list',
      '#items' => array_map(fn($node) => $node->toLink(), $nodes),
      '#cache' => [
        'tags' => ['node_list:article'],
        'max-age' => 3600,
      ],
    ];
  }
}
```

## Service Example

```php
namespace Drupal\my_module\Service;

use Drupal\Core\Entity\EntityTypeManagerInterface;
use Psr\Log\LoggerInterface;

/**
 * Provides article management functionality.
 */
class ArticleManager {

  protected $nodeStorage;
  protected $logger;

  public function __construct(EntityTypeManagerInterface $entity_type_manager, LoggerInterface $logger) {
    $this->nodeStorage = $entity_type_manager->getStorage('node');
    $this->logger = $logger;
  }

  public function getFeaturedArticles($limit = 5) {
    $nids = $this->nodeStorage->getQuery()
      ->condition('type', 'article')
      ->condition('field_featured', 1)
      ->condition('status', 1)
      ->sort('created', 'DESC')
      ->range(0, $limit)
      ->accessCheck(TRUE)
      ->execute();

    return $this->nodeStorage->loadMultiple($nids);
  }
}
```

## Hook Implementations

```php
// my_module.module

/**
 * Implements hook_form_FORM_ID_alter() for node_article_form.
 */
function my_module_form_node_article_form_alter(&$form, $form_state, $form_id) {
  $form['title']['widget'][0]['value']['#description'] = t('Enter a descriptive title.');
}

/**
 * Implements hook_entity_presave() for nodes.
 */
function my_module_node_presave($entity) {
  if ($entity->bundle() == 'article') {
    // Auto-generate summary if empty.
    if (empty($entity->get('body')->summary)) {
      $body = $entity->get('body')->value;
      $entity->get('body')->summary = text_summary($body, NULL, 200);
    }
  }
}

/**
 * Implements hook_theme().
 */
function my_module_theme($existing, $type, $theme, $path) {
  return [
    'my_custom_template' => [
      'variables' => [
        'title' => NULL,
        'content' => NULL,
      ],
      'template' => 'my-custom-template',
    ],
  ];
}
```

## Field Formatter Plugin

```php
namespace Drupal\my_module\Plugin\Field\FieldFormatter;

use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Field\FormatterBase;

/**
 * Plugin implementation of custom field formatter.
 *
 * @FieldFormatter(
 *   id = "custom_text_formatter",
 *   label = @Translation("Custom Text"),
 *   field_types = {
 *     "text",
 *     "text_long"
 *   }
 * )
 */
class CustomTextFormatter extends FormatterBase {

  public function viewElements(FieldItemListInterface $items, $langcode) {
    $elements = [];
    foreach ($items as $delta => $item) {
      $elements[$delta] = [
        '#markup' => strtoupper($item->value),
      ];
    }
    return $elements;
  }
}
```

## Field Widget Plugin

```php
namespace Drupal\my_module\Plugin\Field\FieldWidget;

use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Field\WidgetBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Plugin implementation of custom field widget.
 *
 * @FieldWidget(
 *   id = "custom_text_widget",
 *   label = @Translation("Custom Text Input"),
 *   field_types = {
 *     "text"
 *   }
 * )
 */
class CustomTextWidget extends WidgetBase {

  public function formElement(FieldItemListInterface $items, $delta, array $element, array &$form, FormStateInterface $form_state) {
    $element['value'] = $element + [
      '#type' => 'textfield',
      '#default_value' => $items[$delta]->value ?? '',
      '#size' => 60,
      '#maxlength' => 255,
    ];
    return $element;
  }
}
```

## Controller & Routing

### my_module.routing.yml
```yaml
my_module.dashboard:
  path: '/admin/my-module/dashboard'
  defaults:
    _controller: '\Drupal\my_module\Controller\DashboardController::dashboard'
    _title: 'Dashboard'
  requirements:
    _permission: 'access my module dashboard'

my_module.ajax_callback:
  path: '/my-module/ajax/{node}'
  defaults:
    _controller: '\Drupal\my_module\Controller\AjaxController::callback'
  requirements:
    _permission: 'access content'
    node: \d+
  options:
    parameters:
      node:
        type: entity:node
```

### Controller
```php
namespace Drupal\my_module\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Entity\EntityTypeManagerInterface;

class DashboardController extends ControllerBase {

  protected $entityTypeManager;

  public function __construct(EntityTypeManagerInterface $entity_type_manager) {
    $this->entityTypeManager = $entity_type_manager;
  }

  public static function create(ContainerInterface $container) {
    return new static(
      $container->get('entity_type.manager')
    );
  }

  public function dashboard() {
    $build = [
      '#theme' => 'my_module_dashboard',
      '#data' => $this->getDashboardData(),
      '#cache' => [
        'max-age' => 3600,
        'contexts' => ['user'],
      ],
    ];
    return $build;
  }

  protected function getDashboardData() {
    // Custom logic.
    return [];
  }
}
```

## Form API

```php
namespace Drupal\my_module\Form;

use Drupal\Core\Form\ConfigFormBase;
use Drupal\Core\Form\FormStateInterface;

class SettingsForm extends ConfigFormBase {

  protected function getEditableConfigNames() {
    return ['my_module.settings'];
  }

  public function getFormId() {
    return 'my_module_settings_form';
  }

  public function buildForm(array $form, FormStateInterface $form_state) {
    $config = $this->config('my_module.settings');

    $form['api_key'] = [
      '#type' => 'textfield',
      '#title' => $this->t('API Key'),
      '#default_value' => $config->get('api_key'),
      '#required' => TRUE,
    ];

    $form['enable_feature'] = [
      '#type' => 'checkbox',
      '#title' => $this->t('Enable Feature'),
      '#default_value' => $config->get('enable_feature'),
    ];

    return parent::buildForm($form, $form_state);
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {
    $this->config('my_module.settings')
      ->set('api_key', $form_state->getValue('api_key'))
      ->set('enable_feature', $form_state->getValue('enable_feature'))
      ->save();

    parent::submitForm($form, $form_state);
  }
}
```

## Event Subscriber

```php
namespace Drupal\my_module\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\KernelEvents;

class MyModuleSubscriber implements EventSubscriberInterface {

  public static function getSubscribedEvents() {
    $events[KernelEvents::REQUEST][] = ['onRequest', 100];
    return $events;
  }

  public function onRequest(RequestEvent $event) {
    // Custom logic on request.
  }
}
```

### Register Event Subscriber in .services.yml
```yaml
services:
  my_module.event_subscriber:
    class: Drupal\my_module\EventSubscriber\MyModuleSubscriber
    tags:
      - { name: event_subscriber }
```

## Permissions

### my_module.permissions.yml
```yaml
access my module dashboard:
  title: 'Access My Module Dashboard'
  description: 'View the custom dashboard'

administer my module:
  title: 'Administer My Module'
  restrict access: TRUE
```

## Configuration Schema

### config/schema/my_module.schema.yml
```yaml
my_module.settings:
  type: config_object
  label: 'My Module Settings'
  mapping:
    api_key:
      type: string
      label: 'API Key'
    enable_feature:
      type: boolean
      label: 'Enable Feature'
```

## Drush Commands (Drupal 10+)

```php
namespace Drupal\my_module\Commands;

use Drush\Commands\DrushCommands;

/**
 * Drush commands for my_module.
 */
class MyModuleCommands extends DrushCommands {

  /**
   * Import custom data.
   *
   * @command my_module:import
   * @aliases mmi
   */
  public function import() {
    $this->output()->writeln('Importing data...');
    // Custom import logic.
    $this->logger()->success('Import complete!');
  }
}
```

## Best Practices Checklist

- ✅ Use dependency injection (never `\Drupal::service()` in classes)
- ✅ Use Entity API for all entity operations
- ✅ Implement proper access control
- ✅ Add cache tags and contexts
- ✅ Use translation functions (`t()`, `@Translation`)
- ✅ Follow PSR-4 autoloading
- ✅ Document all functions with PHPDoc
- ✅ Use strict types: `declare(strict_types=1);`
- ✅ Configuration in `config/install/`, not `hook_install()`
- ✅ Export configuration: `ddev drush cex -y`
