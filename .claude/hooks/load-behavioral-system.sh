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
echo "Collective Ready - JIT Loading Active"
