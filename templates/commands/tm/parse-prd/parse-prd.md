Parse a PRD document to generate tasks.

Arguments: $ARGUMENTS

Parse arguments for options:
- `<file>` → PRD file path (default: .taskmaster/docs/prd.txt)
- `research` or `--research` → Enable research mode for enhanced task generation
- `--append` → Append to existing tasks instead of replacing

## Execution

```bash
task-master parse-prd <file> [--research] [--append]
```

## Process

1. Read and analyze PRD document
2. Generate structured tasks with dependencies
3. If `--research`: Use research provider for enhanced analysis
4. If `--append`: Add to existing task list

## Post-Parse

1. Show generated tasks summary
2. Suggest running analyze-complexity
3. Recommend expanding high-complexity tasks
