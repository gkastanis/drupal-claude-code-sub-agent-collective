Initialize a new Task Master project.

Arguments: $ARGUMENTS

Parse arguments for initialization preferences:
- `quick` or `-y` → Skip confirmations, auto-confirm defaults
- `<file.md>` → Use as PRD after init
- `--name=<name>` → Set project name

## Execution

```bash
task-master init
```

If PRD file provided in arguments, automatically run parse-prd after init.

## Post-Initialization

1. Show project structure created
2. Verify AI models configured
3. If PRD provided: `task-master parse-prd <file>`
4. Suggest next steps (configure providers, create tasks)
