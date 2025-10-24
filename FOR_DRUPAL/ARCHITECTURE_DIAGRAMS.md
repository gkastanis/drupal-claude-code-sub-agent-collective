# Drupal Sub-Agent Collective - Architecture Diagrams

## System Architecture

```mermaid
graph TB
    User[User Request] --> Orchestrator{Main Claude<br/>Orchestrator<br/>reads CLAUDE.md}
    
    Orchestrator -->|Level 1<br/>Simple Edit| Direct[Direct Execution<br/>Drush/Composer]
    Direct --> Complete1[✅ COMPLETE]
    
    Orchestrator -->|Level 2<br/>Feature| Architect[Drupal Architect Agent]
    Architect --> ModDev[Module/Theme Dev Agent]
    ModDev --> Security[Security Gate]
    Security -->|PASS| FuncTest[Functional Test Agent]
    Security -->|FAIL| ModDev
    FuncTest -->|PASS| Complete2[✅ COMPLETE]
    FuncTest -->|FAIL| ModDev
    
    Orchestrator -->|Level 3<br/>Multi-component| PM[PM Agent<br/>Task Master MCP]
    PM --> Arch3[Drupal Architect]
    Arch3 --> Multi[Multiple Agents<br/>Parallel Work]
    Multi --> AllGates{All Quality<br/>Gates}
    AllGates -->|PASS| Complete3[✅ COMPLETE]
    AllGates -->|FAIL| Multi
    
    Orchestrator -->|Level 4<br/>Full Project| PM4[PM Agent<br/>Phased Approach]
    PM4 --> Phase1[Phase 1:<br/>Architecture]
    Phase1 --> Phase2[Phase 2:<br/>Core Implementation]
    Phase2 --> Phase3[Phase 3:<br/>Features]
    Phase3 --> Phase4[Phase 4:<br/>Testing & Deploy]
    Phase4 --> Complete4[✅ COMPLETE<br/>Production Ready]
    
    style User fill:#e1f5fe
    style Orchestrator fill:#fff3e0
    style Complete1 fill:#e0f2f1
    style Complete2 fill:#e0f2f1
    style Complete3 fill:#e0f2f1
    style Complete4 fill:#e0f2f1
    style Security fill:#fce4ec
    style AllGates fill:#fce4ec
```

## Agent Ecosystem

```mermaid
graph LR
    subgraph "Core Work Agents"
        A1[Drupal<br/>Architect]
        A2[Module<br/>Dev]
        A3[Theme<br/>Dev]
        A4[Config<br/>Management]
        A5[Content &<br/>Migration]
        A6[Security &<br/>Compliance]
        A7[Performance &<br/>DevOps]
    end
    
    subgraph "Quality Gates"
        G1[Drupal<br/>Standards]
        G2[Security<br/>Gate]
        G3[Performance<br/>Gate]
        G4[Accessibility<br/>Gate]
        G5[Integration<br/>Gate]
    end
    
    subgraph "Testing Agents"
        T1[Functional<br/>Testing]
        T2[Unit<br/>Testing]
        T3[Visual<br/>Regression]
    end
    
    A1 -.-> A2
    A1 -.-> A3
    A2 --> G1
    A2 --> G2
    A3 --> G1
    A3 --> G4
    A4 --> G5
    A5 --> G5
    A6 -.-> G2
    A7 --> G3
    
    G1 --> T1
    G2 --> T1
    T1 --> T2
    T2 --> T3
    
    style A1 fill:#e8f5e8
    style A2 fill:#e8f5e8
    style A3 fill:#e8f5e8
    style A4 fill:#e8f5e8
    style A5 fill:#e8f5e8
    style A6 fill:#e8f5e8
    style A7 fill:#e8f5e8
    style G1 fill:#fce4ec
    style G2 fill:#fce4ec
    style G3 fill:#fce4ec
    style G4 fill:#fce4ec
    style G5 fill:#fce4ec
    style T1 fill:#fff9c4
    style T2 fill:#fff9c4
    style T3 fill:#fff9c4
```

## Level 2 Workflow (Feature Development)

