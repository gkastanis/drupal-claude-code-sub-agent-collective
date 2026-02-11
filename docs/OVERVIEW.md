# Drupal Claude Code Sub-Agent Collective - Architecture Overview

This document provides a high-level overview of the Drupal Claude Code Sub-Agent Collective architecture, its components, and how they interconnect.

## System Purpose

The Drupal Claude Code Sub-Agent Collective is an NPX-installable framework that transforms Claude Code into a coordinated multi-agent development system specialized for Drupal 10/11 projects. It enforces:

- **Hub-and-Spoke Coordination**: Central routing through the Van command
- **Test-Driven Development**: Validated handoffs between agents
- **Drupal Best Practices**: Coding standards, security, and performance validation
- **Research Integration**: Context7 and TaskMaster for informed development

## High-Level Architecture

```mermaid
graph TB
    subgraph "User Interface"
        USER[User Request]
        VAN["/van Command"]
    end

    subgraph "Behavioral Operating System"
        CLAUDE_MD[CLAUDE.md<br/>Behavioral Rules]
        DECISION[DECISION.md<br/>Auto-Delegation]
    end

    subgraph "Core Components"
        INSTALLER[CollectiveInstaller<br/>NPX Installation]
        REGISTRY[AgentRegistry<br/>Agent Lifecycle]
        METRICS[MetricsCollector<br/>Research Validation]
    end

    subgraph "Agent Collective"
        ROUTING[routing-agent<br/>Hub Controller]
        IMPL[Implementation<br/>Agents]
        QUALITY[Quality Gate<br/>Agents]
        RESEARCH[research-agent<br/>Context7]
    end

    subgraph "Enforcement Layer"
        HOOKS[Hook System<br/>8 Shell Scripts]
        COMMANDS[Command System<br/>Slash Commands]
    end

    subgraph "External Integrations"
        TASKMASTER[TaskMaster<br/>MCP Server]
        CONTEXT7[Context7<br/>Documentation]
        PLAYWRIGHT[Playwright<br/>Testing]
    end

    USER --> VAN
    VAN --> CLAUDE_MD
    CLAUDE_MD --> DECISION
    DECISION --> ROUTING

    INSTALLER --> REGISTRY
    INSTALLER --> HOOKS
    INSTALLER --> COMMANDS

    ROUTING --> IMPL
    ROUTING --> QUALITY
    ROUTING --> RESEARCH

    HOOKS --> METRICS

    RESEARCH --> CONTEXT7
    ROUTING --> TASKMASTER
    QUALITY --> PLAYWRIGHT
```

## Core Architectural Principles

### 1. Hub-and-Spoke Pattern

All agent communication flows through the central hub (Van routing command). Agents do not communicate peer-to-peer.

```mermaid
flowchart LR
    subgraph "Hub"
        VAN[Van Router]
    end

    subgraph "Spokes"
        A1[drupal-architect]
        A2[module-development-agent]
        A3[theme-development-agent]
        A4[security-compliance-agent]
        A5[research-agent]
    end

    VAN <--> A1
    VAN <--> A2
    VAN <--> A3
    VAN <--> A4
    VAN <--> A5
```

### 2. Layered Architecture

```mermaid
graph TB
    subgraph "Layer 4: User Interface"
        L4[Slash Commands & Van Router]
    end

    subgraph "Layer 3: Behavioral Control"
        L3[CLAUDE.md Directives & DECISION.md Logic]
    end

    subgraph "Layer 2: Agent Orchestration"
        L2[Agent Registry & Lifecycle Management]
    end

    subgraph "Layer 1: Core Infrastructure"
        L1[Installer, Hooks, Metrics Collection]
    end

    subgraph "Layer 0: External Services"
        L0[TaskMaster MCP, Context7, Playwright]
    end

    L4 --> L3
    L3 --> L2
    L2 --> L1
    L1 --> L0
```

## Directory Structure

