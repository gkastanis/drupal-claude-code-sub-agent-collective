# Templates Comparison Analysis

**Research Date:** 2025-12-17
**Comparison:** Our Templates vs Lullabot Prompt Library
**Focus:** Claude Code only (no multi-tool support needed)

---

## Executive Summary

Our templates are **well-structured and Drupal-specialized** with features Lullabot lacks (handoff protocols, TaskMaster integration, hooks system). However, Lullabot's agent prompts contain **richer implementation guidance** that we can selectively adopt.

### Key Finding

| Aspect | Our Strength | Lullabot Strength |
|--------|-------------|-------------------|
| **Agent Count** | 15 specialized agents | 6 agents |
| **Coordination** | Hub-spoke, handoffs, hooks | None |
| **Drupal Depth** | Architecture, field matrices | Implementation preferences |
| **Testing Philosophy** | Complete but generic | "Critical Integrity Requirement" |
| **Code Style** | Basic best practices | Deep implementation preferences |
| **Routing** | Full /van command system | None |

---

## Template Inventory Comparison

### Our Templates

```
templates/
├── CLAUDE.md                 # 118 lines - Drupal project guide
├── agents/                   # 15 specialized agents
│   ├── drupal-architect.md           # 288 lines ⭐
│   ├── module-development-agent.md   # 167 lines
│   ├── theme-development-agent.md    # 151 lines
│   ├── unit-testing-agent.md         # 186 lines
│   ├── security-compliance-agent.md  # 167 lines
│   ├── functional-testing-agent.md
│   ├── visual-regression-agent.md
│   ├── configuration-management-agent.md
│   ├── content-migration-agent.md
│   ├── performance-devops-agent.md
│   ├── research-agent.md             # 173 lines
│   ├── semantic-architect-agent.md
│   ├── routing-agent.md
│   ├── workflow-agent.md
│   └── enhanced-project-manager-agent.md
├── commands/                 # 50+ commands
│   ├── van.md                        # 144 lines - Routing engine
│   └── tm/                           # 40+ TaskMaster commands
├── hooks/                    # 7 hook scripts
├── .claude-collective/       # Behavioral system
├── .taskmaster/              # TaskMaster integration
├── tests/                    # Test templates
├── docs/                     # Documentation
└── skills/                   # Skill definitions
```

**Total: ~100+ template files**

### Lullabot Prompt Library

```
prompt_library/
├── development/
│   ├── agents/               # 4 development agents
│   │   ├── drupal-backend-specialist.md    # 138 lines ⭐
│   │   ├── drupal-frontend-engineer.md     # 69 lines
│   │   ├── testing-qa-engineer.md          # 136 lines ⭐
│   │   └── code-review-assistant.md        # 234 lines
│   ├── rules/                # 3 rule files
│   │   ├── drupal.md                       # 137 lines ⭐
│   │   ├── drupal-standards.md             # 67 lines
│   │   └── code-quality.md                 # 57 lines
│   ├── prompts/              # 3 prompt files
│   ├── project-configs/      # 2 config files
│   └── resources/            # 2 resource files
├── content-strategy/
│   ├── agents/               # 1 agent
│   └── rules/                # 1 rule file
└── [other disciplines - mostly empty templates]
```

**Total: ~15 content files (Drupal-relevant)**

---

## Feature-by-Feature Comparison

### 1. Agent Definition Format

#### Our Format ✅ Better Structure
```yaml
---
name: module-development-agent
description: Custom Drupal module development...

<example>
user: "Create a custom block plugin..."
assistant: "I'll use the module-development-agent..."
</example>

tools: Read, Write, Edit, Bash, mcp__task-master__*
model: sonnet
color: green
---

# Module Development Agent
**Role**: Custom Drupal module implementation...

## Core Responsibilities
...

## Handoff Protocol
```yaml
handoff:
  from: "@module-development-agent"
  to: "@security-compliance-agent"
  on_failure:
    retry: 2
    route_to: "@drupal-architect"
```
```

#### Lullabot Format ✅ Better Guidance
```yaml
---
name: drupal-backend-specialist
description: >
  Use this agent when...
  Examples:
  <example>
    Context: User needs to create custom module
    user: 'I need to create a custom module...'
    assistant: 'I'll use the drupal-backend-specialist...'
    <commentary>Since this involves...</commentary>
  </example>
model: inherit
---

You are a Senior Drupal Backend Developer with 10+ years...

## **IMPORTANT** Implementation preferences

**Use guard clauses to decrease cyclomatic complexity**
**Favor functional programming style for arrays**
**Prefer `final` classes**
**Use constructor property promotion**
**Avoid getters & setters**
**Write PHPCS compliant code**
**Favor JSON-RPC over custom controllers**
**Use Typed Entity pattern for SOLID**

⚠️ **CRITICAL INTEGRITY REQUIREMENT** ⚠️
...
```

