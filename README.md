# Drupal Claude Code Sub-Agent Collective

[![npm version](https://badge.fury.io/js/drupal-claude-collective.svg)](https://badge.fury.io/js/drupal-claude-collective)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Drupal-focused NPX installer for specialized Drupal development AI agents**

This installs a collection of AI agents designed specifically for Drupal CMS development. Adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective), this version replaces TDD-focused agents with Drupal specialists that understand Drupal architecture, coding standards, security best practices, and configuration management.

## What this installs

```bash
npx drupal-claude-collective init
```

You get 15+ specialized Drupal development agents that understand Drupal architecture, follow Drupal coding standards, and deliver production-ready code.

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

### Core Drupal Work Agents
- **drupal-architect** - Site architecture, content modeling, module selection
- **module-development-agent** - Custom modules with Drupal 10/11 best practices
- **theme-development-agent** - Twig templates, SCSS, JavaScript behaviors
- **configuration-management-agent** - Config export, update hooks, deployment
- **content-migration-agent** - Content architecture and data migrations
- **security-compliance-agent** - Security reviews and phpcs validation
- **performance-devops-agent** - Caching, optimization, deployment

### Quality Gate Agents
- **drupal-standards-gate** - Fast phpcs validation checkpoint
- **security-gate** - Vulnerability scanning and access control checks
- **performance-gate** - Query efficiency and caching validation
- **accessibility-gate** - WCAG 2.1 AA compliance checking
- **integration-gate** - Module compatibility and dependency validation

### Testing Agents
- **functional-testing-agent** - Playwright browser automation for Drupal
- **unit-testing-agent** - PHPUnit tests with Drupal test base
- **visual-regression-agent** - Screenshot comparison testing

### Coordination Agents (Reused from Original)
- **enhanced-project-manager-agent** - Task Master coordination
- **prd-research-agent** - Intelligent PRD breakdown
- **research-agent** - Documentation research
- **task-orchestrator** - Multi-agent coordination
- **routing-agent** - Central routing hub

**Total: 20+ specialized agents** for Drupal development.

## Installation

### Prerequisites
- Claude Code CLI installed
- Drupal 10 or 11 site
- PHP 8.1+ with Composer
- Drush 12+
- Node.js 18+

### Quick Install
```bash
# 1. Install MCP servers
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
claude mcp add playwright -s user -- npx -y playwright-mcp-server

# 2. Navigate to your Drupal project
cd /path/to/drupal

# 3. Install the collective
npx drupal-claude-collective init

# 4. Install Drupal dev tools
composer require --dev drupal/coder phpstan/phpstan
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
```

### Installation Options
```bash
# Full installation (recommended)
npx drupal-claude-collective init

# Minimal installation (core agents only)
npx drupal-claude-collective init --minimal

# Force overwrite existing files
npx drupal-claude-collective init --force
```

## What actually gets installed

```
your-project/
├── CLAUDE.md                    # Behavioral rules for agents
├── .claude/
│   ├── settings.json           # Hook configuration
│   ├── agents/                 # Agent definitions (30+ files)
│   │   ├── prd-research-agent.md
│   │   ├── task-orchestrator.md
│   │   ├── lib/
│   │   │   └── research-analyzer.js  # Complexity analysis engine
│   │   └── ... (lots more agents)
│   └── hooks/                  # TDD enforcement scripts
│       ├── test-driven-handoff.sh
│       └── collective-metrics.sh
└── .claude-collective/
    ├── tests/                  # Test framework templates
    ├── metrics/                # Usage tracking (for development)
    └── package.json           # Testing setup (Vitest)
```

## How It Works

### 1. Complexity Assessment
Main Claude reads `CLAUDE.md` and assesses task complexity (Level 1-4)

### 2. Agent Routing
- **Level 1**: Direct execution (drush commands, file operations)
- **Level 2**: 2-4 specialized agents
- **Level 3**: 5-9 agents with Task Master coordination
- **Level 4**: Full project with phased agent deployment

### 3. Drupal Development Workflow
```
Architecture → Implementation → Quality Gates → Testing → Deployment
```

### 4. Quality Gate Validation
Every implementation passes through:
- ✅ Drupal coding standards (phpcs)
- ✅ Security review (SQL injection, XSS, access control)
- ✅ Performance validation (caching, queries)
- ✅ Accessibility checks (WCAG 2.1 AA)
- ✅ Integration testing (Playwright)

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

## Current State

### What Works Well
- Drupal coding standards enforcement prevents common issues
- Security reviews catch vulnerabilities early
- Agents understand Drupal APIs and best practices
- Configuration management is handled automatically
- Quality gates ensure production-ready code

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

**Agents taking wrong approach**: Central routing through **@task-orchestrator** hub prevents agents from self-selecting incorrectly.

**Agents breaking coordination**: Hub-and-spoke architecture eliminates peer-to-peer communication chaos.

**Agents skipping quality steps**: Quality gates that block completion until standards are met.

**Agents losing context**: Handoff contracts preserve required information across agent transitions.

**Agents providing inconsistent output**: Standardized TDD completion reporting from every implementation agent.

**Agents working on wrong priorities**: ResearchDrivenAnalyzer scores complexity to focus effort appropriately.

Most of these are enforced automatically through hooks and behavioral constraints, not just hoping agents follow instructions.

## Support

- **Issues**: Report bugs and suggestions on GitHub
- **Documentation**: See `FOR_DRUPAL/` directory for detailed guides
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