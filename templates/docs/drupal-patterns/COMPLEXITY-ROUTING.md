# Complexity Routing Guide

## Quick Decision

```
Task received → Check triggers below → Route appropriately
```

| Signals | Action |
|---------|--------|
| Single config/file, no research needed | Execute directly (Level 1) |
| ANY mandatory trigger below | Delegate to `/van` |
| Uncertain | Delegate (safer) |

---

## Mandatory Delegation Triggers

**Delegate to `/van` immediately when task involves ANY of these:**

### Scope-Based
- **3+ components affected** (modules, themes, config files)
- **Cross-cutting changes** (custom code + contrib + configuration)
- **System-wide updates** (version upgrades, API changes, deprecations)

### Complexity-Based
- **5+ code changes** required across files
- **Module replacement/removal**
- **Data model changes** (schema, fields, entities)
- **Integration changes** (external APIs, authentication)

### Risk-Based
- **Security-related** (vulnerabilities, access control)
- **Breaking changes** (affects existing functionality)
- **Production-impacting** (requires rollback planning)

---

## Assessment-Then-Delegate Rule

Run minimal diagnostics to determine scope, then delegate:

```
drush status / composer outdated / drupal-check
        ↓
   Results show:
   - 5+ issues         → STOP, delegate with findings
   - 3+ components     → STOP, delegate with findings
   - Research needed   → STOP, delegate
        ↓
   Truly simple?
   - Single change     → Execute directly
```

**Key**: Gather just enough to route correctly. Don't complete full assessment for complex tasks.

---

## Common Complex Tasks

| Task | Why Delegate | Agent Chain |
|------|--------------|-------------|
| Version upgrades | Multi-phase, compatibility | enhanced-project-manager → research → module-development |
| Deprecation fixes (5+) | Cross-file, testing | module-development → security-compliance |
| Module migrations | Content/config impact | research → module-development → config-management |
| Theme base changes | All templates affected | theme-development → security-compliance |
| Auth changes | Security-critical | research → module-development → security-compliance |
| API integrations | External deps | research → module-development |
| Schema changes | Data integrity | drupal-architect → module-development |
| Multi-module refactor | Coordination | enhanced-project-manager → module-development |
| Security fixes | Validation required | security-compliance → module-development |
| Performance optimization | Profiling needed | performance-devops |

---

## Level Reference

| Level | Agents | When |
|-------|--------|------|
| 1 | 0 | Single config/file, reversible, no research |
| 2 | 2-4 | Single feature, one module/theme |
| 3 | 5-9 | Multi-component system |
| 4 | 8-12+ | Full project, phased approach |

---

## Rule

**When in doubt, delegate.** Better to use agents for a simpler task than to miss complexity.
