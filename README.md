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

# With DDEV for database queries and container management
npx drupal-claude-collective init --with-ddev

# With Sequential Thinking for structured problem decomposition
npx drupal-claude-collective init --with-sequential-thinking

# With all MCP servers (highest resource usage)
npx drupal-claude-collective init --with-all-mcps

# Force overwrite existing files
npx drupal-claude-collective init --force

# Express mode (skip prompts, use defaults)
npx drupal-claude-collective init --yes
```

### Sandboxing for Autonomous Execution

The collective includes pre-configured [sandbox settings](https://code.claude.com/docs/en/sandboxing) for safer, more autonomous agent execution:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker", "ddev"]
  }
}
```

**Benefits:**
- Fewer permission prompts (agents work more autonomously)
- OS-level filesystem and network isolation
- Protection against prompt injection attacks

**Enable sandboxing:**
```
/sandbox
```

Or run `/setup-sandbox` for Drupal-specific guidance.

**Note**: `docker` and `ddev` are excluded as they're incompatible with sandboxing. macOS/Linux only.

### MCP Server Configuration

The collective automatically generates `.mcp.json` with selective MCP server configuration:

**Default Configuration (Recommended)**:
- ✅ **Task Master** (~20MB memory, Low CPU) - Required for /van commands and workflow management
- ❌ **Playwright** - Excluded by default to prevent zombie processes on Linux
- ❌ **Context7** - Excluded by default
- ❌ **DDEV** - Excluded by default (requires `ddev-mcp` installed)
- ❌ **Sequential Thinking** - Excluded by default

**Why exclude Playwright by default?**
Playwright MCP server has a known issue on Linux where it can create zombie processes consuming 99% CPU after CLI exit. Only enable it when you need visual regression testing and use cleanup scripts if necessary.

**Resource Usage Comparison**:
| Configuration | Memory | CPU | Use Case |
|--------------|--------|-----|----------|
| Default (Task Master only) | ~20MB | Low | Backend development, module work |
| + Playwright | ~220MB | High | Visual regression testing |
| + Context7 | ~50MB | Low | Documentation-heavy research |
| + DDEV | ~30MB | Low | Database queries, Drupal CLI via DDEV |
| + Sequential Thinking | ~35MB | Low | Complex architectural decisions |
| All MCPs | ~275MB | High | Full-stack development with testing |

**Adding MCP Servers Later**:
You can modify `.mcp.json` manually or re-run installation with different flags:
```bash
# Add Playwright for a specific project
npx drupal-claude-collective init --with-playwright --force
```

## What actually gets installed

