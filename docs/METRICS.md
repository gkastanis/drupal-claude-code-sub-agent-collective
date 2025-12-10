# Research Metrics Architecture

This document describes the metrics collection system used to validate research hypotheses about agent coordination patterns.

## Research Hypotheses

The collective is designed to validate three core hypotheses:

```mermaid
graph TB
    subgraph "H1: JIT Context Loading"
        JIT[Just-In-Time Loading]
        JIT --> JIT_GOAL[30% context reduction]
    end

    subgraph "H2: Hub-Spoke Coordination"
        HUB[Centralized Routing]
        HUB --> HUB_GOAL[95% routing accuracy]
    end

    subgraph "H3: TDD Handoffs"
        TDD[Test-Driven Handoffs]
        TDD --> TDD_GOAL[98% handoff success]
    end
```

## Metrics System Components

```mermaid
classDiagram
    class MetricsCollector {
        -String sessionId
        -Array dataBuffer
        -Object config
        +initialize()
        +store(eventType, data)
        +retrieve(filters)
        +aggregate(timeRange)
        +export(format)
    }

    class JITLoadingMetrics {
        +recordContextLoad(size, time)
        +measureRetention()
        +calculateEfficiency()
    }

    class HubSpokeMetrics {
        +recordRouting(source, target)
        +detectViolation()
        +calculateCompliance()
    }

    class TDDHandoffMetrics {
        +recordHandoff(success, agent)
        +measureValidation()
        +calculateSuccessRate()
    }

    MetricsCollector <|-- JITLoadingMetrics
    MetricsCollector <|-- HubSpokeMetrics
    MetricsCollector <|-- TDDHandoffMetrics
```

## H1: JIT Context Loading

### Theory

On-demand context loading is more efficient than pre-loading all behavioral rules.

### Metrics Collected

```mermaid
graph LR
    subgraph "Measurements"
        M1[Context Size<br/>tokens]
        M2[Load Time<br/>milliseconds]
        M3[Memory Usage<br/>MB]
        M4[Retention Rate<br/>percentage]
        M5[Relevance Score<br/>0-1]
    end

    subgraph "Targets"
        T1[30% size reduction]
        T2[50% load time reduction]
        T3[40% memory reduction]
    end

    M1 --> T1
    M2 --> T2
    M3 --> T3
```

### Data Collection Flow

```mermaid
sequenceDiagram
    participant Agent
    participant System as CLAUDE.md System
    participant Collector as JITLoadingMetrics

    Agent->>System: Request context
    System->>System: Load on-demand
    System->>Collector: Record load event
    Collector->>Collector: Measure size/time

    Note over Collector: Store metrics
    Collector->>Collector: Calculate efficiency
```

## H2: Hub-Spoke Coordination

### Theory

Centralized routing through a hub outperforms distributed peer-to-peer agent communication.

### Metrics Collected

```mermaid
graph LR
    subgraph "Measurements"
        M1[Routing Compliance<br/>percentage]
        M2[P2P Violations<br/>count]
        M3[Coordination Overhead<br/>time]
        M4[Routing Errors<br/>count]
        M5[Agent Selection Accuracy<br/>percentage]
    end

    subgraph "Targets"
        T1[95% compliance]
        T2[0 violations]
        T3[<10% overhead]
    end

    M1 --> T1
    M2 --> T2
    M3 --> T3
```

### Violation Detection

```mermaid
flowchart TD
    COMM[Agent Communication]

    CHECK{Via Hub?}

    VALID[Valid Routing]
    VIOLATION[P2P Violation]

    RECORD[Record Metric]
    ALERT[Alert & Log]

    COMM --> CHECK
    CHECK --> |Yes| VALID
    CHECK --> |No| VIOLATION

    VALID --> RECORD
    VIOLATION --> ALERT
    ALERT --> RECORD
```

## H3: TDD Handoffs

### Theory

Test-driven, contract-based handoffs improve quality and reduce integration failures.

### Metrics Collected

