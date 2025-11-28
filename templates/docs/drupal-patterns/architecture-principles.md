# Architecture Principles for Drupal Development

**Read when:** Designing Drupal architectures, creating module interfaces, or refactoring existing code.

This document provides comprehensive architectural guidance based on Rich Hickey and Eskil Steenberg's principles, applied to Drupal CMS development.

---

## Quick Reference Checklist

Use this checklist when designing or reviewing Drupal code:

**Module Design:**
- ✅ Single, clear responsibility (can one developer maintain this?)
- ✅ Clean service interfaces with hidden implementation details
- ✅ Module can be rewritten using only its public API
- ✅ Explicit dependencies via dependency injection
- ✅ No "magic" behavior or hidden side effects

**Data & Architecture:**
- ✅ Core data primitives identified and consistent
- ✅ Favor composition over inheritance
- ✅ Simple data structures over complex objects
- ✅ Entity API patterns used correctly
- ✅ Configuration is exportable and versioned

**Quality Gates:**
- ❌ Modules doing multiple unrelated things
- ❌ Service methods exposing implementation details
- ❌ Direct class dependencies (should use interfaces)
- ❌ Global state or hidden mutations
- ❌ Tight coupling between modules

---

## Rich Hickey Principles

Rich Hickey (creator of Clojure) emphasizes simplicity, immutability, and explicit design.

### 1. Simplicity over Ease

**Principle**: Simple means not entangled, independent, and understandable. Easy means familiar or convenient.

**Drupal Application**:

✅ **Simple Approach:**
```php
// Service with single responsibility
class ArticleStatisticsService {
  public function getArticleViewCount(int $nid): int {
    // Clear, focused responsibility
    return $this->database->query(
      'SELECT view_count FROM {article_statistics} WHERE nid = :nid',
      [':nid' => $nid]
    )->fetchField();
  }
}
```

❌ **Easy but Complex:**
```php
// Service trying to do everything
class ArticleService {
  public function doEverything($nid, $action = 'view') {
    // Multiple responsibilities tangled together
    if ($action == 'view') {
      $this->incrementViews($nid);
      $this->logAccess($nid);
      $this->sendNotification($nid);
    } elseif ($action == 'edit') {
      // Different logic path...
    }
    // Hard to understand, test, or modify
  }
}
```

**Why Simple is Better**:
- Easy to test (single responsibility)
- Easy to replace (clear interface)
- Easy to understand (focused purpose)

### 2. Value-Oriented Programming

**Principle**: Build on values (immutable data) instead of mutable state. Values are timeless and context-free.

**Drupal Application**:

✅ **Value-Oriented:**
```php
// Entity as value - load, transform, save
$node = Node::load($nid);
$updated_node = $this->transformNode($node); // Returns new data
$updated_node->save();

// Configuration as values
$config = $this->config('my_module.settings');
$threshold = $config->get('threshold'); // Immutable value
```

❌ **Mutable State:**
```php
// Global state mutation (avoid this)
global $my_module_state;
$my_module_state['count']++; // Hidden mutation

// Service with mutable internal state
class StatefulService {
  private $count = 0; // Mutable state

  public function process() {
    $this->count++; // Side effect
  }
}
```

**Drupal Best Practice**:
- Treat loaded entities as values
- Use configuration system for immutable settings
- Avoid service properties that change during execution

### 3. Time as a First-Class Concern

**Principle**: State changes are values at points in time. Model data over time explicitly.

**Drupal Application**:

✅ **Time-Aware Design:**
```php
// Entity revisions track state over time
$node = Node::load($nid);
$revision_ids = $this->entityTypeManager
  ->getStorage('node')
  ->revisionIds($node);

// Each revision is a value at a point in time
foreach ($revision_ids as $vid) {
  $revision = $this->entityTypeManager
    ->getStorage('node')
    ->loadRevision($vid);
  // Process historical state
}
```

**Drupal Tools for Time**:
- Entity revisions (content history)
- `created` and `changed` timestamps
- Configuration sync (state at deployment time)
- Database update hooks (schema evolution over time)

### 4. Data over Objects

**Principle**: Emphasize simple data structures instead of opaque objects with methods.

**Drupal Application**:

