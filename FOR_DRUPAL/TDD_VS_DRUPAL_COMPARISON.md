# TDD vs Drupal Sub-Agent Collective Comparison

## Key Differences Overview

| Aspect | TDD Version | Drupal Version |
|--------|-------------|----------------|
| **Primary Focus** | Test-Driven Development, general software | Drupal CMS web development |
| **Agent Count** | 19 agents | 15 specialized Drupal agents |
| **Testing Emphasis** | TDD methodology, write tests first | Drupal-specific testing (PHPUnit, functional, security) |
| **Quality Gates** | Generic code quality | Drupal coding standards, security, performance |
| **Tool Integration** | Generic dev tools | Drupal-specific (Drush, Composer, phpcs) |
| **Output** | General applications | Drupal modules, themes, configurations |

## Agent Comparison

### Removed Agents (from TDD version)
These agents don't apply to Drupal development:
- Generic TDD Test Writers (replaced with Drupal-specific testing)
- General QA agents (replaced with Drupal quality gates)

### New Drupal-Specific Agents

| Agent | Purpose | Unique to Drupal |
|-------|---------|------------------|
| **Drupal Architect** | Site architecture, content modeling | ✅ Content types, taxonomies, Views |
| **Module Development Agent** | Custom Drupal module creation | ✅ Hooks, plugins, services, DI |
| **Theme Development Agent** | Drupal theming with Twig | ✅ Twig templates, preprocess functions |
| **Configuration Management Agent** | Drupal CMI workflow | ✅ Config export/import, update hooks |
| **Content & Migration Agent** | Drupal migrations | ✅ Migrate API, content modeling |
| **Security & Compliance Agent** | Drupal-specific security | ✅ Security review, Drupal standards |

### Adapted Agents (modified from TDD version)

| TDD Agent | Drupal Equivalent | Key Changes |
|-----------|-------------------|-------------|
| Implementation Agent | Module/Theme Dev Agents | Split into two: modules & themes |
| Quality Agent | Security & Compliance Agent | Drupal coding standards, security review |
| DevOps Agent | Performance & DevOps Agent | Drupal caching, Drush, Composer |
| Testing Agent | Functional/Unit Testing Agents | Drupal testing frameworks |

## Tool & Technology Differences

### TDD Version Tools
```bash
# Generic testing frameworks
- Jest / Mocha
- Selenium / Cypress
- Generic linters
- Git workflows
```

### Drupal Version Tools
```bash
# Drupal-specific tools
- Drush (Drupal CLI)
- Composer (PHP dependency management)
- PHP_CodeSniffer with Drupal standards
- PHPStan (PHP static analysis)
- PHPUnit with Drupal test base classes
- Drupal Migrate API
- Configuration Management (CMI)
```

## Workflow Differences

### TDD Version Workflow
1. Write failing test
2. Implement minimum code to pass
3. Refactor
4. Repeat

### Drupal Version Workflow
1. Design Drupal architecture (content types, modules needed)
2. Implement using Drupal APIs and best practices
3. Validate against Drupal standards
4. Security review
5. Performance optimization
6. Functional testing in browser
7. Configuration export

## Quality Gate Comparison

| TDD Gates | Drupal Gates | Notes |
|-----------|--------------|-------|
| Test Coverage Gate | Unit Testing Agent | Drupal uses PHPUnit with kernel tests |
| Code Quality Gate | Drupal Standards Gate | phpcs with Drupal/DrupalPractice |
| Integration Gate | Integration Gate | Similar, but checks Drupal module compatibility |
| - | Security Gate | **New**: Drupal-specific security checks |
| - | Accessibility Gate | **New**: WCAG compliance for Drupal output |
| - | Performance Gate | **New**: Drupal caching and query optimization |

## Example Task Comparison

### TDD Version: "Add user login"
```
1. Write test for login functionality
2. Test fails
3. Implement login (generic approach)
4. Test passes
5. Refactor
```

### Drupal Version: "Add user login"
```
1. Architect evaluates: Drupal core already has this
2. If customization needed:
   - Module Dev: Create custom form alter
   - Theme Dev: Style login block
   - Security: Review custom code
   - Functional Test: Test in browser
```

### TDD Version: "Build todo app"
```
Level 3-4 project:
1. PM breaks down into components
2. Write tests for each component
3. Implement components (TDD cycle)
4. Integration testing
5. Browser validation
```

### Drupal Version: "Build event management system"
```
Level 3 project:
1. Architect: Design content architecture
   - Event content type
   - Date field, location taxonomy
   - Views for display
2. Module Dev: Custom registration plugin
3. Theme Dev: Event templates and calendar view
4. Config Mgmt: Export all configurations
5. Security Gate: Review permissions
6. Functional Test: Test registration flow
7. Performance Gate: Check query efficiency
```

