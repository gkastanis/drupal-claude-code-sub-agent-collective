# Installation System Architecture

This document describes the installation process, file mapping, template processing, and configuration management.

## Installation Overview

The collective is installed via NPX with an interactive or express mode:

```mermaid
graph TB
    subgraph "Entry Points"
        NPX[npx drupal-claude-collective init]
        CLI[CLI: claude-code-collective.js]
    end

    subgraph "Installation Modes"
        INTERACTIVE[InteractiveInstaller]
        EXPRESS[Express Mode]
    end

    subgraph "Core Installer"
        INSTALLER[CollectiveInstaller]
    end

    subgraph "Sub-Systems"
        MAPPING[FileMapping]
        MERGE[MergeStrategies]
        MCP[MCPConfigManager]
        TEMPLATES[Template Processing]
    end

    NPX --> CLI
    CLI --> INTERACTIVE
    CLI --> EXPRESS

    INTERACTIVE --> INSTALLER
    EXPRESS --> INSTALLER

    INSTALLER --> MAPPING
    INSTALLER --> MERGE
    INSTALLER --> MCP
    INSTALLER --> TEMPLATES
```

## Installation Sequence

```mermaid
sequenceDiagram
    participant User
    participant CLI as claude-code-collective.js
    participant Installer as CollectiveInstaller
    participant FS as File System
    participant Validator

    User->>CLI: npx drupal-claude-collective init
    CLI->>Installer: new CollectiveInstaller(options)

    Note over Installer: Check Existing Installation
    Installer->>FS: Check .claude/ exists
    FS-->>Installer: Exists/Not exists

    alt Exists without --force
        Installer->>User: Prompt for overwrite
    end

    Note over Installer: Create Directory Structure
    Installer->>FS: mkdir .claude/agents
    Installer->>FS: mkdir .claude/hooks
    Installer->>FS: mkdir .claude/hooks/lib
    Installer->>FS: mkdir .claude/commands
    Installer->>FS: mkdir .claude/rules
    Installer->>FS: mkdir .claude/agent-memory (+ 5 subdirs)
    Installer->>FS: mkdir .claude/skills (+ 10 skill dirs)
    Installer->>FS: mkdir .claude-collective/tests
    Installer->>FS: mkdir .taskmaster/

    Note over Installer: Setup TaskMaster
    Installer->>FS: Copy .taskmaster/ template
    Installer->>FS: Write config.json

    Note over Installer: Install Templates
    Installer->>Installer: Process CLAUDE.md template
    Installer->>FS: Write CLAUDE.md

    Note over Installer: Configure Settings
    Installer->>FS: Write .claude/settings.json

    Note over Installer: Configure MCP
    Installer->>Installer: Generate .mcp.json
    Installer->>FS: Write .mcp.json

    Note over Installer: Setup Hooks
    Installer->>FS: Write hook scripts
    Installer->>FS: chmod 755 hooks

    Note over Installer: Install Agents
    Installer->>FS: Write agent definitions

    Note over Installer: Validate
    Installer->>Validator: validateInstallation()
    Validator->>FS: Check all required files
    Validator-->>Installer: Validation result

    Installer-->>User: Installation complete
```

## File Mapping System

The `FileMapping` class manages template-to-target file relationships:

```mermaid
classDiagram
    class FileMapping {
        -String projectDir
        -Object options
        +getFilteredMapping(type) Array
        +getCoreMapping() Array
        +getAgentMapping() Array
        +getHookMapping() Array
        +getRulesMapping() Array
        +getAgentMemoryMapping() Array
        +getSkillMapping() Array
        +getConfigMapping() Array
        +getTestMapping() Array
    }

    class MappingEntry {
        +String source
        +String target
        +String description
        +Boolean overwrite
        +Boolean executable
        +String category
    }

    FileMapping "1" --> "*" MappingEntry : produces
```

### Mapping Categories

```mermaid
graph TB
    subgraph "Core Files"
        C1[CLAUDE.md]
        C2[.claude-collective/CLAUDE.md]
        C3[.claude-collective/DECISION.md]
    end

    subgraph "Agent Files"
        A1[routing-agent.md]
        A2[drupal-architect.md]
        A3[module-development-agent.md]
        A4[15+ more agents...]
    end

    subgraph "Hook Files"
        H1[load-behavioral-system.sh]
        H2[block-destructive-commands.sh]
        H3[block-sensitive-files.sh]
        H4[collective-metrics.sh]
        H5[test-driven-handoff.sh]
        H6[pre-compact-state.sh]
        H7[subagent-context-inject.sh]
        H8[semantic-docs-update-hook.sh]
    end

    subgraph "Rules Files (v2.1)"
        R1[drupal-services.md]
        R2[drupal-security.md]
        R3[code-quality.md]
        R4[3 more rules...]
    end

    subgraph "Agent Memory (v2.1)"
        AM1[drupal-architect/MEMORY.md]
        AM2[4 more agent memories...]
    end

    subgraph "Config Files"
        CF1[settings.json]
        CF2[settings.local.json]
        CF3[.mcp.json]
    end

    subgraph "Command Files"
        CMD1[van.md]
        CMD2[tm/*.md]
    end

    subgraph "Skill Files (v2.1)"
        SK1[7 Drupal SKILL.md files]
    end
```