### 2. Drupal Standards Content

#### Our drupal-architect.md ✅ Better Field Architecture

```markdown
## Field Architecture Planning

**Field Type Selection Matrix:**

| Content Need | Recommended Field Type | Widget | Notes |
|--------------|----------------------|--------|-------|
| Event date/time | `datetime` | `datetime_default` | Single datetime |
| Date range | `daterange` | `daterange_default` | Start/end dates |
| Location (simple) | `string` | `string_textfield` | Text-based |
...

**Common Field Architecture Mistakes:**
❌ Creating separate field storage for same concept
✅ Better: Share field storage across bundles
```

#### Lullabot drupal.md ✅ Better Code Standards (MDC Format)

```markdown
### drupal-core.mdc (Always Applied)
globs:
  - "**/*.php"
  - "**/*.module"
alwaysApply: true

# Drupal 10 Core Rules

1. **Strict Types & PSR-12**
   declare(strict_types=1);

2. **Final Classes & Visibility**
   - Declare every class `final` unless explicitly intended
   - Make all properties `private readonly`
   - Methods default to `private`

3. **Dependency Injection**
   - Never call `\Drupal::service()` in classes
   - Use constructor injection with promoted properties

4. **Hook Implementations**
   - Thin wrapper: delegate to invokable class with @Hook attribute
```

### 3. Testing Philosophy

#### Our unit-testing-agent.md ✅ Complete Structure

```markdown
## Test Types Available

| Type | Bootstrap | Database | Speed | Use Case |
|------|-----------|----------|-------|----------|
| Unit | None | No | Fast | Pure logic |
| Kernel | Minimal | Yes | Medium | Services, plugins |
| Functional | Full | Yes | Slow | Complete features |

## Quality Validation
- ✅ Tests follow Drupal PHPUnit standards
- ✅ Proper test isolation
- ✅ Mocking used for external dependencies
```

#### Lullabot testing-qa-engineer.md ✅ Better Philosophy

```markdown
**Mantra**: Write a few tests (comprehensive coverage is frowned upon)
for the critical functionalities, mostly integration testing.

- Only write tests that cover logic for the system under test
- Never write tests that cover upstream functionalities or language features
- Only test the code specific for the project

⚠️ **CRITICAL INTEGRITY REQUIREMENT** ⚠️

**This is CHEATING (absolutely forbidden):**
- Skipping tests with conditionals
- Modifying test assertions to pass
- Adding test-environment-specific code to source
- ANY workaround that doesn't fix the real bug

**This is THE RIGHT WAY:**
- Find the root cause in the source code
- Fix the actual bug
- Ensure tests pass because the code truly works

## Inter-Agent Delegation
When you discover code bugs → Delegate to **drupal-backend-expert**
- Provide: Test failure details, expected vs actual, file/line
```

### 4. Routing System

#### Our /van Command ✅ Comprehensive Routing

```markdown
## 🎯 SMART ROUTING DECISION TREE

Request Analysis
├── Architecture/Planning? → @drupal-architect
├── Custom Module? → @module-development-agent
├── Theme Development? → @theme-development-agent
├── Content Migration? → @content-migration-agent
├── Config Management? → @configuration-management-agent
├── Testing Focus? → @functional-testing-agent OR @unit-testing-agent
├── Quality/Security Check? → @security-compliance-agent
├── Performance/Deployment? → @performance-devops-agent
├── Research Focus? → @research-agent
└── Multi-Component Complex? → @enhanced-project-manager-agent

## 🎮 ORCHESTRATION PATTERNS
Pattern 1: Direct Module Development
Pattern 2: Research-Backed Development
Pattern 3: Multi-Component System
```

#### Lullabot ❌ No Routing System

No equivalent. Agents are standalone without coordination.

### 5. Handoff System

#### Our Templates ✅ Full Handoff Protocols

```yaml
## Handoff Protocol

handoff:
  phase: "Development"
  from: "@module-development-agent"
  to: "@security-compliance-agent"
  status: "complete"
  metrics:
    plugins_created: [X]
    services_created: [Y]
  on_failure:
    retry: 2
    route_to: "@drupal-architect"
```

#### Lullabot ✅ Inter-Agent Delegation (Different Pattern)