```
drupal-claude-code-sub-agent-collective/
├── bin/                           # CLI Entry Points
│   └── claude-code-collective.js  # NPX Command Handler
│
├── lib/                           # Core Library
│   ├── index.js                   # Main Entry Point
│   ├── installer.js               # CollectiveInstaller Class
│   ├── validator.js               # Installation Validator
│   ├── AgentRegistry.js           # Agent Lifecycle Manager
│   ├── AgentSpawner.js            # Dynamic Agent Creation
│   ├── AgentTemplateSystem.js     # Agent Template Processing
│   ├── command-system.js          # Command Execution Engine
│   ├── command-parser.js          # Natural Language Parsing
│   ├── merge-strategies.js        # Config Conflict Resolution
│   ├── mcp-config-manager.js      # MCP Server Configuration
│   └── metrics/                   # Research Metrics
│       ├── MetricsCollector.js    # Base Collector
│       ├── JITLoadingMetrics.js   # H1: Context Loading
│       ├── HubSpokeMetrics.js     # H2: Coordination
│       └── TDDHandoffMetrics.js   # H3: Handoff Quality
│
├── templates/                     # Installation Templates
│   ├── CLAUDE.md                  # Behavioral OS Template (~96 lines)
│   ├── .claude/                   # Claude Configuration
│   │   ├── agents/                # Agent Definitions (15, with memory + skills)
│   │   ├── hooks/                 # Enforcement Scripts (8 + shared lib)
│   │   ├── rules/                 # Auto-loaded behavioral rules (6 files)
│   │   ├── agent-memory/          # Persistent agent knowledge (5 agents)
│   │   ├── commands/              # Slash Commands
│   │   └── skills/                # Drupal skills (10 total)
│   ├── .claude-collective/        # Collective Framework
│   │   ├── tests/                 # Test Contracts
│   │   └── metrics/               # Metrics Storage
│   └── .taskmaster/               # TaskMaster Config
│
├── scripts/                       # Testing & Utilities
└── package.json                   # NPM Package Definition
```

## Key Components

### 1. Installation System

The `CollectiveInstaller` handles project setup:

```mermaid
sequenceDiagram
    participant User
    participant NPX as npx drupal-claude-collective
    participant Installer as CollectiveInstaller
    participant FileMapper as FileMapping
    participant MCP as MCPConfigManager

    User->>NPX: init [options]
    NPX->>Installer: install()
    Installer->>Installer: checkExistingInstallation()
    Installer->>Installer: createDirectories()
    Installer->>Installer: setupTaskMaster()
    Installer->>FileMapper: getFilteredMapping()
    FileMapper-->>Installer: Template Mappings
    Installer->>Installer: installTemplates()
    Installer->>MCP: generateConfig()
    MCP-->>Installer: .mcp.json
    Installer->>Installer: setupHooks()
    Installer->>Installer: installAgents()
    Installer->>Installer: validateInstallation()
    Installer-->>User: Installation Complete
```

### 2. Agent Registry

The `AgentRegistry` manages agent lifecycle:

```mermaid
stateDiagram-v2
    [*] --> Registered: register()
    Registered --> Active: initialize
    Active --> Working: invoked
    Working --> Active: completed
    Active --> Warning: health issues
    Warning --> Active: resolved
    Active --> Inactive: timeout
    Inactive --> Active: reactivated
    Active --> Unregistered: unregister()
    Unregistered --> [*]
```

### 3. Metrics Collection

Research validation through three hypothesis collectors:

```mermaid
graph LR
    subgraph "H1: JIT Context Loading"
        JIT[JITLoadingMetrics]
        JIT --> |context_size| M1[Context Reduction]
        JIT --> |load_time| M2[Load Efficiency]
    end

    subgraph "H2: Hub-Spoke Coordination"
        HUB[HubSpokeMetrics]
        HUB --> |routing_compliance| M3[Routing Accuracy]
        HUB --> |peer_violations| M4[No P2P Comms]
    end

    subgraph "H3: TDD Handoffs"
        TDD[TDDHandoffMetrics]
        TDD --> |success_rate| M5[Handoff Success]
        TDD --> |contract_coverage| M6[Validation Coverage]
    end

    M1 --> AGGREGATE[Aggregated Report]
    M2 --> AGGREGATE
    M3 --> AGGREGATE
    M4 --> AGGREGATE
    M5 --> AGGREGATE
    M6 --> AGGREGATE
```

## Request Flow

A typical development request flows through the system:

