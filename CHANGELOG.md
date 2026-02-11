# Changelog

All notable changes to the Drupal Claude Code Sub-Agent Collective.

## [Unreleased]

### Added
- **3 new skills**: `agent-browser` (CLI browser automation with DDEV integration), `discover` (docs-first codebase discovery with scripts), `prd` (Drupal-adapted PRD generator with user stories).
- **2 new testing skills**: `drupal-testing` (curl smoke tests, drush eval patterns, test script templates) and `verification-before-completion` (5-step verification gate preventing unverified completion claims).
- **`testing-verification.md` auto-loaded rule**: Enforces verify-before-completion behavior on every turn - preferred methods, script storage rules, drush eval escaping.
- **`/drupal-verify` command**: On-demand Drupal implementation verification using curl smoke tests and drush eval checks.
- **`scripts/tests/` directory convention**: Standard location for agent-created verification scripts with `index.md` seed file.
- **2 new MCP servers**: `ddev` (database queries, container management via `ddev-mcp`) and `sequential-thinking` (structured problem decomposition via `@modelcontextprotocol/server-sequential-thinking`).
- **CLI flags**: `--with-ddev` and `--with-sequential-thinking` for selective MCP server inclusion.
- Agent skills frontmatter updates: `functional-testing-agent` and `visual-regression-agent` get `agent-browser`; `drupal-architect` and `semantic-architect-agent` get `discover`; `enhanced-project-manager-agent` gets `prd`.
- Testing skills added to 4 core agents: `module-development-agent`, `drupal-architect`, `configuration-management-agent`, `theme-development-agent` all get `drupal-testing` and `verification-before-completion`.
- `/discover` added as recommended first step in `templates/CLAUDE.md` before Glob/Grep.
- Discovery commands section added to `INDEX.md`: `/discover` and `/prd`.
- Testing commands section added to `INDEX.md`: `/drupal-verify`.
- Behavioral rule #5 added to `INDEX.md`: verify before completion.

### Changed
- `module-development-agent` model upgraded from sonnet to opus.
- Skill count: 10 → 15 (7 new file mapping entries, 6 new installer directories).
- Rule count: 6 → 7 (+testing-verification.md).
- File mapping types: 11 → 12 (+scripts).
- Optional MCP servers: 2 → 4 (existing: playwright, context7; new: ddev, sequential-thinking).
- MCP config profile logic updated for 4+ optional servers.
- Full-config resource estimate: ~250MB → ~275MB (5 servers instead of 3).
- Updated README.md: installation options, MCP table, file tree, upgrading section, agent skills.
- Updated docs/v2-session-kickstart.md: skill count, MCP count, commands section, repo tree, agents table.

### Fixed
- 3 MCP config tests updated for new server count and resource calculations.

### Verified
- All 172 unit tests pass.

### Note on external dependencies
- `agent-browser`: Requires `npm install -g agent-browser && agent-browser install` on host. Skill works inside DDEV.
- `ddev-mcp`: Requires DDEV MCP server installed (`ddev-mcp` command available). Auto-detects project from `.ddev/config.yaml`.
- `qmd` (used by discover): Optional. Discovery falls back gracefully to grep-based search when not available.
- `sequential-thinking`: Installed automatically via `npx -y` on first use (no manual setup).

## [2.0.0-dev] - 2025-02-11

### Fixed
- **Installation completeness**: Synced v2.0 templates and file mappings so the installer produces a complete v2.0 setup. Previously 7/21 installation checks failed because new files (INDEX.md, JIT context files) and restructured hooks were only in the repo root, not in `templates/`.
- Added 5 missing JIT context files to `templates/.claude-collective/`: INDEX.md, van-context.md, taskmaster-reference.md, research-framework.md, hook-guide.md.
- Updated `templates/.claude-collective/DECISION.md` from v1.0 (simple routing) to v2.0 (dual auto-delegation with NEXT_ACTION.json, Unicode normalization, full routing decision tree).
- Added 7 missing entries to `lib/file-mapping.js`: 5 collective files + test-driven-handoff.sh + lib/hook-utils.sh.
- Added INDEX.md and DECISION.md import references to `templates/CLAUDE.md`.

### Verified
- All 172 unit tests pass.
- Installation test: 21/21 checks pass.

## [2.0.0] - 2025-02-10

### Changed - Major Overhaul
- **~60% hook code reduction**: Refactored hooks with shared utility library (`lib/hook-utils.sh`). Extracted JSON parsing, Unicode normalization, and handoff detection into reusable functions.
- **~70% /tm command reduction**: Consolidated 47 TaskMaster command files down to 31 through unified skill architecture.
- **JIT Context Loading (validated)**: Startup context reduced from ~500 lines to ~113 lines (INDEX.md + DECISION.md only). All other context loaded on-demand via DECISION.md routing tree.
- **Dual auto-delegation system**: DECISION.md-based handoff detection + hook-based agent handoff processing with Unicode normalization.
- **Compressed INDEX.md**: Single 62-line file replaces multiple startup files, containing agent catalog, command reference, JIT triggers, behavioral rules, and quality standards.

### Added
- `INDEX.md` - Compressed agent/command index with behavioral rules (loaded at startup).
- `DECISION.md` v2.0 - Global decision engine with dual auto-delegation infrastructure.
- `van-context.md` - Routing context, loaded JIT on `/van` command only.
- `taskmaster-reference.md` - TaskMaster quick reference, loaded JIT on `/tm:*` commands.
- `research-framework.md` - Research hypotheses and metrics, loaded JIT on research tasks.
- `hook-guide.md` - Hook troubleshooting guide, loaded JIT on hook debugging.
- `lib/hook-utils.sh` - Shared hook utilities for all hook scripts.
- 3 new workflow skills: `/implement`, `/update-docs`, `/verify-changes`.

