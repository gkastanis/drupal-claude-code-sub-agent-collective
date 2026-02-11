# Session Kickstart - drupal-claude-collective

Read this first when starting a new session on this project.

---

## What This Project Is

An **NPM package** (`drupal-claude-collective`) that installs 15 Drupal-specialized AI agents, 9 enforcement hooks, 15 skills, 7 auto-loaded rule files, slash commands, and coordination infrastructure into Claude Code projects. Users run `npx drupal-claude-collective install --yes` and get a complete multi-agent Drupal development environment.

**npm**: `drupal-claude-collective` | **Current version**: 2.2.0-dev | **License**: MIT

---

## Architecture

### Three Key Patterns

**1. JIT Context Loading** — Only ~96 lines load at startup (INDEX.md + DECISION.md). All other context loads on-demand when triggered by specific commands or task types. This is the core v2.0 innovation, refined in v2.1 by extracting rules to `.claude/rules/` (auto-loaded by Claude Code).

**2. Hub-and-Spoke Coordination** — All agent communication flows through a central hub (the `/van` routing command). Agents never communicate peer-to-peer. The hub selects the optimal agent, delegates, monitors, and validates.

**3. Hook Enforcement** — 9 shell scripts hook into Claude Code events (SessionStart, PreToolUse, PostToolUse, PreCompact, SubagentStart, SubagentStop, TeammateIdle, TaskCompleted) to enforce behavioral rules, block dangerous commands, detect agent handoffs, preserve state during compaction, inject agent context, collect metrics, and advise on verification. Shared utilities live in `lib/hook-utils.sh`.

**4. Rules Directory** (v2.1) — 7 topic-based rule files in `.claude/rules/` auto-loaded by Claude Code. Replaces inline rules in CLAUDE.md for leaner startup context. Includes `testing-verification.md` which enforces verification-before-completion behavior.

**5. Agent Memory** (v2.1) — 5 agents use `memory: project` frontmatter with seed files in `.claude/agent-memory/` for cross-session knowledge persistence.

**6. Skills Extraction** (v2.1) — 7 new Drupal-specific skills extracted from agent definitions, shared across agents via `skills:` frontmatter for JIT loading. Plus `drupal-testing` and `verification-before-completion` skills for practical verification.

### How It Works (Runtime)

```
User types request
  → CLAUDE.md loads INDEX.md + DECISION.md (always-on, ~96 lines)
  → .claude/rules/*.md auto-loaded by Claude Code (6 topic files)
  → DECISION.md evaluates routing tree (first match wins):
      /van command? → load van-context.md → route to specialized agent
      /tm:* command? → load taskmaster-reference.md → execute TM operation
      research task? → load research-framework.md → use research-agent
      hook problem? → load hook-guide.md → troubleshooting
      normal question? → standard Claude, no extra context
  → Selected agent executes via Task() tool
  → Hooks validate handoff, collect metrics
  → Quality gate (security-compliance-agent) validates output
  → Result delivered to user
```

### How It Works (Installation)

```
npx drupal-claude-collective install --yes
  → bin/claude-code-collective.js (CLI entry point)
  → lib/installer.js (CollectiveInstaller class)
  → lib/file-mapping.js (FileMapping class — maps templates/ to target project)
  → Copies templates/ → target project (.claude/, .claude-collective/, CLAUDE.md, .mcp.json)
  → Sets executable permissions on hooks
  → Validates installation (all required files present)
```

---

## Repository Structure

