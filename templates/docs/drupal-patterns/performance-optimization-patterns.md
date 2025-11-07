# Drupal Performance Optimization Patterns

Reference documentation for Drupal performance. **Read when you need optimization examples.**

## Caching Strategies

### Render Caching
```php
$build = [
  '#markup' => 'Expensive content',
  '#cache' => [
    'keys' => ['my_module', 'block', $id],
    'contexts' => ['user', 'url'],
    'tags' => ['node:' . $node->id()],
    'max-age' => 3600,
  ],
];
```

### Cache Tags
```php
// Invalidate cache when node changes
Cache::invalidateTags(['node:' . $node->id()]);

// Add cache tags to render array
$build['#cache']['tags'][] = 'node_list';
```

### Cache Contexts
```php
// Common contexts
'contexts' => [
  'user',           // Per-user caching
  'user.roles',     // Per-role caching
  'languages',      // Per-language
  'url',            // Per-URL
  'url.path',       // Per-path
  'url.query_args', // Per-query string
];
```

## Database Query Optimization

### Entity Query Optimization
```php
// Good: Use range for pagination
$nids = \Drupal::entityQuery('node')
  ->condition('type', 'article')
  ->condition('status', 1)
  ->range(0, 10)
  ->sort('created', 'DESC')
  ->execute();

// Load only needed fields
$nodes = \Drupal::entityTypeManager()
  ->getStorage('node')
  ->loadMultiple($nids);
```

### Avoid N+1 Queries
```php
// Bad: Loads each node individually
foreach ($nids as $nid) {
  $node = Node::load($nid); // N queries!
}

// Good: Load all at once
$nodes = Node::loadMultiple($nids); // 1 query
```

## Redis/Memcache Setup

### settings.php
```php
// Redis configuration
$settings['redis.connection']['interface'] = 'PhpRedis';
$settings['redis.connection']['host'] = 'redis';
$settings['cache']['default'] = 'cache.backend.redis';

// Memcache configuration
$settings['memcache']['servers'] = ['127.0.0.1:11211' => 'default'];
$settings['cache']['default'] = 'cache.backend.memcache';
```

## BigPipe & Dynamic Page Cache

```php
// Enable BigPipe for lazy loading
$build['expensive_part'] = [
  '#lazy_builder' => ['my_module.lazy_builder:build', [$id]],
  '#create_placeholder' => TRUE,
];

// Lazy builder service
public function build($id) {
  return ['#markup' => $this->expensiveOperation($id)];
}
```

## Image Optimization

```php
// Use responsive image styles
$build['image'] = [
  '#type' => 'responsive_image',
  '#responsive_image_style_id' => 'wide',
  '#uri' => $file->getFileUri(),
];

// Lazy loading
$build['image'] = [
  '#theme' => 'image',
  '#uri' => $uri,
  '#attributes' => ['loading' => 'lazy'],
];
```

## Aggregation & CDN

```bash
# Enable CSS/JS aggregation
drush config:set system.performance css.preprocess 1 -y
drush config:set system.performance js.preprocess 1 -y

# Set cache max-age
drush config:set system.performance cache.page.max_age 3600 -y
```

### CDN Configuration
```php
// settings.php
$config['cdn.settings']['status'] = TRUE;
$config['cdn.settings']['mapping']['type'] = 'simple';
$config['cdn.settings']['mapping']['domain'] = 'cdn.example.com';
```

## Performance Commands

```bash
# Check performance config
drush config:get system.performance

# Clear specific caches
drush cache:clear render
drush cache:clear discovery

# Rebuild cache
drush cr

# Database optimization
drush sql:query "OPTIMIZE TABLE cache_render"
```

## Performance Checklist

- ✅ CSS/JS aggregation enabled
- ✅ Page cache enabled (anonymous users)
- ✅ Render caching configured
- ✅ Redis/Memcache for cache backend
- ✅ Image optimization (WebP, lazy loading)
- ✅ CDN configured for static assets
- ✅ Database queries optimized (no N+1)
- ✅ Cron running regularly
- ✅ Views using caching
- ✅ BigPipe enabled for dynamic content
