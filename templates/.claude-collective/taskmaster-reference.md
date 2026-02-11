# TaskMaster Quick Reference

Loaded on-demand for TaskMaster operations. Not loaded at startup.

## Daily Workflow

```
task-master list                                # Show all tasks with status
task-master next                                # Get next available task
task-master show <id>                           # Task details (e.g., show 1.2)
task-master set-status --id=<id> --status=done  # Complete task
```

## Task Management

```
task-master add-task --prompt="desc" --research     # Add task with AI
task-master expand --id=<id> --research --force     # Break into subtasks
task-master update-task --id=<id> --prompt="..."    # Update specific task
task-master update --from=<id> --prompt="..."       # Update tasks from ID onwards
task-master update-subtask --id=<id> --prompt="..." # Implementation notes
```

## Analysis

```
task-master analyze-complexity --research     # Analyze task complexity
task-master complexity-report                 # View complexity report
task-master expand --all --research           # Expand all eligible tasks
```

## Dependencies

```
task-master add-dependency --id=<id> --depends-on=<id>
task-master remove-dependency --id=<id> --depends-on=<id>
task-master validate-dependencies
task-master fix-dependencies
```

## Setup and Generation

```
task-master init                              # Initialize project
task-master parse-prd path/to/prd.txt         # Generate tasks from PRD
task-master parse-prd --append path/to/prd.txt  # Append tasks from new PRD
task-master models --setup                    # Configure AI models
task-master generate                          # Regenerate task markdown files
```

## Task IDs and Status

- Main tasks: 1, 2, 3...
- Subtasks: 1.1, 1.2, 2.1...
- Sub-subtasks: 1.1.1, 1.1.2...
- Status values: pending, in-progress, done, deferred, cancelled, blocked

## MCP Tools (when available)

get_tasks, next_task, get_task, set_task_status, add_task, expand_task,
update_task, update_subtask, analyze_project_complexity, complexity_report

## Key Files

```
.taskmaster/tasks/tasks.json    # Task data (never edit manually)
.taskmaster/docs/prd.txt        # PRD document
.taskmaster/config.json         # Model config (use `task-master models`)
```

## Best Practices

- Use `/clear` between tasks for focused context
- Log implementation notes with `update-subtask` during work
- Use `--research` flag for complex technical tasks (requires Perplexity key)
- Never manually edit tasks.json -- use commands instead
- Reference tasks in commits: `git commit -m "feat: auth system (task 1.2)"`

## AI-Powered Commands (may take up to a minute)

parse-prd, analyze-complexity, expand, add-task, update, update-task, update-subtask

## Iterative Workflow Pattern

1. `task-master show <id>` -- understand requirements
2. `task-master set-status --id=<id> --status=in-progress` -- start work
3. Implement following task details
4. `task-master update-subtask --id=<id> --prompt="notes..."` -- log progress
5. `task-master set-status --id=<id> --status=done` -- complete
6. `task-master next` -- get next task
