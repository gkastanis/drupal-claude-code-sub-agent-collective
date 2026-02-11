# Drupal Services & Dependency Injection

## Mandatory Rules

1. Use services + dependency injection - NEVER use `\Drupal::*` static calls in classes.
2. Use Entity API for all CRUD operations - NEVER use raw SQL queries.
3. New modules require: `.info.yml`, `.module`, `/src` (PSR-4), `.services.yml`.
4. Config defaults go in `config/install/`, not `hook_install()`.
5. Use the library system for front-end assets - no inline JS/CSS.

## Service Design

- Register all services in `<module>.services.yml` with interface type-hints.
- Use constructor property promotion for dependency injection.
- Declare classes `final` unless explicitly designed for extension.
- Use `declare(strict_types=1)` in all custom PHP files.
- Minimize visibility: `private` > `protected` > `public`.

## After Service Changes

Verify Drupal service changes: after service or Twig changes, confirm service injections are correct, DB table and column names exist, and Twig filters actually exist in the project.
