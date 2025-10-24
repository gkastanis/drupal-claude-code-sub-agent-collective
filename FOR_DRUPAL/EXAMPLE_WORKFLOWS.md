# Example Agent Interactions - Real Drupal Tasks

## Example 1: Level 2 - Custom Block Plugin (Simple Feature)

### User Request
> "Create a custom block that displays the 5 most recent articles with their featured images and titles, linkable to the full articles"

### Agent Workflow

#### Step 1: Complexity Assessment (Main Orchestrator)
```
ASSESSMENT: Level 2 - Single feature development
REASONING: 
- Single custom component (block plugin)
- Standard Drupal patterns
- No complex integrations
- Can be completed by 2-3 agents

AGENT ROUTE: @architect → @module-dev → @security → @functional-test
```

#### Step 2: Architecture Agent (@architect)
```yaml
AGENT: Drupal Architect
TASK: Design approach for recent articles block

ANALYSIS:
  - Component Type: Custom block plugin
  - Data Source: Article content type (Drupal core)
  - Query Method: EntityQuery or Views programmatic
  - Cache Strategy: Tag-based caching by article IDs
  
DECISIONS:
  module_name: recent_articles_block
  plugin_type: Block (Drupal\Core\Block\BlockBase)
  dependencies:
    - drupal:node
  fields_needed:
    - title (field_name)
    - field_image (needs to exist on Article)
    - created (timestamp for sorting)
  caching:
    - Cache by article nodes
    - Max-age: 3600 seconds
    - Tags: ['node_list:article']

TECHNICAL_APPROACH: |
  1. Create custom module 'recent_articles_block'
  2. Implement Block plugin in src/Plugin/Block/RecentArticlesBlock.php
  3. Use EntityQuery to fetch 5 most recent published articles
  4. Use dependency injection for EntityTypeManager
  5. Build render array with image styles
  6. Implement proper cache metadata

FILES_TO_CREATE:
  - recent_articles_block.info.yml
  - src/Plugin/Block/RecentArticlesBlock.php

OUTPUT: Architecture document complete
NEXT_AGENT: @module-dev
STATUS: READY_FOR_IMPLEMENTATION
```

#### Step 3: Module Development Agent (@module-dev)
```yaml
AGENT: Module Development Agent
TASK: Implement recent articles block plugin

READING: Architecture document from @architect

ACTION: Creating module structure...

FILE: web/modules/custom/recent_articles_block/recent_articles_block.info.yml
---
name: 'Recent Articles Block'
type: module
description: 'Provides a block displaying recent articles with images'
core_version_requirement: ^10 || ^11
package: Custom
dependencies:
  - drupal:node
---

FILE: web/modules/custom/recent_articles_block/src/Plugin/Block/RecentArticlesBlock.php
---
<?php

namespace Drupal\recent_articles_block\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Plugin\ContainerFactoryPluginInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Drupal\Core\Cache\Cache;

/**
 * Provides a 'Recent Articles' Block.
 *
 * @Block(
 *   id = "recent_articles_block",
 *   admin_label = @Translation("Recent Articles"),
 *   category = @Translation("Custom"),
 * )
 */
class RecentArticlesBlock extends BlockBase implements ContainerFactoryPluginInterface {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Constructs a new RecentArticlesBlock.
   *
   * @param array $configuration
   *   A configuration array containing information about the plugin instance.
   * @param string $plugin_id
   *   The plugin_id for the plugin instance.
   * @param mixed $plugin_definition
   *   The plugin implementation definition.
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager service.
   */
  public function __construct(
    array $configuration,
    $plugin_id,
    $plugin_definition,
    EntityTypeManagerInterface $entity_type_manager
  ) {
    parent::__construct($configuration, $plugin_id, $plugin_definition);
    $this->entityTypeManager = $entity_type_manager;
  }

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container, array $configuration, $plugin_id, $plugin_definition) {
    return new static(
      $configuration,
      $plugin_id,
      $plugin_definition,
      $container->get('entity_type.manager')
    );
  }

  /**
   * {@inheritdoc}
   */
  public function build() {
    $build = [];
    
    // Query for recent articles.
    $node_storage = $this->entityTypeManager->getStorage('node');
    $query = $node_storage->getQuery()
      ->condition('type', 'article')
      ->condition('status', 1)
      ->sort('created', 'DESC')
      ->range(0, 5)
      ->accessCheck(TRUE);
    
    $nids = $query->execute();
    
    if (empty($nids)) {
      return $build;
    }
    
    $nodes = $node_storage->loadMultiple($nids);
    
    $items = [];
    foreach ($nodes as $node) {
      $item = [
        'title' => $node->getTitle(),
        'url' => $node->toUrl()->toString(),
      ];
      
      // Get featured image if it exists.
      if ($node->hasField('field_image') && !$node->get('field_image')->isEmpty()) {
        $image = $node->get('field_image')->first();
        $item['image'] = [
          '#theme' => 'image_style',
          '#style_name' => 'thumbnail',
          '#uri' => $image->entity->getFileUri(),
          '#alt' => $image->alt,
        ];
      }
      
      $items[] = $item;
    }
    
    $build['articles'] = [
      '#theme' => 'item_list',
      '#items' => $items,
      '#list_type' => 'ul',
      '#wrapper_attributes' => ['class' => ['recent-articles-list']],
    ];
    
    return $build;
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheTags() {
    return Cache::mergeTags(
      parent::getCacheTags(),
      ['node_list:article']
    );
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheMaxAge() {
    return 3600; // 1 hour
  }

}
---

COMMANDS_EXECUTED:
  $ drush en recent_articles_block -y
  $ drush cr

VERIFICATION:
  - Module enabled successfully
  - Block plugin discovered
  - Available in block layout UI

OUTPUT:
  status: IMPLEMENTATION_COMPLETE
  location: web/modules/custom/recent_articles_block/
  files_created:
    - recent_articles_block.info.yml
    - src/Plugin/Block/RecentArticlesBlock.php
  
NEXT_AGENT: @security
```