```markdown
## Inter-Agent Delegation

**When you discover code bugs** → Delegate to **drupal-backend-expert**
- Provide: Test failure details, expected vs actual behavior, file/line

**Delegation Example:**
I need to delegate this subtask to drupal-backend-expert:
**Context**: Writing unit tests for ProxyBlock::passContextsToTargetBlock()
**Delegation**: Method has incorrect return type annotation
**Expected outcome**: Fixed method signature
**Integration**: Will update test assertions to match
```

---

## Gap Analysis

### What We Have That Lullabot Lacks

| Our Feature | Value | Lullabot Equivalent |
|-------------|-------|---------------------|
| **Hub-Spoke Coordination** | ⭐⭐⭐⭐⭐ | None |
| **/van Routing Command** | ⭐⭐⭐⭐⭐ | None |
| **Handoff Protocols** | ⭐⭐⭐⭐⭐ | Basic delegation |
| **TaskMaster Integration** | ⭐⭐⭐⭐⭐ | None |
| **Hooks System** | ⭐⭐⭐⭐⭐ | None |
| **15 Specialized Agents** | ⭐⭐⭐⭐⭐ | 6 agents |
| **Field Type Matrix** | ⭐⭐⭐⭐ | None |
| **Research Cache Protocol** | ⭐⭐⭐⭐ | None |
| **Metrics Collection** | ⭐⭐⭐⭐ | None |
| **Quality Gates** | ⭐⭐⭐⭐ | None |

### What Lullabot Has That We Should Adopt

| Lullabot Feature | Value | Our Gap |
|------------------|-------|---------|
| **Implementation Preferences** | ⭐⭐⭐⭐⭐ | Missing coding style mandates |
| **Critical Integrity Requirement** | ⭐⭐⭐⭐⭐ | No "no cheating" rules |
| **Guard Clause Philosophy** | ⭐⭐⭐⭐ | Missing |
| **Functional Array Style** | ⭐⭐⭐⭐ | Missing |
| **`final` Class Default** | ⭐⭐⭐⭐ | Basic mention |
| **Property Promotion** | ⭐⭐⭐⭐ | Missing |
| **No Getters/Setters** | ⭐⭐⭐⭐ | Missing |
| **Typed Entity Pattern** | ⭐⭐⭐⭐ | Missing |
| **JSON-RPC Preference** | ⭐⭐⭐ | Missing |
| **Self-Verification Checklist** | ⭐⭐⭐⭐ | Partial |
| **`<commentary>` Examples** | ⭐⭐⭐ | We have simpler examples |
| **Variable Naming Rules** | ⭐⭐⭐ | Missing snake_case/camelCase |
| **Error Handling Rules** | ⭐⭐⭐ | Basic |

---

## Recommended Enhancements

### Priority 1: Add Implementation Preferences (HIGH VALUE)

Add to `module-development-agent.md`:

```markdown
## **IMPORTANT** Implementation Preferences

**Guard Clauses First:**
Use guard clauses at the beginning of functions to decrease cyclomatic complexity.
Return early when preconditions aren't met.

**Functional Array Style:**
Avoid `foreach` with nested `if`, `break`, `continue`.
Use `array_filter`, `array_map`, `array_reduce` instead.

**`final` Classes by Default:**
Declare every class `final` unless explicitly intended for extension.

**Constructor Property Promotion:**
```php
public function __construct(
    private readonly ConfigFactoryInterface $config,
    private readonly LoggerChannelInterface $logger,
) {}
```

**No Getters/Setters:**
- If only getter needed → use `public readonly`
- If getter and setter needed → make property public

**JSON Operations:**
Always use `\GuzzleHttp\Utils::jsonDecode()` and `jsonEncode()`
Never use PHP's `json_encode`/`json_decode`

**Variable Naming:**
- `$snake_case` for local variables and function parameters
- `$lowerCamelCase` for class attributes
```

### Priority 2: Add Critical Integrity Requirement (HIGH VALUE)

Add to `unit-testing-agent.md`:

```markdown
## ⚠️ CRITICAL INTEGRITY REQUIREMENT ⚠️

You MUST fix the actual bugs in the source code.
Green tests are worthless if achieved through cheating.

**This is CHEATING (absolutely forbidden):**
- ❌ Skipping tests with conditionals
- ❌ Modifying test assertions to pass
- ❌ Adding test-environment-specific code to source
- ❌ Disabling or commenting out tests
- ❌ ANY workaround that doesn't fix the real bug

**This is THE RIGHT WAY:**
- ✅ Find the root cause in the source code
- ✅ Fix the actual bug
- ✅ Ensure tests pass because the code truly works

**Testing Philosophy:**
Write a few tests for critical functionalities, mostly integration testing.
Never write tests that cover upstream functionalities or language features.
Only test code specific to the project.
```

