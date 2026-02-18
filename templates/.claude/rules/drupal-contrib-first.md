# Contrib-First Development

Before writing custom code, check drupal.org for existing modules.

## Before Custom Code

1. Search drupal.org/project/project_module for existing solutions.
2. Evaluate: D10/11 compatibility, security coverage (green shield), active maintenance, site usage count.
3. Check if a Drupal Recipe (10.3+) bundles the needed functionality.
4. Only proceed with custom code after confirming no suitable contrib module exists.

## When Extending Contrib

- Prefer patching or extending an existing module over building from scratch.
- Use hook/event systems to alter contrib behavior rather than forking.