```
drupal-claude-code-sub-agent-collective/
├── bin/claude-code-collective.js        # CLI entry point (npx)
├── lib/                                 # Core library
│   ├── index.js                         # Package entry
│   ├── installer.js                     # CollectiveInstaller (main install logic)
│   ├── file-mapping.js                  # FileMapping (template → target mappings)
│   ├── validator.js                     # Post-install validation
│   ├── merge-strategies.js              # Config conflict resolution
│   ├── mcp-config-manager.js            # .mcp.json generation
│   ├── command-system.js                # Command execution engine
│   ├── command-parser.js                # Natural language parsing
│   ├── AgentRegistry.js                 # Agent lifecycle management
│   ├── AgentSpawner.js                  # Dynamic agent creation
│   ├── AgentTemplateSystem.js           # Template processing
│   └── metrics/                         # Research metrics collectors
│       ├── MetricsCollector.js
│       ├── JITLoadingMetrics.js         # H1: Context efficiency
│       ├── HubSpokeMetrics.js           # H2: Coordination overhead
│       └── TDDHandoffMetrics.js         # H3: Handoff quality
│
├── templates/                           # Everything the installer copies
│   ├── CLAUDE.md                        # Behavioral OS for target project
│   ├── .claude-collective/              # Collective framework files
│   │   ├── INDEX.md                     # Agent/command index (startup)
│   │   ├── DECISION.md                  # Auto-delegation engine (startup)
│   │   ├── CLAUDE.md                    # Full collective rules (/van only)
│   │   ├── van-context.md               # Routing context (JIT)
│   │   ├── taskmaster-reference.md      # TM quick reference (JIT)
│   │   ├── research-framework.md        # Research hypotheses (JIT)
│   │   ├── hook-guide.md               # Hook troubleshooting (JIT)
│   │   ├── agents.md, hooks.md, quality.md, research.md
│   │   ├── tests/                       # Test contracts
│   │   └── metrics/                     # Usage tracking
│   ├── agents/                          # 15 agent definitions (.md, with memory + skills)
│   ├── hooks/                           # 9 hook scripts + lib/
│   │   ├── load-behavioral-system.sh    # SessionStart (18 lines)
│   │   ├── test-driven-handoff.sh       # PostToolUse/SubagentStop (172 lines)
│   │   ├── collective-metrics.sh        # PostToolUse (106 lines)
│   │   ├── block-destructive-commands.sh # PreToolUse (242 lines)
│   │   ├── block-sensitive-files.sh     # PreToolUse (220 lines)
│   │   ├── semantic-docs-update-hook.sh # PostToolUse (75 lines)
│   │   ├── pre-compact-state.sh         # PreCompact (~40 lines) NEW v2.1
│   │   ├── subagent-context-inject.sh   # SubagentStart (~60 lines) NEW v2.1
│   │   ├── teammate-quality-gate.sh     # TeammateIdle/TaskCompleted (~35 lines) NEW v2.2
│   │   └── lib/hook-utils.sh           # Shared utilities (79 lines)
│   ├── .claude/rules/                   # Auto-loaded behavioral rules (7 files) NEW v2.1+
│   ├── agent-memory/                    # Persistent agent knowledge (5 agents) NEW v2.1
│   ├── commands/                        # Slash commands
│   │   ├── van.md, autocompact.md, mock.md, etc.
│   │   └── tm/                          # 31 TaskMaster commands
│   ├── skills/                          # Claude Code skills (3 existing + 7 Drupal + 3 cross-project + 2 testing) v2.1+
│   ├── scripts/tests/                   # Test scripts directory (agent-created verification scripts)
│   ├── docs/                            # Installed documentation
│   ├── settings.json.template           # Hook configuration (8 events, 9 hooks)
│   └── settings.local.json              # Personal overrides template
│
├── .claude-collective/                  # Repo's own collective (dog-fooding)
│   ├── INDEX.md, DECISION.md            # Source of truth for templates
│   ├── van-context.md, taskmaster-reference.md, etc.
│   └── tests/, metrics/
│
├── tests/                               # Unit tests (Vitest)
│   ├── installation.test.js             # Installer tests (25)
│   ├── command-system.test.js           # Command parser tests (50)
│   ├── mcp-config.test.js              # MCP config tests (29)
│   ├── agent-lifecycle.test.js          # Agent registry tests (24)
│   ├── contracts/                       # Contract validation (9)
│   └── handoffs/                        # Handoff tests (16)
│
├── docs/                                # Project documentation
│   ├── OVERVIEW.md                      # Architecture with Mermaid diagrams
│   ├── AGENTS.md                        # Agent system details
│   ├── HOOKS.md                         # Hook system details
│   ├── INSTALLATION.md                  # Install flow diagrams
│   ├── COMMAND-SYSTEM.md                # Command parsing details
│   ├── METRICS.md                       # Research metrics
│   └── research/                        # Lullabot patterns, analysis
│
├── package.json                         # NPM package definition
├── vitest.config.js                     # Test configuration
├── README.md                            # User-facing documentation
├── CHANGELOG.md                         # Version history
└── CLAUDE.md                            # Repo's own behavioral directives
```

---

## The 15 Agents

| Category | Agent | Purpose |
|----------|-------|---------|
| **Coordination** | routing-agent | Central hub, request analysis, agent selection |
| **Core Drupal** | drupal-architect | Architecture, content modeling, module selection |
| | module-development-agent | Custom modules, DI, Entity API, services (opus model) |
| | theme-development-agent | Twig, SCSS, JS behaviors, accessibility |
| | configuration-management-agent | Config export/import, update hooks |
| | content-migration-agent | Migration plugins, ETL pipelines |
| **Quality** | security-compliance-agent | Standards, security, performance, a11y (consolidated) |
| | performance-devops-agent | Caching, optimization, CI/CD |
| **Testing** | functional-testing-agent | Behat/Playwright browser automation |
| | unit-testing-agent | PHPUnit with Drupal test base |
| | visual-regression-agent | Screenshot comparison |
| **Management** | enhanced-project-manager-agent | TaskMaster coordination, sprints |
| | research-agent | Context7 technical research |
| | workflow-agent | Multi-agent orchestration |
| | semantic-architect-agent | Knowledge Graph docs, logic-to-code mapping |

