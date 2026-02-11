# Hook System Architecture

This document describes the hook system that enforces behavioral rules, validates handoffs, and collects research metrics.

## Hook Overview

The collective includes 8 enforcement hooks that integrate with Claude Code's hook system:

```mermaid
graph TB
    subgraph "Claude Code Events"
        SESSION[SessionStart]
        PRE[PreToolUse]
        POST[PostToolUse]
        COMPACT[PreCompact]
        SUBSTART[SubagentStart]
        SUBSTOP[SubagentStop]
    end

    subgraph "Enforcement Hooks"
        H1[load-behavioral-system.sh]
        H2[block-destructive-commands.sh]
        H3[block-sensitive-files.sh]
        H4[collective-metrics.sh]
        H5[semantic-docs-update-hook.sh]
        H6[test-driven-handoff.sh]
        H7[pre-compact-state.sh]
        H8[subagent-context-inject.sh]
    end

    SESSION --> H1
    PRE --> H2
    PRE --> H3
    POST --> H4
    POST --> H5
    POST --> H6
    COMPACT --> H7
    SUBSTART --> H8
```

## Hook Descriptions

| Hook | Event | Lines | Purpose |
|------|-------|-------|---------|
| **load-behavioral-system.sh** | SessionStart | 18 | Loads INDEX.md + DECISION.md at startup, recovers compact state |
| **block-destructive-commands.sh** | PreToolUse | 242 | Security: blocks rm -rf, force push, etc. |
| **block-sensitive-files.sh** | PreToolUse | 220 | Security: blocks Read/Grep on .env, settings.php, credentials |
| **collective-metrics.sh** | PostToolUse | 106 | Collects routing, performance, research metrics |
| **semantic-docs-update-hook.sh** | PostToolUse | 75 | Reminds to update semantic docs after dev tasks |
| **test-driven-handoff.sh** | PostToolUse/SubagentStop | 172 | TDD validation and handoff chaining |
| **pre-compact-state.sh** | PreCompact | ~40 | Saves active agent/task state before context compaction |
| **subagent-context-inject.sh** | SubagentStart | ~60 | Validates agent name, injects recovery context and memory path |

## Hook Flow

### Complete Request Lifecycle

```mermaid
sequenceDiagram
    participant User
    participant Claude as Claude Code
    participant Pre as PreToolUse Hooks
    participant Tool
    participant Post as PostToolUse Hooks
    participant Sub as SubagentStop Hook

    User->>Claude: Request
    Claude->>Pre: Hook: block-destructive-commands
    Pre->>Pre: Check command patterns

    alt Dangerous Command
        Pre-->>Claude: BLOCK
        Claude-->>User: Blocked message
    else Allowed
        Pre-->>Claude: ALLOW
        Claude->>Tool: Execute
        Tool-->>Claude: Result
        Claude->>Post: Hook: collective-metrics
        Post->>Post: Record metrics
        Post-->>Claude: Continue

        alt Agent Task
            Claude->>Sub: Hook: test-driven-handoff
            Sub->>Sub: TDD Validation

            alt Handoff Detected
                Sub-->>Claude: BLOCK + Next Agent
                Claude->>Claude: Auto-delegate
            else No Handoff
                Sub-->>Claude: ALLOW
            end
        end

        Claude-->>User: Response
    end
```

## Test-Driven Handoff Hook

The most complex hook, responsible for TDD validation and workflow automation:

```mermaid
flowchart TB
    START[Agent Completes]

    subgraph "Input Processing"
        PARSE[Parse JSON Input]
        EXTRACT[Extract Agent Output]
    end

    subgraph "TDD Checkpoint"
        TOKEN[Validate Handoff Token]
        OUTPUT[Validate Agent Output]
        CONTRACT[Validate State Contract]
        TEST[Run Vitest Tests]
    end

    subgraph "Handoff Detection"
        DETECT[Detect Handoff Pattern]
        NORMALIZE[Normalize Unicode]
        MATCH[Match Agent Name]
    end

    subgraph "Actions"
        BLOCK[Block + Route to Next]
        ALLOW[Allow Completion]
        FAIL[Fail + Require Fix]
    end

    START --> PARSE
    PARSE --> EXTRACT
    EXTRACT --> TOKEN
    TOKEN --> OUTPUT
    OUTPUT --> CONTRACT
    CONTRACT --> TEST

    TEST --> |Pass| DETECT
    TEST --> |Fail| FAIL

    DETECT --> NORMALIZE
    NORMALIZE --> MATCH

    MATCH --> |Found| BLOCK
    MATCH --> |Not Found| ALLOW
```

### Handoff Pattern Detection

```mermaid
graph LR
    OUTPUT[Agent Output]
    REGEX[Pattern: Use the X subagent to...]
    NORMALIZE[Unicode Normalization]
    EXTRACT[Extract Agent Name]
    ROUTE[Route to Agent]

    OUTPUT --> NORMALIZE
    NORMALIZE --> REGEX
    REGEX --> EXTRACT
    EXTRACT --> ROUTE
```

## Hook Configuration

