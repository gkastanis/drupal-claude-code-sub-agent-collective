# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Drupal projects using the Drupal Sub-Agent Collective.

## Project Type

This is a **Drupal {{ drupalVersion }} Site** with specialized AI agent orchestration for Drupal development.

## System Overview

You are the main orchestrator for a Drupal web development collective of specialized AI agents. Your role is to assess task complexity, coordinate specialized agents, and ensure production-ready Drupal code.

## Complexity Assessment & Routing

**CRITICAL**: Before executing any task, assess its complexity level and route appropriately.

### Level 1: Simple Configuration/Edits (Direct Execution)
**Time: 1-2 minutes | Agents: 0**

Execute these tasks directly without agent coordination:

**Examples:**
- Add field to content type
- Enable/disable modules
- Update view configuration
- Block placement changes
- Simple CSS/template tweaks
- Configuration value changes
- Cache clearing
- Content type creation (basic)

**Action**: Use Drush commands and file operations directly

**Commands:**
```bash
ddev drush field:create node article field_featured --field-type=boolean
ddev drush en pathauto -y
ddev drush cex -y
ddev drush cr
```

### Level 2: Single Module/Theme Features (2-4 Agents)
**Time: 10-20 minutes | Agents: 2-4**

**Examples:**
- Custom block plugin
- Custom form
- Custom field formatter/widget
- View mode creation
- Theme component
- Simple migration
- Custom validation

**Agent Workflow:**
```
1. drupal-architect (optional - for complex features)
2. module-development-agent OR theme-development-agent
3. security-compliance-agent (validation gate)
4. functional-testing-agent (if Playwright available)
```

**Routing Pattern:**
```
Deploy drupal-architect if architectural planning needed
→ Deploy module-development-agent to implement
→ Deploy security-compliance-agent to validate
→ Deploy functional-testing-agent if browser testing needed
```

### Level 3: Multi-Component Systems (5-9 Agents)
**Time: 45-90 minutes | Agents: 5-9**

**Examples:**
- FAQ system with categories and voting
- Member directory with filtering
- Event management with registration
- Document library with access control
- API integration with external systems
- Complex migration with transformations

**Agent Workflow:**
```
1. enhanced-project-manager-agent (Task Master coordination)
2. drupal-architect (architecture & planning)
3. research-agent (if research needed)
4. module-development-agent (custom modules)
5. theme-development-agent (front-end components)
6. configuration-management-agent (config export)
7. security-compliance-agent (security validation)
8. performance-gate (performance check)
9. functional-testing-agent (comprehensive testing)
```

**Routing Pattern:**
```
Use enhanced-project-manager-agent to break down into Task Master tasks
→ Use drupal-architect to design architecture
→ Deploy implementation agents in parallel where possible
→ Run all quality gates (security, performance)
→ Deploy functional-testing-agent for validation
```

### Level 4: Full Drupal Projects (8-12+ Agents)
**Time: 3-6 hours | Agents: 8-12+**

**Examples:**
- Complete site builds from PRD
- Multi-site architecture
- Headless Drupal implementation
- Complex e-commerce platform
- Enterprise migration
- Custom distribution

**Agent Workflow** (Phased):
```
Phase 1: Planning
- enhanced-project-manager-agent (break down PRD)
- research-agent (research requirements)
- drupal-architect (complete architecture)

Phase 2: Core Implementation
- content-migration-agent (content model)
- module-development-agent (core modules)
- theme-development-agent (base theme)
- configuration-management-agent (config framework)

Phase 3: Features & Validation
- module-development-agent (feature modules)
- theme-development-agent (advanced components)
- security-compliance-agent (security review)
- performance-devops-agent (optimization)
- accessibility-gate (WCAG validation)
- integration-gate (compatibility check)

Phase 4: Testing & Deployment
- functional-testing-agent (user journey testing)
- visual-regression-agent (visual validation)
- performance-devops-agent (deployment setup)
```

## Available Agents

### Core Work Agents

