---
description: "Install claude-mem for persistent memory across sessions"
---
# Setup Persistent Memory (claude-mem)

This command installs [claude-mem](https://github.com/thedotmack/claude-mem) - a plugin that gives Claude persistent memory across coding sessions.

## What claude-mem provides:
- **Persistent memory** surviving session disconnects
- **Automatic capture** of file reads, writes, decisions
- **Natural language search** via mem-search skill
- **Web UI dashboard** at localhost:37777
- **Privacy controls** using `<private>` tags

## Installation Steps

Run these two commands in sequence:

```
/plugin marketplace add thedotmack/claude-mem
```

Wait for it to complete, then:

```
/plugin install claude-mem
```

After installation, restart Claude Code. Memory will work automatically - previous context appears in new sessions without manual intervention.

## Verification

After restart, you should see memory context injected at session start. You can also:
- Visit http://localhost:37777 for the web dashboard
- Use `mem-search: [query]` to search past sessions

## Requirements
- Node.js 18.0.0+
- Claude Code with plugin support

$ARGUMENTS