### Priority 3: Add Self-Verification Checklists

Add to each implementation agent:

```markdown
## Self-Verification Checklist

**Before completing, verify:**
- [ ] Class is `final` and marked `declare(strict_types=1);`
- [ ] All dependencies injected via constructor
- [ ] No static calls to `\Drupal::`
- [ ] Hooks use OOP attribute + LegacyHook pattern
- [ ] Services listed in `<module>.services.yml`
- [ ] Visibility of properties/methods minimized
- [ ] Guard clauses used for early returns
- [ ] Functional array operations preferred
- [ ] No getters/setters unless required
```

### Priority 4: Add Error Handling Rules

Add to `CLAUDE.md` or new `drupal-standards.md`:

```markdown
## Error Handling Rules

1. **Use exceptions for error conditions** instead of NULL or FALSE returns
2. **Never catch \Exception** - Only catch exceptions you can handle
3. **Catch narrowest exception possible** - RuntimeException over Exception
4. **Don't catch just to log** - unless declaring error doesn't affect caller
5. **New exceptions inherit** from existing exception classes
```

### Priority 5: Add Inter-Agent Delegation Format

Enhance existing handoff protocol with Lullabot's clear delegation format:

```markdown
## Inter-Agent Delegation

**When discovering bugs during testing** → Delegate to **@module-development-agent**

**Delegation Format:**
```
I need to delegate this subtask to @module-development-agent:

**Context**: [What you were doing when you found the issue]
**Delegation**: [The specific problem that needs fixing]
**Expected outcome**: [What the fix should accomplish]
**Integration**: [How you'll incorporate the fix]
```
```

---

## Implementation Plan

### Phase 1: Quick Wins (30 minutes)

1. [ ] Add Implementation Preferences section to `module-development-agent.md`
2. [ ] Add Critical Integrity Requirement to `unit-testing-agent.md`
3. [ ] Add Self-Verification Checklist to both agents

### Phase 2: Core Enhancements (1-2 hours)

4. [ ] Add Error Handling Rules to `CLAUDE.md`
5. [ ] Add Variable Naming Rules to `CLAUDE.md`
6. [ ] Enhance Inter-Agent Delegation format in handoff sections
7. [ ] Add Guard Clause guidance with examples

### Phase 3: Complete Integration (2-3 hours)

8. [ ] Add Implementation Preferences to `theme-development-agent.md`
9. [ ] Add Implementation Preferences to `security-compliance-agent.md`
10. [ ] Create consolidated `drupal-coding-preferences.md` reference
11. [ ] Update all agents with Self-Verification Checklists

---

## Content to NOT Adopt

Since we're staying Claude Code only:

| Lullabot Feature | Reason to Skip |
|------------------|----------------|
| MDC glob-based rules | Cursor-specific feature |
| `.mdc` file format | Cursor-specific |
| Multi-tool wrappers | We're Claude Code only |
| Voice/Tone Styleguide | Not relevant to development |
| Content Optimization Agent | Not relevant to Drupal dev |
| 11ty site structure | Their hosting, not ours |

---

## Summary

### Our Advantages (Keep)

1. **Hub-Spoke Coordination** - Superior agent orchestration
2. **TaskMaster Integration** - Project management built-in
3. **/van Routing** - Intelligent request routing
4. **Handoff Protocols** - Structured agent transitions
5. **Hooks System** - Behavioral enforcement
6. **Field Type Matrix** - Drupal-specific field guidance
7. **15 Specialized Agents** - More coverage than Lullabot

### Their Advantages (Adopt)

1. **Implementation Preferences** - Add to our agents
2. **Critical Integrity Requirement** - Add to testing agent
3. **Self-Verification Checklists** - Add to all agents
4. **Error Handling Rules** - Add to standards
5. **Variable Naming Convention** - Add to standards
6. **Guard Clause Philosophy** - Add to coding guidance

### Conclusion

Our templates are **architecturally superior** (coordination, routing, handoffs) but Lullabot's agents have **richer implementation guidance**. The recommended enhancements merge Lullabot's coding wisdom into our superior framework.

**Estimated Time to Implement All Enhancements:** 3-4 hours

---

*Document generated for drupal-claude-code-sub-agent-collective template enhancement planning.*
