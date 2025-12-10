# Agent System Architecture

This document describes the agent system, including agent types, lifecycle management, and coordination patterns.

## Agent Overview

The collective includes 15 specialized agents organized into functional categories:

```mermaid
graph TB
    subgraph "Coordination (1)"
        ROUTING[routing-agent<br/>Hub Controller]
    end

    subgraph "Core Drupal (5)"
        ARCH[drupal-architect]
        MOD[module-development-agent]
        THEME[theme-development-agent]
        CONFIG[configuration-management-agent]
        MIGRATE[content-migration-agent]
    end

    subgraph "Quality & Security (2)"
        SECURITY[security-compliance-agent]
        PERF[performance-devops-agent]
    end

    subgraph "Testing (3)"
        FUNC[functional-testing-agent]
        UNIT[unit-testing-agent]
        VIS[visual-regression-agent]
    end

    subgraph "Project Management (4)"
        PM[enhanced-project-manager-agent]
        RESEARCH[research-agent]
        WORKFLOW[workflow-agent]
        SEMANTIC[semantic-architect-agent]
    end

    ROUTING --> ARCH
    ROUTING --> MOD
    ROUTING --> THEME
    ROUTING --> CONFIG
    ROUTING --> MIGRATE
    ROUTING --> SECURITY
    ROUTING --> PERF
    ROUTING --> FUNC
    ROUTING --> UNIT
    ROUTING --> VIS
    ROUTING --> PM
    ROUTING --> RESEARCH
    ROUTING --> WORKFLOW
    ROUTING --> SEMANTIC
```

## Agent Categories

### 1. Coordination Agent

| Agent | Purpose | Key Capabilities |
|-------|---------|------------------|
| **routing-agent** | Central hub for all request routing | Request analysis, agent selection, coordination |

### 2. Core Drupal Agents

| Agent | Purpose | Key Capabilities |
|-------|---------|------------------|
| **drupal-architect** | Site architecture design | Content modeling, module selection, system design |
| **module-development-agent** | Custom module creation | Drupal 10/11 APIs, dependency injection, Entity API |
| **theme-development-agent** | Theme development | Twig templates, SCSS, JavaScript behaviors |
| **configuration-management-agent** | Config export/import | Update hooks, deployment configuration |
| **content-migration-agent** | Data migration | Migration plugins, content transformation |

### 3. Quality & Security Agents

| Agent | Purpose | Key Capabilities |
|-------|---------|------------------|
| **security-compliance-agent** | Consolidated quality validation | Standards, security, performance, accessibility |
| **performance-devops-agent** | Caching & deployment | Performance optimization, CI/CD setup |

### 4. Testing Agents

| Agent | Purpose | Key Capabilities |
|-------|---------|------------------|
| **functional-testing-agent** | Browser automation | Playwright testing, user journey validation |
| **unit-testing-agent** | PHPUnit testing | Drupal test base, kernel tests |
| **visual-regression-agent** | Screenshot comparison | Visual diff testing |

### 5. Project Management Agents

| Agent | Purpose | Key Capabilities |
|-------|---------|------------------|
| **enhanced-project-manager-agent** | TaskMaster coordination | Task breakdown, dependency management |
| **research-agent** | Technical research | Context7 integration, best practices |
| **workflow-agent** | Complex orchestration | Multi-agent workflows |
| **semantic-architect-agent** | Documentation mapping | Knowledge graph, code-business logic mapping |

## Agent Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Installed: Installation
    Installed --> Registered: AgentRegistry.register()
    Registered --> Idle: Initialization
    Idle --> Selected: Van routing
    Selected --> Active: Task assignment
    Active --> Executing: Begin work
    Executing --> Validating: Work complete
    Validating --> HandingOff: TDD passed
    Validating --> Executing: TDD failed (retry)
    HandingOff --> Idle: Handoff complete

    Active --> Error: Exception
    Error --> Idle: Recovery
    Error --> Disabled: Max retries
    Disabled --> [*]
```

## Agent Registry

The `AgentRegistry` class manages all agent lifecycle:

```mermaid
classDiagram
    class AgentRegistry {
        -Map agents
        -Array activityLog
        -Object statistics
        +initialize()
        +register(agentInfo)
        +unregister(agentId)
        +query(criteria)
        +getAgent(agentId)
        +updateStatus(agentId, status)
        +updateActivity(agentId, data)
        +checkHealth(agentId)
        +getStatistics()
    }

    class AgentInfo {
        +String id
        +String name
        +String template
        +String path
        +Object metadata
        +String status
        +Array statusHistory
        +Object activity
        +Object performance
        +Object health
    }

    AgentRegistry "1" --> "*" AgentInfo : manages
```

### Registry Operations

```mermaid
sequenceDiagram
    participant System
    participant Registry as AgentRegistry
    participant Agent
    participant Storage

    Note over System,Storage: Registration Flow
    System->>Registry: register(agentInfo)
    Registry->>Registry: validateAgentInfo()
    Registry->>Agent: Create entry
    Registry->>Storage: saveRegistry()
    Registry-->>System: Registration result

    Note over System,Storage: Query Flow
    System->>Registry: query(criteria)
    Registry->>Registry: Filter agents
    Registry-->>System: Matching agents

    Note over System,Storage: Health Check Flow
    System->>Registry: checkHealth(agentId)
    Registry->>Agent: Validate file exists
    Registry->>Agent: Check performance
    Registry->>Agent: Update health status
    Registry-->>System: Health result
