#!/bin/bash
# test-driven-handoff.sh
# Test-Driven Handoffs with Contract Validation
# Validates agent outputs and detects handoff directives.

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/hook-utils.sh" 2>/dev/null || {
    # Inline fallback if lib not found
    LOG_FILE="/tmp/test-driven-handoff.log"
    timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
    log() { echo "[$(timestamp)] $1" >> "$LOG_FILE"; }
    normalize_text() { echo "$1" | sed 's/[–—‑−]/-/g' | tr -s '[:space:]' ' '; }
    json_field() {
        local json="$1" jq_path="$2" fallback_key="$3" value=""
        if command -v jq >/dev/null 2>&1; then value=$(echo "$json" | jq -r "$jq_path" 2>/dev/null); fi
        if [[ -z "$value" || "$value" == "null" ]]; then value=$(echo "$json" | grep -o "\"$fallback_key\":\"[^\"]*\"" | head -1 | cut -d'"' -f4); fi
        echo "$value"
    }
    extract_agent_output() {
        local json="$1" transcript_path="$2" output=""
        output=$(echo "$json" | jq -r '.tool_response.content[].text' 2>/dev/null)
        if [[ -z "$output" || "$output" == "null" ]]; then
            output=$(echo "$json" | python3 -c "import json,sys
try:
    data=json.load(sys.stdin)
    for item in data.get('tool_response',{}).get('content',[]):
        if 'text' in item: print(item['text']); break
except: pass" 2>/dev/null)
        fi
        if [[ -z "$output" && -n "$transcript_path" && -f "$transcript_path" ]]; then
            output=$(tail -10 "$transcript_path" | jq -r 'select(.type == "assistant") | .message.content[]? | select(type == "string")' 2>/dev/null | tail -1)
        fi
        echo "$output"
    }
    detect_handoff_pattern() {
        local text; text=$(normalize_text "$1")
        local agent; agent=$(echo "$text" | grep -io 'Use the [a-z0-9-]* subagent to' | head -1 | sed 's/[Uu]se the //' | sed 's/ subagent to.*//')
        if [[ -n "$agent" ]]; then echo "$agent"; return 0; fi; return 1
    }
}

# --- Parse input ---
INPUT_JSON=$(cat | sed 's/\\!/!/g')
EVENT=$(json_field "$INPUT_JSON" '.hook_event_name' 'hook_event_name')
SUBAGENT_NAME=$(json_field "$INPUT_JSON" '.tool_input.subagent_type' 'subagent_type')
TRANSCRIPT_PATH=$(json_field "$INPUT_JSON" '.transcript_path' 'transcript_path')
AGENT_OUTPUT=$(extract_agent_output "$INPUT_JSON" "$TRANSCRIPT_PATH")

log "HANDOFF HOOK - Event: $EVENT, Agent: $SUBAGENT_NAME, Output: ${#AGENT_OUTPUT} chars"

# --- TDD Checkpoint: Run tests if agent signals readiness ---
agent_tdd_checkpoint() {
    local agent_name="$1"
    log "TDD CHECKPOINT: $agent_name"

    # Install deps if needed
    if [[ ! -d ".claude-collective/node_modules" ]]; then
        (cd .claude-collective && npm install > /dev/null 2>&1) || true
    fi

    # Run tests with timeout
    timeout 60 bash -c "cd .claude-collective && npx vitest run" > "/tmp/agent-test-$agent_name.log" 2>&1
    local exit_code=$?

    # Check for failures in output
    local has_failures=false
    if [[ ! -f "/tmp/agent-test-$agent_name.log" || ! -s "/tmp/agent-test-$agent_name.log" ]]; then
        has_failures=true
    elif grep -iq "failed\|error\|✗\|×" "/tmp/agent-test-$agent_name.log" && ! grep -iq "0 failed" "/tmp/agent-test-$agent_name.log"; then
        has_failures=true
    elif ! grep -iqE "✓.*test|Tests.*passed|Test Files.*passed|Duration.*[0-9]" "/tmp/agent-test-$agent_name.log"; then
        has_failures=true
    fi

    if [[ $exit_code -ne 0 ]] || [[ "$has_failures" == "true" ]]; then
        local fail_count=$(grep -c "^[[:space:]]*×" "/tmp/agent-test-$agent_name.log" 2>/dev/null || echo "0")
        log "TDD CHECKPOINT FAILED: $agent_name ($fail_count failures, exit=$exit_code)"
        echo "TDD CHECKPOINT FAILED: $agent_name" >&2
        return 1
    fi

    log "TDD CHECKPOINT PASSED: $agent_name"
    echo "TDD CHECKPOINT PASSED: $agent_name" >&2
    return 0
}

