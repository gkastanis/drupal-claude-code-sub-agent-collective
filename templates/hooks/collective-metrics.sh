#!/bin/bash
# collective-metrics.sh - Collects performance metrics and coordination statistics.

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
METRICS_DIR="$PROJECT_DIR/.claude-collective/metrics"
METRICS_FILE="$METRICS_DIR/metrics-$(date +%Y%m%d).json"
LOG_FILE="$METRICS_DIR/collective-metrics.log"
mkdir -p "$METRICS_DIR"

EVENT="${EVENT:-""}"; TOOL_NAME="${TOOL_NAME:-""}"; SUBAGENT_NAME="${SUBAGENT_NAME:-""}"
USER_PROMPT="${USER_PROMPT:-""}"; EXECUTION_TIME_MS="${EXECUTION_TIME_MS:-0}"

epoch_ms() { date +%s%3N; }

# Apply a jq filter to the metrics file atomically.
update_metrics() { jq "$1" "$METRICS_FILE" > "$METRICS_FILE.tmp" && mv "$METRICS_FILE.tmp" "$METRICS_FILE"; }

# Single-pass signal detection on USER_PROMPT.
detect_signals() {
    HAS_ERROR=0; HAS_TESTS=0; HAS_PEER_VIOLATION=0
    [[ -z "$USER_PROMPT" ]] && return
    echo "$USER_PROMPT" | grep -qiE "error|fail|exception|incomplete|retry" && HAS_ERROR=1
    echo "$USER_PROMPT" | grep -qiE "test|spec|coverage|validate" && HAS_TESTS=1
    echo "$USER_PROMPT" | grep -qiE "@[a-z-]*agent.*@[a-z-]*agent" && HAS_PEER_VIOLATION=1
}

# Archive oldest metric files when count exceeds 30.
rotate_metrics() {
    local count; count=$(find "$METRICS_DIR" -maxdepth 1 -name 'metrics-*.json' -type f 2>/dev/null | wc -l)
    [[ "$count" -le 30 ]] && return
    local archive_dir="$METRICS_DIR/archives/$(date +%Y-%m)"; mkdir -p "$archive_dir"
    find "$METRICS_DIR" -maxdepth 1 -name 'metrics-*.json' -type f -printf '%T+ %p\n' 2>/dev/null \
        | sort | head -n $((count - 30)) | cut -d' ' -f2- \
        | while read -r f; do mv "$f" "$archive_dir/"; done
    log "Rotated $((count - 30)) metric files to $archive_dir"
}

# Initialize metrics JSON if missing.
init_metrics() {
    [[ -f "$METRICS_FILE" ]] && return 0
    cat > "$METRICS_FILE" << 'INIT'
{
  "date": "",
  "research_metrics": {
    "jit_hypothesis": { "context_load_times": [], "memory_usage": [], "agent_spawn_times": [] },
    "hub_spoke_hypothesis": { "routing_accuracy": [], "coordination_overhead": [], "peer_communication_violations": 0 },
    "tdd_hypothesis": { "handoff_success_rate": [], "integration_defects": [], "test_coverage": [] }
  },
  "performance_metrics": { "tool_executions": [], "agent_handoffs": [], "directive_violations": [], "quality_gates": [] },
  "system_health": { "uptime": 0, "error_rate": 0, "response_times": [] }
}
INIT
    update_metrics ".date = \"$(date -I)\""
    log "Initialized metrics file: $METRICS_FILE"
}

main() {
    local start_time; start_time=$(epoch_ms)
    log "Metrics: event=$EVENT tool=$TOOL_NAME agent=$SUBAGENT_NAME"
    init_metrics; rotate_metrics; detect_signals

    case "$EVENT" in
        PreToolUse)
            local lt=$(( $(epoch_ms) - start_time )) cs=${#USER_PROMPT}
            update_metrics "
                .research_metrics.jit_hypothesis.context_load_times += [{\"timestamp\": now, \"load_time_ms\": $lt, \"context_size\": $cs, \"tool\": \"$TOOL_NAME\"}]
              | .performance_metrics.tool_executions += [{\"timestamp\": now, \"tool\": \"$TOOL_NAME\", \"execution_time_ms\": $EXECUTION_TIME_MS, \"event\": \"$EVENT\"}]"
            ;;
        PostToolUse)
            local f=".performance_metrics.tool_executions += [{\"timestamp\": now, \"tool\": \"$TOOL_NAME\", \"execution_time_ms\": $EXECUTION_TIME_MS, \"event\": \"$EVENT\"}]"
            [[ "$EXECUTION_TIME_MS" -gt 0 ]] && f="$f | .system_health.response_times += [$EXECUTION_TIME_MS]"
            [[ "$HAS_ERROR" -eq 1 ]] && f="$f | .system_health.error_rate += 1"
            update_metrics "$f"
            ;;
        SubagentStop)
            local ct=$(( $(epoch_ms) - start_time )) ok=$(( 1 - HAS_ERROR ))
            local f="
                .research_metrics.hub_spoke_hypothesis.routing_accuracy += [$ok]
              | .research_metrics.hub_spoke_hypothesis.coordination_overhead += [{\"timestamp\": now, \"coordination_time_ms\": $ct, \"agent\": \"$SUBAGENT_NAME\"}]
              | .research_metrics.tdd_hypothesis.handoff_success_rate += [$ok]
              | .research_metrics.tdd_hypothesis.test_coverage += [{\"timestamp\": now, \"coverage\": 0, \"has_tests\": $HAS_TESTS, \"agent\": \"$SUBAGENT_NAME\"}]
              | .performance_metrics.tool_executions += [{\"timestamp\": now, \"tool\": \"$TOOL_NAME\", \"execution_time_ms\": $EXECUTION_TIME_MS, \"event\": \"$EVENT\"}]
              | .performance_metrics.agent_handoffs += [{\"timestamp\": now, \"agent\": \"$SUBAGENT_NAME\", \"event\": \"$EVENT\"}]"
            [[ "$HAS_PEER_VIOLATION" -eq 1 ]] && f="$f | .research_metrics.hub_spoke_hypothesis.peer_communication_violations += 1"
            update_metrics "$f"
            ;;
        *)  [[ -n "$TOOL_NAME" ]] && update_metrics ".performance_metrics.tool_executions += [{\"timestamp\": now, \"tool\": \"$TOOL_NAME\", \"execution_time_ms\": $EXECUTION_TIME_MS, \"event\": \"$EVENT\"}]" ;;
    esac

    log "Metrics collection completed for event: $EVENT"
}

main "$@"