Hooks are configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": {},
        "hooks": [{ "type": "command", "command": ".claude/hooks/load-behavioral-system.sh" }]
      }
    ],
    "PreToolUse": [
      {
        "matcher": { "toolName": "Bash" },
        "hooks": [{ "type": "command", "command": ".claude/hooks/block-destructive-commands.sh" }]
      },
      {
        "matcher": { "toolName": "Read|Grep" },
        "hooks": [{ "type": "command", "command": ".claude/hooks/block-sensitive-files.sh" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": { "toolName": ".*" },
        "hooks": [
          { "type": "command", "command": ".claude/hooks/collective-metrics.sh" },
          { "type": "command", "command": ".claude/hooks/semantic-docs-update-hook.sh" }
        ]
      },
      {
        "matcher": { "toolName": "Task" },
        "hooks": [{ "type": "command", "command": ".claude/hooks/test-driven-handoff.sh" }]
      }
    ],
    "PreCompact": [
      {
        "matcher": {},
        "hooks": [{ "type": "command", "command": ".claude/hooks/pre-compact-state.sh" }]
      }
    ],
    "SubagentStart": [
      {
        "matcher": { "agentName": ".*" },
        "hooks": [{ "type": "command", "command": ".claude/hooks/subagent-context-inject.sh" }]
      }
    ],
    "SubagentStop": [
      {
        "matcher": {},
        "hooks": [{ "type": "command", "command": ".claude/hooks/test-driven-handoff.sh" }]
      }
    ]
  }
}
```

## Hook Response Types

```mermaid
graph TB
    subgraph "Response Actions"
        ALLOW[Allow<br/>Continue execution]
        BLOCK[Block<br/>Prevent + route]
        WARN[Warn<br/>Log + continue]
        FAIL[Fail<br/>Stop workflow]
    end

    subgraph "JSON Responses"
        J1["{ decision: 'allow' }"]
        J2["{ decision: 'block', reason: '...' }"]
        J3["{ decision: 'warn', message: '...' }"]
        J4["{ decision: 'fail', error: '...' }"]
    end

    ALLOW --> J1
    BLOCK --> J2
    WARN --> J3
    FAIL --> J4
```

## TDD Validation Checkpoints

### Agent-Level Checkpoint

```mermaid
flowchart TD
    START[Agent Signals Completion]
    CHECK[COLLECTIVE_HANDOFF_READY?]

    subgraph "Validation"
        DEPS[Check Dependencies]
        VITEST[Run Vitest Tests]
        BUILD[Run npm build]
    end

    subgraph "Results"
        PASS[Checkpoint Passed]
        RETRY[Block + Retry Agent]
    end

    START --> CHECK
    CHECK --> |Yes| DEPS
    CHECK --> |No| PASS
    DEPS --> VITEST
    VITEST --> |Pass| BUILD
    VITEST --> |Fail| RETRY
    BUILD --> |Pass| PASS
    BUILD --> |Fail| RETRY
```

### Orchestrator Phase Checkpoint

```mermaid
flowchart TD
    OUTPUT[Orchestrator Output]
    DETECT[Detect Phase Completion]

    subgraph "Phase Markers"
        M1[ORCHESTRATION STATUS...COMPLETED]
        M2[ALL TASKS SUCCESSFULLY COMPLETED]
        M3[PHASE...HAS BEEN COMPLETED]
    end

    VALIDATE[Route to tdd-validation-agent]
    CONTINUE[Continue Orchestration]

    OUTPUT --> DETECT
    DETECT --> M1
    DETECT --> M2
    DETECT --> M3

    M1 --> |Match| VALIDATE
    M2 --> |Match| VALIDATE
    M3 --> |Match| VALIDATE

    M1 --> |No Match| CONTINUE
    M2 --> |No Match| CONTINUE
    M3 --> |No Match| CONTINUE
```

## Metrics Collection Hook

```mermaid
graph LR
    subgraph "Input"
        TOOL[Tool Execution]
        RESULT[Execution Result]
        TIME[Execution Time]
    end

    subgraph "Collection"
        METRICS[collective-metrics.sh]
    end

    subgraph "Storage"
        SNAP[Snapshots]
        AGG[Aggregations]
        REPORT[Reports]
    end

    TOOL --> METRICS
    RESULT --> METRICS
    TIME --> METRICS

    METRICS --> SNAP
    METRICS --> AGG
    SNAP --> REPORT
    AGG --> REPORT
