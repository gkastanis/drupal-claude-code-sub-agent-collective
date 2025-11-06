# Agent Handoff Schema Specification

## Overview

This document defines the **standardized handoff schema** for all agents in the Drupal Sub-Agent Collective. This schema enables automated workflow tracking, progress monitoring, and machine-parseable agent communication.

## Purpose

- **Automated Parsing**: Enable tools to parse agent handoffs programmatically
- **Progress Tracking**: Allow TaskMaster and dashboards to track workflow state
- **Error Recovery**: Provide structured failure handling and retry logic
- **CI/CD Integration**: Support automated deployment pipelines
- **Audit Trail**: Maintain complete workflow history

## Schema Format

Agents should include a YAML code block in their completion summaries:

```yaml
handoff:
  phase: "string"           # Current workflow phase
  from: "@agent-name"       # Source agent
  to: "@agent-name | None"  # Target agent or None if complete
  status: "string"          # Current status
  retry_count: number       # Number of retry attempts
  metrics: {}               # Agent-specific metrics
  dependencies: []          # Task dependencies (if applicable)
  on_failure: {}            # Failure recovery configuration
  timestamp: "ISO-8601"     # Completion timestamp (optional)
  context: {}               # Additional context data (optional)
```

## Field Specifications

### Required Fields

#### `phase`
**Type:** String
**Valid Values:**
- `"Research"`
- `"Planning"`
- `"Infrastructure"`
- `"Implementation"`
- `"Testing"`
- `"Integration"`
- `"QA"`
- `"Complete"`

**Description:** The current workflow phase. Used for progress tracking and routing decisions.

**Example:**
```yaml
phase: "Testing"
```

#### `from`
**Type:** String
**Format:** `@agent-name`

**Description:** The agent completing the current phase.

**Example:**
```yaml
from: "@functional-testing-agent"
```

#### `to`
**Type:** String | Null
**Format:** `@agent-name` or `"None"`

**Description:** The next agent to receive control, or `"None"` if workflow is complete.

**Example:**
```yaml
to: "@enhanced-project-manager-agent"
# or
to: "None"
```

#### `status`
**Type:** String
**Valid Values:**
- `"pending"` - Work not yet started
- `"in_progress"` - Currently being executed
- `"complete"` - Successfully completed
- `"failed"` - Execution failed
- `"blocked"` - Blocked by dependencies or issues
- `"retry"` - Retrying after failure

**Description:** Current execution status.

**Example:**
```yaml
status: "complete"
```

### Optional Fields

#### `retry_count`
**Type:** Integer
**Default:** 0

**Description:** Number of retry attempts made. Used for failure recovery logic.

**Example:**
```yaml
retry_count: 1
```

#### `metrics`
**Type:** Object

**Description:** Agent-specific metrics and results. Structure varies by agent type.

**Examples:**

**Testing Agent:**
```yaml
metrics:
  tests_total: 25
  tests_passed: 24
  tests_failed: 1
  coverage: "95%"
  execution_time: "45s"
```

**Implementation Agent:**
```yaml
metrics:
  files_created: 8
  files_modified: 3
  lines_of_code: 450
  complexity_score: 7
```

**Workflow Agent:**
```yaml
metrics:
  agents_coordinated: 5
  parallel_tasks: 2
  quality_gates_passed: true
  total_duration: "25m"
```

#### `dependencies`
**Type:** Array of Strings
**Default:** []

**Description:** Task or subtask IDs that this work depends on or affects.

**Example:**
```yaml
dependencies: ["task-12", "task-15.3"]
```

#### `on_failure`
**Type:** Object

**Description:** Failure recovery configuration.

**Structure:**
```yaml
on_failure:
  retry: number              # Max retry attempts
  route_to: "@agent-name"    # Agent to route failures to
  notify: "@agent-name"      # Agent to notify of failures
  escalate_after: number     # Escalate to delegator after N failures
  context: "string"          # Additional context for failure handler
```