Agent definitions: `templates/agents/*.md` | Mappings: `lib/file-mapping.js:getAgentMapping()`

---

## The 9 Hooks

| Hook | Event | Lines | Purpose |
|------|-------|-------|---------|
| load-behavioral-system.sh | SessionStart | 18 | Loads INDEX.md + DECISION.md at startup, recovers compact state |
| block-destructive-commands.sh | PreToolUse | 242 | Blocks rm -rf, force push, etc. |
| block-sensitive-files.sh | PreToolUse | 220 | Blocks Read/Grep on .env, settings.php |
| collective-metrics.sh | PostToolUse | 106 | Collects routing, performance, research metrics |
| semantic-docs-update-hook.sh | PostToolUse | 75 | Reminds to update semantic docs after dev tasks |
| test-driven-handoff.sh | PostToolUse/SubagentStop | 172 | Detects handoff patterns, routes to next agent |
| pre-compact-state.sh | PreCompact | ~40 | Saves active agent/task state before context compaction |
| subagent-context-inject.sh | SubagentStart | ~60 | Validates agent name, injects recovery context + memory path |
| **teammate-quality-gate.sh** | **TeammateIdle/TaskCompleted** | ~35 | **Advisory verification reminder for agent teams (never blocks)** |
| lib/hook-utils.sh | (shared) | 79 | JSON parsing, Unicode normalization, handoff detection |

Hook templates: `templates/hooks/` | Mappings: `lib/file-mapping.js:getHookMapping()`

---

## Commands

**Routing**: `/van` (agent routing), `/mock` (testing), `/autocompact` (context save)
**Discovery**: `/discover` (docs-first codebase discovery), `/prd` (PRD generator)
**Testing**: `/drupal-verify` (verify Drupal implementations with curl smoke tests and drush eval)
**Handoff**: `/continue-handoff`, `/reset-handoff`
**Workflows**: `/implement`, `/update-docs`, `/verify-changes`
**TaskMaster** (`/tm:*`): list, show, next, add-task, expand, set-status, parse-prd, analyze-complexity, update, models, init, generate, and more (31 total)

Command templates: `templates/commands/` | Mappings: `lib/file-mapping.js:getCommandMapping()`

---

## Testing

```bash
# Run all 172 unit tests
npx vitest run

# Run specific test file
npx vitest run tests/installation.test.js

# Watch mode
npx vitest

# Run the end-to-end installation test
NODE_PATH="$(pwd)/node_modules" node /tmp/claude/test-install.js
```

Test breakdown: 25 installation + 50 command system + 29 MCP config + 24 agent lifecycle + 9 contracts + 16 handoffs + 19 misc = **172 tests**

---

## Release Process

```bash
# 1. Run tests
npx vitest run

# 2. Update version in package.json
# Edit: "version": "X.Y.Z" or "X.Y.Z-dev"

# 3. Commit
git add -A && git commit -m "X.Y.Z"

# 4. Tag
git tag vX.Y.Z

# 5. Push
git push origin main --tags

# 6. Publish to npm
npm publish                    # stable (latest tag)
npm publish --tag dev          # dev channel
```

Install: `npx drupal-claude-collective` (stable) or `npx drupal-claude-collective@dev` (dev)

---

## Key Files to Know

| When working on... | Read these first |
|---|---|
| **Installer logic** | `lib/installer.js`, `lib/file-mapping.js` |
| **What gets installed** | `templates/` directory, `lib/file-mapping.js` |
| **Hook behavior** | `templates/hooks/*.sh`, `templates/hooks/lib/hook-utils.sh` |
| **Agent definitions** | `templates/agents/*.md` (check `memory:` and `skills:` frontmatter) |
| **Behavioral rules** | `templates/.claude/rules/*.md` (auto-loaded by Claude Code, 7 files) |
| **Agent memory seeds** | `templates/agent-memory/*/MEMORY.md` |
| **Drupal skills** | `templates/skills/*/SKILL.md` |
| **Settings/config** | `templates/settings.json.template`, `templates/settings.local.json`, `lib/mcp-config-manager.js` |
| **Tests** | `tests/` directory, `vitest.config.js` |
| **CLI entry point** | `bin/claude-code-collective.js` |
| **JIT context system** | `.claude-collective/INDEX.md`, `.claude-collective/DECISION.md` |
| **Template → install mapping** | `lib/file-mapping.js` (all `get*Mapping()` methods) |