```
your-project/
├── CLAUDE.md                    # Behavioral rules for agents (~96 lines, lean)
├── .mcp.json                    # MCP server configuration (Task Master by default)
├── .claude/
│   ├── settings.json           # Hook configuration (9 hooks across 8 events)
│   ├── settings.local.json     # Personal overrides (not overwritten on updates)
│   ├── agents/                 # 15 agent definitions (with memory + skills frontmatter)
│   │   ├── routing-agent.md
│   │   ├── drupal-architect.md          # memory: project, skills: drupal-entity-api, drupal-service-di, discover, drupal-testing, verification-before-completion
│   │   ├── module-development-agent.md  # model: opus, memory: project, skills: drupal-service-di, drupal-hook-patterns, drupal-coding-standards, drupal-testing, verification-before-completion
│   │   ├── theme-development-agent.md   # skills: twig-templating, drupal-testing, verification-before-completion
│   │   ├── configuration-management-agent.md  # memory: project, skills: drupal-testing, verification-before-completion
│   │   ├── content-migration-agent.md
│   │   ├── security-compliance-agent.md # memory: project, skills: drupal-security-patterns, drupal-coding-standards
│   │   ├── performance-devops-agent.md  # skills: drupal-caching
│   │   ├── functional-testing-agent.md
│   │   ├── unit-testing-agent.md
│   │   ├── visual-regression-agent.md
│   │   ├── enhanced-project-manager-agent.md
│   │   ├── research-agent.md            # memory: project
│   │   ├── semantic-architect-agent.md
│   │   └── workflow-agent.md
│   ├── hooks/                  # Enforcement scripts (10 hooks + shared lib)
│   │   ├── lib/hook-utils.sh
│   │   ├── block-destructive-commands.sh    # PreToolUse(Bash)
│   │   ├── block-sensitive-files.sh         # PreToolUse(Read|Grep)
│   │   ├── collective-metrics.sh            # PostToolUse(*)
│   │   ├── load-behavioral-system.sh        # SessionStart
│   │   ├── semantic-docs-update-hook.sh     # PostToolUse(Edit|Write)
│   │   ├── test-driven-handoff.sh           # PostToolUse(Task)/SubagentStop
│   │   ├── pre-compact-state.sh             # PreCompact (NEW v2.1)
│   │   ├── subagent-context-inject.sh       # SubagentStart (NEW v2.1)
│   │   ├── teammate-quality-gate.sh         # TeammateIdle/TaskCompleted (NEW v2.2)
│   │   └── plan-quality-inject.sh          # PostToolUse:ExitPlanMode (NEW v2.5)
│   ├── rules/                  # Auto-loaded behavioral rules (8 rules, NEW v2.1)
│   │   ├── drupal-services.md       # DI, Entity API, service registration
│   │   ├── drupal-security.md       # Input sanitization, XSS, access control
│   │   ├── translation-rules.md     # t(), .po conventions, Twig |t
│   │   ├── code-quality.md          # Grep after changes, magic numbers, naming
│   │   ├── css-conventions.md       # BEM, specific selectors, asset management
│   │   ├── error-handling.md        # Exception hierarchy, fail fast
│   │   ├── testing-verification.md  # Verify before completion, DDEV shell rules, script storage, drush escaping
│   │   └── drupal-contrib-first.md  # Check drupal.org for existing modules before custom code
│   ├── agent-memory/           # Persistent agent knowledge (NEW v2.1)
│   │   ├── drupal-architect/MEMORY.md
│   │   ├── module-development-agent/MEMORY.md
│   │   ├── security-compliance-agent/MEMORY.md
│   │   ├── research-agent/MEMORY.md
│   │   └── configuration-management-agent/MEMORY.md
│   ├── skills/                 # Claude Code skills (15 total: 3 existing + 7 Drupal + 3 cross-project + 2 testing)
│   │   ├── semantic-docs/           # Semantic documentation navigator
│   │   ├── drupal-entity-api/       # Field types, CRUD, view modes (NEW v2.1)
│   │   ├── drupal-service-di/       # Service definitions, DI patterns (NEW v2.1)
│   │   ├── drupal-caching/          # Cache bins, tags, contexts (NEW v2.1)
│   │   ├── drupal-security-patterns/ # OWASP, access control (NEW v2.1)
│   │   ├── drupal-coding-standards/ # PHPCS, PHPStan, naming (NEW v2.1)
│   │   ├── drupal-hook-patterns/    # OOP hooks, form alters (NEW v2.1)
│   │   ├── twig-templating/         # Template patterns, filters (NEW v2.1)
│   │   ├── agent-browser/           # CLI browser automation with DDEV integration
│   │   ├── discover/                # Docs-first codebase discovery (with scripts/)
│   │   ├── prd/                     # PRD generator for Drupal features
│   │   ├── drupal-testing/          # Curl smoke tests, drush eval patterns
│   │   └── verification-before-completion/  # Verification gate before claiming done
│   └── commands/               # Command system
│       ├── van.md              # Routing command
│       ├── drupal-verify.md    # Drupal implementation verification
│       └── tm/                 # TaskMaster commands
└── .claude-collective/
    ├── INDEX.md               # Agent/command index + behavioral rules (startup)
    ├── DECISION.md            # Auto-delegation decision engine (startup)
    ├── van-context.md         # Routing context (JIT: /van only)
    ├── taskmaster-reference.md # TaskMaster quick reference (JIT: /tm commands)
    ├── research-framework.md  # Research hypotheses (JIT: research tasks)
    ├── hook-guide.md          # Hook troubleshooting (JIT: hook debugging)
    ├── CLAUDE.md              # Collective behavioral rules (/van activated)
    ├── agents.md              # Agent catalog
    ├── hooks.md               # Hook integration requirements
    ├── quality.md             # Quality gates and reporting
    ├── research.md            # Research metrics
    ├── tests/                 # Test framework
    ├── metrics/               # Usage tracking
    └── package.json           # Testing setup
```

## Semantic Documentation Skill

