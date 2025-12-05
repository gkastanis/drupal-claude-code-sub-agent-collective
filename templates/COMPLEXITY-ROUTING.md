# Complexity Assessment & Agent Routing

**CRITICAL: YOU MUST read this file before executing ANY task.**

This document defines mandatory routing rules for the Claude Code Sub-Agent Collective.

---

## MANDATORY: Assess Complexity First

**BEFORE doing anything, determine the task complexity level and route accordingly.**

Failure to route correctly will result in:
- Wasted context on simple tasks
- Incomplete implementations on complex tasks
- Missing quality gates and security checks

---

## Level 1: Simple Tasks (Direct Execution)

**Complexity: Low | Agents: 0 | Time: 1-2 minutes**

**YOU MUST execute these directly - DO NOT spawn agents:**

- Add/edit fields on content types
- Enable/disable modules
- Update view configuration
- Block placement changes
- Simple CSS/template tweaks
- Configuration value changes
- Cache clearing
- Basic content type creation

**Commands:**
```bash
ddev drush field:create node article field_featured --field-type=boolean
ddev drush en pathauto -y
ddev drush cex -y
ddev drush cr
```

---

## Level 2: Single Module/Theme Features (2-4 Agents)

**Complexity: Medium | Agents: 2-4 | Time: 10-20 minutes**

**Examples:**
- Custom block plugin
- Custom form with validation
- Field formatter/widget
- Theme component
- Simple migration
- Custom access control

**REQUIRED Agent Sequence:**
```
1. drupal-architect (if architectural decisions needed)
2. module-development-agent OR theme-development-agent
3. security-compliance-agent (MANDATORY validation gate)
4. functional-testing-agent (if Playwright available)
```

---

## Level 3: Multi-Component Systems (5-9 Agents)

**Complexity: High | Agents: 5-9 | Time: 45-90 minutes**

**Examples:**
- FAQ system with categories and voting
- Member directory with filtering
- Event management with registration
- Document library with access control
- External API integration
- Complex migration with transformations

**REQUIRED Agent Sequence:**
```
Phase 1: Planning
  → enhanced-project-manager-agent (Task Master breakdown)
  → drupal-architect (architecture design)
  → research-agent (if external research needed)

Phase 2: Implementation
  → module-development-agent (custom modules)
  → theme-development-agent (front-end)
  → configuration-management-agent (config export)

Phase 3: Validation (ALL MANDATORY)
  → security-compliance-agent
  → performance-gate
  → functional-testing-agent
```

---

## Level 4: Full Projects (8-12+ Agents)

**Complexity: Very High | Agents: 8-12+ | Time: 3-6 hours**

**Examples:**
- Complete site builds from PRD
- Multi-site architecture
- Headless Drupal implementation
- E-commerce platforms
- Enterprise migrations
- Custom distributions

**REQUIRED Phased Workflow:**

### Phase 1: Planning (NEVER SKIP)
```
→ enhanced-project-manager-agent (PRD breakdown)
→ research-agent (requirements research)
→ drupal-architect (complete architecture)
```

### Phase 2: Core Implementation
```
→ content-migration-agent (content model)
→ module-development-agent (core modules)
→ theme-development-agent (base theme)
→ configuration-management-agent (config framework)
```

### Phase 3: Features & Validation
```
→ module-development-agent (feature modules)
→ theme-development-agent (advanced components)
→ security-compliance-agent (MANDATORY)
→ performance-devops-agent (optimization)
→ accessibility-gate (WCAG validation)
→ integration-gate (compatibility)
```

### Phase 4: Testing & Deployment
```
→ functional-testing-agent (user journeys)
→ visual-regression-agent (visual validation)
→ performance-devops-agent (deployment)
```

---

## Quick Reference Matrix

| Task Type | Level | Agents | First Action |
|-----------|-------|--------|--------------|
| Config change | 1 | 0 | Execute directly |
| Single feature | 2 | 2-4 | module-development-agent |
| Multi-component | 3 | 5-9 | enhanced-project-manager-agent |
| Full project | 4 | 8-12+ | enhanced-project-manager-agent |

---

## IMPORTANT: Validation Gates

**These agents MUST run before any task is considered complete:**

| Gate | When Required | Purpose |
|------|---------------|---------|
| security-compliance-agent | Level 2+ | Security review |
| performance-gate | Level 3+ | Performance check |
| functional-testing-agent | Level 2+ (if Playwright) | Behavior validation |
| accessibility-gate | Level 4 | WCAG compliance |

**DO NOT skip validation gates. Ever.**
