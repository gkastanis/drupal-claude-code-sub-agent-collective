---
name: drupal-testing
description: Practical Drupal testing patterns using curl smoke tests, drush eval, and test scripts. Use when verifying Drupal implementations actually work - module enabled, service exists, page renders, config correct.
---

# Drupal Testing Skill

Practical verification patterns for Drupal implementations in DDEV environments.

## Curl Smoke Test Patterns

### Pattern 1: Status Code + Response Size

```bash
# Get auth cookie first
LOGIN_URL=$(ddev drush uli --uid=1 --no-browser 2>/dev/null)
COOKIE_FILE="/tmp/claude/cookies.txt"
ddev exec curl -s -c "$COOKIE_FILE" -L "$LOGIN_URL" -o /dev/null

# Check status and size
ddev exec curl -s -o /dev/null -w "%{http_code} %{size_download}" \
  -b "$COOKIE_FILE" "http://localhost/TARGET_PATH"
# Expect: "200 <size>" where size > 0
```

### Pattern 2: Download Full HTML

```bash
ddev exec curl -s -b "$COOKIE_FILE" "http://localhost/TARGET_PATH" \
  > /tmp/claude/page-output.html
# Then read /tmp/claude/page-output.html to inspect content
```

### Pattern 3: Extract Specific Content

```bash
# Check for specific text/element on page
ddev exec curl -s -b "$COOKIE_FILE" "http://localhost/TARGET_PATH" \
  | grep -o '<title>[^<]*</title>'
```

### Reusable Template

```bash
#!/bin/bash
# scripts/tests/verify-PROJECT_NAME.sh
# Verify: DESCRIPTION
set -e

COOKIE_FILE="/tmp/cookies-$$.txt"
LOGIN_URL=$(ddev drush uli --uid=1 --no-browser 2>/dev/null)
ddev exec curl -s -c "$COOKIE_FILE" -L "$LOGIN_URL" -o /dev/null

STATUS=$(ddev exec curl -s -o /dev/null -w "%{http_code}" \
  -b "$COOKIE_FILE" "http://localhost/TARGET_PATH")

if [ "$STATUS" = "200" ]; then
  echo "PASS: TARGET_PATH returns 200"
else
  echo "FAIL: TARGET_PATH returns $STATUS (expected 200)"
  exit 1
fi

rm -f "$COOKIE_FILE"
```

## Drush Eval Patterns

**CRITICAL escaping rules:**
- Use `Drupal::` not `\Drupal::` (backslash gets eaten by shell)
- Use `Exception` not `\Exception`
- Keep PHP on one line
- Redirect stderr: `2>/dev/null`
- Use single quotes around PHP code

### Service Verification

```bash
ddev drush eval 'print json_encode(["exists" => Drupal::hasService("my_module.my_service")]);' 2>/dev/null
```

### Module Enabled Check

```bash
ddev drush eval 'print json_encode(["enabled" => Drupal::moduleHandler()->moduleExists("my_module")]);' 2>/dev/null
```

### Entity Field Check

```bash
ddev drush eval '$defs = Drupal::service("entity_field.manager")->getFieldDefinitions("node", "article"); print json_encode(["has_field" => isset($defs["field_custom"])]);' 2>/dev/null
```

### Config Value Check

```bash
ddev drush eval 'print json_encode(Drupal::config("my_module.settings")->get());' 2>/dev/null
```

### Permission Exists

```bash
ddev drush eval '$perms = Drupal::service("user.permissions")->getPermissions(); print json_encode(["exists" => isset($perms["administer my_module"])]);' 2>/dev/null
```

### Route Exists

```bash
ddev drush eval 'try { $url = Drupal::service("url_generator")->generateFromRoute("my_module.page"); print json_encode(["route" => "exists", "url" => $url]); } catch (Exception $e) { print json_encode(["route" => "missing"]); }' 2>/dev/null
```

## Test Script Creation

### Directory Convention

```
scripts/tests/
  index.md            # Index of all test scripts
  verify-*.sh         # Feature verification scripts
  check-*.sh          # Quick check scripts
  smoke-*.sh          # Page smoke test scripts
```

### Creating a Script

1. Write to `scripts/tests/verify-<feature>.sh`
2. Make executable: `chmod +x scripts/tests/verify-<feature>.sh`
3. Update `scripts/tests/index.md` with entry

### Script Template

```bash
#!/bin/bash
# scripts/tests/verify-<feature>.sh
# Verifies: <what this tests>
# Created: <date>
set -e

echo "=== Verifying <feature> ==="

# Test 1: Check module enabled
RESULT=$(ddev drush eval 'print Drupal::moduleHandler()->moduleExists("my_module") ? "yes" : "no";' 2>/dev/null)
if [ "$RESULT" = "yes" ]; then
  echo "PASS: Module enabled"
else
  echo "FAIL: Module not enabled"
  exit 1
fi

# Test 2: Check service exists
RESULT=$(ddev drush eval 'print Drupal::hasService("my_module.service") ? "yes" : "no";' 2>/dev/null)
if [ "$RESULT" = "yes" ]; then
  echo "PASS: Service registered"
else
  echo "FAIL: Service not found"
  exit 1
fi

echo "=== All checks passed ==="
```

## Common Verification Scenarios

| What to Verify | Method | Command |
|---|---|---|
| Module enabled | drush eval | `Drupal::moduleHandler()->moduleExists("x")` |
| Service exists | drush eval | `Drupal::hasService("x.y")` |
| Field on bundle | drush eval | `getFieldDefinitions("node", "article")` |
| Route accessible | curl | Status code 200 check |
| Config value | drush eval | `Drupal::config("x.settings")->get("key")` |
| Permission defined | drush eval | `getPermissions()` check |
| Cache clear works | drush | `ddev drush cr` exits 0 |
| Config imports | drush | `ddev drush cim -y` exits 0 |
