# CLAUDE.md - Drupal Project Guide

## CRITICAL: Read First

**Before ANY task, you MUST:**

1. **Discover first** -- use `/discover FEATURE` or `/discover "search terms"` before Glob/Grep to get Logic IDs and file paths directly from semantic documentation. Falls back gracefully if no semantic docs exist.

2. **Check semantic documentation** using the `semantic-docs` skill:
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

3. **Assess complexity and route agents:**
   ```
   @./.claude/docs/drupal-patterns/COMPLEXITY-ROUTING.md
   ```
   **DO NOT skip this step.** Wrong routing wastes context or produces incomplete work.

4. **If no semantic docs exist** for complex tasks: Run semantic-architect-agent first

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

## Collective Index
**Import compressed agent/command index with behavioral rules.**
@./.claude-collective/INDEX.md

## Decision Engine
**Import auto-delegation infrastructure.**
@./.claude-collective/DECISION.md
