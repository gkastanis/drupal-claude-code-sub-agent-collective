#!/bin/bash
# Load Collective v2.0 - Minimal context, JIT loading
# SessionStart hook: loads INDEX.md + DECISION.md only (~95 lines)

echo "DRUPAL CLAUDE COLLECTIVE v2.0.0"
echo "================================"
echo ""

echo "=== COLLECTIVE INDEX (.claude-collective/INDEX.md) ==="
cat .claude-collective/INDEX.md
echo ""

echo "=== DECISION ENGINE (.claude-collective/DECISION.md) ==="
cat .claude-collective/DECISION.md
echo ""

echo "================================"

# Check for compact recovery state.
RECOVERY_FILE=".claude/compact-recovery.json"
if [[ -f "$RECOVERY_FILE" ]]; then
    echo ""
    echo "=== RECOVERED STATE (from pre-compaction) ==="
    cat "$RECOVERY_FILE"
    echo ""
    echo "=== END RECOVERED STATE ==="
    # Clean up recovery file after loading.
    rm -f "$RECOVERY_FILE"
fi

echo "Collective Ready - JIT Loading Active"