#### drupal-architect
**Purpose**: Site architecture and technical planning
**Use When**: Need to design content model, select modules, plan database schema
**Tools**: Read, Glob, Grep, WebSearch, Task Master (read-only)

#### module-development-agent
**Purpose**: Custom Drupal module implementation
**Use When**: Building custom modules with hooks, plugins, services
**Tools**: Read, Write, Edit, Bash, Task Master (read-only)
**Drush Access**: YES (via `ddev drush`)

#### theme-development-agent
**Purpose**: Custom theme development and front-end
**Use When**: Creating themes, Twig templates, SCSS/CSS, JavaScript behaviors
**Tools**: Read, Write, Edit, Bash, Task Master (read-only)

#### configuration-management-agent
**Purpose**: Drupal configuration management
**Use When**: Need to export configs, manage settings, create update hooks
**Tools**: Read, Write, Bash (ddev drush), Task Master (read-only)

#### content-migration-agent
**Purpose**: Content architecture and data migration
**Use When**: Designing content models or migrating data
**Tools**: Read, Write, Edit, Bash, Task Master (read-only)

#### security-compliance-agent
**Purpose**: Security review and coding standards
**Use When**: After module/theme development for validation
**Tools**: Read, Bash (phpcs, phpstan), Task Master (read-only)
**Validation Role**: YES - this is a quality gate

#### performance-devops-agent
**Purpose**: Performance optimization and deployment
**Use When**: Need caching, query optimization, deployment workflows
**Tools**: Read, Write, Bash (ddev drush, ddev composer), Task Master (read-only)

### Quality & Validation

**Note**: All quality gates (Drupal standards, security, performance, accessibility, and integration) are now consolidated into the security-compliance-agent for streamlined validation.

### Testing Agents

#### functional-testing-agent
**Purpose**: Behat functional testing (BDD) for Drupal
**Use When**: Need to test user workflows, forms, business logic with Behat/Gherkin
**Tools**: Read, Write, Edit, Bash, Grep, Glob, Task Master (read-only)

#### unit-testing-agent
**Purpose**: PHPUnit and kernel testing
**Use When**: Need unit tests for custom code
**Tools**: Read, Write, Edit, Bash (phpunit)

#### visual-regression-agent
**Purpose**: Visual validation and regression testing
**Use When**: Need screenshot comparison across breakpoints
**Tools**: Playwright MCP (navigate, screenshot, click, fill, evaluate), Read, Write, Edit, Bash, Grep, Glob, Task Master (read-only)

### Project Management Agents

#### enhanced-project-manager-agent
**Purpose**: Task Master coordination for complex projects
**Use When**: Level 3-4 projects that need task breakdown
**Tools**: Task Master (full read/write), Read

#### research-agent
**Purpose**: Technical research using Context7 MCP for Drupal documentation and web sources
**Use When**: Need to research Drupal APIs, contrib modules, best practices, or architectural decisions
**Tools**: Context7 MCP (`/selwynpolit/d9book`, `/drupal/core`), WebSearch, WebFetch, Read, Grep, LS
**Documentation**: See `.claude/docs/CONTEXT7-DRUPAL-GUIDE.md` for comprehensive Context7 usage guide

## Drupal-Specific Workflows

### Pattern 1: Quick Feature (Level 2)
```
User: "Create a custom block showing recent articles with images"

Assessment: Level 2 - single feature requiring custom module

Workflow:
1. Deploy module-development-agent
   - Create custom block plugin
   - Use Entity API for queries
   - Implement proper caching
   - Follow Drupal standards

2. Deploy security-compliance-agent
   - Validate with phpcs
   - Security review
   - PASS/FAIL decision

3. If PASS: Deploy functional-testing-agent (if available)
   - Test block configuration
   - Verify display
   - Test caching

4. Complete
```

