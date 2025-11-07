# Drupal Theme Development Patterns

Reference documentation for Drupal theming. **Read when you need theme examples.**

## Theme Structure

```
themes/custom/my_theme/
├── my_theme.info.yml
├── my_theme.libraries.yml
├── my_theme.theme
├── templates/
│   ├── page.html.twig
│   ├── node--article.html.twig
│   └── block--system-branding-block.html.twig
├── css/
│   └── style.css
├── js/
│   └── script.js
└── images/
```

## Basic .info.yml

```yaml
name: My Theme
type: theme
description: 'Custom theme'
core_version_requirement: ^10 || ^11
base theme: false

libraries:
  - my_theme/global-styling

regions:
  header: Header
  primary_menu: 'Primary menu'
  content: Content
  sidebar_first: 'Sidebar first'
  footer: Footer
```

## Libraries

```yaml
# my_theme.libraries.yml
global-styling:
  css:
    theme:
      css/style.css: {}
  js:
    js/script.js: {}
  dependencies:
    - core/drupal

component-carousel:
  css:
    component:
      css/components/carousel.css: {}
  js:
    js/components/carousel.js: {}
  dependencies:
    - core/jquery
```

## Twig Templates

```twig
{# templates/node--article.html.twig #}
<article{{ attributes.addClass('node--article') }}>
  {{ title_prefix }}
  {% if label %}
    <h2{{ title_attributes }}>{{ label }}</h2>
  {% endif %}
  {{ title_suffix }}

  {% if display_submitted %}
    <div class="node__meta">
      {{ author_picture }}
      <span>{{ author_name }}</span>
      <time>{{ date }}</time>
    </div>
  {% endif %}

  <div{{ content_attributes }}>
    {{ content }}
  </div>
</article>
```

## Preprocess Functions

```php
// my_theme.theme

/**
 * Implements hook_preprocess_node().
 */
function my_theme_preprocess_node(&$variables) {
  $node = $variables['node'];

  // Add custom variable
  $variables['custom_date'] = \Drupal::service('date.formatter')
    ->format($node->getCreatedTime(), 'custom');

  // Add class based on field value
  if ($node->hasField('field_featured') && $node->get('field_featured')->value) {
    $variables['attributes']['class'][] = 'node--featured';
  }
}

/**
 * Implements hook_preprocess_page().
 */
function my_theme_preprocess_page(&$variables) {
  // Add page-specific variables
  $variables['site_slogan'] = \Drupal::config('system.site')->get('slogan');
}

/**
 * Implements hook_theme_suggestions_HOOK_alter().
 */
function my_theme_theme_suggestions_node_alter(array &$suggestions, array $variables) {
  $node = $variables['elements']['#node'];

  // Add suggestion for node view mode
  $suggestions[] = 'node__' . $node->bundle() . '__' . $variables['elements']['#view_mode'];
}
```

## Attaching Libraries

```php
// Attach library to all pages
function my_theme_preprocess_html(&$variables) {
  $variables['#attached']['library'][] = 'my_theme/global-styling';
}

// Attach library conditionally
function my_theme_preprocess_node(&$variables) {
  if ($variables['node']->bundle() == 'article') {
    $variables['#attached']['library'][] = 'my_theme/article-enhancements';
  }
}
```

## Responsive Images

```yaml
# In theme or module config/install
responsive_image.styles.wide.yml:
  id: wide
  label: Wide
  image_style_mappings:
    - breakpoint_id: my_theme.mobile
      multiplier: 1x
      image_mapping_type: image_style
      image_mapping: thumbnail
    - breakpoint_id: my_theme.desktop
      multiplier: 1x
      image_mapping_type: image_style
      image_mapping: large
```

## Drupal Behaviors (JavaScript)

```javascript
// js/script.js
(function ($, Drupal) {
  'use strict';

  Drupal.behaviors.myCustomBehavior = {
    attach: function (context, settings) {
      // Run once per element
      $('.my-element', context).once('myCustomBehavior').each(function () {
        $(this).on('click', function() {
          // Handle click
        });
      });
    }
  };

})(jQuery, Drupal);
```

## Theme Commands

```bash
# Clear theme cache
drush cr

# Rebuild theme registry
drush theme:rebuild-registry

# Disable CSS/JS aggregation (dev)
drush config:set system.performance css.preprocess 0 -y
drush config:set system.performance js.preprocess 0 -y
```

## Breakpoints

```yaml
# my_theme.breakpoints.yml
my_theme.mobile:
  label: Mobile
  mediaQuery: '(max-width: 767px)'
  weight: 0
my_theme.tablet:
  label: Tablet
  mediaQuery: '(min-width: 768px) and (max-width: 1023px)'
  weight: 1
my_theme.desktop:
  label: Desktop
  mediaQuery: '(min-width: 1024px)'
  weight: 2
```