#### Step 4: Security & Compliance Agent (@security)
```yaml
AGENT: Security & Compliance Agent
TASK: Review recent_articles_block for security and standards compliance

RUNNING: Security checks...

CHECK 1: Drupal Coding Standards
COMMAND: phpcs --standard=Drupal,DrupalPractice web/modules/custom/recent_articles_block/
RESULT: ✅ PASS - No violations found

CHECK 2: PHPStan Static Analysis
COMMAND: phpstan analyse web/modules/custom/recent_articles_block/
RESULT: ✅ PASS - No errors

CHECK 3: Security Review
ANALYZING:
  ✅ Access control: Using ->accessCheck(TRUE) on entity query
  ✅ XSS prevention: Using render arrays, not raw output
  ✅ SQL injection: Using EntityQuery (safe)
  ✅ Dependency injection: Properly implemented
  ✅ Cache tags: Properly set for article list invalidation
  ✅ Permissions: No custom permissions needed (uses core block permissions)

CHECK 4: Best Practices
  ✅ Proper namespace usage
  ✅ Documentation blocks present
  ✅ Dependency injection used (not \Drupal::)
  ✅ Proper plugin annotation
  ✅ Cache metadata implemented

RESULT: ✅ PASS - All security and compliance checks passed

OUTPUT:
  gate_status: PASS
  issues_found: 0
  recommendations:
    - Consider adding a configurable limit in blockForm()
    - Could add field_image fallback if field doesn't exist
  
NEXT_AGENT: @functional-test
```

#### Step 5: Functional Testing Agent (@functional-test)
```yaml
AGENT: Functional Testing Agent
TASK: Test recent articles block in browser

SETUP: Creating test scenario...

TEST_SCRIPT: tests/recent-articles-block.spec.js
---
const { test, expect } = require('@playwright/test');

test.describe('Recent Articles Block', () => {
  
  test.beforeEach(async ({ page }) => {
    // Log in as admin
    await page.goto('http://localhost/user/login');
    await page.fill('#edit-name', 'admin');
    await page.fill('#edit-pass', 'admin');
    await page.click('#edit-submit');
  });

  test('Block appears in block layout', async ({ page }) => {
    await page.goto('http://localhost/admin/structure/block');
    await page.click('text=Place block');
    const blockExists = await page.locator('text=Recent Articles').isVisible();
    expect(blockExists).toBeTruthy();
  });

  test('Block displays recent articles', async ({ page }) => {
    // Place the block in sidebar
    await page.goto('http://localhost/admin/structure/block/add/recent_articles_block/olivero');
    await page.fill('#edit-region', 'sidebar_first');
    await page.click('#edit-submit');
    
    // Visit homepage
    await page.goto('http://localhost/');
    
    // Check if block is present
    const blockPresent = await page.locator('.recent-articles-list').isVisible();
    expect(blockPresent).toBeTruthy();
    
    // Check for article links
    const articleLinks = await page.locator('.recent-articles-list a').count();
    expect(articleLinks).toBeGreaterThan(0);
    expect(articleLinks).toBeLessThanOrEqual(5);
  });

  test('Article images display correctly', async ({ page }) => {
    await page.goto('http://localhost/');
    
    // Check if images are present
    const images = await page.locator('.recent-articles-list img').count();
    expect(images).toBeGreaterThan(0);
    
    // Verify image style is applied
    const firstImage = await page.locator('.recent-articles-list img').first();
    const src = await firstImage.getAttribute('src');
    expect(src).toContain('/styles/thumbnail/');
  });

  test('Articles are clickable and navigate correctly', async ({ page }) => {
    await page.goto('http://localhost/');
    
    // Click first article link
    await page.locator('.recent-articles-list a').first().click();
    
    // Should navigate to article page
    await expect(page).toHaveURL(/\/node\/\d+/);
  });

});
---

EXECUTING: Playwright tests...
COMMAND: npx playwright test tests/recent-articles-block.spec.js

RESULTS:
  ✅ Block appears in block layout - PASSED
  ✅ Block displays recent articles - PASSED
  ✅ Article images display correctly - PASSED
  ✅ Articles are clickable and navigate correctly - PASSED

All tests passed: 4/4

MANUAL_VERIFICATION:
  ✅ Block visible on frontend
  ✅ Images render with correct image style
  ✅ Links work properly
  ✅ No JavaScript errors in console
  ✅ Responsive on mobile breakpoint

OUTPUT:
  gate_status: PASS
  tests_passed: 4
  tests_failed: 0
  visual_check: PASS
  
STATUS: ✅ COMPLETE - All validation passed
```

