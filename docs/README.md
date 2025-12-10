# Drupal Claude Code Sub-Agent Collective Documentation

This folder contains high-level architecture documentation for the Drupal Claude Code Sub-Agent Collective.

## Documentation Index

| Document | Description |
|----------|-------------|
| [OVERVIEW.md](./OVERVIEW.md) | High-level system architecture, component overview, and data flow |
| [AGENTS.md](./AGENTS.md) | Agent system, lifecycle management, and coordination patterns |
| [HOOKS.md](./HOOKS.md) | Hook system, TDD validation, and enforcement layer |
| [INSTALLATION.md](./INSTALLATION.md) | Installation process, file mapping, and configuration |
| [COMMAND-SYSTEM.md](./COMMAND-SYSTEM.md) | Command parsing, slash commands, and /van routing |
| [METRICS.md](./METRICS.md) | Research metrics collection and hypothesis validation |

## Architecture at a Glance

```mermaid
graph TB
    subgraph "User Layer"
        USER[User Request]
        VAN[/van Command]
    end

    subgraph "Behavioral Layer"
        CLAUDE[CLAUDE.md]
        DECISION[DECISION.md]
    end

    subgraph "Agent Layer"
        ROUTING[routing-agent]
        DRUPAL[Drupal Agents]
        QUALITY[Quality Agents]
    end

    subgraph "Enforcement Layer"
        HOOKS[Hook System]
        METRICS[Metrics Collection]
    end

    subgraph "External Layer"
        TM[TaskMaster MCP]
        C7[Context7 MCP]
    end

    USER --> VAN
    VAN --> CLAUDE
    CLAUDE --> DECISION
    DECISION --> ROUTING
    ROUTING --> DRUPAL
    ROUTING --> QUALITY
    DRUPAL --> HOOKS
    QUALITY --> HOOKS
    HOOKS --> METRICS
    ROUTING --> TM
    ROUTING --> C7
```

## Quick Links

### For Users
- **Getting Started**: See [INSTALLATION.md](./INSTALLATION.md) for installation instructions
- **Using Commands**: See [COMMAND-SYSTEM.md](./COMMAND-SYSTEM.md) for available commands
- **Understanding Agents**: See [AGENTS.md](./AGENTS.md) for agent capabilities

### For Developers
- **System Architecture**: See [OVERVIEW.md](./OVERVIEW.md) for component diagrams
- **Hook Development**: See [HOOKS.md](./HOOKS.md) for hook system details
- **Metrics & Research**: See [METRICS.md](./METRICS.md) for hypothesis validation

## Key Concepts

### Hub-and-Spoke Pattern
All agent communication flows through the central hub (Van routing command). Agents do not communicate peer-to-peer.

### TDD Handoffs
Every agent handoff is validated through test-driven contracts before routing to the next agent.

### JIT Context Loading
Behavioral rules are loaded on-demand rather than pre-loaded, reducing context overhead.

### Drupal Specialization
All agents are specialized for Drupal 10/11 development with built-in coding standards, security validation, and best practices.

## Diagram Legend

The documentation uses Mermaid diagrams throughout:

| Diagram Type | Used For |
|--------------|----------|
| `graph TB/LR` | Component relationships, data flow |
| `flowchart` | Decision trees, processes |
| `sequenceDiagram` | Temporal flows, API calls |
| `classDiagram` | Object structures, relationships |
| `stateDiagram` | State machines, lifecycle |

## Version

Documentation version: 1.5.2
Last updated: 2024

## Contributing

When updating documentation:
1. Keep Mermaid diagrams simple and focused
2. Use consistent naming across documents
3. Cross-reference related sections with links
4. Include both conceptual and technical details
