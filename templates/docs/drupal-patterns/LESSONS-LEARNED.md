# Drupal Field & Config Quick Reference

Essential patterns, mappings, and gotchas for Drupal development.

---

## Field Type → Widget Mapping

**IMPORTANT:** Widget names don't match field types.

| Field Type | Widget Machine Name | Use For |
|------------|---------------------|---------|
| `string` | `string_textfield` | Short text (<255 chars) |
| `text_long` | `text_textarea` | Long text |
| `text_with_summary` | `text_textarea_with_summary` | Articles |
| `datetime` | `datetime_default` | Single date/time |
| `daterange` | `daterange_default` | Start/end dates |
| `email` | `email_default` | Email addresses |
| `telephone` | `telephone_default` | Phone numbers |
| `link` | `link_default` | URLs |
| `boolean` | `boolean_checkbox` | Yes/No |
| `integer` | `number` | Whole numbers |
| `decimal` | `number` | Decimal numbers |
| `entity_reference` | `entity_reference_autocomplete` | Reference to entities |
| `entity_reference` | `options_select` | Reference (dropdown) |
| `image` | `image_image` | Image upload |
| `file` | `file_generic` | File upload |
| `list_string` | `options_select` | Predefined options |

**Discovery commands:**
```bash
ddev drush field:types                        # All field types
ddev drush field:widgets                      # All widgets
ddev drush field:widgets --field-type=datetime # Widgets for type
```

---

## Common Errors & Fixes

### Error: "Field storage already exists"

```
Field storage with name 'field_location' already exists
```

**Fix:** Use `--existing-field-name` to reuse storage:
```bash
ddev drush field:create node venue \
  --field-name=field_location \
  --existing-field-name=field_location \
  --field-label="Venue Location"
```

### Error: Wrong widget name

❌ `--field-widget=datetime`
✅ `--field-widget=datetime_default`

### Error: Missing required flags

❌ `drush field:create node event field_location --field-type=string`

✅
```bash
ddev drush field:create node event \
  --field-name=field_location \
  --field-label="Location" \
  --field-type=string \
  --field-widget=string_textfield
```

### Error: Imaginary options

These DON'T exist on `field:create`:
- `--required`
- `--widget=` (use `--field-widget=`)
- `--help-text=` (use `--field-description=`)

**Always check:** `ddev drush field:create --help`

---

## Field Storage vs Instance

**Storage** = Database schema (shared, create once)
**Instance** = Bundle config (labels, widgets, per content type)

```bash
# First use - creates storage + instance
ddev drush field:create node event \
  --field-name=field_location \
  --field-label="Event Location" \
  --field-type=string \
  --field-widget=string_textfield

# Reuse on another type - instance only
ddev drush field:create node venue \
  --field-name=field_location \
  --existing-field-name=field_location \
  --field-label="Venue Location"
```

---

## Command Templates

### Create Field
```bash
ddev drush field:create node <bundle> \
  --field-name=field_<name> \
  --field-label="<Label>" \
  --field-type=<type> \
  --field-widget=<widget> \
  --cardinality=1
```

### Create Content Type
```bash
ddev drush php:eval "
\Drupal::entityTypeManager()
  ->getStorage('node_type')
  ->create(['type' => '<machine_name>', 'name' => '<Label>'])
  ->save();
"
```

### Verify & Export
```bash
ddev drush field:info node <bundle>   # Verify fields
ddev drush cex -y                     # Export config (ALWAYS after changes)
```

---

## Field Decision Tree

```
Need to store...
├─ Date? → datetime (single) or daterange (range)
├─ Text?
│  ├─ Short (<255) → string
│  ├─ Long/formatted → text_long
│  └─ Email/Phone/URL → email, telephone, link
├─ Number? → integer or decimal
├─ File? → image or file
├─ Reference? → entity_reference
└─ Options? → list_string (fixed) or entity_reference (dynamic)
```

---

## Essential Workflow

```bash
# 1. Make changes
ddev drush field:create ...

# 2. Export IMMEDIATELY
ddev drush cex -y

# 3. Verify
git diff config/sync/

# 4. Commit
git add config/sync/ && git commit -m "feat: Add field"
```

**NEVER skip config export after structural changes.**

---

## DDEV Debugging Lessons

Hard-won patterns from production Drupal/DDEV debugging sessions. Full context: `docs/research/DRUPAL-DDEV-DEBUGGING-FIELD-REPORT.md`.

### Anti-Patterns Summary

| # | Anti-pattern | Fix | Integrated in |
|---|---|---|---|
| 1 | `ddev exec` with pipes/variables | Write a script file, run with `ddev exec bash` or `drush scr` | rules/testing-verification, skills/drupal-testing |
| 2 | `drush eval` with complex PHP or `use` statements | Keep one-line, use `drush scr` for complex logic | rules/testing-verification, skills/drupal-testing |
| 3 | Split `drush uli` + `curl` across separate calls | Single script, same shell, `--uri=http://localhost` | rules/testing-verification, skills/drupal-testing |
| 4 | Guess service names by convention | Check `*.services.yml` or `Drupal::hasService()` | rules/drupal-services, skills/drupal-service-di |
| 5 | Edit vendor file for patched module | Find real file via `ReflectionMethod` | skills/drupal-testing, skills/drupal-service-di |
| 7 | Assume entity access = route access | Read route requirements, trace each access checker | rules/drupal-security, skills/drupal-security-patterns |
| 8 | Search generic strings in HTML output | Use Drupal HTML form IDs (`edit-*`) | rules/testing-verification, skills/drupal-testing |
| 9 | Scripts in `/tmp/claude/` or project root | Use `scripts/tests/` with naming conventions and index | rules/testing-verification, skills/drupal-testing |

**Note**: Lesson #6 (Group module 1.x permission architecture) is domain-specific and documented only in the full field report, not integrated into collective rules or skills.
