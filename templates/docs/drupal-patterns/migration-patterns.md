# Drupal Migration Patterns

Reference documentation for Drupal migrations. **Read when you need migration examples.**

## Basic Migration Structure

```yaml
id: articles_csv
label: Import Articles
migration_group: content

source:
  plugin: csv
  path: modules/custom/my_migration/migrations/articles.csv
  header_offset: 0
  ids: [id]

process:
  type:
    plugin: default_value
    default_value: article
  title: title
  'body/value': body
  'body/format':
    plugin: default_value
    default_value: basic_html

destination:
  plugin: 'entity:node'
```

## Common Source Plugins

**CSV**: `plugin: csv`
**JSON**: `plugin: url` with data parser
**Database**: `plugin: d7_node` (Drupal 7)
**XML**: `plugin: url` with XML parser

## Essential Process Plugins

```yaml
# Default value
field:
  plugin: default_value
  default_value: value

# Static mapping
status:
  plugin: static_map
  source: old_status
  map:
    published: 1
    draft: 0

# Callback transformation
created:
  plugin: callback
  callable: strtotime
  source: date_string

# Migration lookup
uid:
  plugin: migration_lookup
  migration: users_csv
  source: author_id

# Explode (split strings)
tags:
  plugin: explode
  source: tag_list
  delimiter: ','

# File/Image import
field_image:
  plugin: image_import
  source: image_url
  destination: 'public://images/'
```

## Field Mapping Examples

```yaml
# Text field
title: source_title

# Multi-value text
'body/value': body_text
'body/format':
  plugin: default_value
  default_value: full_html

# Entity reference
field_category:
  plugin: migration_lookup
  migration: categories
  source: category_id

# Taxonomy term by name
field_tags:
  plugin: entity_generate
  source: tag_names
  entity_type: taxonomy_term
  bundle: tags
  value_key: name

# Image with alt text
'field_image/target_id':
  plugin: migration_lookup
  migration: files
  source: image_fid
'field_image/alt': image_alt
```

## Running Migrations

```bash
# Import
drush migrate:import articles_csv
drush mim articles_csv

# Rollback
drush migrate:rollback articles_csv
drush mr articles_csv

# Reset status
drush migrate:reset-status articles_csv
drush mrs articles_csv

# Status
drush migrate:status
drush ms
```

## Migration Module Structure

```
modules/custom/my_migration/
├── my_migration.info.yml
├── migrations/
│   ├── articles.csv
│   ├── users.csv
│   └── images/
└── config/install/
    ├── migrate_plus.migration.articles_csv.yml
    ├── migrate_plus.migration.users_csv.yml
    └── migrate_plus.migration_group.my_group.yml
```

## Dependencies

```yaml
migration_dependencies:
  required:
    - users_csv
  optional:
    - files_csv
```

## Error Handling

```yaml
# Skip on empty
field:
  plugin: skip_on_empty
  source: source_field
  method: row

# Default for null
field:
  plugin: null_coalesce
  source:
    - preferred_field
    - fallback_field
  default_value: 'N/A'
```
