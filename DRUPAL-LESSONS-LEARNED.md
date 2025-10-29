# Drupal Development Lessons Learned

This document captures real-world lessons, patterns, and best practices for Drupal development using the Drupal Claude Code Collective.

## Table of Contents

- [Field Management](#field-management)
- [Drush Command Patterns](#drush-command-patterns)
- [Configuration Management](#configuration-management)
- [Development Workflow](#development-workflow)
- [Common Pitfalls](#common-pitfalls)
- [Best Practices](#best-practices)

---

## Field Management

### Field Storage vs Field Instance

Drupal uses a two-level field system that often confuses developers:

**Field Storage (Shared Structure)**
- Defines the database schema
- Can be reused across multiple bundles (content types)
- Created once, shared many times
- Example: A `field_location` storage can be used on Events, Places, and Businesses

**Field Instance (Bundle-Specific Configuration)**
- Configures field behavior for a specific bundle
- Controls labels, help text, required status, default values
- Widget and formatter settings

**Practical Example:**

```bash
# First content type - creates field storage + instance
ddev drush field:create node event \
  --field-name=field_location \
  --field-label="Event Location" \
  --field-type=string \
  --field-widget=string_textfield

# Second content type - reuses field storage
ddev drush field:create node venue \
  --field-name=field_location \
  --existing-field-name=field_location \
  --field-label="Venue Location"
```

**Common Error:**
```
Field storage with name 'field_location' already exists
```

**Solution:** Use `--existing-field-name` to attach existing field storage to a new bundle.

### Widget Names Don't Match Field Types

Field types and their widgets use different machine names:

| Field Type | Common Widget | Widget Machine Name |
|------------|---------------|---------------------|
| `datetime` | Date picker | `datetime_default` |
| `text_long` | Textarea | `text_textarea` |
| `text_with_summary` | Textarea with summary | `text_textarea_with_summary` |
| `entity_reference` | Autocomplete | `entity_reference_autocomplete` |
| `entity_reference` | Select list | `options_select` |
| `string` | Textfield | `string_textfield` |
| `email` | Email field | `email_default` |
| `link` | Link widget | `link_default` |

**Discovery Commands:**
```bash
# List all available field types
ddev drush field:types

# List all available widgets
ddev drush field:widgets

# See what widgets are available for a specific field type
ddev drush field:widgets --field-type=datetime
```

### Field Creation Methods Comparison

#### Option A: Drush Commands (Recommended for Simple Fields)

**Pros:**
- Quick and scriptable
- Easy to version control
- Repeatable across environments
- No code required

**Cons:**
- Limited to basic configurations
- Can be verbose for complex field setups

**Best For:** Standard field additions, scripted deployments, simple field configurations

**Example:**
```bash
ddev drush field:create node event \
  --field-name=field_event_date \
  --field-label="Event Date" \
  --field-type=datetime \
  --field-widget=datetime_default \
  --cardinality=1
```

#### Option B: PHP eval (For Programmatic Operations)

**Pros:**
- Full API access
- Handles complex operations
- Good for bulk operations
- Access to all field configuration options

**Cons:**
- Requires Drupal API knowledge
- More verbose
- Not as straightforward as drush commands

**Best For:** Complex field configurations, bulk operations, conditional field creation

**Example:**
```bash
ddev drush php:eval "
\Drupal::entityTypeManager()
  ->getStorage('node_type')
  ->create([
    'type' => 'event',
    'name' => 'Event',
    'description' => 'Events with dates and locations',
  ])
  ->save();
"
```

#### Option C: UI + Config Export (For Prototyping)

**Pros:**
- Visual feedback
- Easy to see all options
- No command syntax to remember
- Good for exploring possibilities

**Cons:**
- Not scriptable
- Manual process
- Time-consuming for multiple fields

**Best For:** Initial prototyping, one-off configurations, exploring field options

**Workflow:**
1. Create fields via UI: `/admin/structure/types/manage/event/fields`
2. Export configuration: `ddev drush cex -y`
3. Commit to version control

---

## Drush Command Patterns

### field:create - Complete Syntax

```bash
ddev drush field:create <entity_type> <bundle> \
  --field-name=<machine_name> \
  --field-label="<Human Label>" \
  --field-type=<type> \
  --field-widget=<widget> \
  --cardinality=<number> \
  [--existing-field-name=<existing_field>]
```

**Common Mistakes:**

❌ **Wrong:** `drush field:create node event field_location --field-type=string`
- Missing required parameters
- Using positional arguments instead of flags

✅ **Correct:**
```bash
ddev drush field:create node event \
  --field-name=field_location \
  --field-label="Location" \
  --field-type=string \
  --field-widget=string_textfield
```

### Essential Field Commands

```bash
# Create a field
ddev drush field:create node event \
  --field-name=field_description \
  --field-label="Description" \
  --field-type=text_long \
  --field-widget=text_textarea

# View field information
ddev drush field:info node event

# Delete a field instance (keeps field storage)
ddev drush field:delete node event field_description

# List all fields on a bundle
ddev drush field:list node event
```

### Content Type Management

```bash
# Create content type via PHP eval
ddev drush php:eval "
\Drupal::entityTypeManager()
  ->getStorage('node_type')
  ->create([
    'type' => 'event',
    'name' => 'Event',
  ])
  ->save();
"

# Delete a content type (warning: deletes all content!)
ddev drush php:eval "
\Drupal::entityTypeManager()
  ->getStorage('node_type')
  ->load('event')
  ->delete();
"
```

### Verification Commands

```bash
# Verify field was created correctly
ddev drush field:info node event

# Check field storage
ddev drush php:eval "
\$storage = \Drupal::entityTypeManager()
  ->getStorage('field_storage_config')
  ->load('node.field_location');
print_r(\$storage->toArray());
"

# Check configuration status
ddev drush config:status
```

---

## Configuration Management

### Always Export After Structural Changes

```bash
# Export configuration after creating fields/content types
ddev drush cex -y
```

**Why This Matters:**
- Changes are version-controlled
- Team members get the same structure
- Enables deployment to other environments
- Required for proper Drupal development workflow

### Configuration Export Workflow

```bash
# 1. Make changes (create fields, content types, views, etc.)
ddev drush field:create node event --field-name=field_location ...

# 2. Export configuration
ddev drush cex -y

# 3. Review changes
git status
git diff config/sync/

# 4. Commit to version control
git add config/sync/
git commit -m "feat: Add location field to event content type"
```

### Configuration Import Workflow

```bash
# 1. Pull latest code
git pull origin main

# 2. Import configuration
ddev drush cim -y

# 3. Update database
ddev drush updb -y

# 4. Clear cache
ddev drush cr
```

### Partial Configuration Operations

```bash
# Export single configuration item
ddev drush config:export --destination=/tmp/config field.storage.node.field_location

# Import single configuration item
ddev drush config:import --source=/tmp/config field.storage.node.field_location

# Compare configuration
ddev drush config:status
```

---

## Development Workflow

### DDEV Environment Best Practices

**Always prefix drush commands with `ddev` in DDEV environments:**

✅ **Correct:**
```bash
ddev drush cr
ddev drush cex -y
ddev drush field:create node event ...
ddev composer require drupal/webform
```

❌ **Wrong (won't work in DDEV):**
```bash
drush cr              # Runs on host, not in container
composer require ...  # Uses host PHP, not DDEV
```

### Standard Development Cycle

```bash
# 1. Create feature branch
git checkout -b feature/event-content-type

# 2. Make changes (fields, config, code)
ddev drush field:create ...

# 3. Export configuration
ddev drush cex -y

# 4. Test changes
ddev drush cr
# Test in browser

# 5. Run code quality checks
./vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom/

# 6. Commit
git add config/sync/
git commit -m "feat: Add event content type with fields"

# 7. Push and create PR
git push origin feature/event-content-type
```

---

## Common Pitfalls

### 1. Wrong Drush Syntax

**Problem:** Mixing positional and named arguments

❌ **Wrong:**
```bash
drush field:create node event field_location --field-type=string
```

✅ **Correct:**
```bash
ddev drush field:create node event \
  --field-name=field_location \
  --field-type=string \
  --field-widget=string_textfield
```

### 2. Imaginary Options

**Problem:** Assuming options exist that don't

Common imaginary options:
- `--required` (doesn't exist on field:create)
- `--widget=` (should be `--field-widget=`)
- `--help-text=` (should be `--field-description=`)

**Solution:** Always check `--help` first:
```bash
ddev drush field:create --help
```

### 3. Field Storage Conflicts

**Problem:** Trying to create field storage that already exists

**Error:**
```
Field storage with name 'field_location' already exists
```

**Solution:** Use `--existing-field-name`:
```bash
ddev drush field:create node venue \
  --field-name=field_location \
  --existing-field-name=field_location \
  --field-label="Venue Location"
```

### 4. Forgetting Configuration Export

**Problem:** Creating fields but not exporting configuration

**Consequence:**
- Changes not version controlled
- Team members don't get updates
- Can't deploy to production

**Solution:** Always export after structural changes:
```bash
ddev drush cex -y
```

### 5. Widget/Field Type Mismatch

**Problem:** Using wrong widget name

❌ **Wrong:**
```bash
--field-type=datetime \
--field-widget=datetime
```

✅ **Correct:**
```bash
--field-type=datetime \
--field-widget=datetime_default
```

**Solution:** Use discovery commands:
```bash
ddev drush field:widgets --field-type=datetime
```

---

## Best Practices

### 1. Always Check --help First

```bash
# Before using any unfamiliar command
ddev drush field:create --help
ddev drush field:delete --help
```

**Benefits:**
- See all available options
- Understand parameter format
- Find example usage patterns
- Avoid trial-and-error

### 2. Verify Field Information

```bash
# After creating fields, always verify
ddev drush field:info node event
```

**Catches:**
- Incorrect field types
- Wrong widget configuration
- Missing fields
- Cardinality issues

### 3. Use Consistent Field Naming

**Pattern:** `field_` prefix for custom fields

✅ **Good:**
- `field_event_date`
- `field_location`
- `field_registration_deadline`

❌ **Bad:**
- `event_date` (no prefix)
- `EventDate` (camelCase)
- `date` (too generic)

**Why:** Clear distinction between core and custom fields

### 4. Consider Field Reusability

**Before creating a field, ask:**
- Will other content types need this field?
- Is this a truly unique field?
- Can I reuse existing field storage?

**Example:** A "Location" field might be useful for:
- Events
- Venues
- Businesses
- People

→ Create once, reuse across all bundles

### 5. Document Field Purposes

```bash
ddev drush field:create node event \
  --field-name=field_registration_deadline \
  --field-label="Registration Deadline" \
  --field-description="Last date users can register for this event" \
  --field-type=datetime \
  --field-widget=datetime_default
```

**Benefits:**
- Clear purpose for content editors
- Helps future developers
- Reduces confusion

### 6. Export Configuration Immediately

**Workflow:**
```bash
# Make change
ddev drush field:create ...

# Export immediately
ddev drush cex -y

# Verify
git diff config/sync/
```

**Never wait** to export configuration - do it immediately after structural changes.

### 7. Use field:types and field:widgets for Discovery

```bash
# Explore available field types
ddev drush field:types

# Find available widgets
ddev drush field:widgets

# Find widgets for specific field type
ddev drush field:widgets --field-type=entity_reference
```

**Prevents:**
- Using wrong field types
- Guessing widget names
- Trial-and-error debugging

---

## Field Type Selection Guide

### Common Field Requirements

| Requirement | Recommended Field Type | Widget | Notes |
|-------------|----------------------|--------|-------|
| Event date | `datetime` | `datetime_default` | Single date/time |
| Date range | `daterange` | `daterange_default` | Start and end dates |
| Location (simple) | `string` | `string_textfield` | Text-based location |
| Location (structured) | `address` (contrib) | `address_default` | Street, city, state, zip |
| Short text | `string` | `string_textfield` | Max 255 chars |
| Long text | `text_long` | `text_textarea` | Unlimited |
| Text with summary | `text_with_summary` | `text_textarea_with_summary` | For articles |
| Email | `email` | `email_default` | Validates email format |
| Phone | `telephone` | `telephone_default` | Phone number |
| URL | `link` | `link_default` | With title and URL |
| File upload | `file` | `file_generic` | Any file type |
| Image upload | `image` | `image_image` | Images with alt text |
| Yes/No | `boolean` | `boolean_checkbox` | True/false |
| Number | `integer` or `decimal` | `number` | Whole or decimal |
| List (select) | `list_string` | `options_select` | Predefined options |
| Entity reference | `entity_reference` | `entity_reference_autocomplete` | Link to other entities |
| Paragraphs | `entity_reference_revisions` | `paragraphs` | Nested content |

### Field Type Decision Tree

```
Need to store...
├─ Date/Time?
│  ├─ Single date → datetime
│  └─ Date range → daterange
├─ Text?
│  ├─ < 255 chars → string
│  ├─ Formatted text → text_long or text_with_summary
│  └─ Email/Phone/URL → email, telephone, or link
├─ Number?
│  ├─ Whole number → integer
│  └─ Decimal → decimal or float
├─ File/Media?
│  ├─ Image → image
│  ├─ Document → file
│  └─ Video/Audio → media (contrib)
├─ Reference?
│  ├─ Other content → entity_reference (node)
│  ├─ User → entity_reference (user)
│  └─ Taxonomy → entity_reference (taxonomy_term)
└─ List/Options?
   ├─ Predefined options → list_string
   └─ Dynamic → entity_reference
```

---

## Advanced Patterns

### Conditional Field Display

After creating fields, configure conditional display:

1. Create fields via drush
2. Export configuration: `ddev drush cex -y`
3. Edit form display: `/admin/structure/types/manage/event/form-display`
4. Edit view display: `/admin/structure/types/manage/event/display`
5. Export again: `ddev drush cex -y`

### Field Groups (Requires Field Group Module)

```bash
# Install field group module
ddev composer require drupal/field_group
ddev drush en field_group -y

# Create field group via UI or configuration
```

### Custom Field Validation

For fields requiring custom validation, use:
- Hook `hook_field_widget_form_alter()`
- Custom constraint validators
- Form validation handlers

**Example use case:** Event end date must be after start date

---

## When to Use Agents

### Level 1: Direct Execution (What You Did)
**Tasks:**
- Creating content types
- Adding fields
- Simple configuration

**Approach:** Direct drush commands

### Level 2: Module Development Agent
**Tasks:**
- Custom field types
- Custom field widgets
- Custom field formatters
- Field validation logic

**Approach:**
```
Use the module-development-agent to create a custom field widget
for date ranges with client-side validation
```

### Level 3: Multiple Agents
**Tasks:**
- Complex field architecture across multiple content types
- Entity reference relationships
- Custom field storage backends

**Approach:**
```
Use drupal-architect to design the field architecture,
then module-development-agent for custom implementations
```

---

## Quick Reference

### Essential Commands Cheat Sheet

```bash
# Field Operations
ddev drush field:create <entity> <bundle> --field-name=<name> --field-type=<type> --field-widget=<widget>
ddev drush field:info <entity> <bundle>
ddev drush field:delete <entity> <bundle> <field_name>
ddev drush field:list <entity> <bundle>

# Discovery
ddev drush field:types
ddev drush field:widgets
ddev drush field:widgets --field-type=<type>

# Configuration
ddev drush cex -y          # Export
ddev drush cim -y          # Import
ddev drush config:status   # Compare

# Cache
ddev drush cr              # Clear all caches

# Updates
ddev drush updb -y         # Run database updates
```

### Common Field Creation Templates

**Date Field:**
```bash
ddev drush field:create node event \
  --field-name=field_event_date \
  --field-label="Event Date" \
  --field-type=datetime \
  --field-widget=datetime_default \
  --cardinality=1
```

**Text Field:**
```bash
ddev drush field:create node event \
  --field-name=field_description \
  --field-label="Description" \
  --field-type=text_long \
  --field-widget=text_textarea \
  --cardinality=1
```

**Entity Reference:**
```bash
ddev drush field:create node event \
  --field-name=field_venue \
  --field-label="Venue" \
  --field-type=entity_reference \
  --field-widget=entity_reference_autocomplete \
  --cardinality=1 \
  --target-type=node \
  --target-bundle=venue
```

---

## Resources

### Official Drupal Documentation
- [Field API](https://www.drupal.org/docs/drupal-apis/field-api)
- [Entity API](https://www.drupal.org/docs/drupal-apis/entity-api)
- [Configuration Management](https://www.drupal.org/docs/configuration-management)

### Drush Documentation
- [Drush Commands](https://www.drush.org/latest/commands/)
- [Field Commands](https://www.drush.org/latest/commands/field_create/)

### DDEV Documentation
- [DDEV Commands](https://ddev.readthedocs.io/en/stable/users/usage/commands/)
- [DDEV and Drupal](https://ddev.readthedocs.io/en/stable/users/quickstart/#drupal)

---

**Last Updated:** Based on real-world testing with Drupal 10/11 and DDEV

**Contributing:** If you discover additional patterns or lessons, please document them here!