✅ **Data-Oriented:**
```php
// Render arrays (data structures)
$build = [
  '#theme' => 'article_teaser',
  '#title' => $node->getTitle(),
  '#body' => $node->get('body')->value,
  '#cache' => [
    'tags' => $node->getCacheTags(),
  ],
];

// Simple data transformation
function transformArticleData(array $data): array {
  return [
    'title' => $data['title'],
    'summary' => substr($data['body'], 0, 200),
    'read_time' => calculateReadTime($data['body']),
  ];
}
```

❌ **Object-Heavy:**
```php
// Overly complex object hierarchy
class ArticleWrapper {
  private $article;

  public function getTitle() { /* ... */ }
  public function getSummary() { /* ... */ }
  public function getReadTime() { /* ... */ }
  // Methods hide simple data transformations
}
```

**Drupal's Data Structures**:
- Render arrays
- Entity field arrays
- Configuration arrays
- Form API arrays

### 5. Composition over Inheritance

**Principle**: Build systems from small, independent parts rather than deep class hierarchies.

**Drupal Application**:

✅ **Composition:**
```php
// Service composition via dependency injection
class ArticlePublisher {

  public function __construct(
    private NotificationService $notifier,
    private StatisticsService $stats,
    private CacheInvalidator $cache,
  ) {}

  public function publish(NodeInterface $node): void {
    $node->setPublished(TRUE);
    $node->save();

    // Compose behavior from services
    $this->notifier->sendPublishedNotification($node);
    $this->stats->recordPublication($node);
    $this->cache->invalidateArticleCache($node);
  }
}
```

❌ **Deep Inheritance:**
```php
class BaseArticle { /* ... */ }
class PublishableArticle extends BaseArticle { /* ... */ }
class NotifiableArticle extends PublishableArticle { /* ... */ }
class CachedArticle extends NotifiableArticle { /* ... */ }
// Fragile, coupled hierarchy
```

**Drupal Composition Patterns**:
- Service composition via DI
- Plugin composition (blocks, field formatters)
- Event subscriber composition
- Middleware composition (for API routes)

### 6. Explicitness and Transparency

**Principle**: Avoid hidden side effects, implicit contracts, and "magic". Make data flows clear.

**Drupal Application**:

✅ **Explicit:**
```php
// Clear dependencies in constructor
public function __construct(
  EntityTypeManagerInterface $entityTypeManager,
  LoggerInterface $logger,
  CacheBackendInterface $cache,
) {
  $this->entityTypeManager = $entityTypeManager;
  $this->logger = $logger;
  $this->cache = $cache;
}

// Explicit function parameters
public function calculateScore(int $views, int $comments, int $age_days): float {
  return ($views * 2 + $comments * 5) / max($age_days, 1);
}
```

❌ **Implicit Magic:**
```php
// Hidden dependencies via global state
public function doSomething() {
  $user = \Drupal::currentUser(); // Hidden dependency
  $config = \Drupal::config('my.settings'); // Hidden dependency
}

// Magic behavior via static methods
public static function process($data) {
  // What dependencies does this have?
  // What state does it modify?
}
```

---

## Eskil Steenberg Principles

Eskil Steenberg focuses on building large-scale systems that remain maintainable over decades.

### 1. Black Box Design

**Principle**: Every module should be a black box with a clean, documented API. Implementation details must be completely hidden.

**Drupal Application**:

✅ **Black Box Module:**
```php
// Public API (interface)
interface ArticleRecommendationInterface {
  /**
   * Get recommended articles for a user.
   *
   * @param int $uid
   *   User ID.
   * @param int $limit
   *   Number of recommendations.
   *
   * @return \Drupal\node\NodeInterface[]
   *   Array of recommended article nodes.
   */
  public function getRecommendations(int $uid, int $limit = 5): array;
}

// Implementation (hidden)
class ArticleRecommendationService implements ArticleRecommendationInterface {
  public function getRecommendations(int $uid, int $limit = 5): array {
    // Implementation details hidden
    // Could use ML, simple scoring, or random
    // Consumers don't know or care
  }
}
```

**Module Structure**:
```
my_module/
├── my_module.services.yml       # Public service definitions
├── src/
│   ├── ArticleRecommendationInterface.php  # PUBLIC API
│   └── ArticleRecommendationService.php    # Private implementation
```

**Black Box Benefits**:
- Can rewrite implementation without breaking consumers
- Easy to test (mock the interface)
- Clear separation of concerns