#### Step 6: Final Summary (Main Orchestrator)
```yaml
PROJECT: Recent Articles Block
STATUS: ✅ COMPLETE

DELIVERABLES:
  - Custom Drupal module: recent_articles_block
  - Block plugin: RecentArticlesBlock
  - Location: web/modules/custom/recent_articles_block/
  
VALIDATION_RESULTS:
  - Drupal Coding Standards: ✅ PASS
  - Security Review: ✅ PASS
  - Functional Tests: ✅ PASS (4/4)
  - Browser Validation: ✅ PASS

NEXT_STEPS_FOR_USER:
  1. Place the block via /admin/structure/block
  2. Choose region where you want it displayed
  3. Configure visibility settings if needed
  4. Clear cache if block doesn't appear: drush cr

TOTAL_TIME: ~15 minutes
AGENTS_USED: 4 (architect, module-dev, security, functional-test)
```

---

## Example 2: Level 3 - Event Management System (Complex Feature)

### User Request
> "Build an event management system with:
> - Event content type with date, location, registration limit
> - Registration form (name, email, optional message)
> - Admin view showing registrations per event
> - Email notifications to users and admins
> - Calendar view for upcoming events"

### Agent Workflow

#### Step 1: Complexity Assessment
```yaml
ASSESSMENT: Level 3 - Multi-component system
REASONING:
  - Multiple custom components (content type, forms, emails)
  - Database integration (registrations)
  - Multiple agents needed (6-7)
  - Requires PM coordination

AGENT_ROUTE: PM → @architect → @module-dev → @theme-dev → @config-mgmt → @security → @performance → @functional-test → @integration
```

#### Step 2: PM Agent (Task Breakdown)
```yaml
AGENT: Project Manager
TASK: Break down event management system into coordinated tasks

USING: Task Master MCP to create project structure

PROJECT: Event Management System
PHASES:
  - Phase 1: Architecture & Content Model
  - Phase 2: Core Module Development
  - Phase 3: Frontend & Theme
  - Phase 4: Testing & Validation

TASKS_CREATED:
  
  TASK-1: Architecture Design
    agent: @architect
    priority: HIGH
    dependencies: none
    deliverable: Architecture document with content model
    
  TASK-2: Content Type Configuration
    agent: @config-mgmt
    priority: HIGH
    dependencies: [TASK-1]
    deliverable: Event content type with fields
    
  TASK-3: Custom Registration Module
    agent: @module-dev
    priority: HIGH
    dependencies: [TASK-1, TASK-2]
    deliverable: Custom module with registration entity and form
    
  TASK-4: Email Notification System
    agent: @module-dev
    priority: MEDIUM
    dependencies: [TASK-3]
    deliverable: Email hooks and templates
    
  TASK-5: Admin Views
    agent: @config-mgmt
    priority: MEDIUM
    dependencies: [TASK-3]
    deliverable: Views for registration management
    
  TASK-6: Calendar View
    agent: @config-mgmt
    priority: MEDIUM
    dependencies: [TASK-2]
    deliverable: Calendar display of events
    
  TASK-7: Theme Components
    agent: @theme-dev
    priority: MEDIUM
    dependencies: [TASK-2, TASK-3]
    deliverable: Event and registration templates
    
  TASK-8: Security Review
    agent: @security
    priority: HIGH
    dependencies: [TASK-3, TASK-4]
    deliverable: Security validation report
    
  TASK-9: Performance Review
    agent: @performance-devops
    priority: MEDIUM
    dependencies: [TASK-3, TASK-5, TASK-6]
    deliverable: Performance optimization report
    
  TASK-10: Functional Testing
    agent: @functional-test
    priority: HIGH
    dependencies: [TASK-3, TASK-5, TASK-6, TASK-7]
    deliverable: Test suite with all scenarios
    
  TASK-11: Integration Testing
    agent: @integration
    priority: HIGH
    dependencies: [TASK-10]
    deliverable: Full system integration validation

STATUS: Task breakdown complete
NEXT: Execute Phase 1 tasks
```