The collective includes a **semantic-docs skill** for navigating business-logic-to-code mappings. This skill helps agents (and developers) understand how features are implemented by providing machine-readable documentation that maps:

- **User Stories** → **Logic IDs** → **Source Code**

### What It Does

When you have semantic documentation in `docs/semantic/`, agents can:

```bash
# Find where a feature is implemented
$SKILL_DIR/scripts/find-feature.sh AUTH

# Trace a Logic ID to actual code
$SKILL_DIR/scripts/trace-code.sh AUTH-L2

# Look up entity schemas
$SKILL_DIR/scripts/find-entity.sh node_article

# Find user story implementations
$SKILL_DIR/scripts/find-user-story.sh US-004

# List all documented features
$SKILL_DIR/scripts/list-features.sh
```

### Documentation Structure

```
docs/semantic/
├── 00_BUSINESS_INDEX.md    # Master feature index
├── tech/*.md               # Technical specs by feature
├── schemas/*.json          # Entity schemas (fields, relationships)
└── SUMMARY.md              # Quick reference
```

### Logic ID Format

Logic IDs follow the pattern `FEATURE-L#`:
- `AUTH-L1` - First authentication logic unit
- `MIGR-L3` - Third migration logic unit
- `ACCS-L2` - Second access control logic unit

### When to Use

The skill triggers when asking:
- "Where is [feature] implemented?"
- "What does [Logic ID] do?"
- "How does [workflow] work?"
- "What fields does [entity] have?"

### Generating Semantic Docs

Use the **semantic-architect-agent** to generate semantic documentation for your project:

```
"Generate semantic documentation for the authentication system"
```

This creates the `docs/semantic/` structure with business-to-code mappings that all agents can reference.

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

## Upgrading

### Upgrading to v2.5 (from v2.4)

v2.5 extracts high-value Drupal knowledge gaps from the external `drupal-expert` skill, adds a plan quality injection hook, and trims CLAUDE.md/INDEX.md template bloat.

**What changed:**
- New `drupal-contrib-first.md` rule: Always-on rule enforcing drupal.org module search before custom code
- `drupal-coding-standards` skill expanded with Drush generators (`--answers` patterns) and deprecated APIs table (10 mappings)
- `drupal-hook-patterns` skill expanded with D10/D11 compatibility matrix and Recipes (10.3+) note
- New `plan-quality-inject.sh` hook: Injects routing and quality requirements at plan approval
- `CLAUDE.md` template trimmed by 46 lines (removed content already in auto-loaded rules/skills)
- `INDEX.md` template trimmed (removed duplicated behavioral rules summary)
- Rules count: 7 → 8. Hooks count: 9 → 10.

**How to upgrade:**
```bash
npx drupal-claude-collective init --force
```

**Breaking changes:** None. All additions to existing files.

### Upgrading to v2.4 (from v2.3)

v2.4 integrates 10 hard-won DDEV debugging lessons from production Drupal sessions into existing rules, skills, and documentation.

**What changed:**
- Behavioral rule #7 added to INDEX.md: "Write script files for DDEV commands"
- `testing-verification.md` rule expanded with DDEV shell rules, script naming conventions, HTML form ID search patterns
- `drupal-services.md` rule expanded with service name discovery section
- `drupal-security.md` rule expanded with route access vs entity access warning
- `drupal-testing` skill enhanced with DDEV gotchas, same-shell auth pattern, vendor vs contrib file discovery, role-based access testing matrix
- `drupal-service-di` skill enhanced with service name discovery and ReflectionMethod for patched modules
- `drupal-security-patterns` skill enhanced with stacked route access checks section
- `LESSONS-LEARNED.md` doc expanded with anti-patterns summary table and field report cross-reference

**How to upgrade:**
```bash
npx drupal-claude-collective init --force
```

**Breaking changes:** None. All content additions to existing files.

### Upgrading to v2.2 (from v2.1)

v2.2 adds experimental agent teams support - Claude Code's multi-session coordination system where independent teammates share a task list and mailbox.

**What changed:**
- Agent teams enabled by default (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json)
- `teammateMode: "in-process"` configured in settings.json
- New `teammate-quality-gate.sh` hook for `TeammateIdle` and `TaskCompleted` events (advisory only, never blocks)
- Agent Teams guidance section added to CLAUDE.md with role-based teammate suggestions
- Override examples in settings.local.json for disabling agent teams or changing teammate mode
- Hook count: 8 → 9 across 8 event types (was 6)

