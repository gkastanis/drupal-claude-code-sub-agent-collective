# Context7 MCP Integration Guide for Drupal Development

## Overview

Context7 MCP provides real-time access to comprehensive Drupal documentation with thousands of code examples and API references. This guide shows agents how to effectively use Context7 to fetch current Drupal best practices and patterns.

## Available Drupal Resources

### Primary Resources

#### 1. Drupal Developer Quick Reference (`/selwynpolit/d9book`)
**Best for**: Practical examples, common patterns, how-to guides

- **Library ID**: `/selwynpolit/d9book`
- **Code Snippets**: 1,989 examples
- **Trust Score**: 8.6/10
- **Description**: Modern Drupal developer handbook with practical examples
- **Use when**: You need working code examples, common patterns, and practical guidance

**Available Topics**:
- `services` - Service definitions, dependency injection patterns
- `modules` - Custom module development, hooks, plugins
- `forms` - Form API, form validation, form alters
- `entities` - Entity API, content entities, config entities
- `plugins` - Plugin development (blocks, fields, formatters, widgets)
- `routing` - Route definitions, controllers, access control
- `hooks` - Common Drupal hooks and implementations
- `configuration` - Config management, config schema
- `security` - Security best practices, input sanitization
- `performance` - Caching, optimization patterns
- `testing` - PHPUnit, functional tests, Behat
- `migrations` - Migration API, ETL patterns
- `theming` - Twig templates, theme hooks, preprocessors
- `javascript` - Drupal behaviors, jQuery integration
- `ajax` - AJAX API, AJAX commands

#### 2. Drupal Core Documentation (`/drupal/core`)
**Best for**: Official API references, core system documentation

- **Library ID**: `/drupal/core`
- **Code Snippets**: 97 examples
- **Trust Score**: 9.2/10
- **Description**: Official Drupal Core documentation and API references
- **Use when**: You need authoritative API documentation or core system architecture

**Available Topics**:
- `plugin-api` - Plugin system architecture
- `entity-api` - Entity system core APIs
- `services` - Core service definitions
- `events` - Event system and subscribers
- `forms` - Form API core documentation
- `routing` - Routing system architecture
- `cache` - Cache API and cache contexts
- `database` - Database abstraction layer
- `testing` - Core testing frameworks

#### 3. Drupal Main Project (`/drupal/drupal`)
**Best for**: Version-specific documentation

- **Library ID**: `/drupal/drupal`
- **Code Snippets**: 143 examples
- **Trust Score**: 9.2/10
- **Versions**: `11.2.2`, `10_4_8`
- **Use when**: You need version-specific documentation

**Version-Specific Examples**:
```
/drupal/drupal/11.2.2  # Drupal 11.2.2 documentation
/drupal/drupal/10_4_8  # Drupal 10.4.8 documentation
```

### Specialized Resources

#### Drush (`/drush-ops/drush`)
- **Library ID**: `/drush-ops/drush`
- **Code Snippets**: 117 examples
- **Trust Score**: 6.3/10
- **Use for**: Drush command development, generators

#### Drupal Commerce (`/qodeone/drupal-commerce`)
- **Library ID**: `/qodeone/drupal-commerce`
- **Code Snippets**: 232 examples
- **Trust Score**: 4.9/10
- **Use for**: E-commerce development with Drupal Commerce

## How to Use Context7 in Agents

### Step 1: Resolve Library ID

Before fetching documentation, resolve the library ID if you're not sure of the exact identifier:

```javascript
// For general Drupal development
mcp__context7__resolve-library-id(libraryName: "drupal developer handbook")
// Returns: /selwynpolit/d9book

// For core documentation
mcp__context7__resolve-library-id(libraryName: "drupal core")
// Returns: /drupal/core
```

### Step 2: Fetch Topic-Specific Documentation

Use the resolved library ID to fetch documentation for specific topics:

```javascript
// Get dependency injection examples
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "services and dependency injection",
  tokens: 3000
)

// Get plugin development patterns
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "plugin development",
  tokens: 2000
)

// Get official entity API documentation
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/drupal/core",
  topic: "entity-api",
  tokens: 2500
)
```

### Step 3: Use Retrieved Code Examples