#### Step 3: Architect Agent (TASK-1)
```yaml
AGENT: Drupal Architect
TASK: Design event management system architecture

ARCHITECTURE_DOCUMENT:
  
  1. CONTENT MODEL:
    event_content_type:
      name: Event
      machine_name: event
      fields:
        - title (core)
        - body (core, rich text)
        - field_event_date (datetime_range)
        - field_location (text or address field)
        - field_registration_limit (integer)
        - field_registration_deadline (datetime)
        - field_event_image (image)
    
  2. CUSTOM ENTITY:
    entity_type: event_registration
    purpose: Store event registrations
    fields:
      - event_id (entity_reference to event node)
      - registrant_name (string)
      - registrant_email (email)
      - message (text_long, optional)
      - registered_date (timestamp)
      - status (list: confirmed, cancelled, waitlist)
    
  3. MODULE STRUCTURE:
    module_name: event_management
    components:
      - Custom entity: EventRegistration
      - Form: EventRegistrationForm
      - Controller: EventRegistrationController (handle submissions)
      - Service: EventNotificationService (email sending)
      - Plugin: Block plugin for registration form
      - Views integration for admin interface
    
  4. DEPENDENCIES:
    required_modules:
      - datetime_range
      - calendar (contrib)
      - views
      - token (for email templates)
      - address (if using address field)
    
  5. DATABASE SCHEMA:
    tables:
      - event_registration (managed by entity system)
    indexes:
      - event_id (for queries)
      - registrant_email (for lookups)
      - registered_date (for sorting)
    
  6. PERMISSIONS:
    - "register for events" (authenticated users)
    - "view event registrations" (event managers)
    - "administer event registrations" (admins)
    
  7. EMAIL TEMPLATES:
    - registration_confirmation (to registrant)
    - registration_notification (to admin)
    - reminder_email (before event)
    
  8. CACHING STRATEGY:
    - Cache registration counts per event
    - Cache tags: ['event_registration:EVENT_ID']
    - Invalidate on new registration
    
  9. TECHNICAL CONSIDERATIONS:
    - Use queue for email sending (don't block form submission)
    - Rate limiting on registration form
    - CAPTCHA integration for public forms
    - Export all configs for deployment

STATUS: Architecture complete
NEXT_TASKS: [TASK-2, TASK-3] can proceed in parallel
```

#### [Abbreviated for space - similar detailed implementations would follow for:]
- TASK-2: Config Management creates Event content type
- TASK-3: Module Dev implements custom entity and forms
- TASK-4: Module Dev adds email system
- TASK-5: Config Management creates admin views
- TASK-6: Config Management creates calendar view
- TASK-7: Theme Dev creates templates
- TASK-8: Security reviews everything
- TASK-9: Performance optimization
- TASK-10: Functional testing of all user flows
- TASK-11: Integration testing

#### Final Integration Gate
```yaml
AGENT: Integration Gate
TASK: Validate all components work together

TESTS:
  ✅ Event content type creates successfully
  ✅ Registration form appears on event pages
  ✅ Registration submission works
  ✅ Email notifications send correctly
  ✅ Admin view shows all registrations
  ✅ Calendar displays events correctly
  ✅ Registration limit enforcement works
  ✅ Deadline checking works
  ✅ All configurations exportable

COMPATIBILITY:
  ✅ No module conflicts
  ✅ Theme integration successful
  ✅ Performance acceptable (< 2s page load)
  ✅ Mobile responsive

RESULT: ✅ PASS - System ready for production

TOTAL_TIME: ~90 minutes
AGENTS_USED: 9
FILES_CREATED: 25+
CONFIGURATIONS_EXPORTED: 15+
```

---

## Key Takeaways

1. **Level 1 tasks** execute immediately (no agent coordination)
2. **Level 2 tasks** use 2-4 agents in sequence
3. **Level 3 tasks** use 6-9 agents with PM coordination via Task Master
4. **Level 4 tasks** use all agents with phased delivery

Each agent:
- Has specific responsibilities
- Produces structured outputs
- Validates work through quality gates
- Communicates through Task Master or orchestrator
- Documents decisions and implementations

The system ensures production-ready Drupal code that follows best practices and passes all validation gates.