**How to upgrade:**
```bash
npx drupal-claude-collective init --force
```

**Breaking changes:** None. Agent teams are opt-in at usage time - the feature flag just makes them available. All existing commands, agents, and configuration remain compatible.

### Upgrading to v2.1 (from v2.0)

v2.1 adds rules directory, agent memory, 12 new skills, 2 new hooks, 2 new MCP servers, and a practical testing/verification system.

**What changed:**
- `.claude/rules/` directory with 7 topic-based rule files (auto-loaded by Claude Code), including `testing-verification.md`
- CLAUDE.md slimmed from ~161 to ~96 lines (rules extracted to `.claude/rules/`)
- Agent memory system: 5 agents get `memory: project` frontmatter for cross-session persistence
- 7 new Drupal-specific skills extracted from agent definitions (JIT loaded via `skills:` frontmatter)
- 3 new cross-project skills: `agent-browser` (CLI browser automation), `discover` (docs-first codebase discovery), `prd` (PRD generator)
- 2 new testing skills: `drupal-testing` (curl smoke tests, drush eval patterns) and `verification-before-completion` (verification gate before claiming done)
- `/drupal-verify` command for on-demand Drupal implementation verification
- `scripts/tests/` directory convention for agent-created verification scripts
- `module-development-agent` upgraded to opus model
- 2 new hooks: `pre-compact-state.sh` (PreCompact) and `subagent-context-inject.sh` (SubagentStart)
- 2 new optional MCP servers: `ddev` (database/CLI integration) and `sequential-thinking` (problem decomposition)
- `settings.local.json` with documented personal overrides
- Hook count: 6 → 8 across 6 event types

**How to upgrade:**
```bash
npx drupal-claude-collective init --force
```

**Breaking changes:** None. All existing commands, agent names, and configuration remain compatible. Rules previously inline in CLAUDE.md are now in `.claude/rules/` (auto-loaded by Claude Code).

### Upgrading to v2.0 (from v1.x)

v2.0.0 is a major infrastructure overhaul that reduces complexity while maintaining full backward compatibility.

**What changed:**
- Hook scripts refactored with shared utility library (`lib/hook-utils.sh`), reducing total hook code by ~60%
- `/tm:*` command variants consolidated into unified skills (47 files down to 31)
- All 15 agents enhanced with self-verification checklists and Lullabot best practices
- 3 new workflow skills added: `/implement`, `/update-docs`, `/verify-changes`
- Inline php-lint hook added for immediate PHP syntax feedback

**How to upgrade:**
```bash
npx drupal-claude-collective init --force
```

**Breaking changes:** None. All existing `/tm:*` commands, agent names, and configuration files remain compatible.

## Current State

### What Works Well
- **Streamlined agent collective** (15 agents vs 47 original - 68% reduction)
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
# 1. Restart Claude Code (hooks need to load)

# 2. Validate installation
npx drupal-claude-collective validate

# 3. Generate semantic docs (enables /discover and fast code navigation)
# In Claude Code: "Generate semantic documentation for this project"
# This creates docs/semantic/ with business index and Logic ID mappings.
# All agents use this for efficient code discovery instead of Glob/Grep.

# 4. Try /discover to verify semantic docs work
# In Claude Code: "/discover --status"

# 5. Try a simple task
# In Claude Code: "Add a 'Featured' boolean field to the Article content type"
# Expected: Direct execution via drush

# 6. Try a Level 2 feature
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

### Optional External Tools (for specific skills/MCPs)
- **agent-browser**: CLI browser automation (`npm install -g agent-browser && agent-browser install`). Used by `agent-browser` skill.
- **ddev-mcp**: DDEV MCP server for database/CLI integration. Install via DDEV add-on. Used by `--with-ddev` flag.
- **qmd**: Fast document search. Used by `discover` skill for full-text search (optional -- falls back to grep).

These are NOT installed by the collective. Install them separately if you need the corresponding skills or MCP servers.

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

- **Issues**: Report bugs and suggestions on [GitHub Issues](https://github.com/gkastanis/drupal-claude-code-sub-agent-collective/issues)
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
