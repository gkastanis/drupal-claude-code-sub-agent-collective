# Collective Index

## Agents (15 installed)

| Agent | Role |
|-------|------|
| routing-agent | Request analysis and agent selection |
| drupal-architect | Architecture decisions, dependency injection, entity API |
| module-development-agent | Drupal module creation: hooks, plugins, services, schema |
| theme-development-agent | Twig templates, assets, responsive design, accessibility |
| configuration-management-agent | CMI, install/update hooks, config schema |
| content-migration-agent | Source/process plugins, ETL pipelines, rollback |
| security-compliance-agent | OWASP, Drupal SA, access control, input sanitization |
| performance-devops-agent | Caching, aggregation, CDN, database optimization |
| functional-testing-agent | Behat scenarios, contexts, step definitions |
| unit-testing-agent | PHPUnit mocking, assertions, coverage |
| visual-regression-agent | Baseline comparison, thresholds, responsive screenshots |
| enhanced-project-manager-agent | Sprint planning, task coordination, milestone tracking |
| research-agent | Context7 technical research, library documentation |
| workflow-agent | Multi-agent orchestration, complex task coordination |
| semantic-architect-agent | Logic-to-code documentation, entity schemas |

## Commands

**Routing**: /van (agent routing), /mock (testing), /autocompact (context save)
**Discovery**: /discover (docs-first codebase discovery), /prd (PRD generator)
**Handoff**: /continue-handoff, /reset-handoff
**TaskMaster** (/tm:\*): list, show, next, add-task, expand, set-status, parse-prd, analyze-complexity, update-task, update-subtask, add-dependency, fix-dependencies, complexity-report, generate, models, init, remove-task, remove-subtask, validate-dependencies
**Testing**: /drupal-verify (verify Drupal implementations)
**Workflows**: /implement, /update-docs, /verify-changes
**TaskMaster Workflows**: /tm:workflows/auto-implement-tasks, /tm:workflows/smart-workflow, /tm:workflows/command-pipeline

## Context Loading (JIT)

Load ONLY when needed -- never at startup:
- `/van` command used --> load `van-context.md` for routing matrices and behavioral directives
- TaskMaster operations --> load `taskmaster-reference.md` for command quick-reference
- Research/analysis tasks --> load `research-framework.md` for hypotheses and metrics
- Hook debugging --> load `hook-guide.md` for troubleshooting and restart procedures
- Semantic docs tasks --> check `docs/semantic/00_BUSINESS_INDEX.md` for logic-to-code mappings

## Behavioral Rules

Detailed rules are in `.claude/rules/` (auto-loaded by topic). Key rules:

1. **Grep after multi-file changes** - catch missed references.
2. **Verify Drupal service changes** - confirm injections, table names, Twig filters.
3. **Use config over magic numbers** - search for existing constants first.
4. **Remove from ALL locations** - grep to confirm nothing was missed.
5. **Verify before completion** - run tests (curl smoke or drush eval), document results, store scripts in `scripts/tests/`.

## Quality

- TDD: Tests first (RED) --> implement (GREEN) --> refactor
- Handoff validation: context completeness, agent match, tests passing
- Agents report: completion status with test results (display verbatim, never summarize)
- Phase gates: all subtasks complete, tests pass, no directive violations
