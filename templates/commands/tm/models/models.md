Configure or view AI model settings.

Arguments: $ARGUMENTS

Parse arguments:
- `setup` → Interactive model configuration
- `view` or (no args) → Show current model configuration
- `--set-main <model>` → Set main AI model
- `--set-research <model>` → Set research model
- `--set-fallback <model>` → Set fallback model

## Execution

```bash
# View current configuration
task-master models

# Interactive setup
task-master models --setup

# Set specific model
task-master models --set-main <model-id>
```

## Recommended Configurations

- **Best results**: Claude (main) + Perplexity (research)
- **Budget**: GPT-3.5 (main) + Perplexity (research)
- **Maximum**: GPT-4 (main) + Perplexity (research) + Claude (fallback)

## Post-Setup

- Test provider connectivity
- Verify configuration saved
- Suggest parse-prd to test
