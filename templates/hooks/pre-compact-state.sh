#!/bin/bash
# pre-compact-state.sh - Saves agent state before context compaction.
# PreCompact hook: preserves active agent, task context, and session metadata
# so they can be recovered after compaction via load-behavioral-system.sh.

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
RECOVERY_FILE="$PROJECT_DIR/.claude/compact-recovery.json"
LOG_FILE="${LOG_FILE:-/tmp/pre-compact-state.log}"

log "PreCompact hook triggered - saving state"

# Collect current state.
ACTIVE_AGENT=""
CURRENT_TASK=""
HANDOFF_STATE=""

# Check for active handoff context.
HANDOFF_FILE="$PROJECT_DIR/.claude/handoff/NEXT_ACTION.json"
if [[ -f "$HANDOFF_FILE" ]]; then
    HANDOFF_STATE=$(cat "$HANDOFF_FILE" 2>/dev/null)
    ACTIVE_AGENT=$(json_field "$HANDOFF_STATE" ".agent" "agent")
    log "Found active handoff: agent=$ACTIVE_AGENT"
fi

# Check for TaskMaster current task.
TASKS_FILE="$PROJECT_DIR/.taskmaster/tasks/tasks.json"
if [[ -f "$TASKS_FILE" ]] && command -v jq >/dev/null 2>&1; then
    CURRENT_TASK=$(jq -r '
        .master.tasks[]?
        | select(.status == "in-progress")
        | {id, title, status}
    ' "$TASKS_FILE" 2>/dev/null | head -20)
fi

# Build recovery JSON.
mkdir -p "$(dirname "$RECOVERY_FILE")"

if command -v jq >/dev/null 2>&1; then
    jq -n \
        --arg ts "$(date -Iseconds)" \
        --arg agent "$ACTIVE_AGENT" \
        --arg task "$CURRENT_TASK" \
        --arg handoff "$HANDOFF_STATE" \
        '{
            saved_at: $ts,
            active_agent: $agent,
            current_task: $task,
            handoff_state: $handoff,
            version: "2.1.0"
        }' > "$RECOVERY_FILE"
else
    cat > "$RECOVERY_FILE" << EOF
{
    "saved_at": "$(date -Iseconds)",
    "active_agent": "$ACTIVE_AGENT",
    "current_task": "$CURRENT_TASK",
    "handoff_state": "",
    "version": "2.1.0"
}
EOF
fi

log "State saved to $RECOVERY_FILE"

# Emit user-visible message about state preservation.
echo "Context compacting - agent state saved to .claude/compact-recovery.json"
if [[ -n "$ACTIVE_AGENT" ]]; then
    echo "Active agent preserved: $ACTIVE_AGENT"
fi