### 2. Replaceable Components

**Principle**: Any module should be rewritable from scratch using only its interface. If you can't understand a module, it should be easy to replace.

**Drupal Application**:

✅ **Replaceable Service:**
```php
// Service definition with interface
services:
  my_module.search:
    class: Drupal\my_module\Search\DatabaseSearch
    arguments: ['@database', '@entity_type.manager']

# Can replace implementation later
services:
  my_module.search:
    class: Drupal\my_module\Search\ElasticsearchSearch
    arguments: ['@elasticsearch.client', '@entity_type.manager']

# Consumers don't need to change - same interface
```

**Test for Replaceability**:
1. Can you list all public methods without reading the code?
2. Can you implement the interface without looking at the original?
3. Would consumers break if you swapped implementations?

If "yes" to all three, it's replaceable.

### 3. Single Responsibility Modules

**Principle**: One module = one person should be able to build/maintain it. Each module should have a single, clear purpose.

**Drupal Application**:

✅ **Single Responsibility:**
```
article_statistics/        # Tracks article view counts
article_recommendations/   # Recommends related articles
article_notifications/     # Sends notifications about articles
```

Each module does ONE thing well.

❌ **Multiple Responsibilities:**
```
articles_plus/  # Does statistics, recommendations, notifications, exports, etc.
# One developer can't understand this
# Can't be replaced piece by piece
```

**Signs of Good Module Boundaries**:
- Module purpose fits in one sentence
- One developer can maintain it
- Can be enabled/disabled independently
- Has clear inputs and outputs

### 4. Primitive-First Design

**Principle**: Identify core "primitive" data types that flow through your system. Design everything around these primitives.

**Drupal Application**:

✅ **Identify Primitives:**
```php
// Drupal's core primitives:
// - Entity: NodeInterface, UserInterface, TermInterface
// - Field: FieldItemInterface
// - Render array: array
// - Configuration: ImmutableConfig

// Design services around these primitives
interface ArticleProcessorInterface {
  public function process(NodeInterface $article): array;
  // Input primitive: NodeInterface
  // Output primitive: array (render array)
}

interface CommentNotifierInterface {
  public function notify(CommentInterface $comment, UserInterface $recipient): void;
  // Input primitives: CommentInterface, UserInterface
}
```

**Primitive Consistency**:
- Always use `NodeInterface`, never concrete `Node` class
- Always use render arrays for output
- Always use `FieldItemListInterface` for field access

### 5. Format/Interface Design

**Principle**: Make interfaces as simple as possible to implement. Prefer one good way over multiple complex options.

**Drupal Application**:

✅ **Simple Interface:**
```php
interface ContentTransformerInterface {
  /**
   * Transform content from one format to another.
   *
   * @param string $content
   *   Content to transform.
   * @param string $from_format
   *   Source format (e.g., 'markdown').
   * @param string $to_format
   *   Target format (e.g., 'html').
   *
   * @return string
   *   Transformed content.
   */
  public function transform(string $content, string $from_format, string $to_format): string;
}
```

❌ **Complex Interface:**
```php
interface ContentTransformerInterface {
  public function setSource($content, $format, array $options = []);
  public function setTarget($format, array $options = []);
  public function addPlugin($plugin);
  public function configure(array $config);
  public function execute();
  public function getResult($format = NULL);
  // Too many steps, too many options, hard to implement
}
```

---

## Drupal-Specific Application

### Module Design

**Black Box Module Pattern:**

1. **Define Public Interface:**
```php
// src/MyModuleServiceInterface.php
interface MyModuleServiceInterface {
  public function doSomething(int $id): array;
}
```

2. **Implement Service:**
```php
// src/MyModuleService.php
class MyModuleService implements MyModuleServiceInterface {
  public function __construct(
    private EntityTypeManagerInterface $entityTypeManager,
    private CacheBackendInterface $cache,
  ) {}

  public function doSomething(int $id): array {
    // Implementation details hidden
  }
}
```

3. **Register Service:**
```yaml
# my_module.services.yml
services:
  my_module.service:
    class: Drupal\my_module\MyModuleService
    arguments: ['@entity_type.manager', '@cache.default']
```

**Single Responsibility Example:**

❌ **Bad: Multiple Responsibilities**
```
user_management/
  - User authentication
  - User profiles
  - User permissions
  - User notifications
  - User statistics
```

