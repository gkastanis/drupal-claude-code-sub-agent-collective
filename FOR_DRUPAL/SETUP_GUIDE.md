# Drupal Web Development Sub-Agent Collective - Setup Guide

## Prerequisites

### 1. System Requirements
- Node.js 18+ installed
- Claude Code CLI installed
- Drupal 10 or 11 installation
- Composer installed
- PHP 8.1+ with required extensions
- Drush 12+

### 2. Drupal Development Environment
Your Drupal site should be accessible and functional:
```bash
# Verify Drupal installation
cd /path/to/drupal
drush status

# Should show:
# Drupal version : 10.x.x or 11.x.x
# Site URI       : http://your-site.local
# Database       : Connected
```

### 3. Code Quality Tools
Install PHP_CodeSniffer with Drupal standards:
```bash
composer require --dev drupal/coder
composer require --dev phpstan/phpstan
composer require --dev phpunit/phpunit

# Register Drupal coding standards
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer

# Verify installation
./vendor/bin/phpcs -i
# Should show: Drupal, DrupalPractice
```

## Installation Steps

### Step 1: Install MCP Servers

```bash
# Task Master (Required - for PM agent coordination)
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai

# Playwright (Required - for functional testing)
claude mcp add playwright -s user -- npx -y playwright-mcp-server

# Install Playwright browsers
npx playwright install
```

### Step 2: Initialize Your Drupal Project

```bash
# Navigate to your Drupal project
cd /path/to/your/drupal/project

# Initialize Task Master
npx task-master-ai init

# Configure for Claude Code (zero cost)
npx task-master-ai models --setMain claude-code/sonnet --setResearch claude-code/sonnet

# This creates .task-master/ directory for state management
```

### Step 3: Set Up CLAUDE.md

Copy the CLAUDE.md file to your Drupal project root:
```bash
cp CLAUDE.md /path/to/your/drupal/project/.claude/CLAUDE.md
```

This file instructs Claude Code how to orchestrate the specialized agents.

### Step 4: Create Helper Scripts (Optional)

Create a `scripts/` directory with useful Drupal commands:

**scripts/drupal-standards-check.sh**
```bash
#!/bin/bash
echo "Running Drupal coding standards check..."
./vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom/ web/themes/custom/
```

**scripts/drupal-static-analysis.sh**
```bash
#!/bin/bash
echo "Running PHPStan static analysis..."
./vendor/bin/phpstan analyse web/modules/custom/ web/themes/custom/
```

**scripts/drupal-tests.sh**
```bash
#!/bin/bash
echo "Running PHPUnit tests..."
./vendor/bin/phpunit web/modules/custom/
```

Make them executable:
```bash
chmod +x scripts/*.sh
```

### Step 5: Configure Agent Access Permissions

Create a `.claude/agent-config.json` file:
```json
{
  "agents": {
    "pm": {
      "tools": ["task_master_full", "file_read"],
      "mcp_servers": ["task-master"]
    },
    "architect": {
      "tools": ["task_master_read", "file_read", "web_search"],
      "mcp_servers": ["task-master"]
    },
    "module_dev": {
      "tools": ["file_read", "file_write", "file_edit", "bash", "task_master_read"],
      "allowed_commands": ["drush", "composer"]
    },
    "theme_dev": {
      "tools": ["file_read", "file_write", "file_edit", "bash", "task_master_read"],
      "allowed_commands": ["drush", "npm", "yarn"]
    },
    "security": {
      "tools": ["file_read", "bash", "task_master_read"],
      "allowed_commands": ["phpcs", "phpstan"]
    },
    "functional_test": {
      "tools": ["bash", "task_master_read"],
      "mcp_servers": ["playwright"]
    },
    "performance_devops": {
      "tools": ["file_read", "file_write", "bash", "task_master_read"],
      "allowed_commands": ["drush", "composer"]
    }
  }
}
```

## Verification

### Test the System

Open Claude Code and try a simple Level 1 task:
```
Add a "Featured" boolean field to the Article content type
```

Claude should:
1. Recognize this as Level 1 (simple)
2. Execute directly using Drush commands
3. Verify the field was created

### Test Level 2 Feature
```
Create a custom block plugin that displays the site name and a custom message that can be configured in the block settings
```

