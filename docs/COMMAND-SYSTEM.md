# Command System Architecture

This document describes the command parsing, execution, and slash command systems.

## Command System Overview

The collective provides a multi-layer command system:

```mermaid
graph TB
    subgraph "User Input"
        NATURAL[Natural Language]
        SLASH[Slash Commands]
        VAN[/van Command]
    end

    subgraph "Command Processing"
        PARSER[CollectiveCommandParser]
        AUTOCOMPLETE[CommandAutocomplete]
        HELP[CommandHelpSystem]
    end

    subgraph "Execution"
        SYSTEM[CommandSystem]
        HISTORY[CommandHistoryManager]
        METRICS[Command Metrics]
    end

    NATURAL --> PARSER
    SLASH --> PARSER
    VAN --> PARSER

    PARSER --> SYSTEM
    PARSER --> AUTOCOMPLETE
    SYSTEM --> HISTORY
    SYSTEM --> METRICS
    PARSER --> HELP
```

## Command System Components

```mermaid
classDiagram
    class CommandSystem {
        -CommandParser parser
        -CommandHistoryManager history
        -CommandAutocomplete autocomplete
        -CommandHelpSystem help
        -Object metrics
        +executeCommand(input, context)
        +getSuggestions(partial)
        +getHelp(query)
        +getMetrics()
    }

    class CommandParser {
        +parse(input)
        +validateCommand(input)
        +preprocessCommand(input)
    }

    class CommandAutocomplete {
        +getSuggestions(partial, context)
        +clearCache()
    }

    class CommandHistoryManager {
        +addCommand(cmd, result, time)
        +getHistory(limit)
        +searchHistory(query)
        +getStatistics()
    }

    class CommandHelpSystem {
        +getHelp(query)
        +getInteractiveHelp(input)
        +getErrorHelp(error, command)
    }

    CommandSystem --> CommandParser
    CommandSystem --> CommandHistoryManager
    CommandSystem --> CommandAutocomplete
    CommandSystem --> CommandHelpSystem
```

## Command Execution Flow

```mermaid
sequenceDiagram
    participant User
    participant System as CommandSystem
    participant Parser as CommandParser
    participant History as HistoryManager
    participant Metrics

    User->>System: executeCommand(input)
    System->>System: Start timer

    System->>Parser: validate(input)
    Parser-->>System: Validation result

    alt Invalid command
        System-->>User: Error response
    else Valid command
        System->>Parser: parse(input)
        Parser-->>System: Parsed result
        System->>System: Stop timer
        System->>History: addCommand(...)
        System->>Metrics: updateMetrics(...)
        System-->>User: Execution result
    end
```

## Van Routing Command

The `/van` command is the primary entry point for collective routing:

```mermaid
flowchart TD
    USER[User: /van create module]

    subgraph "Van Processing"
        LOAD[Load CLAUDE.md]
        ANALYZE[Analyze Request]
        ROUTE[Route to Agent]
    end

    subgraph "Agent Selection"
        SIMPLE[Level 1: Direct]
        SINGLE[Level 2: Single Agent]
        MULTI[Level 3: Multi-Agent]
        FULL[Level 4: Full Project]
    end

    USER --> LOAD
    LOAD --> ANALYZE
    ANALYZE --> ROUTE

    ROUTE --> SIMPLE
    ROUTE --> SINGLE
    ROUTE --> MULTI
    ROUTE --> FULL
```

### Routing Decision Matrix

```mermaid
graph LR
    subgraph "Request Patterns"
        R1[build/create/implement]
        R2[fix/debug/resolve]
        R3[test/validate]
        R4[optimize/polish]
        R5[research/analyze]
        R6[setup/configure]
    end

    subgraph "Agent Routes"
        A1[component-implementation-agent]
        A2[feature-implementation-agent]
        A3[testing-implementation-agent]
        A4[polish-implementation-agent]
        A5[research-agent]
        A6[infrastructure-implementation-agent]
    end

    R1 --> A1
    R1 --> A2
    R2 --> A2
    R3 --> A3
    R4 --> A4
    R5 --> A5
    R6 --> A6
```

## TaskMaster Commands

The `/tm` command namespace provides TaskMaster integration:

