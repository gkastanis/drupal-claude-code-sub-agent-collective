Install Task Master globally.

Arguments: $ARGUMENTS

Parse arguments:
- `quick` or `-y` → Skip checks, install directly
- (no args) → Full detection and guided installation

## Installation Process

1. **Check if installed**: `which task-master`
2. **Verify Node.js 16+**: `node --version`
3. **Install**: `npm install -g task-master-ai`
4. **Verify**: `task-master --version`

## Post-Install

1. Run `task-master init` if no project exists
2. Configure AI providers: `task-master models --setup`
3. Suggest next steps

## Troubleshooting

- Permission errors: `sudo npm install -g task-master-ai` or fix npm prefix
- Network issues: Use `--registry https://registry.npmjs.org/`
- Node version: Use nvm to install Node 18+