✅ **Good: Focused Modules**
```
user_auth/           # Authentication only
user_profiles/       # Profile management only
user_notifications/  # Notifications only
```

### Data Flow

**Identify Primitives:**

Drupal's core primitives for custom modules:

1. **Entities**: `NodeInterface`, `UserInterface`, `TermInterface`
2. **Fields**: `FieldItemListInterface`, `FieldItemInterface`
3. **Render Arrays**: `array`
4. **Configuration**: `ImmutableConfig`
5. **Database**: `Connection`

**Consistent Data Flow:**
```php
// Always use interfaces, not concrete classes
public function processArticle(NodeInterface $article): array {
  // Load field data (primitive: FieldItemListInterface)
  $body = $article->get('body');

  // Transform to render array (primitive: array)
  $build = [
    '#theme' => 'article_display',
    '#title' => $article->label(),
    '#body' => $body->view('full'),
  ];

  return $build;
}
```

### Interface Design

**Service Contract Example:**

```php
/**
 * Article recommendation service.
 *
 * Provides article recommendations based on user behavior.
 */
interface ArticleRecommendationInterface {

  /**
   * Get recommended articles for a user.
   *
   * @param int $uid
   *   User ID.
   * @param array $options
   *   Optional parameters:
   *   - limit: Number of recommendations (default: 5)
   *   - exclude_nids: Node IDs to exclude
   *
   * @return \Drupal\node\NodeInterface[]
   *   Recommended articles, ordered by relevance.
   */
  public function getRecommendations(int $uid, array $options = []): array;
}
```

**Interface Design Checklist:**
- ✅ Clear method names
- ✅ Type hints on all parameters
- ✅ Documented expected inputs/outputs
- ✅ One obvious way to use it
- ✅ Can be implemented without reading existing code

### Testing Philosophy

**Black Box Testing:**

```php
/**
 * Test the recommendation service interface.
 */
class ArticleRecommendationTest extends KernelTestBase {

  public function testRecommendations() {
    // Test against interface, not implementation
    $service = \Drupal::service('my_module.recommendations');
    assert($service instanceof ArticleRecommendationInterface);

    // Test public API behavior
    $recommendations = $service->getRecommendations(1, ['limit' => 3]);

    $this->assertCount(3, $recommendations);
    $this->assertContainsOnlyInstancesOf(NodeInterface::class, $recommendations);
  }
}
```

**Test the "What", Not the "How":**
- ✅ Test public interface behavior
- ✅ Test expected outputs for given inputs
- ❌ Don't test internal implementation details
- ❌ Don't test private methods

---

## Red Flags to Avoid

### Architecture Red Flags

❌ **Multiple Responsibilities:**
```php
class ArticleManager {
  public function create() { }      // Creation
  public function publish() { }     // Publishing
  public function notify() { }      // Notifications
  public function statistics() { }  // Analytics
  public function export() { }      // Data export
  // This class does too many unrelated things
}
```

✅ **Single Responsibility:**
```php
class ArticlePublisher { public function publish() { } }
class ArticleNotifier { public function notify() { } }
class ArticleStatistics { public function record() { } }
// Each class has one clear purpose
```

❌ **Leaky Abstractions:**
```php
interface CacheInterface {
  public function get($key);
  public function set($key, $value);
  public function getRedisConnection(); // Implementation detail leaked!
}
```

✅ **Clean Abstraction:**
```php
interface CacheInterface {
  public function get($key);
  public function set($key, $value);
  // No implementation details in interface
}
```

❌ **Hard Dependencies:**
```php
class ArticleService {
  public function process() {
    // Direct instantiation - hard dependency
    $notifier = new EmailNotifier();
    $notifier->send();
  }
}
```

✅ **Dependency Injection:**
```php
class ArticleService {
  public function __construct(
    private NotifierInterface $notifier,
  ) {}

  public function process() {
    $this->notifier->send();
  }
}
```

❌ **Magic Behavior:**
```php
public function saveArticle($data) {
  // Hidden side effects!
  $this->clearCache();
  $this->sendNotifications();
  $this->updateStatistics();
  // None of these are obvious from function name
}
```

