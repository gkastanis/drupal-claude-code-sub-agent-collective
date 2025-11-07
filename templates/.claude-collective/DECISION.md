# Auto-Delegation Decision Logic

## Purpose
This file contains the auto-delegation rules that determine when to automatically invoke the collective versus using standard Claude behavior.

## When to Auto-Delegate to Collective

### Drupal Development Tasks (AUTO-DELEGATE)
**Trigger**: User requests Drupal-specific implementation work
**Action**: Automatically invoke `/van` command
**Examples**:
- "Create a custom Drupal module for..."
- "Build a content type with fields..."
- "Implement a custom block plugin..."
- "Create migration from CSV to Drupal nodes..."
- "Set up Behat tests for the contact form..."

### Drupal Architecture & Planning (AUTO-DELEGATE)
**Trigger**: User requests Drupal architecture or content modeling
**Action**: Automatically invoke `/van` command
**Examples**:
- "Design the content model for an event management system"
- "Plan the module architecture for..."
- "What's the best approach for Drupal field storage..."
- "Design taxonomy structure for..."

### Drupal Testing & Quality (AUTO-DELEGATE)
**Trigger**: User requests Drupal testing or security review
**Action**: Automatically invoke `/van` command
**Examples**:
- "Write PHPUnit tests for my custom service..."
- "Review this module for security issues..."
- "Create Behat scenarios for user registration..."
- "Set up visual regression tests for the theme..."
- "Run coding standards check on this module..."

### Drupal Performance & DevOps (AUTO-DELEGATE)
**Trigger**: User requests Drupal optimization or deployment
**Action**: Automatically invoke `/van` command
**Examples**:
- "Optimize this query to prevent N+1 problems..."
- "Set up Redis caching for Drupal..."
- "Configure deployment workflow for Drupal site..."
- "Optimize image delivery with CDN..."

### Drupal Research (AUTO-DELEGATE)
**Trigger**: User needs Drupal best practices or library research
**Action**: Automatically invoke `/van` command
**Examples**:
- "Research the best Drupal modules for..."
- "What are best practices for Drupal field architecture..."
- "How to implement proper cache tags in Drupal..."

## When NOT to Auto-Delegate (Use Standard Claude)

### Drupal Questions & Explanations
**Trigger**: User asks about Drupal concepts without requesting implementation
**Action**: Answer directly using standard Claude knowledge
**Examples**:
- "What is the Entity API in Drupal?"
- "Explain how Drupal's render pipeline works"
- "What's the difference between a module and a theme?"
- "How does Drupal's permission system work?"

### General Programming Questions
**Trigger**: Non-Drupal programming questions
**Action**: Answer directly
**Examples**:
- "How do I use Git?"
- "Explain JavaScript promises"
- "What's the best way to structure a REST API?"

### Project Management Questions
**Trigger**: Questions about project planning without implementation
**Action**: Answer directly
**Examples**:
- "How should I organize my Drupal project?"
- "What's a good development workflow?"
- "Should I use Composer for Drupal?"

### Debugging Help
**Trigger**: User needs help understanding errors or debugging
**Action**: Help debug directly, unless fix requires code changes
**Examples**:
- "What does this Drupal error mean?" → Answer directly
- "Fix this Drupal WSOD issue" → Auto-delegate to collective

## Auto-Delegation Decision Tree

```
User Request
    ↓
Is it Drupal-related?
    ↓
    NO → Standard Claude behavior
    ↓
    YES
    ↓
Does it require code implementation, architecture, testing, or optimization?
    ↓
    YES → Auto-delegate to /van command
    ↓
    NO (just explanation/question)
    ↓
Standard Claude behavior
```

## Explicit Override

Users can always explicitly invoke collective with:
- `/van` command - Direct collective invocation
- "Use the collective to..." - Explicit request

Users can prevent auto-delegation with:
- "Just explain..." - Request explanation only
- "Don't implement, just..." - Skip implementation

## Example Decision Making

| User Request | Auto-Delegate? | Reason |
|--------------|----------------|--------|
| "Create a custom Drupal block" | YES | Drupal implementation task |
| "What is a Drupal block?" | NO | Explanation only |
| "Review my module for security" | YES | Security validation task |
| "Explain Drupal security best practices" | NO | Knowledge question |
| "Write PHPUnit tests for my service" | YES | Testing implementation |
| "What testing tools does Drupal use?" | NO | Informational question |
| "Optimize this Drupal query" | YES | Performance optimization task |
| "How does Drupal query optimization work?" | NO | Conceptual explanation |
| "Fix this deprecation warning" | YES | Code implementation needed |
| "What does this deprecation mean?" | NO | Error explanation |

## Handoff to Collective

When auto-delegating, preserve the full user request context:

```
/van [original user request verbatim]
```

Do not summarize, rephrase, or interpret - pass the exact request to let the collective's routing logic handle the nuance.

---

**Version**: Drupal Auto-Delegation v1.0
**Last Updated**: 2025-11-07