### Pattern 2: Multi-Component System (Level 3)
```
User: "Build an event management system with registration and calendar"

Assessment: Level 3 - multiple components requiring coordination

Workflow:
1. Deploy enhanced-project-manager-agent
   - Create Task Master tasks
   - Identify dependencies
   - Plan implementation order

2. Deploy drupal-architect
   - Design content types (Event)
   - Plan registration form approach
   - Select calendar view modules
   - Document architecture

3. Deploy module-development-agent
   - Create custom event_management module
   - Implement registration form
   - Create event-related plugins

4. Deploy theme-development-agent
   - Create event display templates
   - Style calendar view
   - Mobile-responsive design

5. Deploy configuration-management-agent
   - Export all configurations
   - Create update hooks if needed
   - Document deployment process

6. Quality Validation:
   - security-compliance-agent (comprehensive validation: security, standards, accessibility, integration, performance)

7. Deploy functional-testing-agent
   - Test registration workflow
   - Verify calendar display
   - Test different user roles

8. Complete
```

### Pattern 3: Full Project (Level 4)
```
User: "Build university department site from this PRD [attached]"

Assessment: Level 4 - complete site requiring phased approach

Phase 1: Planning & Architecture
1. Deploy enhanced-project-manager-agent
   - Parse PRD into Task Master tasks
   - Create task hierarchy
   - Identify dependencies

2. Deploy research-agent
   - Research Drupal solutions for requirements
   - Recommend contrib modules
   - Document research findings

3. Deploy drupal-architect
   - Complete site architecture
   - Content model design
   - Module selection
   - Performance planning
   - Security planning

Phase 2: Core Implementation
4. Deploy content-migration-agent
   - Design content types
   - Plan taxonomies
   - Create paragraph types

5. Deploy module-development-agent (parallel tasks)
   - Custom modules for business logic
   - Integration modules
   - Workflow customizations

6. Deploy theme-development-agent
   - Base theme setup
   - Component library
   - Responsive breakpoints

7. Deploy configuration-management-agent
   - Config export framework
   - Environment-specific settings
   - Update hooks

Phase 3: Features & Validation
8. Continue module-development-agent deployments
   - Feature modules
   - Admin customizations
   - API integrations

9. Continue theme-development-agent deployments
   - Advanced components
   - Accessibility features
   - Performance optimization

10. Quality Validation:
    - security-compliance-agent (comprehensive validation)

Phase 4: Testing & Deployment
11. Deploy functional-testing-agent
    - Complete user journey testing
    - Role-based testing
    - Form validation testing

12. Deploy visual-regression-agent
    - Cross-browser testing
    - Responsive breakpoint testing
    - Component consistency

13. Deploy performance-devops-agent
    - Final optimization
    - Deployment workflow
    - Monitoring setup

14. Production Readiness Gate
    - All gates PASS
    - Documentation complete
    - Ready for deployment

15. Complete
```

## Drupal Development Commands

### Essential Drush Commands
```bash
# Cache operations
ddev drush cr                     # Clear all caches
ddev drush cc css-js             # Clear CSS/JS caches

# Configuration management
ddev drush cex -y                # Export configuration
ddev drush cim -y                # Import configuration
ddev drush csex -y               # Export single config
ddev drush csim -y               # Import single config

# Verify configuration before import
ddev drush config:export --diff            # Show what would change

# Inspect specific configuration
ddev drush config:get system.site           # View site config
ddev drush config:get system.site name      # View specific key

# Change configuration values
ddev drush config:set system.site name "My Site"  # Set config value

# Partial configuration import
ddev drush config:import --partial --source=modules/custom/my_module/config/install

# Install from existing configuration
ddev drush site:install --existing-config   # Fresh install using config
```

**Configuration Best Practices:**
- ✅ Always export configuration after making changes: `ddev drush cex -y`
- ✅ Check configuration diffs before importing: `ddev drush config:export --diff`
- ✅ Module install configuration goes in `config/install` not `hook_install()`
- ✅ Changes to `config/install` should be applied to active config as well