```

## Agent Communication

### Hub-and-Spoke Pattern

All communication flows through the central hub (routing-agent):

```mermaid
flowchart TB
    subgraph "Incoming"
        REQ[User Request]
    end

    subgraph "Hub"
        VAN[/van Command<br/>routing-agent]
    end

    subgraph "Outgoing"
        A1[Agent 1]
        A2[Agent 2]
        A3[Agent 3]
    end

    subgraph "Return"
        RES[Response]
    end

    REQ --> VAN
    VAN --> A1
    VAN --> A2
    VAN --> A3
    A1 --> VAN
    A2 --> VAN
    A3 --> VAN
    VAN --> RES

    style VAN fill:#f9f,stroke:#333,stroke-width:4px
```

### Handoff Protocol

```mermaid
sequenceDiagram
    participant Source as Source Agent
    participant Hook as Hook System
    participant Hub as routing-agent
    participant Target as Target Agent

    Source->>Source: Complete work
    Source->>Hook: Signal handoff
    Hook->>Hook: TDD Validation

    alt Validation Passed
        Hook->>Hub: Handoff approved
        Hub->>Target: Route to next agent
        Target->>Target: Continue workflow
    else Validation Failed
        Hook->>Source: Retry required
        Source->>Source: Fix issues
        Source->>Hook: Re-signal handoff
    end
```

## Agent Definition Structure

Each agent is defined in a Markdown file with YAML frontmatter:

```markdown
---
name: module-development-agent
description: Creates custom Drupal modules following best practices
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
capabilities:
  - Drupal 10/11 module development
  - Dependency injection patterns
  - Entity API usage
  - Service registration
---

# Module Development Agent

## Purpose
[Agent description and responsibilities]

## Workflow
[Step-by-step process]

## Quality Standards
[Requirements for completion]

## Handoff Template
[Format for handoff messages]
```

## Agent Selection Matrix

The routing-agent uses this matrix for agent selection:

```mermaid
graph TD
    REQ[Request Analysis]

    REQ --> |Architecture needed| ARCH[drupal-architect]
    REQ --> |Module work| MOD[module-development-agent]
    REQ --> |Theme work| THEME[theme-development-agent]
    REQ --> |Config changes| CONFIG[configuration-management-agent]
    REQ --> |Migration| MIGRATE[content-migration-agent]
    REQ --> |Security review| SEC[security-compliance-agent]
    REQ --> |Performance| PERF[performance-devops-agent]
    REQ --> |Testing| TEST{Test Type}
    REQ --> |Research| RESEARCH[research-agent]
    REQ --> |Complex project| PM[enhanced-project-manager-agent]

    TEST --> |Functional| FUNC[functional-testing-agent]
    TEST --> |Unit| UNIT[unit-testing-agent]
    TEST --> |Visual| VIS[visual-regression-agent]
```

## Complexity-Based Routing

| Level | Description | Agents Used | Example |
|-------|-------------|-------------|---------|
| **1** | Simple config/edits | 0 (direct execution) | Add field, enable module |
| **2** | Single feature | 2-4 | Custom block, form |
| **3** | Multi-component | 5-9 | FAQ system, member directory |
| **4** | Full project | 8-12+ | Complete site build |

```mermaid
graph LR
    subgraph "Level 1"
        L1[Direct Drush/File Operations]
    end

    subgraph "Level 2"
        L2A[drupal-architect]
        L2B[module-development-agent]
        L2C[security-compliance-agent]
    end

    subgraph "Level 3"
        L3A[enhanced-project-manager-agent]
        L3B[Multiple Implementation Agents]
        L3C[Quality Gates]
        L3D[Testing Agents]
    end

    subgraph "Level 4"
        L4A[Full Phased Deployment]
        L4B[All Agent Categories]
        L4C[Comprehensive Validation]
    end
```

## Agent Performance Tracking

```mermaid
graph TB
    subgraph "Metrics Collected"
        M1[Invocation Count]
        M2[Processing Time]
        M3[Success Rate]
        M4[Error Count]
    end

    subgraph "Health Indicators"
        H1[File Integrity]
        H2[Response Time]
        H3[Reliability Score]
        H4[Resource Usage]
    end

    subgraph "Analysis"
        A[Performance Report]
    end

    M1 --> A
    M2 --> A
    M3 --> A
    M4 --> A
    H1 --> A
    H2 --> A
    H3 --> A
    H4 --> A
```

## Dynamic Agent Creation

The system supports creating new agents at runtime:

```mermaid
sequenceDiagram
    participant User
    participant Spawner as AgentSpawner
    participant Templates as TemplateSystem
    participant Registry as AgentRegistry

    User->>Spawner: Create new agent
    Spawner->>Templates: Load base template
    Templates->>Spawner: Template content
    Spawner->>Spawner: Process variables
    Spawner->>Spawner: Write agent file
    Spawner->>Registry: register(newAgent)
    Registry-->>User: Agent ready
```

## See Also

- [OVERVIEW.md](./OVERVIEW.md) - System architecture overview
- [HOOKS.md](./HOOKS.md) - Hook system and TDD validation
- [INSTALLATION.md](./INSTALLATION.md) - Agent installation process
