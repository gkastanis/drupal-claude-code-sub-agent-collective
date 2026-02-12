# Drupal Security Rules

## Input Sanitization

- Sanitize all user inputs using `Xss::filter()` or render arrays.
- Use Form API validation for all form submissions.
- Use parameterized queries or Entity API - never concatenate user input into SQL.

## Output Protection

- Rely on Twig auto-escaping for output.
- Use `Html::escape()` for raw HTML output outside Twig.
- Never output unescaped user input.

## Access Control

- Define access control on all custom routes and entity operations.
- Use CSRF protection via Form API tokens on state-changing operations.
- Validate file uploads: type, size, and extension checks.

## Route Access vs Entity Access

- Routes can stack **multiple** access checkers -- all must pass for access to be granted.
- `$entity->access('update')` returning ALLOWED does NOT mean the route grants access. Other checkers (archived status, custom gates) may still deny.
- Debugging 403: read the route's `requirements` YAML and trace each `_*_access*` checker class individually.

## Credentials

- No hardcoded credentials or API keys in source code.
- Use environment variables or Drupal's key module for secrets.
- Never commit `.env`, `settings.local.php`, or credential files.
