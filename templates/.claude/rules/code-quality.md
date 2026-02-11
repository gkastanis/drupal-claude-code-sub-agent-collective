# Code Quality Rules

Rules from production usage analysis (150 sessions, 1,131 messages).

## After Multi-File Changes

Grep the codebase for remaining references after modifying functions, constants, or variables across files. This catches missed locations that would cause runtime errors.

## Config Over Magic Numbers

Search for existing config constants before hardcoding values (e.g., `* 8` for hours, `* 5` for weekdays). Use system-configured values instead.

## Remove From ALL Locations

When removing or disabling something, remove from ALL locations (controller, template, Twig, JS, config) and grep to confirm nothing was missed.

## Write Files to Project Directory

Write output files to the appropriate project directory, not inline in chat.

## Implementation Preferences

- Use guard clauses to decrease cyclomatic complexity - return early.
- Prefer `array_filter()`, `array_map()`, `array_reduce()` over `foreach` with nested `if/break/continue`.
- Use data objects instead of arrays. Convert arrays to objects ASAP.
- PHP 8.4+: Use property hooks for get/set methods.
- Exception: Drupal render/form APIs can use arrays.

## JSON & Logging

- Use `\GuzzleHttp\Utils::jsonDecode/jsonEncode` (not PHP's `json_*`).
- Use `LoggerInterface` methods (`debug`/`info`/`warning`/`error`) - no custom debug flags.
- Avoid "Service" namespace (`Drupal\my_module\Service`) - use logical groupings.

## Variable Naming

- `$snake_case` for local variables and function parameters.
- `$lowerCamelCase` for class properties/attributes.

## Comments

- End full sentences with `.`
- Exception: NO periods in Behat annotations (`@Then`, `@Given`, `@When`).
- Feature file tag = filename without `.feature`.
