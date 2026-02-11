Set task status: $ARGUMENTS

Arguments: task ID and status (e.g., "42 done", "3.1 in-progress")

Valid statuses: pending, in-progress, done, deferred, cancelled, review

## Execution

Parse the task ID and target status from arguments, then run:
```bash
task-master set-status --id=<task-id> --status=<status>
```

## Pre-Completion Checks (when setting to "done")

1. Verify test strategy was followed
2. Check if all subtasks are complete
3. Validate acceptance criteria met

## Post-Update Actions

1. Identify newly unblocked tasks
2. Show updated project progress
3. Suggest logical next task
