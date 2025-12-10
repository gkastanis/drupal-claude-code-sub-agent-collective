# CLAUDE.md - Drupal Project Guide

## CRITICAL: Read First

**Before ANY task, you MUST:**

1. **Check semantic documentation** using the `semantic-docs` skill:
   ```
   docs/semantic/00_BUSINESS_INDEX.md    # Master feature index
   docs/semantic/tech/*.md               # Logic-to-code mappings
   docs/semantic/schemas/*.json          # Entity schemas
   ```
   Use the **semantic-docs skill** (`.claude/skills/semantic-docs/`) to search efficiently:
   - `find-feature.sh FLWG` - Get full technical spec for a feature
   - `find-logic-id.sh AUTH-L2` - Find specific logic implementation
   - `trace-code.sh HIER-L3` - Trace logic to source code

   Reference implementations using Logic IDs (e.g., AUTH-L2, FLWG-L1)

2. **Assess complexity and route agents:**
   ```
   @./.claude/docs/drupal-patterns/COMPLEXITY-ROUTING.md
   ```
   **DO NOT skip this step.** Wrong routing wastes context or produces incomplete work.

3. **If no semantic docs exist** for complex tasks: Run semantic-architect-agent first

---

## Project Structure

```
www/modules/custom/     # Custom modules
www/themes/custom/      # Custom themes
config/                 # Drupal configuration
translations/           # .po files (project-wide)
behat/                  # Behat tests
scripts/                # Build/deployment
```

---

## Commands

```bash
# Environment
ddev start                    # Start local
ddev composer install         # Install dependencies

# Drush
ddev drush cr                 # Clear cache
ddev drush cex -y             # Export config
ddev drush cim -y             # Import config
ddev drush updb -y            # Database updates

# Testing
ddev robo behat               # All Behat tests
ddev robo behat @tag          # Single test by tag
ddev exec phpunit --configuration www/core/phpunit.xml.dist www/modules/custom

# Theming
npm install && npm run build  # Compile assets
```

---

## Drupal Development Rules

**YOU MUST follow these rules:**

1. Use services + dependency injection - NEVER `\Drupal::*` calls
2. Use Entity API for CRUD - NEVER raw SQL
3. Wrap translatable text in `t()` or `TranslatableMarkup`
4. Do NOT add fields to user bundle unless explicitly told
5. New modules require: `.info.yml`, `.module`, `/src` (PSR-4), `.services.yml`
6. Config defaults go in `config/install/`
7. Front-end: use library system, no inline JS/CSS

**Translation rules:**
- Context = module name (PHP string, not constant)
- English in code, translations in `/translations/*.po` with msgctxt

**Comments & Behat:**
- End full sentences with `.`
- Exception: NO periods in Behat annotations (@Then, @Given, @When)
- Feature file tag = filename without `.feature`
- Don't check field visibility when Drupal states control it

---

## Security & Performance

**IMPORTANT:**
- Sanitize inputs: `Xss::filter()` or render arrays
- Cache output: use `#cache` metadata
- Minimize database calls - use caching layers

---

## Architecture Checklist

**Before writing code, ASK:**
1. What are the core data types flowing through this system?
2. Could someone rewrite this module using only its public interface?
3. Will this be maintainable in 2-3 years?
4. Does each module have ONE clear responsibility?

**Module design:**
- One module = one purpose (black box with clean interface)
- Hide implementation behind services/interfaces
- Communicate via services, events, hooks - not direct class deps

**DO NOT:**
- Expose internal implementation in APIs
- Create modules too complex for one person
- Hard-code technology dependencies

**Detailed principles:** `@./.claude/docs/drupal-patterns/architecture-principles.md`