```mermaid
sequenceDiagram
    participant User
    participant Orchestrator
    participant Architect
    participant ModuleDev
    participant Security
    participant FuncTest
    
    User->>Orchestrator: "Create custom block<br/>with recent articles"
    Orchestrator->>Orchestrator: Assess complexity<br/>(Level 2)
    Orchestrator->>Architect: Design approach
    Architect->>Architect: Plan content model<br/>Choose block plugin<br/>Design caching
    Architect->>ModuleDev: Architecture doc
    ModuleDev->>ModuleDev: Create module<br/>Implement plugin<br/>Follow standards
    ModuleDev->>Security: Request review
    Security->>Security: Run phpcs<br/>Check security<br/>Validate DI
    alt Security PASS
        Security->>FuncTest: Approved
        FuncTest->>FuncTest: Playwright tests<br/>Browser validation
        alt Tests PASS
            FuncTest->>User: ✅ Module ready
        else Tests FAIL
            FuncTest->>ModuleDev: Fix issues
        end
    else Security FAIL
        Security->>ModuleDev: Fix issues
    end
```

## Level 3 Workflow (Multi-Component System)

```mermaid
sequenceDiagram
    participant User
    participant Orchestrator
    participant PM
    participant TaskMaster
    participant Agents
    participant Gates
    participant Integration
    
    User->>Orchestrator: "Build event management<br/>system with registration"
    Orchestrator->>PM: Coordinate project
    PM->>TaskMaster: Create task breakdown
    TaskMaster->>PM: Tasks structured
    
    PM->>Agents: TASK-1: Architecture
    PM->>Agents: TASK-2: Content types
    PM->>Agents: TASK-3: Custom module
    PM->>Agents: TASK-4: Email system
    PM->>Agents: TASK-5: Admin views
    
    Agents->>Gates: Submit for validation
    
    alt All Gates PASS
        Gates->>Integration: Proceed to integration
        Integration->>Integration: Test full system<br/>Check compatibility
        alt Integration PASS
            Integration->>User: ✅ System ready
        else Integration FAIL
            Integration->>PM: Coordinate fixes
        end
    else Any Gate FAIL
        Gates->>PM: Report issues
        PM->>Agents: Coordinate fixes
    end
```

## Tool Integration Flow

```mermaid
graph TD
    subgraph "Claude Code Environment"
        Main[Main Claude<br/>Orchestrator]
        CLAUDE[CLAUDE.md<br/>Instructions]
        Main -.reads.-> CLAUDE
    end
    
    subgraph "MCP Servers"
        TM[Task Master<br/>MCP]
        PW[Playwright<br/>MCP]
    end
    
    subgraph "Drupal Tools"
        Drush[Drush CLI]
        Composer[Composer]
        PHPCS[PHP_CodeSniffer]
        PHPStan[PHPStan]
    end
    
    subgraph "Drupal Site"
        Core[Drupal Core]
        Custom[Custom Modules]
        Config[Config Export]
        DB[(Database)]
    end
    
    Main --> TM
    Main --> PW
    Main --> Drush
    Main --> Composer
    Main --> PHPCS
    Main --> PHPStan
    
    Drush --> Core
    Drush --> Custom
    Drush --> Config
    Composer --> Custom
    Core --> DB
    Custom --> DB
    
    PW -.tests.-> Core
    PW -.tests.-> Custom
    
    style Main fill:#fff3e0
    style CLAUDE fill:#e8eaf6
    style TM fill:#f3e5f5
    style PW fill:#f3e5f5
    style Core fill:#e8f5e8
    style Custom fill:#e8f5e8
    style Config fill:#e8f5e8
```

## Quality Gate Process

```mermaid
flowchart TD
    Start[Code Submitted] --> Standards{Drupal<br/>Standards<br/>Gate}
    
    Standards -->|PASS| Security{Security<br/>Gate}
    Standards -->|FAIL| Fix1[Fix Standards<br/>Issues]
    Fix1 --> Standards
    
    Security -->|PASS| Performance{Performance<br/>Gate}
    Security -->|FAIL| Fix2[Fix Security<br/>Issues]
    Fix2 --> Security
    
    Performance -->|PASS| Access{Accessibility<br/>Gate}
    Performance -->|FAIL| Fix3[Optimize<br/>Performance]
    Fix3 --> Performance
    
    Access -->|PASS| Integration{Integration<br/>Gate}
    Access -->|FAIL| Fix4[Fix A11y<br/>Issues]
    Fix4 --> Access
    
    Integration -->|PASS| Complete[✅ All Gates<br/>Passed]
    Integration -->|FAIL| Fix5[Fix Integration<br/>Issues]
    Fix5 --> Integration
    
    style Standards fill:#fce4ec
    style Security fill:#fce4ec
    style Performance fill:#fce4ec
    style Access fill:#fce4ec
    style Integration fill:#fce4ec
    style Complete fill:#e0f2f1
```

## Data Flow

