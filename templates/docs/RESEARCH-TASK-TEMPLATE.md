# Research-Backed Task Template

## Overview
Template for Task Master tasks that include research references, enabling implementation agents to access Context7 research findings and apply current Drupal best practices.

## Task Template Format

### Task Master Task with Research References
```json
{
  "id": "3.2",
  "title": "Implement event registration custom entity with email notifications",
  "description": "Create custom entity for event registrations with automated email confirmation system",
  "research_context": {
    "required_research": ["custom-entities", "email-api", "dependency-injection"],
    "research_files": [
      ".taskmaster/docs/research/2025-08-09_drupal-custom-entities-best-practices.md",
      ".taskmaster/docs/research/2025-08-09_email-notifications-token-integration.md"
    ],
    "context7_topics": [
      "/drupal/core topic:'custom entities'",
      "/selwynpolit/d9book topic:'email notifications'"
    ],
    "key_findings": [
      "Custom entities should extend ContentEntityBase with proper annotations",
      "Email notifications use MailManager service with dependency injection",
      "Token module integration for dynamic email content",
      "Configuration in config/install/ not hook_install()"
    ]
  },
  "implementation_guidance": {
    "quality_approach": "Follow Drupal standards, write Behat tests, validate with PHPCS",
    "validation_criteria": [
      "Entity creation and storage works correctly",
      "Email notifications sent on entity save",
      "Passes PHPCS/PHPStan validation",
      "Behat test covers registration workflow",
      "Configuration exportable via drush cex"
    ]
  }
}
```

### Research File Reference Format
```markdown
📚 **Research References:**
- **Custom Entities**: `.taskmaster/docs/research/2025-08-09_drupal-custom-entities-best-practices.md`
- **Email System**: `.taskmaster/docs/research/2025-08-09_email-notifications-token-integration.md`

🎯 **Key Research Findings:**
- Custom entities extend ContentEntityBase with @ContentEntityType annotation
- Use dependency injection for MailManager service (not \Drupal::service())
- Token module provides dynamic content in email templates
- Entity configuration should be in config/install/ directory

✅ **Quality Validation Criteria:**
- [ ] Entity creates/updates/deletes successfully
- [ ] Email sent with correct recipient and content
- [ ] PHPCS validation passes (Drupal/DrupalPractice)
- [ ] PHPStan level 6 passes
- [ ] Behat test validates registration workflow
- [ ] Configuration exports cleanly
```

## Agent Integration Patterns

### For Research Agent
```javascript
// When generating tasks, include research context with Context7 references
const taskWithResearch = {
  ...baseTask,
  research_context: {
    required_research: extractedDrupalTopics,
    research_files: relevantCacheFiles,
    context7_topics: [
      "/drupal/core topic:'custom entities'",
      "/selwynpolit/d9book topic:'email'"
    ],
    key_findings: criticalResearchPoints
  },
  implementation_guidance: {
    quality_approach: "Drupal standards with Behat testing",
    validation_criteria: specificQualityCriteria
  }
};
```

### For Implementation Agents
```javascript
// Before implementing, check for research context
const task = mcp__task-master__get_task(taskId);

if (task.research_context?.research_files) {
  // Load cached research findings
  for (const researchFile of task.research_context.research_files) {
    const research = Read(researchFile);
    // Apply research to implementation approach
  }
}

if (task.research_context?.context7_topics) {
  // Fetch current Drupal documentation
  for (const topic of task.research_context.context7_topics) {
    const docs = mcp__context7__get_library_docs({
      context7CompatibleLibraryID: topic.split(' ')[0],
      topic: topic.split("'")[1]
    });
    // Apply current best practices
  }
}

// Follow quality standards from task guidance
if (task.implementation_guidance?.quality_approach) {
  // 1. Implement with Drupal standards
  // 2. Write Behat tests for functionality
  // 3. Validate with quality gates (PHPCS, security)
}
```

## Quality-Focused Implementation with Research

### Research-Informed Development Cycle
1. **PLAN Phase**: Review research findings and Context7 documentation
2. **IMPLEMENT Phase**: Apply research-backed patterns with Drupal standards
3. **VALIDATE Phase**: Run quality gates (PHPCS, PHPStan, security review)
4. **TEST Phase**: Behat functional tests validate user workflows

