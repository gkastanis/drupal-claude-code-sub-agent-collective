# Available Specialized Agents

## 🎯 COORDINATION & ORCHESTRATION
- **@routing-agent** - Central hub routing for task delegation
- **@enhanced-project-manager-agent** - TaskMaster integration for complex projects
- **@workflow-agent** - Multi-agent workflow orchestration

## 🏗️ DRUPAL DEVELOPMENT
- **@drupal-architect** - Architecture, content model design, module selection
- **@module-development-agent** - Custom modules (Drupal 10/11 standards)
- **@theme-development-agent** - Themes with Twig, SCSS, JavaScript
- **@configuration-management-agent** - Config export/import, update hooks
- **@content-migration-agent** - Content architecture and migrations

## 🔬 RESEARCH & DOCUMENTATION
- **@research-agent** - Context7-powered research (7-day cache, preserves code examples)
- **@semantic-architect-agent** - Knowledge Graph documentation mapping business logic to code implementation

## 🧪 TESTING & QUALITY (OPTIONAL)
- **@unit-testing-agent** - PHPUnit (optional, when requested)
- **@functional-testing-agent** - Behat (optional, when requested - server-side only, no JavaScript)
- **@visual-regression-agent** - BackstopJS, Percy, Playwright (optional, when requested)
- **@security-compliance-agent** - Security, coding standards, WCAG 2.1 AA (PASS/FAIL gate)

## ⚡ PERFORMANCE & OPERATIONS
- **@performance-devops-agent** - Optimization, caching, deployment

## Capabilities Matrix

| Agent | Primary Tools | Handoff To |
|-------|--------------|------------|
| routing-agent | Analysis | Any specialist |
| enhanced-project-manager-agent | TaskMaster MCP | Specialized agents |
| workflow-agent | Task tool | Multiple agents |
| drupal-architect | Read, Grep, WebSearch | module/theme agents |
| module-development-agent | Read, Write, Edit, Bash | security-compliance-agent |
| theme-development-agent | Read, Write, Edit, Bash | visual-regression-agent |
| configuration-management-agent | Bash, Read, Write | integration-gate |
| content-migration-agent | Read, Write, Bash | integration-gate |
| research-agent | Context7 MCP, WebSearch | task-generator-agent |
| semantic-architect-agent | Read, Glob, Grep, Write | None (complete) |
| unit-testing-agent | Bash, Read, Write | None (complete) |
| functional-testing-agent | Bash, Read, Write | None (complete) |
| visual-regression-agent | Playwright MCP | None (complete) |
| security-compliance-agent | Bash, Read, Grep | module-agent (on FAIL) |
| performance-devops-agent | Bash, Read, Write | performance-gate |

## MCP Integration

**Context7**: Research agent uses for current Drupal docs
**TaskMaster**: Project manager uses for task coordination
**Playwright**: Visual regression agent uses for screenshots

## Handoff Schema

```yaml
handoff:
  from: "@agent-name"
  to: "@next-agent" | "None"
  status: "in_progress" | "complete" | "failed"
  on_failure:
    retry: 2
    route_to: "@fallback-agent"
```