```mermaid
graph LR
    subgraph "Measurements"
        M1[Handoff Success Rate<br/>percentage]
        M2[Validation Time<br/>milliseconds]
        M3[Retry Rate<br/>percentage]
        M4[Contract Coverage<br/>percentage]
        M5[Error Detection Rate<br/>percentage]
    end

    subgraph "Targets"
        T1[98% success rate]
        T2[50% defect reduction]
        T3[90% test coverage]
    end

    M1 --> T1
    M2 --> T2
    M3 --> T3
```

### Handoff Validation Flow

```mermaid
sequenceDiagram
    participant Source as Source Agent
    participant Hook as Handoff Hook
    participant Collector as TDDHandoffMetrics
    participant Target as Target Agent

    Source->>Hook: Signal completion
    Hook->>Hook: Run TDD validation

    alt Validation Passed
        Hook->>Collector: Record success
        Hook->>Target: Route handoff
    else Validation Failed
        Hook->>Collector: Record failure
        Hook->>Source: Request retry
    end

    Collector->>Collector: Update statistics
```

## Metrics Storage

```mermaid
graph TB
    subgraph "Data Flow"
        COLLECT[Collect Event]
        BUFFER[Buffer Events]
        FLUSH[Flush to Disk]
    end

    subgraph "Storage Locations"
        SNAP[snapshots/<br/>Raw events]
        AGG[aggregations/<br/>Computed stats]
        REPORT[reports/<br/>Analysis]
        SESSION[sessions/<br/>Session summaries]
    end

    COLLECT --> BUFFER
    BUFFER --> FLUSH
    FLUSH --> SNAP
    SNAP --> AGG
    AGG --> REPORT
    FLUSH --> SESSION
```

### Directory Structure

```
.claude-collective/metrics/
├── snapshots/               # Raw metric events
│   └── snapshot-{timestamp}.json
├── aggregations/            # Computed aggregations
│   └── aggregation-{timestamp}.json
├── reports/                 # Analysis reports
│   └── report-{date}.md
├── sessions/                # Session summaries
│   └── {sessionId}.json
├── baseline.json            # Pre-collective baseline
└── config.json              # Metrics configuration
```

## Baseline Comparison

```mermaid
graph LR
    subgraph "Baseline (Pre-Collective)"
        B1[Context: 10000 tokens]
        B2[Routing: N/A]
        B3[Handoffs: 0%]
    end

    subgraph "Current Metrics"
        C1[Context: ? tokens]
        C2[Routing: ?%]
        C3[Handoffs: ?%]
    end

    subgraph "Improvement"
        I1[H1: Delta]
        I2[H2: Delta]
        I3[H3: Delta]
    end

    B1 --> I1
    C1 --> I1
    B2 --> I2
    C2 --> I2
    B3 --> I3
    C3 --> I3
```

## Statistical Analysis

```mermaid
graph TB
    subgraph "Sample Collection"
        COLLECT[Collect N samples]
    end

    subgraph "Analysis"
        SIZE[Check sample size]
        MEAN[Calculate mean]
        VAR[Calculate variance]
        CONF[Calculate confidence]
    end

    subgraph "Validation"
        THRESHOLD[Compare to threshold]
        RESULT[Hypothesis result]
    end

    COLLECT --> SIZE
    SIZE --> MEAN
    MEAN --> VAR
    VAR --> CONF
    CONF --> THRESHOLD
    THRESHOLD --> RESULT
```

### Confidence Levels

| Sample Size | Confidence Level |
|-------------|------------------|
| < 30 | 0.50 (Insufficient) |
| 30-99 | 0.70 (Moderate) |
| 100-499 | 0.85 (Good) |
| 500-999 | 0.90 (Very Good) |
| 1000+ | 0.95 (Excellent) |

## Aggregation

```mermaid
flowchart TD
    RAW[Raw Metrics]

    subgraph "Time Aggregation"
        HOUR[Hourly]
        DAY[Daily]
        WEEK[Weekly]
    end

    subgraph "Type Aggregation"
        H1[JIT Metrics]
        H2[Hub-Spoke Metrics]
        H3[TDD Metrics]
    end

    COMBINED[Combined Report]

    RAW --> HOUR
    RAW --> DAY
    RAW --> WEEK

    HOUR --> H1
    HOUR --> H2
    HOUR --> H3

    DAY --> H1
    DAY --> H2
    DAY --> H3

    WEEK --> H1
    WEEK --> H2
    WEEK --> H3

    H1 --> COMBINED
    H2 --> COMBINED
    H3 --> COMBINED
```

