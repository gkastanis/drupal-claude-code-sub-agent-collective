#!/bin/bash
# subagent-context-inject.sh - Injects project context when agents spawn.
# SubagentStart hook: provides compact recovery context, environment hints,
# and validates agent name against the 15-agent registry.

# Source shared utilities with inline fallback.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/hook-utils.sh" 2>/dev/null || {
    timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
    log() { echo "[$(timestamp)] $1" >> "$LOG_FILE"; }
    json_field() {
        local json="$1" jq_path="$2" fallback_key="$3" value=""
        if command -v jq >/dev/null 2>&1; then value=$(echo "$json" | jq -r "$jq_path" 2>/dev/null); fi
        if [[ -z "$value" || "$value" == "null" ]]; then value=$(echo "$json" | grep -o "\"$fallback_key\":\"[^\"]*\"" | head -1 | cut -d'"' -f4); fi
        echo "$value"
    }
}

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
AGENT_NAME="${SUBAGENT_NAME:-unknown}"
LOG_FILE="${LOG_FILE:-/tmp/subagent-context-inject.log}"

log "SubagentStart hook triggered for agent: $AGENT_NAME"

# Registry of valid agent names.
VALID_AGENTS="routing-agent drupal-architect module-development-agent theme-development-agent configuration-management-agent content-migration-agent security-compliance-agent performance-devops-agent functional-testing-agent unit-testing-agent visual-regression-agent enhanced-project-manager-agent research-agent workflow-agent semantic-architect-agent"

# Validate agent name against registry.
AGENT_VALID=0
for valid in $VALID_AGENTS; do
    if [[ "$AGENT_NAME" == "$valid" ]]; then
        AGENT_VALID=1
        break
    fi
done

if [[ "$AGENT_VALID" -eq 0 && "$AGENT_NAME" != "unknown" && "$AGENT_NAME" != "mock-"* ]]; then
    log "WARNING: Unknown agent name '$AGENT_NAME' - not in 15-agent registry"
    echo "WARNING: Agent '$AGENT_NAME' is not in the collective registry. Valid agents: routing-agent, drupal-architect, module-development-agent, theme-development-agent, configuration-management-agent, content-migration-agent, security-compliance-agent, performance-devops-agent, functional-testing-agent, unit-testing-agent, visual-regression-agent, enhanced-project-manager-agent, research-agent, workflow-agent, semantic-architect-agent"
fi

# Inject compact recovery context if it exists.
RECOVERY_FILE="$PROJECT_DIR/.claude/compact-recovery.json"
if [[ -f "$RECOVERY_FILE" ]]; then
    log "Injecting compact recovery context"
    echo "RECOVERED CONTEXT (from pre-compaction):"
    cat "$RECOVERY_FILE"
    echo ""
fi

# Inject agent memory path hint.
MEMORY_DIR="$PROJECT_DIR/.claude/agent-memory/$AGENT_NAME"
if [[ -d "$MEMORY_DIR" ]]; then
    log "Agent memory directory exists: $MEMORY_DIR"
    echo "AGENT MEMORY: Review .claude/agent-memory/$AGENT_NAME/MEMORY.md for project-specific knowledge. Update on completion."
fi

# Inject project environment hints.
if [[ -f "$PROJECT_DIR/composer.json" ]]; then
    DRUPAL_VERSION=""
    if command -v jq >/dev/null 2>&1; then
        DRUPAL_VERSION=$(jq -r '.require["drupal/core"] // .require["drupal/core-recommended"] // "unknown"' "$PROJECT_DIR/composer.json" 2>/dev/null)
    fi
    if [[ -n "$DRUPAL_VERSION" && "$DRUPAL_VERSION" != "null" && "$DRUPAL_VERSION" != "unknown" ]]; then
        echo "PROJECT ENVIRONMENT: Drupal $DRUPAL_VERSION"
    fi
fi

log "Context injection complete for $AGENT_NAME"