```mermaid
graph TB
    TM[/tm]

    subgraph "Project Setup"
        INIT[/tm/init]
        PARSE[/tm/parse-prd]
    end

    subgraph "Task Management"
        LIST[/tm/list]
        SHOW[/tm/show]
        NEXT[/tm/next]
        STATUS[/tm/set-status]
    end

    subgraph "Task Operations"
        ADD[/tm/add-task]
        EXPAND[/tm/expand]
        UPDATE[/tm/update]
    end

    subgraph "Analysis"
        ANALYZE[/tm/analyze-complexity]
        REPORT[/tm/complexity-report]
    end

    TM --> INIT
    TM --> PARSE
    TM --> LIST
    TM --> SHOW
    TM --> NEXT
    TM --> STATUS
    TM --> ADD
    TM --> EXPAND
    TM --> UPDATE
    TM --> ANALYZE
    TM --> REPORT
```

## Command Autocomplete

```mermaid
flowchart LR
    INPUT[Partial Input]

    subgraph "Context"
        RECENT[Recent Commands]
        STATE[System State]
        AVAILABLE[Available Commands]
    end

    SUGGESTIONS[Ranked Suggestions]

    INPUT --> RECENT
    INPUT --> STATE
    INPUT --> AVAILABLE

    RECENT --> SUGGESTIONS
    STATE --> SUGGESTIONS
    AVAILABLE --> SUGGESTIONS
```

### Suggestion Ranking

```mermaid
graph TD
    INPUT[User Types: /tm l]

    MATCH[Pattern Match]

    S1[/tm/list - High: exact prefix]
    S2[/tm/learn - Medium: prefix match]
    S3[/tm/list-tasks - Low: substring]

    RANK[Rank by frequency]
    RESULT[Ordered Suggestions]

    INPUT --> MATCH
    MATCH --> S1
    MATCH --> S2
    MATCH --> S3
    S1 --> RANK
    S2 --> RANK
    S3 --> RANK
    RANK --> RESULT
```

## Command History

```mermaid
graph LR
    subgraph "Storage"
        FILE[command-history.json]
    end

    subgraph "Entry Structure"
        CMD[command]
        RESULT[result]
        TIME[executionTime]
        STAMP[timestamp]
    end

    subgraph "Operations"
        ADD[addCommand]
        SEARCH[searchHistory]
        STATS[getStatistics]
        CLEAR[clearOldHistory]
    end

    ADD --> FILE
    SEARCH --> FILE
    STATS --> FILE
    CLEAR --> FILE

    FILE --> CMD
    FILE --> RESULT
    FILE --> TIME
    FILE --> STAMP
```

## Command Metrics

```mermaid
graph TB
    subgraph "Collected Metrics"
        M1[totalCommands]
        M2[successfulCommands]
        M3[failedCommands]
        M4[averageExecutionTime]
        M5[slowCommands]
    end

    subgraph "Calculated"
        C1[successRate]
        C2[performanceThreshold]
        C3[naturalLanguageUsage]
    end

    M1 --> C1
    M2 --> C1
    M4 --> C2
    M5 --> C2
```

## Command Preprocessing

Before execution, commands are preprocessed:

```mermaid
flowchart LR
    RAW[Raw Input]

    subgraph "Processing Steps"
        TRIM[Trim whitespace]
        NORMALIZE[Normalize spaces]
        CORRECT[Fix typos]
    end

    CLEAN[Clean Command]

    RAW --> TRIM
    TRIM --> NORMALIZE
    NORMALIZE --> CORRECT
    CORRECT --> CLEAN
```

### Typo Corrections

| Typo | Correction |
|------|------------|
| `/collecitve` | `/collective` |
| `/agnet` | `/agent` |
| `/gaet` | `/gate` |
| `stauts` | `status` |
| `lsit` | `list` |

## Command Validation

```mermaid
flowchart TD
    CMD[Command Input]

    CHECK1{Non-empty string?}
    CHECK2{Has content?}
    CHECK3{Safe patterns?}

    VALID[Valid]
    INVALID[Invalid + Error]

    CMD --> CHECK1
    CHECK1 --> |No| INVALID
    CHECK1 --> |Yes| CHECK2
    CHECK2 --> |No| INVALID
    CHECK2 --> |Yes| CHECK3
    CHECK3 --> |No| INVALID
    CHECK3 --> |Yes| VALID
```

### Dangerous Pattern Detection

```mermaid
graph TD
    CMD[Command]

    subgraph "Blocked Patterns"
        P1[rm -rf]
        P2[sudo rm]
        P3[../../..]
        P4[system\(]
        P5[exec\(]
    end

    CHECK{Contains pattern?}
    BLOCK[Block execution]
    ALLOW[Allow execution]

    CMD --> CHECK
    P1 --> CHECK
    P2 --> CHECK
    P3 --> CHECK
    P4 --> CHECK
    P5 --> CHECK

    CHECK --> |Yes| BLOCK
    CHECK --> |No| ALLOW
```