## Export Formats

```mermaid
graph LR
    DATA[Metrics Data]

    JSON[JSON<br/>Full data]
    CSV[CSV<br/>Tabular]
    MD[Markdown<br/>Report]

    DATA --> JSON
    DATA --> CSV
    DATA --> MD
```

### JSON Export Structure

```json
{
  "timestamp": "ISO-8601",
  "sessionId": "string",
  "hypotheses": {
    "h1_jitLoading": {
      "validated": false,
      "confidence": 0.85,
      "metrics": {...}
    },
    "h2_hubSpoke": {
      "validated": true,
      "confidence": 0.92,
      "metrics": {...}
    },
    "h3_tddHandoffs": {
      "validated": true,
      "confidence": 0.88,
      "metrics": {...}
    }
  }
}
```

## Lifecycle Management

```mermaid
sequenceDiagram
    participant System
    participant Collector as MetricsCollector
    participant Storage

    Note over Collector: Initialization
    System->>Collector: initialize()
    Collector->>Storage: Create directories
    Collector->>Storage: Load baseline
    Collector->>Collector: Start timers

    Note over Collector: Collection
    loop During session
        System->>Collector: store(event, data)
        Collector->>Collector: Buffer event

        alt Buffer full
            Collector->>Storage: Flush buffer
        end
    end

    Note over Collector: Shutdown
    System->>Collector: shutdown()
    Collector->>Storage: Flush remaining
    Collector->>Storage: Save session summary
    Collector->>Collector: Stop timers
```

## Data Cleanup

```mermaid
flowchart TD
    TIMER[Cleanup Timer]

    CHECK[Check file age]
    CUTOFF{Older than retention?}

    DELETE[Delete file]
    KEEP[Keep file]

    EMIT[Emit cleanup event]

    TIMER --> CHECK
    CHECK --> CUTOFF
    CUTOFF --> |Yes| DELETE
    CUTOFF --> |No| KEEP
    DELETE --> EMIT
```

### Retention Policy

| Data Type | Default Retention |
|-----------|-------------------|
| Snapshots | 30 days |
| Aggregations | 90 days |
| Reports | 365 days |
| Sessions | 30 days |

## Real-Time Monitoring

```mermaid
graph LR
    EVENT[Metric Event]

    subgraph "Real-Time"
        EMIT[Emit 'metric_collected']
        LISTENER[Event Listeners]
    end

    subgraph "Actions"
        LOG[Log to console]
        ALERT[Trigger alert]
        UPDATE[Update dashboard]
    end

    EVENT --> EMIT
    EMIT --> LISTENER
    LISTENER --> LOG
    LISTENER --> ALERT
    LISTENER --> UPDATE
```

## Configuration

```json
{
  "hypotheses": {
    "h1_jitLoading": {
      "name": "JIT Context Loading",
      "targetReduction": 0.3,
      "confidenceThreshold": 0.95
    },
    "h2_hubSpoke": {
      "name": "Hub-and-Spoke Coordination",
      "targetCompliance": 0.9,
      "confidenceThreshold": 0.95
    },
    "h3_tddHandoffs": {
      "name": "Test-Driven Development Handoffs",
      "targetSuccessRate": 0.8,
      "confidenceThreshold": 0.95
    }
  },
  "collection": {
    "bufferSize": 100,
    "flushInterval": 30000,
    "enableValidation": true
  },
  "analysis": {
    "minSampleSize": 30,
    "confidenceLevel": 0.95
  }
}
```

## See Also

- [OVERVIEW.md](./OVERVIEW.md) - System architecture overview
- [HOOKS.md](./HOOKS.md) - Metrics collection hooks
- [AGENTS.md](./AGENTS.md) - Agent performance tracking
