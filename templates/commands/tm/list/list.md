List tasks with intelligent argument parsing.

Arguments: $ARGUMENTS

Parse arguments to determine filters and display options:
- Status: pending, in-progress, done, review, deferred, cancelled
- `subtasks` or `tree` → Include subtasks in hierarchical view
- `blocked` → Show only blocked tasks
- Task IDs: "1,3,5" or "1-5" → Show specific tasks
- Combinations: "pending high" = pending AND high priority

## Execution

Based on parsed intent, run the appropriate command:
```bash
task-master list [--status=<status>] [--with-subtasks]
```

## Display

- Group by relevant criteria
- Show status badges for quick scanning
- Highlight dependencies and blockers
- Include progress indicators for parent tasks
- Suggest next actions based on what's shown