## Batch Command Execution

```mermaid
sequenceDiagram
    participant Caller
    participant System as CommandSystem
    participant Executor

    Caller->>System: executeBatch(commands, options)

    alt Sequential (maxConcurrency=1)
        loop For each command
            System->>Executor: executeCommand(cmd)
            Executor-->>System: Result
            alt Failed && !continueOnError
                System-->>Caller: Partial results
            end
        end
    else Parallel
        Note over System: Split into chunks
        loop For each chunk
            System->>Executor: Promise.allSettled(chunk)
            Executor-->>System: Chunk results
        end
    end

    System-->>Caller: All results
```

## Help System

```mermaid
graph TB
    QUERY[User Query]

    subgraph "Help Types"
        GENERAL[General Help]
        SPECIFIC[Command Help]
        ERROR[Error Help]
        INTERACTIVE[Interactive Help]
    end

    subgraph "Output"
        DOC[Documentation]
        EXAMPLES[Examples]
        SUGGEST[Suggestions]
    end

    QUERY --> GENERAL
    QUERY --> SPECIFIC
    QUERY --> ERROR
    QUERY --> INTERACTIVE

    GENERAL --> DOC
    SPECIFIC --> EXAMPLES
    ERROR --> SUGGEST
    INTERACTIVE --> DOC
    INTERACTIVE --> SUGGEST
```

## Command Export

```mermaid
graph LR
    DATA[Command Data]

    subgraph "Formats"
        JSON[JSON Export]
        CSV[CSV Export]
        MD[Markdown Export]
    end

    DATA --> JSON
    DATA --> CSV
    DATA --> MD
```

### Export Contents

| Format | Includes |
|--------|----------|
| **JSON** | Full metrics, history, system state |
| **CSV** | Command history (timestamp, command, result) |
| **Markdown** | Metrics summary, recent commands table |

## Slash Command Structure

Each slash command is defined in a Markdown file:

```markdown
---
name: command-name
description: What the command does
arguments: Optional arguments pattern
---

# Command Title

[Command instructions and steps]
```

### Command Directory Structure

```
.claude/commands/
├── van.md                    # Main routing command
├── autocompact.md            # Context management
├── reset-handoff.md          # Reset handoff state
├── continue-handoff.md       # Continue handoff chain
└── tm/                       # TaskMaster namespace
    ├── init/
    │   └── init-project.md
    ├── list/
    │   ├── list-tasks.md
    │   └── list-tasks-with-subtasks.md
    ├── show/
    │   └── show-task.md
    ├── set-status/
    │   ├── to-done.md
    │   ├── to-in-progress.md
    │   └── to-pending.md
    └── ...
```

## Data Flow

```mermaid
flowchart TD
    subgraph "Input Layer"
        USER[User Input]
        SLASH[Slash Command]
        NATURAL[Natural Language]
    end

    subgraph "Processing Layer"
        PARSE[Parser]
        VALIDATE[Validator]
        PREPROCESS[Preprocessor]
    end

    subgraph "Execution Layer"
        EXECUTE[Executor]
        ROUTE[Router]
    end

    subgraph "Output Layer"
        HISTORY[History]
        METRICS[Metrics]
        RESULT[Result]
    end

    USER --> SLASH
    USER --> NATURAL

    SLASH --> PARSE
    NATURAL --> PARSE

    PARSE --> VALIDATE
    VALIDATE --> PREPROCESS
    PREPROCESS --> EXECUTE

    EXECUTE --> ROUTE
    ROUTE --> RESULT

    EXECUTE --> HISTORY
    EXECUTE --> METRICS
```

## System Maintenance

```mermaid
sequenceDiagram
    participant System
    participant History
    participant Cache
    participant Metrics

    Note over System: Maintenance Cycle
    System->>History: clearOldHistory(30 days)
    History-->>System: Entries removed

    System->>Cache: clearCache()
    Cache-->>System: Cache cleared

    System->>Metrics: Trim slowCommands
    Metrics-->>System: Metrics trimmed

    System->>System: Emit maintenance:complete
```

## See Also

- [OVERVIEW.md](./OVERVIEW.md) - System architecture overview
- [AGENTS.md](./AGENTS.md) - Agent routing via commands
- [HOOKS.md](./HOOKS.md) - Command enforcement hooks
