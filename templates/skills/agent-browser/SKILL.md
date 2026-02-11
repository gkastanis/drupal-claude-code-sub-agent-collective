---
name: agent-browser
description: Automates browser interactions for web testing, form filling, screenshots, and data extraction. Use when the user needs to navigate websites, interact with web pages, fill forms, take screenshots, test web applications, or extract information from web pages.
---

# Browser Automation with agent-browser

## DDEV Integration

agent-browser works inside DDEV-based Drupal projects. URLs use the pattern `<project>.ddev.site`.

### Prerequisites

```bash
# Install on host (not inside DDEV container)
npm install -g agent-browser
agent-browser install  # Download Chromium
```

### Auto-Detect Project URL

The project URL is derived from `.ddev/config.yaml`. For a project named `myproject`, the URL is `https://myproject.ddev.site`.

### Drupal Login Workflow

```bash
# Get a one-time login URL via Drush
ddev drush uli

# Open the one-time login URL in agent-browser
agent-browser open "$(ddev drush uli)"
agent-browser wait --load networkidle

# Save authenticated state for reuse
agent-browser state save auth.json
```

### Common Drupal Admin Tasks

```bash
# Load saved auth and navigate to admin
agent-browser state load auth.json
agent-browser open https://myproject.ddev.site/admin/content

# Test content editing
agent-browser open https://myproject.ddev.site/node/add/article
agent-browser snapshot -i
agent-browser fill @e1 "Test Article Title"
agent-browser click @e3  # Save button

# Test Views UI
agent-browser open https://myproject.ddev.site/admin/structure/views
agent-browser snapshot -i

# Test configuration pages
agent-browser open https://myproject.ddev.site/admin/config
agent-browser snapshot -i
```

---

## Quick start

```bash
agent-browser open <url>           # Navigate to page
agent-browser snapshot -i          # Get interactive elements with refs
agent-browser click @e1            # Click element by ref
agent-browser fill @e2 "text"      # Fill input by ref
agent-browser close                # Close browser
```

## Core workflow

1. Navigate: `agent-browser open <url>`
2. Snapshot: `agent-browser snapshot -i` (returns elements with refs like `@e1`, `@e2`)
3. Interact using refs from the snapshot
4. Re-snapshot after navigation or significant DOM changes

## Commands

### Navigation

```bash
agent-browser open <url>           # Navigate to URL
agent-browser back                 # Go back
agent-browser forward              # Go forward
agent-browser reload               # Reload page
agent-browser close                # Close browser
```

### Snapshot (page analysis)

```bash
agent-browser snapshot             # Full accessibility tree
agent-browser snapshot -i          # Interactive elements only (recommended)
agent-browser snapshot -c          # Compact output
agent-browser snapshot -d 3        # Limit depth to 3
```

### Interactions (use @refs from snapshot)

```bash
agent-browser click @e1            # Click
agent-browser dblclick @e1         # Double-click
agent-browser fill @e2 "text"      # Clear and type
agent-browser type @e2 "text"      # Type without clearing
agent-browser press Enter          # Press key
agent-browser press Control+a      # Key combination
agent-browser hover @e1            # Hover
agent-browser check @e1            # Check checkbox
agent-browser uncheck @e1          # Uncheck checkbox
agent-browser select @e1 "value"   # Select dropdown
agent-browser scroll down 500      # Scroll page
agent-browser scrollintoview @e1   # Scroll element into view
```

### Get information

```bash
agent-browser get text @e1         # Get element text
agent-browser get value @e1        # Get input value
agent-browser get title            # Get page title
agent-browser get url              # Get current URL
```

### Screenshots

```bash
agent-browser screenshot           # Screenshot to stdout
agent-browser screenshot path.png  # Save to file
agent-browser screenshot --full    # Full page
```

### Wait

```bash
agent-browser wait @e1             # Wait for element
agent-browser wait 2000            # Wait milliseconds
agent-browser wait --text "Success"  # Wait for text
agent-browser wait --load networkidle  # Wait for network idle
```

### Semantic locators (alternative to refs)

```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find label "Email" fill "user@test.com"
```

## Example: Form submission

```bash
agent-browser open https://example.com/form
agent-browser snapshot -i
# Output shows: textbox "Email" [ref=e1], textbox "Password" [ref=e2], button "Submit" [ref=e3]
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --load networkidle
agent-browser snapshot -i  # Check result
```

## Example: Authentication with saved state

```bash
# Login once
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "username"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json

# Later sessions: load saved state
agent-browser state load auth.json
agent-browser open https://app.example.com/dashboard
```

## Sessions (parallel browsers)

```bash
agent-browser --session test1 open site-a.com
agent-browser --session test2 open site-b.com
agent-browser session list
```

## JSON output (for parsing)

Add `--json` for machine-readable output:

```bash
agent-browser snapshot -i --json
agent-browser get text @e1 --json
```

## Debugging

```bash
agent-browser open example.com --headed  # Show browser window
agent-browser console                    # View console messages
agent-browser errors                     # View page errors
```
