Break down tasks into subtasks.

Arguments: $ARGUMENTS

Parse arguments for expansion options:
- `<task-id>` → Expand a specific task
- `all` or `--all` → Expand all pending tasks that need subtasks
- `research` or `--research` → Use research provider for enhanced analysis
- `force` or `--force` → Expand regardless of complexity score

## Execution

```bash
# Single task
task-master expand --id=<task-id> [--research] [--force]

# All pending tasks
task-master expand --all [--research] [--force]
```

## Expansion Process

1. Analyze task complexity and requirements
2. Create 3-7 subtasks per task
3. Each subtask scoped to 1-4 hours
4. Maintain logical implementation order

## Post-Expansion

1. Show subtask hierarchy
2. Update dependency graph
3. Suggest implementation order