✅ **Explicit Behavior:**
```php
public function saveArticle(NodeInterface $article): void {
  $article->save();
}

public function publishArticle(NodeInterface $article): void {
  $this->saveArticle($article);
  $this->cache->invalidate(['article:' . $article->id()]);
  $this->notifier->sendPublished($article);
  $this->stats->recordPublication($article);
  // All side effects are explicit
}
```

### Drupal-Specific Red Flags

❌ **Global State Access:**
```php
public function process() {
  $user = \Drupal::currentUser();
  $config = \Drupal::config('my.settings');
  $database = \Drupal::database();
  // Hidden dependencies
}
```

✅ **Explicit Dependencies:**
```php
public function __construct(
  private AccountInterface $currentUser,
  private ImmutableConfig $config,
  private Connection $database,
) {}
```

❌ **Procedural Code in Classes:**
```php
class MyService {
  public static function doSomething($data) {
    // Static methods = procedural code
    // Can't inject dependencies
    // Can't mock for testing
  }
}
```

✅ **Proper OOP:**
```php
class MyService {
  public function doSomething(array $data): array {
    // Instance method
    // Can inject dependencies
    // Easy to test
  }
}
```

---

## Refactoring Strategy

### When to Refactor

**Apply These Principles When:**

1. **Creating New Modules** - Start with clean architecture
2. **Module Growing Complex** - Split when it passes "one developer can maintain" test
3. **Code Review Flags Issues** - Red flags indicate refactoring needed
4. **Adding Features** - Don't pile features onto bad architecture

### Refactoring Steps

**Step 1: Identify Primitives**

What are the core data types?

```php
// Example: Article workflow module
// Primitives:
// - NodeInterface (articles)
// - WorkflowStateInterface (states)
// - UserInterface (actors)
```

**Step 2: Draw Black Box Boundaries**

What should be hidden vs. exposed?

```php
// Public API:
interface WorkflowManagerInterface {
  public function transitionState(NodeInterface $node, string $to_state): void;
  public function getCurrentState(NodeInterface $node): string;
}

// Hidden:
// - How states are stored
// - Validation logic
// - Notification mechanisms
```

**Step 3: Design Clean Interfaces**

```php
// Before refactoring, ask:
// - Could someone implement this interface without reading the code?
// - Are all parameters necessary?
// - Is the return type clear?
```

**Step 4: Implement Incrementally**

```php
// 1. Create interface
interface NewServiceInterface { }

// 2. Create new implementation
class NewService implements NewServiceInterface { }

// 3. Register new service
// 4. Update consumers one by one
// 5. Remove old service when no longer used
```

**Step 5: Test Interfaces**

```php
// Test against interface, not implementation
public function testWorkflow() {
  $workflow = \Drupal::service('my_module.workflow');
  assert($workflow instanceof WorkflowManagerInterface);

  // Test public API
  $workflow->transitionState($node, 'published');
  $this->assertEquals('published', $workflow->getCurrentState($node));
}
```

### Architecture Review Questions

**Before Committing Code, Ask:**

1. **Simplicity**: Is this the simplest solution that could work?
2. **Responsibility**: Does this module/class have ONE clear purpose?
3. **Replaceability**: Could someone rewrite this using only the public interface?
4. **Primitives**: Are we using Drupal's core primitives correctly?
5. **Explicitness**: Are all dependencies and side effects explicit?
6. **Maintainability**: Will this be understandable in 2-3 years?

---

## Summary

**Core Philosophy:**

> "It's faster to write five lines of code today than to write one line today and then have to edit it in the future." - Eskil Steenberg

**Apply These Principles:**

1. **Simplicity over Ease** (Hickey) - Choose maintainable over convenient
2. **Black Box Modules** (Steenberg) - Hide implementation, expose clean interfaces
3. **Single Responsibility** (Both) - One module = one clear purpose
4. **Replaceable Components** (Steenberg) - Design for replaceability
5. **Explicit over Implicit** (Hickey) - No magic, clear dependencies

**Quality Gates:**

✅ Can one developer maintain this module?
✅ Could you rewrite it using only the public interface?
✅ Are all dependencies explicit?
✅ Is the purpose clear from the module name?
✅ Would this be understandable in 2-3 years?

**Remember:**

Good architecture makes complex systems feel simple. Bad architecture makes simple systems feel complex.

---

*For practical Drupal code examples, see the other pattern documents in this directory.*