---

## v2.2 Changes from v2.1

| Metric | v2.1 | v2.2 | Change |
|--------|------|------|--------|
| Hook count | 8 | 9 | +1 (teammate-quality-gate.sh) |
| Hook events | 6 | 8 | +2 (TeammateIdle, TaskCompleted) |
| Agent teams | Not available | Enabled by default | Experimental multi-session coordination |
| Settings keys | hooks, sandbox, etc. | +env, +teammateMode | Agent teams configuration |

## v2.1 Changes from v2.0

| Metric | v2.0 | v2.1 | Change |
|--------|------|------|--------|
| CLAUDE.md startup | ~161 lines | ~96 lines | -40% (rules extracted) |
| Hook count | 6 | 8 | +2 (PreCompact, SubagentStart) |
| Hook events | 3 | 6 | +3 (PreCompact, SubagentStart, SubagentStop) |
| Drupal skills | 3 | 15 | +7 Drupal + 3 cross-project + 2 testing (drupal-testing, verification-before-completion) |
| Agents with memory | 0 | 5 | New: cross-session persistence |
| Auto-loaded rule files | 0 | 7 | New: .claude/rules/ directory (+testing-verification.md) |
| File mapping types | 9 | 12 | +rules, +agent-memory, +scripts |
| Optional MCP servers | 2 | 4 | +ddev, +sequential-thinking |

## v2.0 Changes from v1.x

| Metric | v1.x | v2.0 | Reduction |
|--------|------|------|-----------|
| Startup context | 737 lines | ~113 lines | 85% |
| test-driven-handoff.sh | 652 lines | 172 + 79 shared | 74% |
| Total hook scripts | 13 | 6 + shared lib | 54% |
| TM commands | 47 files | 31 files | 34% |
| Agent self-verification | 0/15 | 15/15 | -- |
| Doc contradictions | 6 | 0 | 100% |

**PRD**: `.taskmaster/docs/prd.txt`

**External dependencies (NOT installed by collective):**
- `agent-browser`: `npm install -g agent-browser && agent-browser install` (for agent-browser skill)
- `ddev-mcp`: DDEV add-on (for --with-ddev MCP server)
- `qmd`: Optional fast search (for discover skill, falls back to grep)
- `sequential-thinking`: Auto-installed via `npx -y` on first use (no manual setup)

---

## Design Principles

1. **Lean passive context** (Vercel pattern): INDEX.md is a compressed map, not full docs
2. **True JIT loading**: Only load what's needed when it's needed
3. **No contradictions**: If we say "only on /van", it ONLY loads on /van
4. **15 agents = 15 agents**: Dev repo meta-agents stay in dev repo, not in templates
5. **Hooks do one thing well**: No 740-line hooks. Extract shared utils into `lib/hook-utils.sh`
6. **Commands are parameterized**: One `set-status` command, not six `to-done/to-pending/...` files
7. **Self-verification**: Every agent validates its own output before completing
8. **Templates mirror repo**: `.claude-collective/` files must be synced to `templates/.claude-collective/`
9. **Rules in `.claude/rules/`** (v2.1): Topic-based files auto-loaded by Claude Code, not inline in CLAUDE.md
10. **Agent memory persists** (v2.1): `memory: project` enables cross-session knowledge accumulation
11. **Skills are shared** (v2.1): Domain knowledge extracted into SKILL.md files, referenced via `skills:` frontmatter
12. **Context compaction resilience** (v2.1): PreCompact saves state, SessionStart recovers it

---

## Detailed Documentation

| Document | What it covers |
|---|---|
| [README.md](../README.md) | User-facing: installation, agents, usage, troubleshooting |
| [CHANGELOG.md](../CHANGELOG.md) | Full version history v1.0.0 → current |
| [docs/OVERVIEW.md](OVERVIEW.md) | Architecture with Mermaid diagrams |
| [docs/AGENTS.md](AGENTS.md) | Agent lifecycle, registry, selection matrix |
| [docs/HOOKS.md](HOOKS.md) | Hook flow, TDD validation, response format (9 hooks, 8 events) |
| [docs/INSTALLATION.md](INSTALLATION.md) | Installer sequence, file mapping, merge strategies |
| [docs/COMMAND-SYSTEM.md](COMMAND-SYSTEM.md) | Command parsing, autocomplete, history |
| [docs/METRICS.md](METRICS.md) | Research metrics, 3 hypotheses, KPIs |
| [.taskmaster/docs/prd.txt](../.taskmaster/docs/prd.txt) | v2.0 Product Requirements Document |