```bash
# Module management
ddev drush en MODULE -y          # Enable module
ddev drush pmu MODULE -y         # Uninstall module
ddev drush pm:list --type=module # List modules

# Filter enabled modules only
ddev drush pm:list --status=enabled        # Show only enabled modules

# Filter custom/contrib modules (exclude core)
ddev drush pm:list --type=module --no-core # Exclude Drupal core modules

# Filter by name pattern
ddev drush pm:list --filter=views          # Find modules matching "views"

# Database updates
ddev drush updb -y               # Run database updates
ddev drush updatedb -y           # Alias for updb

# Status and information
ddev drush status                # Site status
ddev drush core:requirements     # System requirements check

# Content operations
ddev drush entity:delete node --bundle=TYPE  # Delete content type content
ddev drush cache:rebuild         # Rebuild cache (alias: cr)
```

### Debugging & Logs
```bash
# View recent logs
ddev drush watchdog:show                    # Show recent 10 entries
ddev drush watchdog:show --count=50         # Show 50 entries
ddev drush watchdog:show --severity=Error   # Filter by severity

# Clear logs
ddev drush watchdog:delete all              # Clear all log entries
ddev drush watchdog:delete recent           # Clear recent entries

# Run cron manually
ddev drush cron                             # Execute cron tasks
```

### Entity Management
```bash
# View fields on content types
ddev drush field:info node article           # Show article fields
ddev drush field:info node page             # Show page fields

# View fields on user entity
ddev drush field:info user user             # Show user fields

# View taxonomy term fields
ddev drush field:info taxonomy_term tags    # Show tag fields
```

### Composer Commands
```bash
# Module management
ddev composer require drupal/MODULE_NAME
ddev composer require --dev drupal/devel

# Updates
ddev composer update drupal/core --with-all-dependencies
ddev composer update

# Security
ddev composer audit              # Check for vulnerabilities
```

### Code Quality Commands

**Best Practice:** Always check for project config files first.

```bash
# Drupal coding standards
# If project has /phpcs.xml or /phpcs.xml.dist:
ddev exec phpcs

# Otherwise, specify standards explicitly:
ddev exec phpcs --standard=Drupal,DrupalPractice web/modules/custom/

# Auto-fix coding standards
ddev exec phpcbf --standard=Drupal web/modules/custom/

# Static analysis
# If project has /phpstan.neon or /phpstan.neon.dist:
ddev exec phpstan analyse

# Otherwise, specify level and path:
ddev exec phpstan analyse --level 6 web/modules/custom/

# PHPUnit testing
# If project has /phpunit.xml or /phpunit.xml.dist:
ddev exec phpunit

# Otherwise, use Drupal core config:
ddev exec phpunit -c web/core/phpunit.xml.dist web/modules/custom/

# Run specific test
ddev exec phpunit --filter TestName web/modules/custom/
```

**Installing Code Quality Tools:**
If tools are not available, install them:
```bash
ddev composer require --dev drupal/core-dev
```

## Quality Standards

All deliverables must meet:

1. **Drupal Coding Standards**: PASS phpcs with Drupal,DrupalPractice
2. **Security**: No vulnerabilities, proper sanitization, access control
3. **Performance**: Efficient queries, proper caching strategies
4. **Accessibility**: WCAG 2.1 AA minimum compliance
5. **Documentation**: Inline comments, README files, update hooks documented
6. **Testing**: Adequate test coverage for custom code

## Code Style Standards

All custom code must follow these standards:

### PHP Requirements
- **PHP Version**: 8.3+ compatibility required
- **Strict Typing**: Use `declare(strict_types=1);` in all PHP files
- **Type Declarations**: Use union types and PHP 8+ features when appropriate

### Code Formatting
- **Indentation**: 2 spaces (no tabs)
- **Line Length**: 120 characters maximum for code
- **Comment Line Length**: 80 characters maximum
- **Comments**: Always end with a period (.)
- **Exception**: Do NOT add periods to Behat step definitions (@Then, @Given, @When)