Context7 returns working code examples that you can use directly:

```php
// Example from Context7 /selwynpolit/d9book - dependency injection
public function __construct(
  private readonly MessengerInterface $messenger,
  private readonly AccountProxyInterface $currentUser,
  private readonly PagerManagerInterface $pagerManager,
) {}
```

## Agent-Specific Usage Patterns

### For module-development-agent

```javascript
// When creating a custom service
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "services dependency injection constructor",
  tokens: 2000
)

// When creating a plugin
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "block plugins",
  tokens: 2500
)

// When creating a form
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "form api validation",
  tokens: 2000
)
```

### For theme-development-agent

```javascript
// When working with Twig templates
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "twig templates preprocessors",
  tokens: 2500
)

// When adding theme hooks
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "theme hooks suggestions",
  tokens: 2000
)
```

### For security-compliance-agent

```javascript
// When reviewing security patterns
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "security sanitization xss",
  tokens: 2500
)

// When checking access control
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "permissions access control",
  tokens: 2000
)
```

### For content-migration-agent

```javascript
// When building migrations
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "migrations etl process plugins",
  tokens: 3000
)
```

### For performance-devops-agent

```javascript
// When optimizing caching
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "caching cache contexts tags",
  tokens: 2500
)
```

## Best Practices

### 1. Choose the Right Resource

**Use `/selwynpolit/d9book` when**:
- You need practical, working code examples
- You want to see common patterns and best practices
- You need how-to guides for specific tasks
- You want real-world implementation examples

**Use `/drupal/core` when**:
- You need official API documentation
- You want to understand core system architecture
- You need authoritative reference material
- You're working with core APIs directly

**Use `/drupal/drupal` when**:
- You need version-specific documentation
- You're working with a specific Drupal version
- You need to ensure compatibility with a particular release

### 2. Use Descriptive Topics

Good topics are specific and descriptive:

```javascript
// ✅ Good - specific and descriptive
topic: "services dependency injection constructor"
topic: "form api validation submit handlers"
topic: "entity query conditions sorting"

// ❌ Bad - too vague
topic: "services"
topic: "forms"
topic: "entities"
```

### 3. Optimize Token Usage

- **Small queries**: 1000-1500 tokens
- **Medium queries**: 2000-2500 tokens
- **Large queries**: 3000-4000 tokens
- **Comprehensive research**: 5000+ tokens

```javascript
// Quick API reference check
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/drupal/core",
  topic: "cache api",
  tokens: 1500
)

// Comprehensive pattern research
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "custom entity content entity bundle",
  tokens: 4000
)
```

### 4. Preserve Code Examples

When Context7 returns code snippets, preserve them in your responses:

```php
// ✅ Good - preserve the actual code example
/** From Context7 /selwynpolit/d9book **/
public function __construct(
  array $configuration,
  $plugin_id,
  $plugin_definition,
  private readonly AccountProxyInterface $currentUser,
  private readonly DateFormatterInterface $dateFormatter,
) {
  parent::__construct($configuration, $plugin_id, $plugin_definition);
}

// ❌ Bad - don't summarize code examples
// "Use dependency injection in the constructor..."
```

### 5. Combine Multiple Queries for Complex Tasks

For complex features, make multiple targeted queries:

```javascript
// Step 1: Get plugin structure
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "block plugin annotation",
  tokens: 2000
)

// Step 2: Get dependency injection pattern
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "plugin dependency injection create",
  tokens: 2000
)

// Step 3: Get configuration schema
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "configuration schema definition",
  tokens: 1500
)
```

## Common Query Examples

### Module Development

```javascript
// Service definition with DI
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "services.yml dependency injection arguments",
  tokens: 2000
)

// Custom controller
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "controller routing dependency injection",
  tokens: 2500
)

// Event subscriber
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "event subscriber kernel events",
  tokens: 2000
)
```

### Theme Development

```javascript
// Twig templates and preprocessing
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "twig template_preprocess variables",
  tokens: 2500
)

// Theme suggestions
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "theme suggestions hook_theme_suggestions",
  tokens: 2000
)
```

### Forms

