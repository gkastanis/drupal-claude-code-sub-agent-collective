# Available Specialized Agents

## 🎯 COORDINATION & ORCHESTRATION
- **@routing-agent** - Central hub routing for agent task delegation (hub-and-spoke coordinator)
- **@enhanced-project-manager-agent** - TaskMaster integration for complex project management with actual execution
- **@workflow-agent** - Multi-agent workflow orchestrator for ad-hoc coordination (without TaskMaster)

## 🏗️ DRUPAL DEVELOPMENT SPECIALISTS
- **@drupal-architect** - Site architecture and technical planning, content model design, module selection
- **@module-development-agent** - Custom Drupal module implementation following Drupal 10/11 standards
- **@theme-development-agent** - Custom theme development with Twig, SCSS, JavaScript, and Drupal behaviors
- **@configuration-management-agent** - Config export/import, update hooks, deployment workflows
- **@content-migration-agent** - Content architecture design and data migration modules

## 🔬 RESEARCH & ANALYSIS
- **@research-agent** - Context7-powered technical research with protocol-driven workflows
  - Reads research protocols first (RESEARCH-CACHE-PROTOCOL.md, RESEARCH-BEST-PRACTICES.md)
  - Preserves Context7 code examples (never summarizes them)
  - 7-day cache freshness rules
  - Hands off to task-generator-agent

## 🧪 TESTING & QUALITY SPECIALISTS (OPTIONAL)
- **@unit-testing-agent** - PHPUnit testing (unit, kernel, functional tests) - optional, when requested
- **@functional-testing-agent** - Behat functional testing with Gherkin syntax - optional, when requested
  - **NOTE**: NO JavaScript/AJAX support - server-side behavior only
  - Uses ddev robo behat for execution
- **@visual-regression-agent** - Visual regression testing with BackstopJS, Percy, and Playwright - optional, when requested

## 🔒 SECURITY & COMPLIANCE
- **@security-compliance-agent** - Security review, Drupal coding standards, WCAG 2.1 AA accessibility
  - SQL injection and XSS prevention validation
  - Access control verification
  - Integration and dependency validation
  - Returns PASS/FAIL gate results with remediation workflow

## ⚡ PERFORMANCE & OPERATIONS
- **@performance-devops-agent** - Performance optimization, caching strategies (Redis/Memcached), deployment workflows
  - Query optimization (N+1 prevention)
  - BigPipe lazy loading
  - CDN configuration
  - CI/CD pipeline setup

## Agent Capabilities Matrix

| Agent | Primary Tools | Output | Handoff To |
|-------|--------------|--------|------------|
| routing-agent | Analysis | Agent selection | Any specialist agent |
| enhanced-project-manager-agent | TaskMaster MCP, Task tool | Coordination report | Specialized agents |
| workflow-agent | Task tool, complexity analysis | Workflow summary | Multiple agents in sequence/parallel |
| drupal-architect | Read, Grep, WebSearch | Architecture document | module/theme agents |
| module-development-agent | Read, Write, Edit, Bash | Module code | security-compliance-agent |
| theme-development-agent | Read, Write, Edit, Bash | Theme code | visual-regression-agent |
| configuration-management-agent | Bash, Read, Write | Config files, update hooks | integration-gate |
| content-migration-agent | Read, Write, Bash | Migration module | integration-gate |
| research-agent | Context7 MCP, WebSearch, Read | Research documents | task-generator-agent |
| unit-testing-agent | Bash, Read, Write | Test code, coverage report | None (complete) |
| functional-testing-agent | Bash, Read, Write | Behat scenarios | None (complete) |
| visual-regression-agent | Playwright MCP, Bash | BackstopJS config, screenshots | None (complete) |
| security-compliance-agent | Bash, Read, Grep | PASS/FAIL gate result | module-development-agent (on FAIL) |
| performance-devops-agent | Bash, Read, Write | Optimized code, deployment scripts | performance-gate |

## Research-Backed Agent Intelligence

**Context7 integration for current Drupal documentation:**

```bash
# Research agent uses autonomously
mcp__context7__resolve_library_id(libraryName="drupal")
mcp__context7__get_library_docs(context7CompatibleLibraryID="/drupal/core", topic="entity-api")

# TaskMaster integration for project coordination
mcp__task_master__next_task(projectRoot=".")
mcp__task_master__get_task(id="5", projectRoot=".")
```

## Enhanced Agent Capabilities

**Agents leverage research and TaskMaster integration for informed decisions:**

```yaml
# Research-backed development workflow
research_workflow:
  1. research-agent: Context7 library documentation + Drupal best practices
  2. drupal-architect: Architecture design with researched patterns
  3. module-development-agent: Implementation with dependency injection
  4. security-compliance-agent: Validation with WCAG 2.1 AA + coding standards
  5. unit-testing-agent: PHPUnit tests (optional, when requested)

# TaskMaster coordination
project_coordination:
  coordinator: enhanced-project-manager-agent
  task_source: TaskMaster MCP
  workflow: Multi-phase development with research integration
  validation: Quality-driven handoffs with contract validation
```

## Agent Handoff Schema

All agents use standardized YAML handoff blocks:

```yaml
handoff:
  phase: "Development" | "Testing" | "Integration" | "Complete"
  from: "@agent-name"
  to: "@next-agent" | "None"
  status: "in_progress" | "complete" | "failed" | "blocked"
  retry_count: 0
  metrics:
    # Agent-specific metrics
  dependencies: ["task-id-1", "task-id-2"]
  on_failure:
    retry: 2
    route_to: "@fallback-agent"
    notify: "@coordinator-agent"
    context: "Specific failure reason and remediation needs"
```

## Drupal-Specific Features

### Field Management (module-development-agent)
- Drush field creation with storage reuse patterns
- Widget/field type mapping discovery
- Configuration export integration

### Security Validation (security-compliance-agent)
- PHP_CodeSniffer with Drupal and DrupalPractice standards
- PHPStan static analysis
- WCAG 2.1 AA accessibility compliance
- SQL injection and XSS prevention verification

### Testing Options (When Requested)
- **PHPUnit**: Unit, Kernel, Functional tests - optional
- **Behat**: Server-side functional testing (no JavaScript) - optional
- **BackstopJS**: Visual regression with responsive breakpoints - optional

### Performance Optimization
- Redis/Memcached caching configuration
- N+1 query prevention
- BigPipe lazy loading
- CDN integration

---

**Version**: Drupal Agent Collective v1.0
**Agent Count**: 14 specialized agents
**Coverage**: Full Drupal development lifecycle
