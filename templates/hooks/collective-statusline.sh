#!/bin/bash
# collective-statusline.sh
# Enhanced statusline for Drupal Claude Collective.
# Shows: git branch | version | context usage | TaskMaster counts | handoff state.
# Reads Claude Code context window JSON from stdin.
# Designed to complete in <50ms. Degrades gracefully without jq.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
HAS_JQ=$(command -v jq >/dev/null 2>&1 && echo 1 || echo 0)
SEGMENTS=()

# --- Project folder name ---
folder=$(basename "$PROJECT_DIR")
if [[ -n "$folder" && "$folder" != "." ]]; then
  SEGMENTS+=("\033[1m${folder}\033[0m")
fi

# --- Git branch ---
branch=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null || echo "")
if [[ -n "$branch" ]]; then
  SEGMENTS+=("\033[36m${branch}\033[0m")
fi

# --- Version (root package.json only, skip test framework) ---
if [[ "$HAS_JQ" == "1" && -f "$PROJECT_DIR/package.json" ]]; then
  version=$(jq -r '.version // empty' "$PROJECT_DIR/package.json" 2>/dev/null)
  if [[ -n "$version" ]]; then
    SEGMENTS+=("v${version}")
  fi
fi

# --- Context window usage (from stdin JSON) ---
if [[ "$HAS_JQ" == "1" ]]; then
  stdin_json=$(cat)
  if [[ -n "$stdin_json" && "$stdin_json" != "{}" ]]; then
    # Use pre-calculated used_percentage (most reliable).
    pct=$(echo "$stdin_json" | jq -r '.context_window.used_percentage // empty' 2>/dev/null | cut -d. -f1)
    if [[ -n "$pct" ]]; then
      # Use cumulative session totals for the token display.
      total_in=$(echo "$stdin_json" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null)
      total_out=$(echo "$stdin_json" | jq -r '.context_window.total_output_tokens // 0' 2>/dev/null)

      # Format token counts as compact "Xk" values.
      in_k=$((total_in / 1000))
      out_k=$((total_out / 1000))

      # Color: green <50%, yellow 50-80%, red >80%.
      if [[ $pct -lt 50 ]]; then
        color="\033[32m"
      elif [[ $pct -lt 80 ]]; then
        color="\033[33m"
      else
        color="\033[31m"
      fi
      SEGMENTS+=("${color}ctx:${pct}% ${in_k}k>${out_k}k\033[0m")
    fi
  fi
else
  # Consume stdin even without jq to avoid broken pipe.
  cat >/dev/null
fi

# --- TaskMaster task counts ---
TM_FILE="$PROJECT_DIR/.taskmaster/tasks/tasks.json"
if [[ -f "$TM_FILE" ]]; then
  pending=$(grep -c '"status": *"pending"' "$TM_FILE" 2>/dev/null) || pending=0
  active=$(grep -c '"status": *"in-progress"' "$TM_FILE" 2>/dev/null) || active=0
  if [[ $((pending + active)) -gt 0 ]]; then
    SEGMENTS+=("tm:${pending}p/${active}a")
  fi
fi

# --- Handoff indicator ---
HANDOFF_FILE="$PROJECT_DIR/.claude/handoff/NEXT_ACTION.json"
if [[ -f "$HANDOFF_FILE" ]]; then
  if [[ "$HAS_JQ" == "1" ]]; then
    agent=$(jq -r '.target_agent // empty' "$HANDOFF_FILE" 2>/dev/null)
  else
    agent=$(grep -o '"target_agent":\s*"[^"]*"' "$HANDOFF_FILE" 2>/dev/null | head -1 | cut -d'"' -f4)
  fi
  if [[ -n "$agent" ]]; then
    SEGMENTS+=("\033[35mhandoff:${agent}\033[0m")
  fi
fi

# --- Output ---
if [[ ${#SEGMENTS[@]} -eq 0 ]]; then
  echo "collective"
  exit 0
fi

# Join segments with " | ".
result=""
for i in "${!SEGMENTS[@]}"; do
  if [[ $i -gt 0 ]]; then
    result+=" | "
  fi
  result+="${SEGMENTS[$i]}"
done

echo -e "$result"