### Quality-First Implementation
```php
<?php

namespace Drupal\event_management\Entity;

use Drupal\Core\Entity\ContentEntityBase;
use Drupal\Core\Entity\EntityTypeInterface;
use Drupal\Core\Field\BaseFieldDefinition;

/**
 * Defines the Event Registration entity.
 *
 * Based on research: Custom entities extend ContentEntityBase
 * with proper annotation documentation.
 *
 * @ContentEntityType(
 *   id = "event_registration",
 *   label = @Translation("Event Registration"),
 *   base_table = "event_registration",
 *   entity_keys = {
 *     "id" = "id",
 *     "uuid" = "uuid",
 *   },
 * )
 */
class EventRegistration extends ContentEntityBase {

  /**
   * {@inheritdoc}
   *
   * Based on research: Define base fields with proper type hints
   * and field constraints.
   */
  public static function baseFieldDefinitions(EntityTypeInterface $entity_type): array {
    $fields = parent::baseFieldDefinitions($entity_type);

    // Research-backed pattern: Entity reference with proper cardinality
    $fields['event_id'] = BaseFieldDefinition::create('entity_reference')
      ->setLabel(t('Event'))
      ->setSetting('target_type', 'node')
      ->setSetting('handler', 'default')
      ->setRequired(TRUE);

    return $fields;
  }

}
```

Then validate with:
```bash
# Quality gates based on research best practices
ddev exec phpcs --standard=Drupal,DrupalPractice web/modules/custom/event_management/
ddev exec phpstan analyse --level=6 web/modules/custom/event_management/
```

## Simple Reference Format for Agents

### Quick Research Check
```bash
# Check for cached Drupal research
research_files=$(grep -l "custom entity\|email notification" .taskmaster/docs/research/*.md 2>/dev/null || echo "")

if [ -n "$research_files" ]; then
  echo "📚 Using cached research: $research_files"
else
  echo "🔍 Will fetch from Context7: /drupal/core, /selwynpolit/d9book"
fi
```

### Research-Backed Implementation Steps
1. **Check Task**: Get research context from Task Master task
2. **Load Research**: Read referenced research files
3. **Fetch Context7**: Get current Drupal documentation if needed
4. **Plan Implementation**: Create approach based on research findings
5. **Quality Cycle**: Implement → PHPCS → PHPStan → Security Review → Behat Tests
6. **Validate**: Ensure implementation meets Drupal best practices

## Benefits

### Implementation Quality
- **Current Patterns**: Use latest Drupal API syntax and best practices
- **Informed Decisions**: Base implementation on comprehensive research
- **Standards Compliance**: Research-informed validation ensures PHPCS/PHPStan compliance

### Development Efficiency
- **No Research Redundancy**: Agents reference shared research findings
- **Clear Guidance**: Tasks include specific implementation direction
- **Quality Focus**: Standards-first approach with research-backed criteria

### Consistency
- **Shared Knowledge**: All agents use same research findings and Context7 docs
- **Version Alignment**: Consistent Drupal API usage across implementations
- **Pattern Consistency**: Research-backed Drupal patterns applied uniformly

## Context7 Integration

### Fetching Current Documentation
```javascript
// Get official Drupal Core documentation
const coreDoc = mcp__context7__get_library_docs({
  context7CompatibleLibraryID: "/drupal/core",
  topic: "custom entities"
});

// Get practical developer examples
const devBook = mcp__context7__get_library_docs({
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "email notifications"
});

// Combine with cached research for comprehensive context
```

### Research File Structure
```markdown
# Drupal Custom Entities Best Practices

**Source**: Context7 /drupal/core, /selwynpolit/d9book
**Date**: 2025-08-09
**Topics**: Custom entities, content entities, entity API

## Key Findings
1. Custom entities should extend ContentEntityBase or ConfigEntityBase
2. Use @ContentEntityType or @ConfigEntityType annotation
3. Define entity keys (id, uuid, label)
4. Implement baseFieldDefinitions() for content entities
5. Store configuration in config/install/ directory

## Code Examples
[Include researched examples from Context7]

## Security Considerations
- Access control via entity access handlers
- Input validation on all fields
- Proper sanitization using Drupal APIs
```

This research template enables Drupal agents to build on comprehensive research and current documentation for high-quality implementations.
