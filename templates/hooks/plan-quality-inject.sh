#!/bin/sh
# plan-quality-inject.sh
# PostToolUse:ExitPlanMode Hook - Inject routing and quality requirements for Drupal work
# Advisory only (stdout) - does not block execution
#
# When a plan is approved and implementation begins, this hook checks if the plan
# references Drupal file types. If so, it injects implementation requirements that
# improve routing, quality gate compliance, and semantic docs maintenance.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source shared utilities if available
if [ -f "$SCRIPT_DIR/lib/hook-utils.sh" ]; then
    . "$SCRIPT_DIR/lib/hook-utils.sh"
fi

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract tool name to confirm this is ExitPlanMode
TOOL_NAME=""
if command -v jq >/dev/null 2>&1; then
    TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool_name // ""' 2>/dev/null)
fi
if [ -z "$TOOL_NAME" ] || [ "$TOOL_NAME" = "null" ]; then
    TOOL_NAME=$(echo "$INPUT_JSON" | grep -o '"tool_name":"[^"]*"' | head -1 | cut -d'"' -f4)
fi

# Only act on ExitPlanMode
if [ "$TOOL_NAME" != "ExitPlanMode" ]; then
    exit 0
fi

# Extract plan content from tool input or tool response
PLAN_CONTENT=""
if command -v jq >/dev/null 2>&1; then
    # Try to get plan file path from tool input
    PLAN_FILE=$(echo "$INPUT_JSON" | jq -r '.tool_input.planFile // .tool_input.plan_file // ""' 2>/dev/null)
    # Get the plan content from tool response if available
    PLAN_CONTENT=$(echo "$INPUT_JSON" | jq -r '.tool_response.content[]?.text // ""' 2>/dev/null)
    # Also check tool_input for any plan text
    if [ -z "$PLAN_CONTENT" ] || [ "$PLAN_CONTENT" = "null" ]; then
        PLAN_CONTENT=$(echo "$INPUT_JSON" | jq -r '.tool_input // ""' 2>/dev/null)
    fi
fi

# Fallback: extract plan content with grep
if [ -z "$PLAN_CONTENT" ] || [ "$PLAN_CONTENT" = "null" ]; then
    PLAN_CONTENT="$INPUT_JSON"
fi

# If we have a plan file path, try to read it
if [ -n "$PLAN_FILE" ] && [ "$PLAN_FILE" != "null" ] && [ -f "$PLAN_FILE" ]; then
    PLAN_CONTENT=$(cat "$PLAN_FILE" 2>/dev/null)
fi

# Check if plan references Drupal file types
DRUPAL_DETECTED=false
if echo "$PLAN_CONTENT" | grep -qiE '\.(php|module|theme|twig|install|inc|services\.yml|routing\.yml|info\.yml|schema\.yml|permissions\.yml|links\.(menu|task|action)\.yml)'; then
    DRUPAL_DETECTED=true
fi

# Also check for Drupal-specific terms in the plan
if [ "$DRUPAL_DETECTED" = "false" ]; then
    if echo "$PLAN_CONTENT" | grep -qiE '(drupal|drush|ddev|hook_|Entity(Type|ViewDisplay)|FieldType|Plugin|render array|Form.*API|config/install|www/modules|www/themes)'; then
        DRUPAL_DETECTED=true
    fi
fi

# If no Drupal work detected, exit silently
if [ "$DRUPAL_DETECTED" = "false" ]; then
    exit 0
fi

# Inject implementation requirements to stdout (advisory, not blocking)
cat <<'REQUIREMENTS'

IMPLEMENTATION REQUIREMENTS (auto-injected by collective):
- Route implementation tasks to specialized agents via /van (not general-purpose)
- Run quality checks (phpcs, phpstan) on modified PHP files before completion
- Use drupal-testing skill for test verification: curl smoke tests or drush eval
- After completion: update semantic documentation (docs/semantic/) if business logic, services, or entity schemas changed. Use semantic-architect-agent if docs/semantic/00_BUSINESS_INDEX.md exists.

REQUIREMENTS

exit 0
