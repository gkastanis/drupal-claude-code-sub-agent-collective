# Lullabot Prompt Library - High-Value Research

**Research Date:** 2025-12-17
**Researcher:** Claude Code Collective Analysis
**Source Repository:** [Lullabot/prompt_library](https://github.com/Lullabot/prompt_library)
**Target Project:** drupal-claude-code-sub-agent-collective v1.8.3

---

## Executive Summary

The **Lullabot Prompt Library** is a curated, discipline-organized collection of AI prompts, rules, agents, and project configurations. Built with 11ty and designed for community contribution, it represents production-grade content developed by a leading Drupal agency.

### Why This is High-Value

1. **Production-Tested Content** - Created by Lullabot engineers for real client work
2. **Drupal-Specific Expertise** - Deep Drupal 10/11 knowledge we can directly use
3. **Community-Driven** - GitHub issue templates for contributions
4. **Multi-Discipline** - Development, QA, Content Strategy, PM, Design
5. **Agent Definitions** - Professional-grade agent prompts with examples

---

## Library Structure

```
prompt_library/
├── development/           # Development discipline
│   ├── agents/           # AI agent configurations
│   │   ├── drupal-backend-specialist.md    ⭐ HIGH VALUE
│   │   ├── drupal-frontend-engineer.md     ⭐ HIGH VALUE
│   │   ├── testing-qa-engineer.md          ⭐ HIGH VALUE
│   │   └── code-review-assistant.md        ⭐ HIGH VALUE
│   ├── rules/            # Development rules/guidelines
│   │   ├── drupal.md                       ⭐ HIGH VALUE
│   │   ├── drupal-standards.md             ⭐ HIGH VALUE
│   │   └── code-quality.md
│   ├── prompts/          # AI prompts for tasks
│   │   ├── drupal-code-review.md
│   │   ├── ai-code-review.md
│   │   └── adr.md
│   ├── project-configs/  # Project setup templates
│   │   ├── drupal-setup.md
│   │   └── 11ty-setup.md
│   └── resources/        # Learning resources
│       ├── basic-prompting.md
│       └── drupal-and-ddev-links.md
├── content-strategy/
│   ├── agents/
│   │   └── content-optimization.md
│   └── rules/
│       └── lullabot-voice-and-tone-styleguide.md
├── quality-assurance/    # QA discipline (templates ready)
├── project-management/   # PM discipline (templates ready)
├── sales-marketing/      # Marketing discipline
└── design/               # Design discipline
```

---

## High-Value Content Analysis

### 1. Drupal Backend Specialist Agent ⭐⭐⭐⭐⭐

**File:** `development/agents/drupal-backend-specialist.md`
**Lines:** 138

#### Key Patterns to Steal

**Role Definition with Examples:**
```yaml
name: drupal-backend-specialist
description: >
  Use this agent when you need expert guidance on Drupal backend development
  tasks including custom module creation, database schema design, API development,
  plugin architecture, or complex backend functionality.
  Examples:
  <example>
    Context: User needs to create a custom Drupal module for managing inventory
    user: 'I need to create a custom module that tracks product inventory...'
    assistant: 'I'll use the drupal-backend-specialist agent...'
    <commentary>Since this involves custom module development...</commentary>
  </example>
```

**Implementation Preferences (Unique Value):**
- Use guard clauses to decrease cyclomatic complexity
- Favor functional programming for arrays (`array_filter`, `array_map`, `array_reduce`)
- Prefer `final` classes by default
- Use constructor property promotion
- Avoid getters/setters - use `public readonly` instead
- Write PHPCS compliant code on first pass
- Favor plain data objects over structured arrays
- Use `#config_target` for settings forms
- Favor JSON-RPC endpoints over custom JSON controllers
- Use Typed Entity pattern for SOLID principles

**Self-Verification Checklist:**
```markdown
- [ ] Class is `final` and marked `strict_types`
- [ ] All dependencies injected via constructor
- [ ] No static calls to `\Drupal::`
- [ ] Hooks use OOP attribute + LegacyHook
- [ ] Services listed in `<module>.services.yml`
- [ ] Visibility of properties/methods minimized
```

---

### 2. Drupal Rules (MDC Format) ⭐⭐⭐⭐⭐

**File:** `development/rules/drupal.md`

#### Auto-Attached Rules Pattern

Lullabot uses `.mdc` files (Cursor rules format) with glob patterns for auto-application:

**drupal-core.mdc (Always Applied):**
```yaml
globs:
  - "**/*.php"
  - "**/*.module"
  - "**/*.install"
  - "**/*.services.yml"
alwaysApply: true
```

**drupal-theme.mdc (Auto Attached for Twig):**
```yaml
globs:
  - "**/*.html.twig"
  - "**/*.theme"
alwaysApply: false
```

**drupal-testing.mdc (Auto Attached for Tests):**
```yaml
globs:
  - "tests/src/**/*.php"
alwaysApply: false
```

#### Key Rules Content

**Strict Types & PSR-12:**
```php
declare(strict_types=1);
```

**Final Classes & Visibility:**
- Declare every class `final` unless explicitly intended for extension
- Make all properties `private readonly` when possible
- Methods default to `private`; use `protected`/`public` only as needed

**Dependency Injection:**
```php
// NEVER do this
\Drupal::service();
\Drupal::config();

// ALWAYS do this
public function __construct(
    private readonly ConfigFactoryInterface $config,
    private readonly LoggerChannelInterface $logger,
) {}
```

**OOP Hook Implementations:**
```php
// Use @Hook attribute with invokable class
// See: https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Hook%21Attribute%21Hook.php/class/Hook/11.x
// Provide LegacyHook bridge for procedural modules
```

---

### 3. Testing QA Engineer Agent ⭐⭐⭐⭐⭐

**File:** `development/agents/testing-qa-engineer.md`

#### Testing Philosophy

```markdown
**Mantra**: Write a few tests (comprehensive coverage is frowned upon) for
the critical functionalities, mostly integration testing.

- Only write tests that cover logic for the system under test
- Never write tests that cover upstream functionalities or language features
- Only test the code specific for the project
```

#### Critical Integrity Requirement

```markdown
⚠️ **CRITICAL INTEGRITY REQUIREMENT** ⚠️
You MUST fix the actual bugs in the source code.

**This is CHEATING (absolutely forbidden):**
- Skipping tests with conditionals
- Modifying test assertions to pass
- Adding test-environment-specific code to source
- Disabling or commenting out tests
- ANY workaround that doesn't fix the real bug

**This is THE RIGHT WAY:**
- Find the root cause in the source code
- Fix the actual bug
- Ensure tests pass because the code truly works
```

#### Inter-Agent Delegation Pattern

```markdown
**When you discover code bugs** → Delegate to **drupal-backend-expert**
- Provide: Test failure details, expected vs actual behavior, file/line location

**When tests reveal missing functionality** → Delegate to **drupal-backend-expert**
- Provide: Test requirements, expected API interface

**Delegation Example:**
I need to delegate this subtask to drupal-backend-expert:

**Context**: Writing unit tests for ProxyBlock::passContextsToTargetBlock()
**Delegation**: Method has incorrect return type annotation
**Expected outcome**: Fixed method signature and proper type hints
**Integration**: Will update test assertions to match corrected return type
```

---

### 4. Code Review Assistant Agent ⭐⭐⭐⭐

**File:** `development/agents/code-review-assistant.md`
**Lines:** 234

#### Severity Classification

```markdown
- **Critical**: Security vulnerabilities, data loss risks, system breaking changes
- **High**: Major functionality issues, significant performance problems, design flaws
- **Medium**: Code quality issues, minor security concerns, maintainability problems
- **Low**: Style inconsistencies, optimization opportunities, documentation gaps
```

#### Review Output Format

```markdown
## Summary
Brief overall assessment of code quality and readiness

## Critical Issues (if any)
[Security vulnerabilities and blocking issues]

## Detailed Feedback

### Security Analysis
- [Specific security findings with severity and recommendations]

### Code Quality
- [Structure, naming, complexity, and organization feedback]

### Performance Considerations
- [Performance issues and optimization opportunities]

## Recommendations
- [ ] Specific actionable items for improvement

## Approval Status
[Ready to merge / Needs revisions / Requires security review]
```

#### Code Example Pattern

```markdown
❌ Current approach:
[problematic code snippet]

✅ Recommended approach:
[improved code snippet]

💡 Why: [explanation of the improvement]
```

---

### 5. Voice and Tone Styleguide ⭐⭐⭐⭐

**File:** `content-strategy/rules/lullabot-voice-and-tone-styleguide.md`

#### Why Avoid Idioms (Important for AI Content)

```markdown
- **Accessibility for Non-Native Speakers**: Idioms don't translate well
- **Professional Clarity**: Technical content requires precision
- **Avoiding "AI-Generated" Sound**: Idioms make content sound generic
- **Better SEO Performance**: Search engines prefer clear language
- **Inclusive Communication**: Direct language is universally understood
```

#### Examples

```markdown
❌ DON'T: "This API integration was a piece of cake."
✅ DO: "This API integration was straightforward to implement."

❌ DON'T: "This legacy code is a can of worms."
✅ DO: "This legacy code presents multiple interconnected challenges."
```

---

### 6. Drupal Development Standards ⭐⭐⭐⭐

**File:** `development/rules/drupal-standards.md`

#### Unique Standards

```markdown
## Module Development
- Avoid creating classes in a "Service" namespace (e.g., Drupal\my_module\Service)
- Create classes in namespaces that logically group with existing classes
- If no logical group, create classes in the root of the module namespace

## JSON Handling
- Always use `\GuzzleHttp\Utils::jsonDecode` and `\GuzzleHttp\Utils::jsonEncode`
- Never use PHP's `json_encode` and `json_decode` methods

## Logging
- Do not create separate "debug" flags for debug logging
- Log each message using the appropriate LoggerInterface method
  (debug(), info(), warning(), error())
```

---

### 7. Code Quality Standards ⭐⭐⭐

**File:** `development/rules/code-quality.md`

#### Error Handling Rules

```markdown
1. Use exceptions for error conditions instead of NULL or FALSE returns
2. Do not catch \Exception. Only catch exceptions that can be handled
3. Catch the narrowest exception possible
4. Do not catch exceptions simply to log them
5. New exceptions should inherit from existing exception classes
```

#### PHP 8.4+ Features

```markdown
## Data Objects
- Use data objects instead of arrays
- Arrays should be converted to objects as soon as possible
- If using PHP 8.4+, use property hooks for get/set methods
- This does not apply to Drupal's render or form APIs
```

---

### 8. Content Optimization Agent ⭐⭐⭐

**File:** `content-strategy/agents/content-optimization.md`

#### Priority Matrix System

```markdown
High Impact + Easy Implementation:
- Quick wins: Meta tag optimization, header structure, readability, CTAs

High Impact + Medium Implementation:
- Content restructuring, keyword optimization, internal linking

Medium Impact + Easy Implementation:
- Style adjustments, social sharing optimization, accessibility

High Impact + High Implementation:
- Complete rewrites, comprehensive SEO overhauls, multi-channel adaptation
```

---

## Integration Opportunities for Our Project

### Immediate Value (Copy & Adapt)

| Lullabot Content | Our Equivalent | Action |
|------------------|----------------|--------|
| `drupal-backend-specialist.md` | `@module-development-agent` | Merge expertise sections |
| `drupal-frontend-engineer.md` | `@theme-development-agent` | Merge Single-Directory Components info |
| `testing-qa-engineer.md` | `@unit-testing-agent` | Add integrity requirements |
| `drupal.md` rules | `templates/CLAUDE.md` | Add MDC patterns |
| `drupal-standards.md` | `templates/CLAUDE.md` | Merge unique standards |
| `code-review-assistant.md` | `@quality-agent` | Add review format |
| Voice/tone styleguide | New file | Create for our docs |

### Implementation Recommendations

#### 1. Enhance Agent Definitions

Add to our agents:
- Inline examples with `<example>` tags
- `<commentary>` explaining when to use
- Self-verification checklists
- Inter-agent delegation patterns

#### 2. Add MDC-Style Context Loading

Consider glob-based rules that auto-apply:
```yaml
# .claude/rules/drupal-core.mdc
globs: ["**/*.php", "**/*.module"]
alwaysApply: true
```

#### 3. Create Quality Gate Format

Standardize review output format:
```markdown
## Summary
## Critical Issues
## Detailed Feedback
## Recommendations
## Approval Status
```

#### 4. Add Implementation Preferences

Document coding style preferences:
- Guard clauses over nested conditionals
- Functional array operations
- `final` classes by default
- Property promotion
- No getters/setters

---

## Full Content Inventory

### Agents (6 files)

| Agent | Lines | Value |
|-------|-------|-------|
| drupal-backend-specialist.md | 138 | ⭐⭐⭐⭐⭐ |
| drupal-frontend-engineer.md | 69 | ⭐⭐⭐⭐⭐ |
| testing-qa-engineer.md | 136 | ⭐⭐⭐⭐⭐ |
| code-review-assistant.md | 234 | ⭐⭐⭐⭐ |
| content-optimization.md | 295 | ⭐⭐⭐ |
| Total | ~900 | |

### Rules (5 files)

| Rule | Lines | Value |
|------|-------|-------|
| drupal.md (with MDC examples) | 137 | ⭐⭐⭐⭐⭐ |
| drupal-standards.md | 67 | ⭐⭐⭐⭐ |
| code-quality.md | 57 | ⭐⭐⭐ |
| voice-and-tone-styleguide.md | 179 | ⭐⭐⭐ |
| Total | ~440 | |

### Prompts (4 files)

| Prompt | Purpose |
|--------|---------|
| drupal-code-review.md | Drupal-specific review checklist |
| ai-code-review.md | General code review |
| adr.md | Architecture Decision Records |

### Project Configs (3 files)

| Config | Purpose |
|--------|---------|
| drupal-setup.md | Drupal 11 project structure |
| 11ty-setup.md | 11ty site setup |
| pre_action_prompt.mdc.txt | Pre-action prompts |

### Resources (2 files)

| Resource | Purpose |
|----------|---------|
| basic-prompting.md | Curated learning links |
| drupal-and-ddev-links.md | Drupal/DDEV resources |

---

## Community Contribution System

### GitHub Issue Templates

Lullabot has standardized submission forms:

- `prompt-submission.yml` - Submit new prompts
- `rule-submission.yml` - Submit new rules
- `agent-submission.yml` - Submit agent definitions
- `project-config-submission.yml` - Submit project configs
- `workflow-state-submission.yml` - Submit workflows
- `resource-submission.yml` - Submit resources

### Slack Integration

Automated submission via Slack:
```yaml
# .github/workflows/slack_submit.yml
on:
  repository_dispatch:
    types: [slack-prompt-submission]
```

### llms.txt Pattern

Auto-generated comprehensive project snapshot for AI context:
- Contains all source code, docs, configs
- Updated when project changes significantly
- Can be provided to AI assistants for full context

---

## Action Items for Our Project

### Phase 1: Content Merge (1-2 days)

1. [ ] Merge `drupal-backend-specialist.md` into `@module-development-agent`
2. [ ] Merge `drupal-frontend-engineer.md` into `@theme-development-agent`
3. [ ] Add integrity requirements from `testing-qa-engineer.md`
4. [ ] Add review format from `code-review-assistant.md`
5. [ ] Update `templates/CLAUDE.md` with unique Drupal standards

### Phase 2: Structure Enhancement (2-3 days)

6. [ ] Add `<example>` patterns to all agents
7. [ ] Add self-verification checklists
8. [ ] Create inter-agent delegation patterns
9. [ ] Document implementation preferences

### Phase 3: Consider New Features (Future)

10. [ ] Evaluate MDC-style glob-based rules
11. [ ] Consider contribution templates
12. [ ] Evaluate llms.txt pattern for project snapshots

---

## Appendix: Complete Agent Template

Based on Lullabot patterns, here's the ideal agent structure:

```markdown
---
title: "Agent Name"
description: "Brief description"
date: "YYYY-MM-DD"
layout: "markdown.njk"
discipline: "development"
contentType: "agents"
tags: [relevant, tags]
---

`````
---
name: agent-name
description: >
  When to use this agent with examples:
  <example>
    Context: [situation]
    user: '[what user says]'
    assistant: '[what Claude responds]'
    <commentary>[why this agent is appropriate]</commentary>
  </example>
model: inherit
---

You are a [Role] with [experience description]. You specialize in [specializations].

## Core Responsibilities
- [Responsibility 1]
- [Responsibility 2]

## Technical Expertise
- [Skill 1]
- [Skill 2]

## Implementation Preferences
- [Preference 1 with reasoning]
- [Preference 2 with reasoning]

## Self-Verification Checklist
- [ ] [Check 1]
- [ ] [Check 2]

## Inter-Agent Delegation
**When [situation]** → Delegate to **@agent-name**
- Provide: [what context to give]
- Expected outcome: [what to expect back]

## Communication Guidelines
- [Guideline 1]
- [Guideline 2]

⚠️ **CRITICAL REQUIREMENTS** ⚠️
[Any critical behavioral requirements]
`````
```

---

*Document generated from Lullabot Prompt Library analysis for drupal-claude-code-sub-agent-collective enhancement planning.*