Claude should:
1. Assess as Level 2
2. Route to @architect for planning
3. Route to @module-dev for implementation
4. Route to @security for review
5. Route to @functional-test for validation

## Project Structure

Your Drupal project should look like:
```
your-drupal-project/
├── .claude/
│   ├── CLAUDE.md           # Main orchestration instructions
│   └── agent-config.json   # Agent permissions
├── .task-master/           # Task Master state (auto-created)
├── composer.json
├── composer.lock
├── web/
│   ├── core/
│   ├── modules/
│   │   ├── contrib/
│   │   └── custom/        # Your custom modules here
│   ├── themes/
│   │   ├── contrib/
│   │   └── custom/        # Your custom themes here
│   └── sites/
├── vendor/
├── scripts/               # Helper scripts
│   ├── drupal-standards-check.sh
│   ├── drupal-static-analysis.sh
│   └── drupal-tests.sh
└── tests/                 # Playwright tests
```

## Usage Examples

### Level 1: Simple Tasks (Direct Execution)
- "Add an image field to the Basic Page content type"
- "Change the site name to 'My Awesome Site'"
- "Enable the Pathauto module"
- "Clear all caches"

### Level 2: Feature Development (2-3 Agents)
- "Create a custom block that shows the 5 most recent blog posts"
- "Add a custom field formatter for phone numbers with click-to-call"
- "Create a view that displays events in calendar format"
- "Implement a custom validation for the contact form"

### Level 3: Multi-Component Systems (5-7 Agents)
- "Build an FAQ system with categories, voting, and search"
- "Create a member directory with custom fields, filtering, and map display"
- "Implement a document library with access control and version tracking"
- "Build a job posting system with application forms and admin review"

### Level 4: Full Projects (8+ Agents)
- "Build a complete university department site from this PRD"
- "Create a multi-tenant real estate listing platform"
- "Develop an e-learning platform with courses, quizzes, and certificates"
- "Build a news/media site with editorial workflow and subscriptions"

## Troubleshooting

### Task Master Issues
```bash
# Reinitialize if needed
rm -rf .task-master
npx task-master-ai init
npx task-master-ai models --setMain claude-code/sonnet
```

### MCP Connection Issues
```bash
# List installed MCPs
claude mcp list

# Remove and reinstall
claude mcp remove task-master
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
```

### Drupal Permissions Issues
Make sure the web server user can write to necessary directories:
```bash
chmod -R 775 web/sites/default/files
chmod -R 775 config/sync
```

### Code Quality Tools Not Found
```bash
# Reinstall dev dependencies
composer install --dev

# Verify paths
ls -la vendor/bin/phpcs
ls -la vendor/bin/phpstan
```

## Best Practices

1. **Start Small**: Begin with Level 1-2 tasks to understand the workflow
2. **Clear Requirements**: Provide detailed requirements for Level 3-4 projects
3. **Version Control**: Commit after each successful phase
4. **Testing**: Always validate in a development environment first
5. **Documentation**: Let agents document their work - review and adjust
6. **Configuration Management**: Export configs after each feature completion

## Next Steps

1. Test the system with progressively complex tasks
2. Customize agent instructions in CLAUDE.md for your team's needs
3. Add custom MCPs if needed (e.g., Drush MCP, Drupal.org API MCP)
4. Build a library of reusable patterns
5. Document your team's specific workflows

## Support Resources

- Drupal documentation: https://www.drupal.org/docs
- Drupal API: https://api.drupal.org
- Drupal coding standards: https://www.drupal.org/docs/develop/standards
- Claude Code docs: https://docs.claude.com/en/docs/claude-code

## Advanced Configuration

### Custom MCP Servers (Future Enhancement)

Consider creating these custom MCPs:

1. **Drupal API MCP**: Query Drupal.org for module documentation
2. **Drush MCP**: Structured Drush command execution
3. **Drupal Git MCP**: Automated patch application and module updates
4. **Performance Monitoring MCP**: Integration with New Relic/Blackfire

### Multi-Environment Support

Configure for dev/staging/prod:
```json
{
  "environments": {
    "dev": {
      "drupal_root": "/path/to/dev",
      "site_url": "http://dev.local"
    },
    "staging": {
      "drupal_root": "/path/to/staging",
      "site_url": "https://staging.example.com"
    }
  }
}
```

Your Drupal Sub-Agent Collective is now ready to use!