**Example:**
```yaml
on_failure:
  retry: 2
  route_to: "@implementation-agent"
  notify: "@enhanced-project-manager-agent"
  escalate_after: 3
  context: "Test failures require implementation fixes"
```

#### `timestamp`
**Type:** String (ISO-8601)
**Default:** Current timestamp

**Description:** When the handoff was created.

**Example:**
```yaml
timestamp: "2025-01-06T14:30:00Z"
```

#### `context`
**Type:** Object

**Description:** Additional context data for workflow tracking.

**Example:**
```yaml
context:
  project_type: "Drupal 11"
  taskmaster_enabled: true
  complexity_level: 3
  research_cached: false
```

## Agent-Specific Schema Examples

### Workflow Agent Handoff

```yaml
handoff:
  phase: "Implementation"
  from: "@workflow-agent"
  to: "@feature-implementation-agent"
  status: "in_progress"
  retry_count: 0
  metrics:
    agents_coordinated: 3
    parallel_tasks: 2
    quality_gates_passed: true
    workflow_duration: "15m"
  dependencies: []
  on_failure:
    retry: 2
    route_to: "@research-agent"
    notify: "@routing-agent"
    escalate_after: 3
  context:
    workflow_type: "Multi-Technology Project"
    research_complete: true
```

### Functional Testing Agent Handoff

```yaml
handoff:
  phase: "Testing"
  from: "@functional-testing-agent"
  to: "None"
  status: "complete"
  retry_count: 0
  metrics:
    scenarios: 15
    scenarios_passed: 14
    scenarios_failed: 1
    coverage: "User workflows: 90%"
    execution_time: "3m 45s"
    screenshots: 3
  dependencies: ["task-8", "task-9"]
  on_failure:
    retry: 2
    route_to: "@module-development-agent"
    notify: "@enhanced-project-manager-agent"
    context: "Failed scenario: User registration validation"
```

### Unit Testing Agent Handoff

```yaml
handoff:
  phase: "Testing"
  from: "@unit-testing-agent"
  to: "None"
  status: "complete"
  retry_count: 0
  metrics:
    tests_total: 45
    tests_passed: 45
    tests_failed: 0
    coverage: "92%"
    test_types:
      unit: 25
      kernel: 15
      functional: 5
    execution_time: "1m 30s"
  dependencies: ["task-10.1", "task-10.2"]
```

### Visual Regression Agent Handoff

```yaml
handoff:
  phase: "Testing"
  from: "@visual-regression-agent"
  to: "None"
  status: "complete"
  retry_count: 0
  metrics:
    scenarios: 12
    viewports: 3
    screenshots_baseline: 36
    screenshots_current: 36
    diff_threshold: "0.1%"
    failures: 0
  dependencies: ["task-11"]
```

### Enhanced PM Agent Handoff

```yaml
handoff:
  phase: "Complete"
  from: "@enhanced-project-manager-agent"
  to: "None"
  status: "complete"
  retry_count: 0
  metrics:
    tasks_completed: 15
    subtasks_completed: 47
    quality_gates_passed: 5
    total_duration: "2h 15m"
  dependencies: []
  context:
    taskmaster_status: "All tasks complete"
    final_validation: "passed"
```

### Research Agent Handoff

```yaml
handoff:
  phase: "Research"
  from: "@research-agent"
  to: "@task-generator-agent"
  status: "complete"
  retry_count: 0
  metrics:
    technologies_researched: 5
    context7_queries: 8
    cache_files_created: 3
    research_duration: "8m"
  dependencies: []
  context:
    research_quality: "comprehensive"
    working_examples_extracted: true
    cache_location: ".taskmaster/docs/research/"
```

## Integration Guidelines

### For Agent Developers

