---
description: "Update documentation to match recent code changes"
---
# /update-docs - Documentation Synchronization

## Purpose

Audit and update all project documentation to ensure it accurately reflects the current state of the codebase. Detects stale docs, missing entries, and inconsistencies between code and documentation.

## Input

Read optional scope or focus area from `$ARGUMENTS`. If no arguments are provided, perform a full documentation audit against recent changes.

## Protocol

### Step 1: Identify Recent Changes

Check what has changed recently to determine what documentation may be stale:

```bash
git log --oneline -20
git diff --name-only HEAD~10
```

Build a list of:
- Modified modules, services, and classes
- New or removed files
- Changed configuration
- Updated dependencies
- API or interface changes

### Step 2: Audit Semantic Documentation

If `docs/semantic/` exists:

1. Read `docs/semantic/00_BUSINESS_INDEX.md` to get the master feature index
2. For each recently changed module/feature, check if the corresponding tech doc in `docs/semantic/tech/` is still accurate:
   - Do Logic IDs still map to the correct code locations?
   - Are file paths still valid?
   - Do function/method signatures match?
   - Are any new logic steps missing from the mapping?
3. Check `docs/semantic/schemas/*.json` for entity schema accuracy:
   - Do field definitions match the actual entity definitions?
   - Are any new fields missing?

Update any stale semantic docs to match the current code.

### Step 3: Audit CHANGELOG

If `CHANGELOG.md` exists:

1. Compare the most recent CHANGELOG entry date against recent commits
2. If commits exist after the last CHANGELOG entry, draft new entries:
   - Group by: Added, Changed, Fixed, Removed, Security
   - Reference issue/ticket numbers if available in commit messages
   - Keep entries concise but descriptive
3. If no CHANGELOG exists, note this but do not create one unless `$ARGUMENTS` requests it

### Step 4: Audit README and Project Docs

Check for staleness in:
- `README.md` - installation instructions, feature lists, usage examples
- `docs/` directory files - architecture docs, API docs, guides
- `.claude/docs/` - collective documentation

For each doc file found, verify:
- Referenced file paths still exist
- Referenced commands still work
- Feature descriptions match current behavior
- Configuration examples match current schema
- Version numbers are current

### Step 5: Audit Inline Documentation

For files that changed recently, check:
- PHPDoc blocks on modified classes and methods match signatures
- `@param` and `@return` types are accurate
- `@deprecated` notices reference the correct replacement
- Hook documentation comments describe current behavior
- README files within module directories are current

### Step 6: Audit Configuration Documentation

If config schema files exist:
- Verify `config/schema/*.yml` descriptions match actual config behavior
- Check that `config/install/*.yml` default values are documented
- Verify permissions described in docs match `.permissions.yml`
- Check routing docs match `.routing.yml`

### Step 7: Verify Documentation Accuracy Against Code

For each documentation update made, cross-reference against the actual code:
- Read the referenced source files
- Confirm the documentation accurately describes the implementation
- Do not document aspirational behavior -- only document what exists

### Step 8: Report Results

Output a summary:

```
## Documentation Update Complete

### Changes Made
- docs/semantic/tech/FEATURE.md - Updated Logic ID mappings for [reason]
- CHANGELOG.md - Added entries for commits [hash range]
- README.md - Updated installation section
- ...

### Documentation Status
- Semantic docs: UP TO DATE / UPDATED / NOT PRESENT
- CHANGELOG: UP TO DATE / UPDATED / NOT PRESENT
- README: UP TO DATE / UPDATED
- Inline PHPDoc: UP TO DATE / UPDATED
- Config schema docs: UP TO DATE / UPDATED / N/A

### Warnings
- [Any docs that could not be auto-updated and need manual review]
- [Any referenced files that no longer exist]

### Recommendations
- [Suggestions for missing documentation that should be created]
```

$ARGUMENTS
