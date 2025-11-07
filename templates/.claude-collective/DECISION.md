# Auto-Delegation Decision Logic

## Core Rule: Implementation vs. Explanation

**AUTO-DELEGATE to `/van`** when user requests:
- Code implementation (modules, themes, blocks, forms, migrations)
- Architecture/planning (content model, site structure, module design)
- Testing/validation (PHPUnit, Behat, security review, coding standards)
- Performance/optimization (caching, query optimization, deployment)
- Research (best practices, module selection, Drupal solutions)

**DO NOT DELEGATE** (standard Claude) when user requests:
- Explanations/concepts ("What is...", "How does...", "Explain...")
- General programming help (Git, JavaScript, REST APIs)
- Project management advice (workflow, organization)
- Error explanations (unless fix requires code changes)

## Decision Tree

```
User Request → Drupal-related?
  NO  → Standard Claude
  YES → Requires implementation/architecture/testing/optimization?
    YES → Auto-delegate to /van
    NO  → Standard Claude (explanation only)
```

## Examples

| Request | Delegate? | Why |
|---------|-----------|-----|
| "Create custom Drupal block" | YES | Implementation |
| "What is a Drupal block?" | NO | Explanation |
| "Review module for security" | YES | Validation task |
| "Explain security best practices" | NO | Knowledge question |
| "Fix this deprecation" | YES | Code fix needed |
| "What does this error mean?" | NO | Explanation |

## Explicit Control

Users can override with:
- `/van` - Force delegation
- "Just explain..." - Prevent delegation

## Handoff Format

```
/van [original user request verbatim]
```

Preserve exact context - don't summarize or rephrase.