## [1.8.5] - 2025-02-09

### Added
- Inter-agent delegation capabilities for complex multi-step workflows.
- Self-verification checklists for all 15 agents to validate their own output quality.

## [1.8.4] - 2025-02-08

### Added
- Lullabot best practices integrated into agent templates.
- Enhanced Drupal coding patterns based on enterprise development experience.

## [1.8.3] - 2025-02-07

### Removed
- claude-mem integration removed (not production ready). Memory features deferred to future release.

## [1.8.2] - 2025-02-06

### Added
- Drupal branding throughout installer UX (splash screen, messaging).
- Improved installer user experience with clearer progress indicators.

### Fixed
- Repository name corrections in package.json and README (community PR by @theodorosploumis).

## [1.8.1] - 2025-02-05

### Fixed
- Consolidated force overwrite prompts into single menu to reduce installer friction.
- Applied npm pkg fix corrections.

## [1.8.0] - 2025-02-04

### Added
- Native sandboxing support for safer autonomous agent execution.
- `autoAllowBashIfSandboxed` setting for fewer permission prompts.
- Docker/ddev excluded from sandbox (incompatible).
- `/setup-sandbox` command for Drupal-specific sandboxing guidance.

## [1.7.1] - 2025-02-03

### Changed
- Updated CHANGELOG and README with recent release documentation.

## [1.7.0] - 2025-02-02

### Added
- `/setup-memory` command for claude-mem integration (later removed in 1.8.3).

## [1.6.2] - 2025-02-01

### Added
- `condition-based-waiting` skill: Replace arbitrary sleeps with condition polling for reliable tests.
- `git-advanced-workflows` skill: Rebase, cherry-pick, bisect, worktrees, and reflog recovery.

## [1.6.1] - 2025-01-31

### Added
- `semantic-docs` skill for business-logic-to-code navigation.
- Scripts: find-feature.sh, find-logic-id.sh, trace-code.sh, find-entity.sh, find-user-story.sh, list-features.sh.

## [1.6.0] - 2025-01-30

### Changed
- Slimmed CLAUDE.md with progressive disclosure patterns.
- Reduced initial context load while maintaining full capability on demand.

## [1.5.2] - 2025-01-29

### Fixed
- Removed redundant comment line in CLAUDE.md template.

## [1.5.1] - 2025-01-29

### Fixed
- Restored essential Complexity Assessment and Routing section to CLAUDE.md that was accidentally removed during slimming.

## [1.5.0] - 2025-01-28

### Added
- Rich Hickey and Eskil Steenberg architecture principles integrated into CLAUDE.md.
- Module design guidelines: one module = one purpose, black box interfaces, no direct class dependencies.

## [1.4.0] - 2025-01-27

### Added
- Enhanced semantic-architect documentation quality with human review warnings.
- Code structure visualization in semantic docs.
- Post-task update hooks for semantic documentation.

## [1.3.0] - 2025-01-26

### Added
- Selective MCP server configuration in `.mcp.json`.
- Playwright opt-out by default (prevents zombie processes on Linux).
- Context7 opt-in via `--with-context7` flag.
- Resource usage documentation per MCP configuration.

## [1.2.2] - 2025-01-25

### Fixed
- Tool invocation syntax in semantic-architect-agent Research and Analysis Process.

## [1.2.1] - 2025-01-25

### Fixed
- YAML syntax error in semantic-architect-agent frontmatter.

## [1.2.0] - 2025-01-24

### Added
- semantic-architect-agent for Knowledge Graph documentation.
- Maps business logic to code: User Stories -> Logic IDs -> Source Code.
- Entity schema generation for Drupal content types.

## [1.1.1] - 2025-01-23

### Added
- Comprehensive Context7 MCP documentation for Drupal development.

### Fixed
- Installation path resolution improvements.

## [1.1.0] - 2025-01-22

### Changed
- Comprehensive Drupal rebranding from generic sub-agent collective.
- All agents updated with Drupal-specific knowledge and patterns.
- CLI branding reflects Drupal focus.
- Templates replaced: React/Vite examples -> Drupal custom entity examples.

## [1.0.4] - 2025-01-21

### Added
- Enhanced agent consistency across all 15 agents.
- Drupal best practices enforcement in agent templates.

## [1.0.3] - 2025-01-20

### Fixed
- Missing block-sensitive-files hook added to settings.json template.

## [1.0.2] - 2025-01-19

### Fixed
- README documentation corrections (hook list, support links).
- Test suite compatibility with streamlined agent set.

## [1.0.1] - 2025-01-18

### Added
- Comprehensive hook system: block-destructive-commands, block-sensitive-files, collective-metrics, load-behavioral-system, semantic-docs-update-hook.
- Sensitive file protection for .env, settings.php, credential files.

## [1.0.0] - 2025-01-17

### Added
- Initial Drupal-focused release.
- 15 specialized agents (streamlined from 47 in the original project - 68% reduction).
- Consolidated quality validation via security-compliance-agent.
- Hub-and-spoke coordination architecture.
- NPX installer with express, minimal, and interactive modes.
- Task Master MCP integration.
- Adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective).