```mermaid
sequenceDiagram
    participant User
    participant Van as /van Command
    participant Claude as CLAUDE.md
    participant Decision as DECISION.md
    participant Agent as Selected Agent
    participant Hook as Hooks System
    participant Gate as Quality Gate

    User->>Van: "Create custom Drupal module"
    Van->>Claude: Load behavioral rules
    Claude->>Decision: Route request
    Decision->>Agent: Deploy drupal-architect
    Agent->>Agent: Design architecture
    Agent->>Hook: Signal completion
    Hook->>Hook: TDD Validation
    Hook->>Decision: Handoff to next agent
    Decision->>Agent: Deploy module-development-agent
    Agent->>Agent: Implement module
    Agent->>Hook: Signal completion
    Hook->>Gate: Quality validation
    Gate->>Gate: Security, Standards, Performance
    Gate-->>User: Delivery Complete
```

## Data Flow

### Configuration Data

```mermaid
flowchart TD
    subgraph "Source: Templates"
        T1[templates/CLAUDE.md]
        T2[templates/.claude/agents/]
        T3[templates/.claude/hooks/]
        T4[templates/.taskmaster/]
    end

    subgraph "Transform: Installer"
        INSTALL[CollectiveInstaller]
        MERGE[MergeStrategies]
        CONFIG[MCPConfigManager]
    end

    subgraph "Destination: Project"
        D1[CLAUDE.md]
        D2[.claude/agents/]
        D3[.claude/hooks/]
        D4[.taskmaster/]
        D5[.mcp.json]
    end

    T1 --> INSTALL
    T2 --> INSTALL
    T3 --> INSTALL
    T4 --> INSTALL

    INSTALL --> MERGE
    MERGE --> D1
    MERGE --> D2
    MERGE --> D3
    MERGE --> D4

    INSTALL --> CONFIG
    CONFIG --> D5
```

### Runtime Data

```mermaid
flowchart LR
    subgraph "Input"
        USER[User Request]
        CONTEXT[Project Context]
    end

    subgraph "Processing"
        PARSE[Command Parser]
        ROUTE[Van Router]
        AGENT[Agent Execution]
    end

    subgraph "Output"
        CODE[Generated Code]
        METRICS[Metrics Data]
        HISTORY[Command History]
    end

    USER --> PARSE
    CONTEXT --> ROUTE
    PARSE --> ROUTE
    ROUTE --> AGENT
    AGENT --> CODE
    AGENT --> METRICS
    PARSE --> HISTORY
```

## Integration Points

### External Services

| Service | Purpose | Connection |
|---------|---------|------------|
| **TaskMaster** | Task coordination | MCP Server via .mcp.json |
| **Context7** | Drupal documentation | MCP Server via .mcp.json |
| **Playwright** | Browser testing | MCP Server (optional) |

### Claude Code Integration

```mermaid
graph TB
    subgraph "Claude Code"
        CC[Claude Code CLI]
        SETTINGS[.claude/settings.json]
        AGENTS[.claude/agents/]
        HOOKS[.claude/hooks/]
        COMMANDS[.claude/commands/]
        RULES[.claude/rules/]
        SKILLS[.claude/skills/]
        MEMORY[.claude/agent-memory/]
    end

    subgraph "Collective"
        COLLECTIVE[drupal-claude-collective]
    end

    COLLECTIVE --> |installs| SETTINGS
    COLLECTIVE --> |installs| AGENTS
    COLLECTIVE --> |installs| HOOKS
    COLLECTIVE --> |installs| COMMANDS
    COLLECTIVE --> |installs| RULES
    COLLECTIVE --> |installs| SKILLS
    COLLECTIVE --> |seeds| MEMORY

    CC --> |reads| SETTINGS
    CC --> |uses| AGENTS
    CC --> |triggers| HOOKS
    CC --> |executes| COMMANDS
    CC --> |auto-loads| RULES
    CC --> |JIT loads| SKILLS
```

## See Also

- [AGENTS.md](./AGENTS.md) - Detailed agent system documentation
- [HOOKS.md](./HOOKS.md) - Hook system and enforcement layer
- [INSTALLATION.md](./INSTALLATION.md) - Installation process and data flow
- [COMMAND-SYSTEM.md](./COMMAND-SYSTEM.md) - Command parsing and execution
- [METRICS.md](./METRICS.md) - Research metrics and hypothesis validation
