# Testing & Verification Rules

## Verify Before Claiming Completion

**Mandatory gate**: Run tests, read output, confirm it proves your claim, THEN claim done.
Never say "should work", "looks correct", or "I've implemented X" without test output.

## Preferred Verification Methods (priority order)

### 1. Curl Smoke Tests (most reliable)

```bash
# Status code + response size
ddev exec curl -s -o /dev/null -w "%{http_code} %{size_download}" -b <COOKIE> "http://localhost/<PATH>"

# Download full HTML
ddev exec curl -s -b <COOKIE> "http://localhost/<PATH>" > /tmp/claude/page-output.html

# Get auth cookie
ddev drush uli --uid=1 --no-browser 2>/dev/null
```

### 2. Drush Eval (secondary)

**Escaping rules**: Use `Drupal::` not `\Drupal::` in single quotes. Use `Exception` not `\Exception`. No `use` statements. Keep PHP on one line.

```bash
ddev drush eval 'print json_encode(["exists" => Drupal::hasService("my.service")]);' 2>/dev/null
```

### 3. Test Scripts (complex scenarios)

Store in `scripts/tests/`. Never `/tmp/claude` or project root.
Update `scripts/tests/index.md` when creating scripts.

## Red Flags

These phrases signal unverified claims - stop and test first:
- "should work now" / "looks correct" / "this will fix it"
- Claiming completion without test output in your response

## DDEV Shell Rules

- **Never** pass complex shell constructs (pipes, variables, nested quotes) through `ddev exec` -- write a script file and execute it.
- `drush uli` + `curl` must be in the **same script, same shell**, with `--uri=http://localhost` so the cookie domain matches.
- When checking form element visibility in curl output, search for Drupal HTML IDs (`edit-features`, `edit-moderation-state-0`) not generic machine names.

## Script Storage

- **ALWAYS**: `scripts/tests/` directory with index
- **NEVER**: `/tmp/claude/` (can't execute from ddev), project root (clutter)
- Make executable: `chmod +x scripts/tests/*.sh`

**Naming conventions:**
- `verify-{feature}.sh` -- feature verification
- `debug-{feature}-{aspect}.php` -- investigation
- `check-{aspect}.sh` -- quick checks
- `list-{entities}.php` -- data listing
- `fix-{issue}.php` -- one-time fixes
