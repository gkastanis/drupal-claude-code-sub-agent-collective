# Drupal Research Cache Protocol

## Overview
This protocol prevents redundant research calls by implementing a cache-first research system across all agents for Drupal modules, APIs, and best practices using TaskMaster's existing `.taskmaster/docs/research/` directory.

## Cache Structure
```
.taskmaster/docs/research/
├── 2025-01-15_entity-api-drupal-10-patterns.md
├── 2025-01-15_webform-8x-custom-elements.md
├── 2025-01-15_commerce-2x-payment-gateways.md
└── ...
```

## Cache Freshness Rules
- **Fresh**: < 7 days old → REUSE without Context7 call
- **Stale**: 7+ days old → Context7 refresh required  
- **Missing**: No cache file → Context7 research required

## Agent Responsibilities

### 1. Workflow Agent
**BEFORE** creating workflow JSON:
```javascript
// Check for Drupal module/API keywords in request
const drupalTopics = detectDrupalTopics(userRequest);

// For each topic, check cache status
for (topic of drupalTopics) {
  Grep(pattern: topic, path: ".taskmaster/docs/research/", output_mode: "files_with_matches");
  // Determine cache_status: "cached_fresh" | "cached_stale" | "needs_research"
}

// Add cache status to workflow JSON
{
  "research_requirements": {
    "cache_status": {
      "entity-api": "cached_fresh",
      "webform": "needs_research"
    },
    "cache_files": [".taskmaster/docs/research/2025-01-15_entity-api.md"]
  }
}
```

### 2. Research Agent
**BEFORE** Context7/WebSearch calls:
```javascript
// Check cache first
const cacheFiles = Grep(pattern: drupalTopic, path: ".taskmaster/docs/research/");

if (cacheFiles.length > 0) {
  const cacheContent = Read(cacheFiles[0]);
  const fileDate = extractDateFromFilename(cacheFiles[0]);

  if (isFileFresh(fileDate, 7)) {
    // Use cached research, skip Context7/WebSearch
    return cacheContent;
  }
}

// Only call Context7/WebSearch if cache miss or stale
mcp__context7__resolve-library-id(drupalModule);
mcp__context7__get-library-docs(resolvedId);
// OR
WebSearch(query: "Drupal 10 " + drupalTopic + " best practices");

// Save new research to cache
mcp__task-master__research(query, saveToFile: true);
```

### 3. Module Development Agent
**BEFORE** coding:
```javascript
// Get task with research requirements
const task = mcp__task-master__get_task(id);

// Check for cache file references
if (task.research_requirements?.cache_files) {
  const researchFindings = Read(task.research_requirements.cache_files[0]);
  // Apply cached research to Drupal module implementation
} else {
  // Block implementation - request research first
  throw new Error("No research findings available for Drupal module/API task");
}
```

## Cache File Format
Standard format for research cache files:
```markdown
---
title: Research Session
module: entity-api
drupal_version: 10.2.x
query: "Drupal 10 Entity API custom entity creation patterns"
date: 2025-01-15
timestamp: 2025-01-15T10:30:00.000Z
---

# Drupal 10 Entity API Research Findings

## Current Version Best Practices
- Use ContentEntityBase for custom content entities
- Implement ContentEntityInterface properly
- Define entity keys in annotation (id, uuid, bundle, label)
- Use entity_keys in .module file

## Breaking Changes from Drupal 8/9
- Deprecated \Drupal::entityManager() - use dependency injection
- entity_load() removed - use entity_type.manager service
- New typed data API requirements

## Implementation Guidance
[Detailed Drupal implementation patterns...]
```

## Cache Validation Rules

### Freshness Check
```javascript
const isFileFresh = (filename, maxDays = 7) => {
  const fileDate = filename.match(/^(\d{4}-\d{2}-\d{2})/)?.[1];
  if (!fileDate) return false;
  
  const daysDiff = (Date.now() - new Date(fileDate)) / (1000 * 60 * 60 * 24);
  return daysDiff < maxDays;
};
```

### Drupal Topic Detection
```javascript
const drupalTopics = [
  'entity-api', 'form-api', 'render-api', 'plugin-api',
  'webform', 'commerce', 'paragraphs', 'views', 'layout-builder',
  'dependency-injection', 'services', 'hooks', 'event-subscribers',
  'twig', 'theme-system', 'libraries', 'javascript-behaviors',
  'migrate-api', 'config-api', 'state-api', 'queue-api',
  'behat', 'phpunit', 'playwright', 'drupal-test-traits'
];

const detectDrupalTopics = (text) => {
  return drupalTopics.filter(topic =>
    text.toLowerCase().includes(topic.toLowerCase())
  );
};
```

## Error Recovery

### Cache Miss Scenario
```javascript
// If module development agent finds no research cache
mcp__task-master__update_task(id,
  prompt: "BLOCKED: No research cache found for Drupal module/API task. Requesting research agent.");
mcp__task-master__set_task_status(id, "blocked");
// Return control to workflow agent to add research step
```

### Stale Cache Scenario  
```javascript
// If cache is stale (>7 days), refresh required
mcp__task-master__update_task(id,
  prompt: "Research cache stale. Refreshing Context7 documentation for " + libraryName);
// Proceed with Context7 research and cache update
```

## Benefits

### Performance
- **Eliminates redundant Context7 calls** - save API requests and time
- **Faster agent coordination** - cached research immediately available
- **Reduced context switching** - agents reference same research files

### Consistency  
- **Single source of truth** - all agents use same research findings
- **Version accuracy** - prevents mixing library versions across agents
- **Traceability** - clear research provenance in task updates

### Cost Efficiency
- **Reduced API usage** - Context7 calls only when necessary
- **Shared research** - one Context7 call serves multiple agents/tasks
- **Intelligent caching** - fresh research reused, stale research refreshed

## Implementation Timeline
- **Phase 1**: ✅ Cache-first protocols added to all agents
- **Phase 2**: ✅ Research sharing via TaskMaster integration  
- **Phase 3**: ✅ Validation and reuse mechanisms documented
- **Phase 4**: 🔄 Testing and refinement of cache system