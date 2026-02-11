# Hook System Guide

Loaded on-demand for hook debugging. Not loaded at startup.

## Critical: Hook Changes Require Restart

Any changes to hooks or agent configs require user to restart Claude Code.
DO NOT continue testing until restart confirmed. Commit changes first.

## Current Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| load-behavioral-system.sh | SessionStart | Loads collective behavioral system |
| test-driven-handoff.sh | PostToolUse | Detects handoff patterns, emits Task() calls |
| collective-metrics.sh | PostToolUse | Collects performance and research metrics |
| block-destructive-commands.sh | PreToolUse | Blocks dangerous git/rm commands |
| block-sensitive-files.sh | PreToolUse | Blocks Read/Grep on .env, settings.php |
| semantic-docs-update-hook.sh | PostToolUse | Reminds to update semantic docs after dev tasks |

## Hook-Agent Integration

- Pre-task hooks validate directive compliance before execution
- Post-task hooks collect research metrics after completion
- Agent handoff hooks ensure contract validation at boundaries
- Emergency hooks trigger violation protocols on failures
