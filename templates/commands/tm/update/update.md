Update tasks with intelligent field detection.

Arguments: $ARGUMENTS

Parse arguments to determine update intent:
- `<task-id> <prompt>` → Update single task with new information
- `from <id> <prompt>` → Update multiple tasks starting from ID
- `subtask <id> <prompt>` → Add implementation notes to subtask
- Natural language: "mark 23 as done", "tasks 20-25 need review"

## Execution

```bash
# Single task
task-master update-task --id=<id> --prompt="<changes>"

# Multiple tasks from ID
task-master update --from=<id> --prompt="<changes>"

# Subtask notes
task-master update-subtask --id=<id> --prompt="<notes>"
```

## Smart Detection

- Status keywords → update status
- Priority changes → adjust priority
- Dependency updates → modify dependencies
- Implementation notes → update subtask details

## Post-Update

- Show updated task details
- Check for dependency impacts
- Suggest follow-up actions
