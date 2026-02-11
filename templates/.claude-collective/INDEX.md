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
**Handoff**: /continue-handoff, /reset-handoff
**TaskMaster** (/tm:\*): list, show, next, add-task, expand, set-status, parse-prd, analyze-complexity, update-task, update-subtask, add-dependency, fix-dependencies, complexity-report, generate, models, init, remove-task, remove-subtask, validate-dependencies
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

Rules from production usage analysis (150 sessions, 1,131 messages):

1. **Grep after multi-file changes**: After modifying functions, constants, or variables across files, grep the codebase for remaining references to catch missed locations.

2. **Verify Drupal service changes**: After service or Twig changes, verify: service injections are correct, DB table and column names exist, Twig filters actually exist in the project.

3. **Use config over magic numbers**: Search for existing config constants before hardcoding values (e.g., * 8 for hours, * 5 for weekdays). Use system-configured values.

4. **Remove from ALL locations**: When removing or disabling something, remove from ALL locations (controller, template, Twig, JS, config) and grep to confirm nothing was missed.

5. **Write files to project directory**: Write output files to the appropriate project directory, not inline in chat.

6. **Target specific CSS selectors**: For CSS fixes, target specific elements within context (.parent .child), not parent containers.

## Quality

- TDD: Tests first (RED) --> implement (GREEN) --> refactor
- Handoff validation: context completeness, agent match, tests passing
- Agents report: completion status with test results (display verbatim, never summarize)
- Phase gates: all subtasks complete, tests pass, no directive violations