## MCP Server Usage

### TDD Version
```bash
# Generic development MCPs
- task-master (coordination)
- context7 (library docs)
- playwright (browser testing)
```

### Drupal Version
```bash
# Same core MCPs
- task-master (coordination)
- playwright (browser testing)

# Potential Drupal-specific MCPs (to be developed)
- drush-mcp (Drupal CLI operations)
- drupal-api-mcp (api.drupal.org documentation)
- composer-mcp (PHP dependency management)
```

## Code Standards

### TDD Version
```javascript
// Generic JavaScript/TypeScript
- ESLint
- Prettier
- TypeScript strict mode
```

### Drupal Version
```php
// Drupal PHP standards
- Drupal Coding Standards (via phpcs)
- DrupalPractice (additional best practices)
- PHPStan (static analysis)
- Drupal API usage patterns
```

## Testing Approach Differences

### TDD Version
- **Philosophy**: Tests define requirements
- **Workflow**: Red → Green → Refactor
- **Coverage**: 100% test coverage goal
- **Tools**: Unit tests drive development

### Drupal Version
- **Philosophy**: Drupal standards define requirements
- **Workflow**: Architecture → Implementation → Standards → Testing
- **Coverage**: Critical paths tested, contrib modules trusted
- **Tools**: Multiple testing layers (unit, kernel, functional, browser)

## Output Artifacts

### TDD Version Deliverables
```
project/
├── src/
│   └── components/     # Implementations
├── tests/
│   ├── unit/          # Unit tests
│   ├── integration/   # Integration tests
│   └── e2e/           # End-to-end tests
└── README.md
```

### Drupal Version Deliverables
```
drupal/
├── web/
│   ├── modules/custom/
│   │   └── my_module/
│   │       ├── my_module.info.yml
│   │       ├── my_module.module
│   │       └── tests/          # PHPUnit tests
│   └── themes/custom/
│       └── my_theme/
│           ├── my_theme.info.yml
│           ├── templates/      # Twig files
│           └── css/
├── config/sync/               # Exported configs
└── README.md
```

## Best Use Cases

### TDD Version Best For:
- Greenfield JavaScript/TypeScript projects
- Applications where requirements are test-definable
- Projects needing extensive test coverage
- API development with clear contracts
- Team enforcing TDD methodology

### Drupal Version Best For:
- Drupal 10/11 website development
- Custom module/theme development
- Content-driven websites
- Enterprise CMS implementations
- Drupal agency project work
- Sites requiring Drupal best practices
- Organizations using Drupal's configuration management

## Migration Path

If you have the TDD version and want to adapt it for Drupal:

### Step 1: Replace CLAUDE.md
- Remove TDD-specific workflow instructions
- Add Drupal architecture guidelines
- Update agent definitions for Drupal focus

### Step 2: Update Agent Roles
- Rename/repurpose Implementation Agent → Module/Theme Agents
- Add Drupal-specific agents (Architecture, Config Management)
- Update Quality gates for Drupal standards

### Step 3: Tool Integration
- Add Drush command support
- Add Composer commands
- Configure phpcs with Drupal standards
- Set up PHPUnit with Drupal test base

### Step 4: Testing Strategy
- Remove TDD red-green-refactor mandate
- Add Drupal-specific test types (kernel, functional)
- Integrate Drupal security review
- Add performance validation

## When to Use Which Version?

### Use TDD Version When:
- Building custom applications from scratch
- Team is committed to TDD methodology
- Need high test coverage enforcement
- Working with modern JavaScript frameworks
- Requirements are test-definable

### Use Drupal Version When:
- Building Drupal websites or applications
- Working with existing Drupal codebase
- Need Drupal best practices enforcement
- Leveraging Drupal's contrib ecosystem
- Using Drupal's configuration management
- Building for Drupal agencies/clients

## Performance Characteristics

| Metric | TDD Version | Drupal Version |
|--------|-------------|----------------|
| Initial setup time | ~10 minutes | ~15 minutes (Drupal setup) |
| Simple task (Level 1) | ~2 minutes | ~1 minute (Drush commands) |
| Feature dev (Level 2) | ~10-15 minutes | ~15-20 minutes (Drupal architecture) |
| Complex system (Level 3) | ~30-60 minutes | ~45-90 minutes (Drupal components) |
| Full project (Level 4) | ~2-4 hours | ~3-6 hours (Drupal site build) |

## Conclusion

The **TDD version** is optimized for general software development with test-driven methodology, while the **Drupal version** is specialized for Drupal CMS development with Drupal-specific best practices, security standards, and configuration management.

Choose based on your project type and team methodology preferences.