1. **Include Schema Block:** Add the YAML handoff block to your agent's completion summary
2. **Populate Required Fields:** Always include `phase`, `from`, `to`, and `status`
3. **Add Relevant Metrics:** Include agent-specific metrics that provide value
4. **Define Failure Handling:** Specify `on_failure` configuration for error recovery
5. **Maintain Consistency:** Use standardized phase names and status values

### For Workflow Coordinators

1. **Parse Handoff Blocks:** Extract YAML blocks from agent responses
2. **Track Progress:** Use `phase` and `status` for workflow state management
3. **Handle Failures:** Implement retry logic based on `on_failure` configuration
4. **Aggregate Metrics:** Collect metrics across agents for reporting
5. **Validate Dependencies:** Check `dependencies` array for task ordering

### For CI/CD Pipelines

1. **Extract Status:** Parse `status` field to determine pass/fail
2. **Collect Metrics:** Aggregate metrics for reporting and dashboards
3. **Trigger Actions:** Use `on_failure` to trigger retry or notification logic
4. **Track History:** Store handoff blocks for audit trail
5. **Generate Reports:** Use metrics and status for automated reporting

## Backward Compatibility

Agents can continue using their existing markdown summary formats. The YAML handoff schema is **optional but recommended** for enhanced automation.

**Both formats are valid:**

```markdown
## TESTING COMPLETE

✅ Tests passed: 25/25
✅ Coverage: 95%
✅ Execution time: 45s

**Next Agent:** None
```

**With handoff schema (recommended):**

```markdown
## TESTING COMPLETE

✅ Tests passed: 25/25
✅ Coverage: 95%
✅ Execution time: 45s

**Next Agent:** None

```yaml
handoff:
  phase: "Testing"
  from: "@functional-testing-agent"
  to: "None"
  status: "complete"
  metrics:
    tests_passed: 25
    coverage: "95%"
    execution_time: "45s"
```

## Validation

### Schema Validation Script

```javascript
function validateHandoff(handoff) {
  const required = ['phase', 'from', 'to', 'status'];
  const validPhases = ['Research', 'Planning', 'Infrastructure', 'Implementation',
                       'Testing', 'Integration', 'QA', 'Complete'];
  const validStatuses = ['pending', 'in_progress', 'complete', 'failed', 'blocked', 'retry'];

  // Check required fields
  for (const field of required) {
    if (!handoff[field]) {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  // Validate phase
  if (!validPhases.includes(handoff.phase)) {
    throw new Error(`Invalid phase: ${handoff.phase}`);
  }

  // Validate status
  if (!validStatuses.includes(handoff.status)) {
    throw new Error(`Invalid status: ${handoff.status}`);
  }

  // Validate agent names
  if (handoff.from && !handoff.from.startsWith('@')) {
    throw new Error(`Agent name must start with @: ${handoff.from}`);
  }

  if (handoff.to && handoff.to !== 'None' && !handoff.to.startsWith('@')) {
    throw new Error(`Agent name must start with @: ${handoff.to}`);
  }

  return true;
}
```

## Benefits

### For Development
- ✅ Clear structure for agent communication
- ✅ Automated workflow tracking
- ✅ Easier debugging and troubleshooting
- ✅ Consistent error handling

### For Operations
- ✅ Real-time progress monitoring
- ✅ Automated retry logic
- ✅ Audit trail for compliance
- ✅ Performance metrics collection

### For Users
- ✅ Better visibility into workflow progress
- ✅ Faster error recovery
- ✅ More reliable automation
- ✅ Enhanced quality assurance

## Version History

- **v1.0** (2025-01-06): Initial schema specification
  - Defined core fields and structure
  - Added agent-specific examples
  - Established validation rules

## See Also

- **Workflow Agent**: `templates/agents/workflow-agent.md`
- **Testing Agents**: `templates/agents/*-testing-agent.md`
- **Enhanced PM Agent**: `templates/agents/enhanced-project-manager-agent.md`
- **Research Agent**: `templates/agents/research-agent.md`