```javascript
// Form building and validation
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "form api elements validation submit",
  tokens: 3000
)

// AJAX forms
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "ajax form callback commands",
  tokens: 2500
)
```

### Entities

```javascript
// Custom entity creation
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "custom content entity annotations handlers",
  tokens: 4000
)

// Entity queries
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "entity query conditions range pager",
  tokens: 2000
)
```

### Configuration Management

```javascript
// Config schema
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "configuration schema type mapping",
  tokens: 2000
)

// Config forms
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "configuration form settings config factory",
  tokens: 2500
)
```

## Error Handling

### Library Not Found

If a library can't be resolved, try alternative search terms:

```javascript
// If "drupal9 book" doesn't work
mcp__context7__resolve-library-id(libraryName: "drupal developer")
mcp__context7__resolve-library-id(libraryName: "selwyn drupal")
```

### Topic Too Broad

If results aren't specific enough, narrow your topic:

```javascript
// Instead of: "forms"
topic: "form api validation custom validators"

// Instead of: "entities"
topic: "custom content entity field definitions base fields"

// Instead of: "plugins"
topic: "block plugin dependency injection configuration"
```

### Token Limit

If you hit token limits, split into multiple queries:

```javascript
// Instead of one 8000 token query about "complete module development"
// Make 3-4 targeted 2000 token queries:
topic: "module structure info.yml services.yml"
topic: "custom plugin block annotation"
topic: "dependency injection controller"
topic: "routing access control permissions"
```

## Integration with research-agent

The research-agent uses Context7 as part of its comprehensive research protocol:

1. **Check research cache** first (`.taskmaster/docs/research/`)
2. **Resolve library ID** for the technology being researched
3. **Fetch Context7 documentation** with appropriate topic and token limit
4. **Preserve code examples** in research cache files
5. **Combine with Claude knowledge** for best practices and patterns
6. **Cache results** for future use

See `/templates/agents/research-agent.md` for complete research protocol.

## Quick Reference

### Most Common Drupal Topics

| Topic | Best Resource | Typical Tokens |
|-------|---------------|----------------|
| Services & DI | `/selwynpolit/d9book` | 2000-3000 |
| Plugins | `/selwynpolit/d9book` | 2000-2500 |
| Forms | `/selwynpolit/d9book` | 2500-3000 |
| Entities | `/selwynpolit/d9book` | 3000-4000 |
| Routing | `/selwynpolit/d9book` | 1500-2000 |
| Hooks | `/selwynpolit/d9book` | 2000-2500 |
| Theming | `/selwynpolit/d9book` | 2500-3000 |
| Migrations | `/selwynpolit/d9book` | 3000-4000 |
| Security | `/selwynpolit/d9book` | 2000-2500 |
| Caching | `/selwynpolit/d9book` | 2000-2500 |
| Testing | `/selwynpolit/d9book` | 2500-3000 |
| Config Management | `/selwynpolit/d9book` | 2000-2500 |

### Token Allocation Guidelines

- **Quick lookup**: 1000-1500 tokens (API signature, simple example)
- **Standard query**: 2000-2500 tokens (full examples with context)
- **Complex feature**: 3000-4000 tokens (multiple examples, edge cases)
- **Comprehensive research**: 4000-5000 tokens (complete patterns, integrations)

### Library Selection Decision Tree

```
Need Drupal documentation?
├─ Need practical examples?
│  └─ Use /selwynpolit/d9book (1,989 snippets, Trust: 8.6)
│
├─ Need official API docs?
│  └─ Use /drupal/core (97 snippets, Trust: 9.2)
│
└─ Need version-specific?
   └─ Use /drupal/drupal/VERSION (143 snippets, Trust: 9.2)
```

## Summary

Context7 MCP provides agents with access to comprehensive, up-to-date Drupal documentation. By using the right library for the task, crafting specific topic queries, and preserving code examples, agents can deliver accurate, current, and production-ready Drupal code.

**Key Takeaways**:
- Use `/selwynpolit/d9book` for practical examples (1,989 snippets)
- Use `/drupal/core` for official documentation (97 snippets)
- Be specific with topic queries
- Preserve code examples from Context7
- Optimize token usage based on query complexity
- Cache research results for future use