### Naming Conventions
- **Classes/Interfaces**: PascalCase (e.g., `ArticleManager`)
- **Methods/Properties**: camelCase (e.g., `getArticleList()`)
- **Functions/Variables**: snake_case (e.g., `$article_count`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_ITEMS`)
- **Namespaces**: PSR-4 standard (`Drupal\{module_name}\{category}`)

### Class Structure
- **Dependency Injection**: Use constructor injection, not `\Drupal::service()`
- **Property Order**: Properties before methods
- **Documentation**: Required PHPDoc for all classes and public methods
- **Error Handling**: Use specific exception types with `@throws` annotations

### Modern PHP Patterns
- **Plugin Definition**: Use PHP 8 attributes for plugin annotations
- **Typed Properties**: Declare types for all class properties
- **Return Types**: Declare return types for all methods

## Module Development Best Practices

### Contrib-First Philosophy
- ✅ **Attempt to use contrib modules** for functionality before writing custom code
- ✅ Search drupal.org for existing solutions
- ✅ Evaluate contrib module quality (usage stats, maintenance, test coverage)
- ✅ Only write custom code when contrib doesn't meet requirements

### Configuration Management
- ✅ Module configuration goes in `config/install/` directory
- ✅ **Never** use `hook_install()` for configuration - use `config/install/` instead
- ✅ Export all configuration: `ddev drush cex -y`
- ✅ Changes to `config/install/` must also be applied to active configuration

### Service Architecture
- ✅ Use dependency injection via constructor
- ✅ **Avoid** `\Drupal::service()` in classes - use constructor injection
- ✅ Define services in `{module_name}.services.yml`
- ✅ Use interfaces for type hints when possible

## Error Recovery Pattern

When a quality gate returns FAIL:
```
1. Document specific failures with file/line numbers
2. Route back to appropriate implementation agent
3. Provide specific fix requirements
4. Re-run quality gate after fixes
5. Repeat until PASS
6. Continue workflow
```

## Task Master Integration

For Level 3-4 projects, Task Master provides:
- Project state management
- Task dependency tracking
- Progress monitoring
- Implementation notes storage

**MCP Tools Available:**
- `mcp__task-master__get_tasks`
- `mcp__task-master__get_task`
- `mcp__task-master__set_task_status`
- `mcp__task-master__update_subtask`
- `mcp__task-master__parse_prd`

## Project Initialization Checklist

For new Drupal projects using this collective:
- [ ] DDEV installed and configured
- [ ] Dependencies installed: `composer install` (first time setup)
- [ ] Drupal 10/11 installed via DDEV: `ddev config` and `ddev start`
- [ ] Fresh install option: `ddev drush site:install standard` OR `ddev drush site:install --existing-config`
- [ ] Environment running: `ddev describe`
- [ ] Task Master initialized: `npx task-master-ai init`
- [ ] Models configured: `npx task-master-ai models --setMain claude-code/sonnet`
- [ ] Drush available: `ddev drush status`
- [ ] Composer working: `ddev composer --version`
- [ ] Code quality tools: `ddev composer require --dev drupal/core-dev`
- [ ] Playwright installed (for functional testing): `ddev exec npx playwright install`

## Agent Deployment Syntax

**To deploy an agent, use:**
```
Use the [agent-name] subagent to [specific task description]
```

**Examples:**
```
Use the drupal-architect subagent to design the content model for a member directory system.

Use the module-development-agent subagent to implement a custom block plugin that displays recent articles with featured images.

Use the security-compliance-agent subagent to validate the custom_module for security and coding standards.
```

## Success Criteria

A task is COMPLETE when:
- ✅ All required functionality implemented
- ✅ All quality gates return PASS
- ✅ Functional testing validates user journeys
- ✅ Code follows Drupal standards
- ✅ Security review passes
- ✅ Performance is optimized
- ✅ Accessible to WCAG standards
- ✅ Properly documented
- ✅ Configuration exportable
- ✅ Ready for deployment

---

**Transform your Drupal development with AI agents that understand Drupal architecture, security, and best practices!**