# --- TDD Validation: Check agent output quality ---
execute_tdd_validation() {
    local output="$1" agent_name="$2"
    local passed=true msgs=()

    # Check for completion evidence
    if echo "$output" | grep -qi -E "(complete|done|finished|implemented|created|delivered)"; then
        msgs+=("completion evidence found")
    else
        passed=false; msgs+=("no completion evidence")
    fi

    # Agent-type-specific checks
    if [[ "$agent_name" == *"research"* ]]; then
        if ! echo "$output" | grep -qi -E "(research|analysis|findings|Context7|library)"; then
            passed=false; msgs+=("missing research deliverables")
        fi
    elif [[ "$agent_name" == *"implementation"* || "$agent_name" == *"component"* || "$agent_name" == *"feature"* ]]; then
        if ! echo "$output" | grep -qi -E "(file|code|component|function|test|build)"; then
            passed=false; msgs+=("missing implementation deliverables")
        fi
    fi

    log "TDD VALIDATION for $agent_name: [${msgs[*]}] passed=$passed"
    [[ "$passed" == "true" ]] && return 0 || return 1
}

# --- Main logic ---
main() {
    # Only process SubagentStop or PostToolUse(Task) events
    if [[ "$EVENT" != "SubagentStop" && "$EVENT" != "PostToolUse" ]]; then
        return 0
    fi

    if [[ "$EVENT" == "PostToolUse" ]]; then
        local tool_name=$(json_field "$INPUT_JSON" '.tool_name' 'tool_name')
        [[ "$tool_name" != "Task" ]] && return 0
    fi

    [[ -z "$AGENT_OUTPUT" ]] && return 0

    # CHECKPOINT: TDD validation when agent signals handoff readiness
    if echo "$AGENT_OUTPUT" | grep -q "COLLECTIVE_HANDOFF_READY"; then
        if [[ "$SUBAGENT_NAME" != "tdd-validation-agent" ]]; then
            if ! agent_tdd_checkpoint "$SUBAGENT_NAME"; then
                local fail_count=$(grep -c "^[[:space:]]*×" "/tmp/agent-test-$SUBAGENT_NAME.log" 2>/dev/null || echo "0")
                cat <<EOF
{
  "decision": "block",
  "reason": "TDD VALIDATION FAILED: $SUBAGENT_NAME has $fail_count failing tests. Fix tests before handoff. Log: /tmp/agent-test-$SUBAGENT_NAME.log. Execute next: Use the $SUBAGENT_NAME subagent to fix the failing tests."
}
EOF
                return 1
            fi
        fi
    fi

    # Detect handoff directive
    local next_agent
    if next_agent=$(detect_handoff_pattern "$AGENT_OUTPUT"); then
        log "HANDOFF DETECTED: $SUBAGENT_NAME -> $next_agent"
        cat <<EOF
{
  "decision": "block",
  "reason": "WORKFLOW AUTOMATION: $SUBAGENT_NAME handed off to $next_agent. Execute next: Use the $next_agent subagent to continue the workflow."
}
EOF
    elif [[ "$SUBAGENT_NAME" == *"implementation"* ]] && echo "$AGENT_OUTPUT" | grep -qi -E "(complete|done|finished|delivered)"; then
        # Implementation agent completed without explicit handoff - return to hub
        log "HUB RETURN: $SUBAGENT_NAME completed"
        cat <<EOF
{
  "decision": "block",
  "reason": "WORKFLOW AUTOMATION: $SUBAGENT_NAME completed. Execute next: Use the task-orchestrator subagent to coordinate the next phase."
}
EOF
    fi

    # Run TDD validation (non-blocking, logs only)
    execute_tdd_validation "$AGENT_OUTPUT" "$SUBAGENT_NAME" || true

    return 0
}

main "$@"
