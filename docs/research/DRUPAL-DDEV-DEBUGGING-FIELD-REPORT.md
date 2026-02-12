# Field Report: Drupal Debugging with DDEV — Hard-Won Lessons

**Source**: Production debugging session on EIC Community platform (Drupal 10, Group module 1.x, DDEV)
**Context**: Fixing group-level permissions after converting Research Institutions from nodes to groups

---

## 1. DDEV `exec` Mangles Shell Constructs

**Problem**: `ddev exec` passes commands through multiple shell layers, destroying pipes (`|`), variable expansion (`$var`), nested quotes, and `grep -P`.

**Rule**: Always write a script file and execute it.

```bash
# BAD — breaks in ddev exec
ddev exec "drush eval 'foreach ($groups as $g) { echo $g->id(); }'"

# GOOD — write to file, run the file
cat > scripts/tests/my-check.php << 'EOF'
<?php
$groups = \Drupal::entityTypeManager()->getStorage('group')->loadMultiple();
foreach ($groups as $g) { echo $g->id() . "\n"; }
EOF
ddev exec drush scr scripts/tests/my-check.php
```

**Why**: Bash expands `$g`, `$groups` etc. before PHP sees them. Single quotes don't survive the ddev exec shell chain reliably.

---

## 2. `drush eval` — Keep It Stupid Simple

**Rules**:
- One-line PHP only
- Use `Drupal::` not `\Drupal::` inside single quotes
- Use `Exception` not `\Exception`
- No `use` statements
- Complex logic → script file with `drush scr`

```bash
# GOOD
ddev drush eval 'echo Drupal::service("my.service")->getLabel();'

# BAD — namespace backslashes break
ddev drush eval 'echo \Drupal::service("my.service")->getLabel();'
```

---

## 3. `drush uli` Must Be Consumed in the Same Shell

**Problem**: One-time login tokens expire and the session cookie is bound to the URL's domain/protocol.

**Rules**:
- Generate and use the login URL in a single script
- Use `--uri=http://localhost` so the cookie matches your curl target
- Never split `drush uli` and `curl` across separate `ddev exec` calls

```bash
#!/bin/bash
# CORRECT pattern for authenticated curl testing
LOGIN_URL=$(drush uli --uid=2 --no-browser --uri=http://localhost 2>/dev/null)
COOKIE=$(curl -s -D - -o /dev/null -L "$LOGIN_URL" 2>/dev/null \
  | grep -i 'set-cookie' | head -1 \
  | sed 's/.*set-cookie: *//i' | cut -d';' -f1)
curl -s -b "$COOKIE" "http://localhost/group/1/edit"
```

**Gotcha**: If `drush uli` generates `https://mysite.ddev.site/...` but you curl `http://localhost/...`, the session cookie domain won't match → 403. Always pass `--uri=http://localhost`.

---

## 4. Drupal Service Names — Don't Guess, Ask

**Problem**: Service names follow no universal convention. Guessing wastes turns.

**Quick check**:
```bash
ddev drush eval 'print json_encode(["exists" => Drupal::hasService("my.service")]);'
```

**Real example** from this session:
- `group.permission_checker` → does NOT exist
- `group_permission.checker` → correct service name
- `group_permissions.group_permissions_manager` → does NOT exist (plural `permissions`)
- `group_permission.group_permissions_manager` → correct (singular `permission` prefix)

**Tip**: When a service name fails, read the module's `*.services.yml` file rather than guessing variations.

---

## 5. Vendor vs Contrib — Know Which File Runs

**Problem**: Patched modules may live in `web/modules/contrib/` while the original sits in `vendor/drupal/`. Editing the wrong one has no effect.

**How to find the real file**:
```php
$ref = new \ReflectionMethod($service, 'methodName');
echo $ref->getFileName();
```

**Real example**: `GroupPermissionChecker` existed in both locations:
- `vendor/drupal/group/src/Access/GroupPermissionChecker.php` — original (not loaded)
- `web/modules/contrib/group/src/Access/GroupPermissionChecker.php` — patched version (actually loaded)

Editing the vendor copy did nothing. OpCache also cached the stale version.

---

## 6. Group Module Permission Architecture (Group 1.x)

**Two-tier system**:
- **User-level permissions** (Drupal roles): `create group` type permissions
- **Group-level permissions** (Group roles): `edit group`, `view group`, `delete group`

