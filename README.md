# Drupal Claude Code Sub-Agent Collective

[![npm version](https://badge.fury.io/js/drupal-claude-collective.svg)](https://badge.fury.io/js/drupal-claude-collective)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Drupal-focused NPX installer for specialized Drupal development AI agents**

This installs a collection of AI agents designed specifically for Drupal CMS development. Adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective), this version replaces TDD-focused agents with Drupal specialists that understand Drupal architecture, coding standards, security best practices, and configuration management.

## What this installs

```bash
npx drupal-claude-collective init
```

You get 15 specialized Drupal development agents that understand Drupal architecture, follow Drupal coding standards, and deliver production-ready code.

## Why this exists

Drupal development with AI assistants often results in:
- Code that violates Drupal coding standards
- Security vulnerabilities (SQL injection, XSS)
- Improper use of Drupal APIs
- Missing configuration management
- Poor performance patterns

This collective solves these problems with agents that:
1. Follow Drupal 10/11 best practices and coding standards
2. Perform security reviews (phpcs, vulnerability scans)
3. Use proper Drupal APIs (Entity API, dependency injection)
4. Manage configuration export/import
5. Implement proper caching and performance patterns

## What you get after installation

### Core Coordination (1 agent)
- **routing-agent** - Central routing hub for intelligent agent selection

### Core Drupal Work (5 agents)
- **drupal-architect** - Site architecture, content modeling, module selection
- **module-development-agent** - Custom modules with Drupal 10/11 best practices
- **theme-development-agent** - Twig templates, SCSS, JavaScript behaviors
- **configuration-management-agent** - Config export, update hooks, deployment
- **content-migration-agent** - Content architecture and data migrations

### Quality & Security (2 agents)
- **security-compliance-agent** - Comprehensive validation: Drupal standards, security, performance, accessibility, integration (all quality gates consolidated into one agent)
- **performance-devops-agent** - Caching, optimization, deployment

### Testing (3 agents)
- **functional-testing-agent** - Playwright browser automation for Drupal
- **unit-testing-agent** - PHPUnit tests with Drupal test base
- **visual-regression-agent** - Screenshot comparison testing

### Project Management & Documentation (4 agents)
- **enhanced-project-manager-agent** - Task Master coordination for complex projects
- **research-agent** - Technical research for Drupal solutions
- **workflow-agent** - Complex workflow orchestration
- **semantic-architect-agent** - Knowledge Graph documentation mapping business logic to code

**Total: 15 specialized agents** (streamlined from 47 agents in January 2025 - 68% reduction!)

**Key improvement**: All quality gates (Drupal standards, security, performance, accessibility, integration) consolidated into `security-compliance-agent` for streamlined validation workflow.

## Installation

### Prerequisites
- Claude Code CLI installed
- Drupal 10 or 11 site
- PHP 8.1+ with Composer
- Drush 12+
- Node.js 18+

### Quick Install
```bash
# 1. Navigate to your Drupal project
cd /path/to/drupal

# 2. Install the collective (includes Task Master MCP server configuration)
npx drupal-claude-collective init

# 3. Install Drupal dev tools
composer require --dev drupal/coder phpstan/phpstan
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
```

**Note**: The collective now generates `.mcp.json` configuration automatically. Task Master is included by default. Playwright and Context7 are opt-in (see MCP Server Configuration below).

### About Context7 Integration

Context7 MCP provides agents with real-time access to comprehensive Drupal documentation with thousands of working code examples. The collective uses three primary Drupal resources:

**Developer Quick Reference** (`/selwynpolit/d9book`):
- Modern Drupal developer handbook with practical examples
- **1,989 code snippets** | **Trust Score: 8.6/10**
- Best for: Working code examples, common patterns, how-to guides
- Covers: Services, plugins, forms, entities, migrations, theming, testing

**Official Core Documentation** (`/drupal/core`):
- Drupal Core official API documentation
- **97 code snippets** | **Trust Score: 9.2/10**
- Best for: Official API references, core system architecture
- Covers: Plugin API, Entity API, routing, caching, database abstraction

**Drupal Main Project** (`/drupal/drupal`):
- Version-specific Drupal documentation
- **143 code snippets** | **Trust Score: 9.2/10**
- Available versions: 11.2.2, 10.4.8
- Best for: Version-specific patterns and compatibility

**How Agents Use Context7**:
```javascript
// Agents fetch topic-specific documentation on-demand
mcp__context7__get-library-docs(
  context7CompatibleLibraryID: "/selwynpolit/d9book",
  topic: "services dependency injection",
  tokens: 2500
)
```

This ensures agents always have access to current Drupal best practices and can provide working code examples from trusted sources. See `templates/docs/CONTEXT7-DRUPAL-GUIDE.md` for complete usage guide.

### Installation Options
```bash
# Default installation (Task Master MCP only - lightest, recommended)
npx drupal-claude-collective init

# Minimal installation (core agents only, Task Master MCP)
npx drupal-claude-collective init --minimal

# With Playwright for visual regression testing
npx drupal-claude-collective init --with-playwright

# With Context7 for documentation lookup
npx drupal-claude-collective init --with-context7

# With all MCP servers (highest resource usage)
npx drupal-claude-collective init --with-all-mcps

# Force overwrite existing files
npx drupal-claude-collective init --force

# Express mode (skip prompts, use defaults)
npx drupal-claude-collective init --yes
```

### MCP Server Configuration

The collective automatically generates `.mcp.json` with selective MCP server configuration:

**Default Configuration (Recommended)**:
- ✅ **Task Master** (~20MB memory, Low CPU) - Required for /van commands and workflow management
- ❌ **Playwright** - Excluded by default to prevent zombie processes on Linux
- ❌ **Context7** - Excluded by default

**Why exclude Playwright by default?**
Playwright MCP server has a known issue on Linux where it can create zombie processes consuming 99% CPU after CLI exit. Only enable it when you need visual regression testing and use cleanup scripts if necessary.

**Resource Usage Comparison**:
| Configuration | Memory | CPU | Use Case |
|--------------|--------|-----|----------|
| Default (Task Master only) | ~20MB | Low | Backend development, module work |
| + Playwright | ~220MB | High | Visual regression testing |
| + Context7 | ~50MB | Low | Documentation-heavy research |
| All MCPs | ~250MB | High | Full-stack development with testing |

**Adding MCP Servers Later**:
You can modify `.mcp.json` manually or re-run installation with different flags:
```bash
# Add Playwright for a specific project
npx drupal-claude-collective init --with-playwright --force
```

## What actually gets installed

```
your-project/
├── CLAUDE.md                    # Behavioral rules for agents
├── .mcp.json                    # MCP server configuration (Task Master by default)
├── .claude/
│   ├── settings.json           # Hook configuration
│   ├── agents/                 # 15 agent definitions
│   │   ├── routing-agent.md
│   │   ├── drupal-architect.md
│   │   ├── module-development-agent.md
│   │   ├── theme-development-agent.md
│   │   ├── configuration-management-agent.md
│   │   ├── content-migration-agent.md
│   │   ├── security-compliance-agent.md
│   │   ├── performance-devops-agent.md
│   │   ├── functional-testing-agent.md
│   │   ├── unit-testing-agent.md
│   │   ├── visual-regression-agent.md
│   │   ├── enhanced-project-manager-agent.md
│   │   ├── research-agent.md
│   │   ├── semantic-architect-agent.md
│   │   └── workflow-agent.md
│   ├── hooks/                  # Enforcement scripts (6 hooks)
│   │   ├── directive-enforcer.sh
│   │   ├── collective-metrics.sh
│   │   ├── routing-executor.sh
│   │   ├── load-behavioral-system.sh
│   │   ├── block-destructive-commands.sh
│   │   └── block-sensitive-files.sh
│   └── commands/               # Command system
│       ├── van.md              # Routing command
│       └── tm/                 # TaskMaster commands
└── .claude-collective/
    ├── tests/                  # Test framework
    ├── metrics/                # Usage tracking
    └── package.json           # Testing setup
```

## How It Works

### 1. Complexity Assessment
Main Claude reads `CLAUDE.md` and assesses task complexity (Level 1-4)

### 2. Agent Routing
- **Level 1**: Direct execution (drush commands, file operations) - 0 agents
- **Level 2**: Single-feature development - 2-3 specialized agents
- **Level 3**: Multi-component systems - 5-7 agents with Task Master coordination
- **Level 4**: Full projects - 8-12 agents with phased deployment

### 3. Drupal Development Workflow
```
Architecture → Implementation → Quality Gates → Testing → Deployment
```

### 4. Consolidated Quality Validation
Every implementation passes through the **security-compliance-agent**, which validates:
- ✅ Drupal coding standards (phpcs, phpstan)
- ✅ Security review (SQL injection, XSS, access control)
- ✅ Performance validation (caching, query efficiency)
- ✅ Accessibility compliance (WCAG 2.1 AA)
- ✅ Integration compatibility (dependencies, config)

**Note**: All quality gates consolidated into one agent for streamlined validation workflow.

### 5. Delivery Standard
```
## DRUPAL FEATURE COMPLETE

✅ Module created: my_custom_module
✅ Coding standards: PASS (0 errors, 0 warnings)
✅ Security review: PASS
✅ Functional tests: PASS
✅ Configuration exported
📊 Ready for deployment
```

## Management Commands

```bash
# Check installation status
npx drupal-claude-collective status

# Validate installation integrity
npx drupal-claude-collective validate

# Repair installation
npx drupal-claude-collective repair

# Remove collective
npx drupal-claude-collective clean

# Get help
npx drupal-claude-collective --help
```

## Security: Sensitive File Protection

The collective automatically **blocks AI agent access** to sensitive files to prevent accidental exposure of credentials and secrets.

### Protected Files (Default)

**Environment Files:**
- `.env` and `.env.*` (all variants)

**Drupal Configuration:**
- `settings.php`
- `*.settings.php` (e.g., `local.settings.php`)
- `settings.*.php` (e.g., `settings.local.php`)

**Credentials:**
- `.key`, `.pem`, `.crt`, `.p12`, `.pfx` files
- SSH keys (`id_rsa`, `id_ed25519`, `authorized_keys`)

### Customizing Protected Files

Edit `.claude/sensitive-files.json` to add your own patterns:

```json
{
  "patterns": {
    "custom_patterns": [
      "my_secret_config\\.php$",
      "private/.*\\.key$",
      "credentials/.*"
    ]
  },
  "allowlist": [
    "sites/default/default.settings.php"
  ]
}
```

**Pattern Format**: Regular expressions (regex)

### How It Works

When agents try to use `Read` or `Grep` tools on protected files:

```
🚫 BLOCKED: Drupal settings.php contains database credentials and secrets
Attempted to access: web/sites/default/settings.php

💡 If you need to review configuration:
   - Ask the user to provide specific config values
   - Use drush config:get for specific settings
   - Request manual review of the file
   - Or add the file to .claude/sensitive-files.json allowlist
```

### Bypassing Protection

If you need agents to access a specific file, add it to the allowlist in `.claude/sensitive-files.json`.

## Current State

### What Works Well
- **Streamlined agent collective** (14 agents vs 47 - 70% reduction)
- **Consolidated quality validation** - one comprehensive gate instead of 6 separate gates
- **Sensitive file protection** - automatic blocking of .env, settings.php, and credential files
- Drupal coding standards enforcement prevents common issues
- Security reviews catch vulnerabilities early
- Agents understand Drupal APIs and best practices
- Configuration management is handled automatically
- Faster routing with fewer agents to choose from

### Experimental Features
- Theme development agent (works but being refined)
- Content migration agent (handles basic scenarios)
- Visual regression testing (depends on Playwright setup)

### Known Limitations
- Requires existing Drupal 10/11 installation
- Best for custom module/theme development
- Requires Node.js >= 16
- Need Task Master MCP for complex projects (Level 3-4)
- Agents work best with clear, detailed requirements

## Testing Your Installation

After installing:

```bash
# 1. Validate installation
npx drupal-claude-collective validate

# 2. Check status
npx drupal-claude-collective status

# 3. Restart Claude Code (if hooks were installed)

# 4. Try a simple task
# In Claude Code: "Add a 'Featured' boolean field to the Article content type"
# Expected: Direct execution via drush

# 5. Try a Level 2 feature
# In Claude Code: "Create a custom block plugin that displays the 5 most recent articles"
# Expected: module-development-agent → security-compliance-agent → functional-testing-agent
```

## Troubleshooting

### Installation fails
- Check Node.js version: `node --version` (need >= 16)
- Clear npm cache: `npm cache clean --force`
- Try force install: `npx claude-code-collective init --force`

### Agents don't work
- Restart Claude Code (hooks need to load)
- Check `.claude/settings.json` exists
- Run `npx claude-code-collective validate`

### Tests don't run
- Make sure your project has a test runner (Jest, Vitest, etc.)
- Check if tests are actually being written to files
- Look at the TDD completion reports from agents

### Research is slow
- Context7 might be having connectivity issues
- Agent might be being thorough (this varies)
- Check `.claude-collective/metrics/` for timing data

## Requirements

### System Requirements
- **Node.js**: >= 16.0.0
- **NPM**: >= 8.0.0
- **Claude Code**: Latest version with MCP support

### Drupal Requirements
- **Drupal**: 10.x or 11.x
- **PHP**: 8.1+
- **Drush**: 12+
- **Composer**: Latest version

### Development Tools
- **PHP_CodeSniffer**: With Drupal standards (`drupal/coder`)
- **PHPStan**: For static analysis (recommended)
- **Playwright**: For functional testing (optional but recommended)

## What This Is and Isn't

### What It Is
- Drupal development aid for building production-ready modules and themes
- Collection of Drupal-specialized AI agents
- Adapted from claude-code-sub-agent-collective for Drupal CMS
- Opinionated about Drupal best practices

### What It Isn't
- A replacement for Drupal knowledge
- Guaranteed to handle every edge case
- A substitute for code review
- Magic that requires zero Drupal understanding

## Why Drupal-Specific Agents?

Generic AI assistants often produce Drupal code that:
- Violates coding standards
- Contains security vulnerabilities
- Uses deprecated APIs
- Ignores configuration management
- Has poor performance patterns

Drupal-specialized agents enforce:
- Proper use of Entity API
- Dependency injection patterns
- Security best practices
- Configuration export workflows
- Performance and caching standards

## Research features (experimental)

To make agents smarter about modern development:

- **Context7 integration** - real, current library documentation
- **ResearchDrivenAnalyzer** - intelligent complexity assessment
- **Smart task breakdown** - only creates subtasks when actually needed
- **Best practice application** - research-informed patterns

This stuff is experimental and sometimes overthinks things, but generally helpful.

## Solutions to common agent problems

AI agents can be unreliable. Here's what I built to deal with that:

**Agents ignoring TDD rules**: Hook system enforces test-first development before any code gets written.

**Agents bypassing directives**: CLAUDE.md behavioral operating system with prime directives that override default behavior.

**Agents stopping mid-task**: Test-driven handoff validation ensures work gets completed or explicitly handed off.

**Agents making up APIs**: Context7 integration forces agents to use real, current documentation.

**Agents taking wrong approach**: Central routing through **@routing-agent** hub prevents agents from self-selecting incorrectly.

**Agents breaking coordination**: Hub-and-spoke architecture eliminates peer-to-peer communication chaos.

**Agents skipping quality steps**: Consolidated **security-compliance-agent** blocks completion until all validation passes (standards, security, performance, accessibility, integration).

**Agents losing context**: Handoff contracts preserve required information across agent transitions.

**Agents providing inconsistent output**: Standardized TDD completion reporting from every implementation agent.

**Agents working on wrong priorities**: ResearchDrivenAnalyzer scores complexity to focus effort appropriately.

Most of these are enforced automatically through hooks and behavioral constraints, not just hoping agents follow instructions.

## Support

- **Issues**: Report bugs and suggestions on [GitHub Issues](https://github.com/jodagreyhame/drupal-claude-code-sub-agent-collective/issues)
- **NPM Package**: [drupal-claude-collective](https://www.npmjs.com/package/drupal-claude-collective)
- **Validation**: Run `npx drupal-claude-collective validate` for diagnostics

### Resources
- **Drupal.org**: https://www.drupal.org
- **Drupal API**: https://api.drupal.org
- **Drupal Coding Standards**: https://www.drupal.org/docs/develop/standards
- **Original Project**: https://github.com/vanzan01/claude-code-sub-agent-collective

## Credits

Adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective) by vanzan01 for Drupal CMS development.

Specialized for Drupal with custom agents, quality gates, and Drupal-specific workflows.

## License

MIT License - Use it, break it, fix it, whatever works for you.

---

**Drupal-Specialized** | **Production-Ready Code** | **Drupal 10/11** | **Agent-Based Development**

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.