## Template Processing

```mermaid
flowchart LR
    subgraph "Input"
        TEMPLATE[Template File]
        VARS[Variables]
    end

    subgraph "Processing"
        READ[Read Template]
        REPLACE[Replace Placeholders]
    end

    subgraph "Output"
        RESULT[Processed Content]
    end

    TEMPLATE --> READ
    VARS --> REPLACE
    READ --> REPLACE
    REPLACE --> RESULT
```

### Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_ROOT}}` | Absolute project path | `/home/user/drupal-site` |
| `{{INSTALL_DATE}}` | Installation timestamp | `2024-01-15T10:30:00Z` |
| `{{VERSION}}` | Collective version | `1.5.2` |
| `{{USER_NAME}}` | Current user | `developer` |
| `{{PROJECT_NAME}}` | Project directory name | `my-drupal-site` |

## Merge Strategies

When files already exist, the `MergeStrategies` class handles conflicts:

```mermaid
flowchart TD
    EXISTING[Existing File]
    NEW[New Template]

    CHECK{Files Identical?}

    SKIP[Skip - No changes]
    CONFLICT{Strategy?}

    SMART[Smart Merge]
    FORCE[Force Overwrite]
    SKIP_CONFLICT[Skip Conflicts]

    BACKUP[Create Backup]
    WRITE[Write New File]
    MERGE[Merge Contents]

    EXISTING --> CHECK
    NEW --> CHECK

    CHECK --> |Yes| SKIP
    CHECK --> |No| CONFLICT

    CONFLICT --> |smart-merge| SMART
    CONFLICT --> |force| FORCE
    CONFLICT --> |skip-conflicts| SKIP_CONFLICT

    FORCE --> BACKUP
    BACKUP --> WRITE

    SMART --> MERGE
    MERGE --> WRITE

    SKIP_CONFLICT --> SKIP
```

### Smart Merge for Settings

```mermaid
graph LR
    subgraph "Existing"
        E1[User hooks]
        E2[User allowedTools]
        E3[User configs]
    end

    subgraph "New"
        N1[Collective hooks]
        N2[Collective allowedTools]
        N3[Collective configs]
    end

    subgraph "Merged"
        M1[All hooks combined]
        M2[All tools combined]
        M3[Collective + User configs]
    end

    E1 --> M1
    N1 --> M1
    E2 --> M2
    N2 --> M2
    E3 --> M3
    N3 --> M3
```

## MCP Configuration

The `MCPConfigManager` generates `.mcp.json`:

```mermaid
flowchart TD
    OPTIONS[Installation Options]

    CHECK1{--with-playwright?}
    CHECK2{--with-context7?}
    CHECK3{--with-all-mcps?}

    TM[Add TaskMaster MCP]
    PW[Add Playwright MCP]
    C7[Add Context7 MCP]

    CONFIG[Generate .mcp.json]
    VALIDATE[Validate Configuration]
    WRITE[Write File]

    OPTIONS --> TM
    TM --> CHECK1
    CHECK1 --> |Yes| PW
    CHECK1 --> |No| CHECK2

    PW --> CHECK2
    CHECK2 --> |Yes| C7
    CHECK2 --> |No| CONFIG

    C7 --> CONFIG

    OPTIONS --> CHECK3
    CHECK3 --> |Yes| TM
    CHECK3 --> |Yes| PW
    CHECK3 --> |Yes| C7

    CONFIG --> VALIDATE
    VALIDATE --> WRITE
```

### MCP Server Profiles

```mermaid
graph TB
    subgraph "Default Profile"
        D1[TaskMaster Only<br/>~20MB, Low CPU]
    end

    subgraph "With Playwright"
        P1[TaskMaster + Playwright<br/>~220MB, High CPU]
    end

    subgraph "With Context7"
        C1[TaskMaster + Context7<br/>~50MB, Low CPU]
    end

    subgraph "All MCPs"
        A1[All Servers<br/>~250MB, High CPU]
    end
```

## Directory Creation

