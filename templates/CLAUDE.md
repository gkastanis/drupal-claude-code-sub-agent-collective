# CLAUDE.md

## Project Overview
This project is a **Drupal 10/11** site built with a **Composer-based workflow**.
Development follows **Drupal coding standards**, **Drupal API best practices**, and modern **Symfony service patterns**.

---

## Project Structure

```
www/
  modules/custom/  # Main custom module
  themes/custom/              # Custom themes
behat/                        # Behat tests and configs
  behat.yml                   # Behat configuration
  screenshots/                # Failed test screenshots
translations/                 # Project-wide translations (.po files)
config/                       # Drupal configuration
scripts/                      # Build and deployment scripts
```

---

## Development Environment

**Requirements**
- PHP 8.3+ (Drupal 10 and Drupal 11)
- Composer 2.x
- MySQL 8.x
- Node.js 18+ (for theme build)
- Drush 12+
- ddev
- Behat for functional testing

**Install**
```bash
ddev composer install
```

**Run (Local)**
```bash
ddev start
```

**Reference**
- Follow Drupal PHP Coding Standards: https://www.drupal.org/docs/develop/standards

---

## Theming

- Themes in `themes/custom/{theme_name}`
- Use Drupal's libraries system for CSS/JS: https://www.drupal.org/docs/theming-drupal/adding-stylesheets-css-and-javascript-js-to-a-drupal-theme
- Compile front-end assets with:

```bash
npm install
npm run build
```
- All assets should be in `/dist` and referenced via `*.libraries.yml`.

---

## Behat
- The tag at top of the behat feature file should be the name of the feature file without the .feature postfix.
- Don't check for visibility of fields when Drupal states are used to make them visible/invisible.

---

## Drush Commands

**Clear cache**
```bash
ddev drush cr
```

**Export config**
```bash
ddev drush cex -y
```

**Import config**
```bash
ddev drush cim -y
```

**Run database updates**
```bash
ddev drush updb -y
```
---

## Robo commands

**Run all behat test cases**
```bash
ddev robo behat
```

**Run 1 behat test cases**
```bash
# Put a unique tag before the specific behat test case.
# When unique tag is "@unique1" then:
ddev robo behat @unique1
```

---

## Testing

- PHPUnit for unit and kernel tests.
- Behat for functional browser testing.

**Run PHPUnit:**
```bash
ddev exec phpunit --configuration www/core/phpunit.xml.dist www/modules/custom
```

**Run all behat test cases**
```bash
ddev robo behat
```

**Run 1 behat test cases**
```bash
# Put a unique tag before the specific behat test case.
# When unique tag is "@unique1" then:
ddev robo behat @unique1
```

---

## Notes for Claude

When generating PHP/Drupal code diligently use following rules:
1. Always follow Drupal 10/11 APIs -- avoid deprecated functions.
2. Use services + dependency injection instead of global \Drupal::* calls in new code.
3. When creating new modules:
    - Provide `.info.yml`, `.module`, and `/src` folder with PSR-4 namespaces.
    - Register services in `{module_name}.services.yml`.
4. Use Drupal's Entity API for CRUD -- do not run raw SQL unless absolutely necessary.
5. Always wrap translatable text in `t()` or `TranslatableMarkup`.
6. For front-end:
    - Use the library system.
    - Avoid inline JS/CSS.
7. Place configuration defaults in `config/install/` and commit them.
8. Do not add fields to the user bundle, unless explicitly told to do so.
# DXC Drupal specific rules:
9. When writing a new translation in code, always use as context the name of the module the translation is in.
   The context should be a PHP string, and must not be a constant.
10. English source strings are used in code. Translations should be put in the .po file(s) in the project wide directory "/translations" with proper msgctxt.
11. End all full sentences in comments with a '.'.
    Exception: Do NOT add periods to Behat step definitions (@Then, @Given, @When annotations).

---

## Security & Performance
- Sanitize all user inputs using Drupal's `Xss::filter()` or render arrays.
- Cache renderable output properly using cache metadata (`#cache` keys).
- Avoid unnecessary database calls -- use caching layers.

---

## Architecture Philosophy

The codebase will follow principles of maintainable, modular design inspired by Rich Hickey and
Eskil Steenberg:

**Core Principles:**
1. **Simplicity over Ease** - Choose maintainable solutions over quick fixes
2. **Black Box Modules** - Each module should have clean interfaces with hidden implementation details
3. **Single Responsibility** - One module = one clear purpose
4. **Replaceable Components** - Modules should be rewritable using only their public interface
5. **Explicit over Implicit** - Avoid "magic" and hidden side effects

**In Practice:**
- Design services with clear, documented APIs
- Hide implementation details behind interfaces
- Use dependency injection to decouple components
- Prefer data structures over complex objects
- Write code that optimizes for human understanding, not cleverness

**Key Questions When Coding:**
- What are the core data types flowing through this system?
- Could someone rewrite this module using only its public interface?
- Will this be maintainable in 2-3 years by different developers?
- Does each module have one obvious responsibility?

**For detailed architecture guidance**, read:
```
@./docs/drupal-patterns/architecture-principles.md
```

---

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