**Group role audiences**:
- `outsider` — non-members, mapped from Drupal roles via `GroupRoleSynchronizer`
- `member` — group members
- `anonymous` — anonymous users

**Permission scope precedence**:
1. `SCOPE_GROUP` (per-group custom permissions) — checked first
2. `SCOPE_GROUP_TYPE` (role-based config permissions) — fallback

**Critical**: If a `group_permission` entity exists for a group (even with empty permissions), it creates a SCOPE_GROUP item that takes precedence over SCOPE_GROUP_TYPE. This silently overrides all role-based permissions with nothing.

---

## 7. Route Access ≠ Entity Access

**Problem**: `$group->access('update')` returns ALLOWED but the edit form still returns 403.

**Why**: Drupal routes can stack multiple access checks. The group edit form route had THREE:
```yaml
_entity_access: group.update       # Entity-level check
_archived_route_access_check: TRUE  # Custom: is group archived?
_group_pages_access_check: TRUE     # Custom: blocked group check
```

**Debugging approach**: Read the route's requirements, then trace each access checker class individually. Don't assume entity access is the only gate.

---

## 8. HTML Form IDs vs Generic Strings

**Problem**: Searching for generic strings like `group_visibility` matches Solr config in `drupalSettings` JSON, not the form element.

**Rule**: Search for Drupal HTML IDs (`edit-features`, `edit-moderation-state-0`) rather than machine names when checking form element visibility in curl output.

---

## 9. Verification Script Patterns

**Store scripts in `scripts/tests/`**, never `/tmp/claude/` (can't execute from ddev) or project root.

**Maintain an index**: `scripts/tests/index.md` with script names and purposes.

**Naming conventions**:
- `verify-{feature}.sh` — Feature verification (the "did it work?" check)
- `debug-{feature}-{aspect}.php` — Debug scripts (the "why doesn't it work?" investigation)
- `check-{aspect}.sh` — Quick checks
- `list-{entities}.php` — Data listing scripts
- `fix-{issue}.php` — One-time fix scripts

**Pattern for comprehensive verification**:
```bash
#!/bin/bash
# Authenticate, then test multiple groups in a loop
LOGIN_URL=$(drush uli --uid=$UID --no-browser --uri=http://localhost 2>/dev/null)
COOKIE=$(curl -s -D - -o /dev/null -L "$LOGIN_URL" 2>/dev/null \
  | grep -i 'set-cookie' | head -1 | sed 's/.*set-cookie: *//i' | cut -d';' -f1)

for GID in $GROUP_IDS; do
  HTTP_VIEW=$(curl -s -o /dev/null -w "%{http_code}" -b "$COOKIE" "http://localhost/group/$GID")
  HTTP_EDIT=$(curl -s -o /dev/null -w "%{http_code}" -b "$COOKIE" "http://localhost/group/$GID/edit")
  echo "Group $GID: view=$HTTP_VIEW edit=$HTTP_EDIT"
done
```

---

## 10. Testing Access for Different Roles

**Always create test users** — don't rely on existing users who may have unexpected role combinations.

```bash
drush user:create testauth --password=testauth123
drush user:create testadmin --password=testadmin123
drush user:role:add my_admin_role testadmin
```

**Test matrix**:
| User type | Published group | Unpublished group |
|-----------|----------------|-------------------|
| Anonymous | view only | 403 |
| Authenticated | view only | 403 |
| Role-based admin | view + edit | view + edit |
| uid 1 | view + edit | view + edit (bypass) |

**Check what users see, not just access codes**:
- Download HTML, grep for form IDs (workflow fields, edit links, local task tabs)
- Verify absence of admin elements for non-admin users

---

## Summary of Anti-Patterns

| Anti-pattern | Fix |
|---|---|
| `ddev exec` with pipes/variables | Write a script file |
| `drush eval` with complex PHP | Use `drush scr script.php` |
| Split `drush uli` + `curl` across calls | Single script, same shell |
| Guess service names | Check `*.services.yml` or `Drupal::hasService()` |
| Edit vendor file for patched module | Find real file via `ReflectionMethod` |
| Assume entity access = route access | Read route requirements, trace each checker |
| Search generic strings in HTML | Use Drupal HTML form IDs |
| Scripts in `/tmp/claude/` | Use `scripts/tests/` with index |
