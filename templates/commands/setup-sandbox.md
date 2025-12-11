---
description: "Enable OS-level sandboxing for safer autonomous agent execution"
---
# Setup Sandboxing

This command helps you enable Claude Code's native sandboxing for more autonomous and secure agent execution.

## What Sandboxing Provides

**Filesystem Isolation:**
- Writes restricted to current working directory
- Read access to system, except denied paths
- OS-level enforcement (bubblewrap on Linux, Seatbelt on macOS)

**Network Isolation:**
- Only approved domains accessible
- New domains trigger permission prompts
- All subprocesses inherit restrictions

**Benefits:**
- Fewer permission prompts (reduced approval fatigue)
- Protection against prompt injection attacks
- Malicious dependencies can't exfiltrate data
- Agents work more autonomously within safe boundaries

## Enable Sandboxing

Run this slash command in Claude Code:

```
/sandbox
```

This opens a menu to choose between:
- **Auto-allow mode**: Sandboxed commands run without prompts
- **Regular permissions mode**: Commands still require approval but sandbox applies

## Drupal-Specific Configuration

The collective pre-configures sandbox settings optimized for Drupal development:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker", "ddev"],
    "allowUnsandboxedCommands": true,
    "network": {
      "allowLocalBinding": true
    }
  }
}
```

**Why these settings:**
- `docker` and `ddev` excluded - incompatible with sandbox, need full system access
- `allowLocalBinding: true` - needed for local dev servers (ddev, drush serve)
- `allowUnsandboxedCommands: true` - escape hatch for edge cases (goes through normal permission flow)

## Customization

Edit `.claude/settings.json` to adjust:

```json
{
  "sandbox": {
    "excludedCommands": ["docker", "ddev", "your-tool"],
    "network": {
      "allowUnixSockets": ["/var/run/docker.sock"]
    }
  }
}
```

## Requirements

- macOS or Linux (Windows not yet supported)
- Claude Code with sandbox support

## Troubleshooting

**Command fails in sandbox:**
- Add it to `excludedCommands` array
- Or use `dangerouslyDisableSandbox` parameter (triggers permission prompt)

**Network access blocked:**
- Approve domain when prompted, or
- Add to allowed domains in settings

**ddev/Docker not working:**
- Already excluded by default
- If issues persist, check `excludedCommands` includes them

## Learn More

Full documentation: https://code.claude.com/docs/en/sandboxing

$ARGUMENTS