```mermaid
graph LR
    subgraph "Input"
        Request[User Request]
        PRD[PRD Document]
        Files[Existing Files]
    end
    
    subgraph "Processing"
        Parse[Parse Requirements]
        Route[Route to Agents]
        Execute[Execute Tasks]
        Validate[Quality Gates]
    end
    
    subgraph "Output"
        Modules[Custom Modules]
        Themes[Custom Themes]
        Configs[Configurations]
        Tests[Test Suites]
        Docs[Documentation]
    end
    
    Request --> Parse
    PRD --> Parse
    Files --> Parse
    
    Parse --> Route
    Route --> Execute
    Execute --> Validate
    
    Validate -->|PASS| Modules
    Validate -->|PASS| Themes
    Validate -->|PASS| Configs
    Validate -->|PASS| Tests
    Validate -->|PASS| Docs
    
    Validate -->|FAIL| Execute
    
    style Request fill:#e1f5fe
    style Modules fill:#e0f2f1
    style Themes fill:#e0f2f1
    style Configs fill:#e0f2f1
    style Tests fill:#e0f2f1
    style Docs fill:#e0f2f1
```

## Agent Communication Pattern

```mermaid
graph TD
    Main[Main Orchestrator]
    
    subgraph "Communication Layer"
        TM[Task Master<br/>State Management]
    end
    
    subgraph "Agent Pool"
        A1[Agent 1]
        A2[Agent 2]
        A3[Agent 3]
        A4[Agent N]
    end
    
    Main -->|Assign Task| TM
    TM -->|Route| A1
    TM -->|Route| A2
    TM -->|Route| A3
    TM -->|Route| A4
    
    A1 -->|Update Status| TM
    A2 -->|Update Status| TM
    A3 -->|Update Status| TM
    A4 -->|Update Status| TM
    
    TM -->|Report Progress| Main
    
    A1 -.Dependencies.-> A2
    A2 -.Dependencies.-> A3
    
    style Main fill:#fff3e0
    style TM fill:#f3e5f5
```

## Comparison: TDD vs Drupal Version

```mermaid
graph LR
    subgraph "TDD Version"
        TDD1[Write Test]
        TDD2[Implement]
        TDD3[Refactor]
        TDD1 --> TDD2
        TDD2 --> TDD3
        TDD3 --> TDD1
    end
    
    subgraph "Drupal Version"
        D1[Architecture]
        D2[Implementation]
        D3[Standards Check]
        D4[Security Review]
        D5[Testing]
        D1 --> D2
        D2 --> D3
        D3 --> D4
        D4 --> D5
    end
    
    style TDD1 fill:#ffebee
    style TDD2 fill:#ffebee
    style TDD3 fill:#ffebee
    style D1 fill:#e8f5e8
    style D2 fill:#e8f5e8
    style D3 fill:#e8f5e8
    style D4 fill:#e8f5e8
    style D5 fill:#e8f5e8
```

## Deployment Pipeline

```mermaid
graph LR
    Dev[Development<br/>Environment]
    Test[Testing<br/>Environment]
    Stage[Staging<br/>Environment]
    Prod[Production<br/>Environment]
    
    Dev -->|drush cex| ConfigExport[Config Export]
    ConfigExport -->|Git Commit| VCS[Version Control]
    VCS -->|Deploy| Test
    
    Test -->|drush cim| TestImport[Config Import]
    TestImport -->|Validate| TestValidate{Tests Pass?}
    
    TestValidate -->|Yes| Stage
    TestValidate -->|No| Dev
    
    Stage -->|drush cim| StageImport[Config Import]
    StageImport -->|Validate| StageValidate{QA Pass?}
    
    StageValidate -->|Yes| Prod
    StageValidate -->|No| Dev
    
    Prod -->|drush cim| ProdImport[Config Import]
    ProdImport --> Live[✅ Live Site]
    
    style Dev fill:#e3f2fd
    style Test fill:#fff9c4
    style Stage fill:#fff3e0
    style Prod fill:#e8f5e8
    style Live fill:#e0f2f1
```

---

## How to Use These Diagrams

1. **System Architecture**: Understand overall flow based on complexity levels
2. **Agent Ecosystem**: See how agents and gates interconnect
3. **Level 2 Workflow**: Understand simple feature development
4. **Level 3 Workflow**: Understand complex multi-component projects
5. **Tool Integration**: See how Claude Code connects to Drupal tools
6. **Quality Gates**: Understand the validation process
7. **Data Flow**: See input to output transformation
8. **Agent Communication**: Understand how agents coordinate via Task Master

These diagrams can be rendered in any Mermaid-compatible tool or directly in GitHub/GitLab README files.