```mermaid
graph TB
    ROOT[Project Root]

    ROOT --> CLAUDE[.claude/]
    CLAUDE --> AGENTS[agents/]
    CLAUDE --> HOOKS[hooks/]
    HOOKS --> HOOKLIB[lib/]
    CLAUDE --> COMMANDS[commands/]
    CLAUDE --> RULES[rules/ v2.1]
    CLAUDE --> AGENTMEM[agent-memory/ v2.1]
    AGENTMEM --> AM1[drupal-architect/]
    AGENTMEM --> AM2[module-development-agent/]
    AGENTMEM --> AM3[security-compliance-agent/]
    AGENTMEM --> AM4[research-agent/]
    AGENTMEM --> AM5[configuration-management-agent/]
    CLAUDE --> SKILLS[skills/]
    SKILLS --> SK1[semantic-docs/]
    SKILLS --> SK2[drupal-entity-api/ v2.1]
    SKILLS --> SK3[drupal-service-di/ v2.1]
    SKILLS --> SK4[7 more skills...]

    ROOT --> COLLECTIVE[.claude-collective/]
    COLLECTIVE --> TESTS[tests/]
    TESTS --> HANDOFFS[handoffs/]
    TESTS --> DIRECTIVES[directives/]
    TESTS --> CONTRACTS[contracts/]
    COLLECTIVE --> METRICS[metrics/]

    ROOT --> TASKMASTER[.taskmaster/]
    TASKMASTER --> TASKS[tasks/]
    TASKMASTER --> DOCS[docs/]
    TASKMASTER --> REPORTS[reports/]
    TASKMASTER --> TEMPLATES[templates/]
```

## Installation Options

```mermaid
graph LR
    subgraph "Flags"
        F1[--yes: Express mode]
        F2[--force: Overwrite]
        F3[--minimal: Core only]
        F4[--with-playwright]
        F5[--with-context7]
        F6[--with-all-mcps]
    end

    subgraph "Modes"
        M1[smart-merge]
        M2[force]
        M3[skip-conflicts]
    end

    subgraph "Backup Strategies"
        B1[full]
        B2[simple]
        B3[none]
    end
```

## Validation

Post-installation validation ensures all required files exist:

```mermaid
flowchart TD
    START[Start Validation]

    C1{CLAUDE.md exists?}
    C2{settings.json exists?}
    C3{hooks/ directory exists?}
    C4{agents/ directory exists?}
    C5{tests/ directory exists?}
    C6{rules/ directory exists?}
    C7{agent-memory/ directory exists?}

    PASS[Validation Passed]
    FAIL[Validation Failed]

    START --> C1
    C1 --> |Yes| C2
    C1 --> |No| FAIL
    C2 --> |Yes| C3
    C2 --> |No| FAIL
    C3 --> |Yes| C4
    C3 --> |No| FAIL
    C4 --> |Yes| C5
    C4 --> |No| FAIL
    C5 --> |Yes| C6
    C5 --> |No| FAIL
    C6 --> |Yes| C7
    C6 --> |No| FAIL
    C7 --> |Yes| PASS
    C7 --> |No| FAIL
```

## Installation Status

The `getInstallationStatus()` method checks current state:

```mermaid
graph LR
    subgraph "Status Checks"
        S1[installed: Boolean]
        S2[behavioral: Boolean]
        S3[testing: Boolean]
        S4[hooks: Boolean]
        S5[agents: Array]
        S6[issues: Array]
    end

    subgraph "Files Checked"
        F1[.claude/ exists]
        F2[CLAUDE.md exists]
        F3[.claude-collective/tests/ exists]
        F4[.claude/hooks/ exists]
        F5[.claude/agents/*.md count]
    end

    F1 --> S1
    F2 --> S2
    F3 --> S3
    F4 --> S4
    F5 --> S5
```

## Repair Process

```mermaid
sequenceDiagram
    participant User
    participant CLI
    participant Installer
    participant Validator

    User->>CLI: npx drupal-claude-collective repair
    CLI->>Validator: validateInstallation()
    Validator-->>CLI: Issues found

    loop For each issue
        CLI->>Installer: Fix issue
        Installer->>Installer: Re-install missing file
    end

    CLI->>Validator: Re-validate
    Validator-->>CLI: Validation passed
    CLI-->>User: Repair complete
```

## Clean Uninstall

```mermaid
flowchart TD
    START[npx drupal-claude-collective clean]

    PROMPT{Confirm removal?}

    REMOVE1[Remove .claude/]
    REMOVE2[Remove .claude-collective/]
    REMOVE3[Remove CLAUDE.md]
    REMOVE4[Remove .mcp.json]

    KEEP[Keep .taskmaster/]

    DONE[Uninstall complete]

    START --> PROMPT
    PROMPT --> |Yes| REMOVE1
    PROMPT --> |No| DONE

    REMOVE1 --> REMOVE2
    REMOVE2 --> REMOVE3
    REMOVE3 --> REMOVE4
    REMOVE4 --> KEEP
    KEEP --> DONE
```

## Data Flow Summary

```mermaid
flowchart LR
    subgraph "Source"
        NPM[NPM Package<br/>templates/]
    end

    subgraph "Transform"
        INSTALL[CollectiveInstaller<br/>Template Processing]
    end

    subgraph "Destination"
        PROJECT[Project Directory<br/>.claude/, .mcp.json, etc.]
    end

    subgraph "Runtime"
        CLAUDE[Claude Code<br/>Uses installed files]
    end

    NPM --> INSTALL
    INSTALL --> PROJECT
    PROJECT --> CLAUDE
```

## See Also

- [OVERVIEW.md](./OVERVIEW.md) - System architecture overview
- [AGENTS.md](./AGENTS.md) - Agent installation details
- [HOOKS.md](./HOOKS.md) - Hook installation and configuration