```

## Security Hooks

### Block Destructive Commands

```mermaid
graph TD
    CMD[Command Input]

    subgraph "Dangerous Patterns"
        P1[rm -rf]
        P2[sudo rm]
        P3[../../..]
        P4[system\(\"]
        P5[exec\(]
    end

    CHECK{Pattern Match?}
    BLOCK[Block Execution]
    ALLOW[Allow Execution]

    CMD --> CHECK
    CHECK --> |Match| BLOCK
    CHECK --> |No Match| ALLOW

    P1 --> CHECK
    P2 --> CHECK
    P3 --> CHECK
    P4 --> CHECK
    P5 --> CHECK
```

### Sensitive File Protection

```mermaid
graph TD
    FILE[File Access Request]

    subgraph "Protected Files"
        F1[.env / .env.*]
        F2[settings.php]
        F3[*.key / *.pem]
        F4[SSH Keys]
    end

    CHECK{Protected?}
    BLOCK[Block Access]
    ALLOW[Allow Access]

    FILE --> CHECK
    F1 --> CHECK
    F2 --> CHECK
    F3 --> CHECK
    F4 --> CHECK

    CHECK --> |Yes| BLOCK
    CHECK --> |No| ALLOW
```

## Hook Data Flow

```mermaid
flowchart LR
    subgraph "Input Sources"
        STDIN[stdin: JSON]
        ENV[Environment Variables]
        FILES[Project Files]
    end

    subgraph "Processing"
        HOOK[Hook Script]
    end

    subgraph "Output Destinations"
        STDOUT[stdout: JSON Response]
        STDERR[stderr: User Messages]
        LOG[/tmp/*.log]
        METRICS[.claude-collective/metrics/]
    end

    STDIN --> HOOK
    ENV --> HOOK
    FILES --> HOOK

    HOOK --> STDOUT
    HOOK --> STDERR
    HOOK --> LOG
    HOOK --> METRICS
```

## Error Handling

```mermaid
flowchart TD
    ERROR[Hook Error]

    subgraph "Error Types"
        E1[Parse Error]
        E2[Validation Error]
        E3[Execution Error]
        E4[Timeout]
    end

    subgraph "Recovery Actions"
        R1[Log + Continue]
        R2[Block + Report]
        R3[Retry Hook]
        R4[Fallback Behavior]
    end

    ERROR --> E1
    ERROR --> E2
    ERROR --> E3
    ERROR --> E4

    E1 --> R1
    E2 --> R2
    E3 --> R3
    E4 --> R4
```

## Hook Development Guidelines

### Input Processing

```bash
# Read JSON from stdin
INPUT_JSON=$(cat | sed 's/\\!/!/g')

# Parse with jq (preferred)
EVENT=$(echo "$INPUT_JSON" | jq -r '.hook_event_name')

# Fallback to grep/sed
EVENT=$(echo "$INPUT_JSON" | grep -o '"hook_event_name":"[^"]*"' | cut -d'"' -f4)
```

### Response Format

```bash
# Allow action
cat <<EOF
{
  "decision": "allow"
}
EOF

# Block with reason
cat <<EOF
{
  "decision": "block",
  "reason": "Explanation for user"
}
EOF
```

### Logging

```bash
LOG_FILE="/tmp/hook-name.log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# User-visible messages go to stderr
echo "User message" >&2
```

## PreCompact Hook (v2.1)

Saves active agent state before context compaction to prevent losing task context.

```mermaid
flowchart TD
    COMPACT[Context Compaction Triggered]
    SAVE[Save State to .claude/compact-recovery.json]

    subgraph "State Saved"
        S1[Active Agent Name]
        S2[Current Task Context]
        S3[Handoff State]
        S4[Timestamp]
    end

    RECOVER[SessionStart: Recover State]
    DELETE[Delete Recovery File]

    COMPACT --> SAVE
    SAVE --> S1
    SAVE --> S2
    SAVE --> S3
    SAVE --> S4

    S1 --> RECOVER
    RECOVER --> DELETE
```

### Recovery Flow

The `load-behavioral-system.sh` hook checks for the recovery file on SessionStart:
1. If `.claude/compact-recovery.json` exists, reads and outputs saved state
2. Injects recovered context into the session
3. Deletes the recovery file after successful injection

## SubagentStart Hook (v2.1)

Validates agent names and injects project context when agents spawn.

```mermaid
flowchart TD
    SPAWN[Agent Spawning]

    VALIDATE{Agent in 15-agent registry?}
    WARN[Warning: Unknown agent name]
    INJECT[Inject Context]

    subgraph "Injected Context"
        I1[Compact Recovery Data]
        I2[Agent Memory Path]
        I3[Drupal Version from composer.json]
    end

    SPAWN --> VALIDATE
    VALIDATE --> |No| WARN
    VALIDATE --> |Yes| INJECT
    WARN --> INJECT

    INJECT --> I1
    INJECT --> I2
    INJECT --> I3
```

### Agent Registry Validation

The hook validates against the 15 known agents:
- routing-agent, drupal-architect, module-development-agent
- theme-development-agent, configuration-management-agent, content-migration-agent
- security-compliance-agent, performance-devops-agent
- functional-testing-agent, unit-testing-agent, visual-regression-agent
- enhanced-project-manager-agent, research-agent, workflow-agent, semantic-architect-agent

Unknown agent names are logged as warnings but execution continues.

## Shared Utilities (lib/hook-utils.sh)

All hooks source `lib/hook-utils.sh` for:
- JSON parsing (with jq fallback to grep/sed)
- Unicode dash normalization for handoff pattern matching
- Handoff pattern detection
- Logging utilities

## See Also

- [OVERVIEW.md](./OVERVIEW.md) - System architecture overview
- [AGENTS.md](./AGENTS.md) - Agent system and handoffs
- [METRICS.md](./METRICS.md) - Research metrics collection
