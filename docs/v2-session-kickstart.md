# v2.0 Overhaul - Session Kickstart

Use this document to initialize a new Claude Code session for working on the v2.0 overhaul.

**Copy-paste this entire document as your first message in a new session.**

---

## Project Context

You are working on `drupal-claude-code-sub-agent-collective` (v1.8.5 -> v2.0.0), an NPM package that installs 15 Drupal-specialized agents into Claude Code projects.

**PRD**: `.taskmaster/docs/prd.txt`
**Tasks**: `.taskmaster/tasks/tasks.json` (11 tasks, managed via TaskMaster MCP)
**Insights Report**: `~/.claude/usage-data/report.html` (150 sessions analyzed, findings integrated into tasks)

## The Problem (Why v2.0)

The current system has critical issues discovered through research and usage analysis:

1. **Context bloat**: 737 lines loaded on EVERY session via startup hook. Only ~120 needed.
2. **Fake JIT**: Claims "JIT context loading" but pre-loads everything unconditionally.
3. **Agent proliferation**: 29 agent defs in dev repo, only 15 installed to users.
4. **6 contradictions**: Documentation claims don't match actual behavior.
5. **Hook complexity**: `test-driven-handoff.sh` is 740 lines. Should be ~200.
6. **Command redundancy**: 47 TM commands with 6 nearly identical status files.

## v2.0 Goals

| Metric | v1.x | Target | Achieved |
|--------|------|--------|----------|
| Always-loaded context | 737 lines | <150 lines | ~95 lines (INDEX.md + DECISION.md) |
| Agent definitions | 29 | 15 | 15 (validated) |
| Hook: test-driven-handoff.sh | 652 lines | ~200 lines | 172 lines + 79-line utils |
| Hook: load-behavioral-system.sh | 49 lines | ~20 lines | 18 lines |
| Commands | 47 | ~20-26 | 31 (34% reduction) |
| Contradictions | 6 | 0 | 0 (DECISION.md rewritten) |
| Behavioral rules from usage data | 0 | 6 (in INDEX.md) | 6 |
| Workflow skills | 0 | 3 | 0 (Task 11 pending) |

## Progress

### Completed (6/11 tasks)

**Task 1: Create lean INDEX.md and context loading infrastructure** -- DONE
- Created `.claude-collective/INDEX.md` (60 lines) -- compressed agent/command index + 6 behavioral rules
- Created `.claude-collective/van-context.md` (69 lines) -- routing context, loaded only on `/van`
- Created `.claude-collective/taskmaster-reference.md` (90 lines) -- TM quick ref, JIT loaded
- Created `.claude-collective/research-framework.md` (56 lines) -- research hypotheses, JIT loaded
- Created `.claude-collective/hook-guide.md` (26 lines) -- hook troubleshooting, JIT loaded
- Updated `CLAUDE.md` to import only INDEX.md + DECISION.md (removed .taskmaster/CLAUDE.md import)
- **Result**: Startup context reduced from 737 to ~101 lines (86% reduction)

**Task 2: Rewrite load-behavioral-system.sh** -- DONE
- Rewrote startup hook from ~49 lines to 18 lines
- Loads only INDEX.md + DECISION.md (~95 lines of content)
- Updated branding to v2.0.0
- Updated both `.claude/hooks/` and `templates/hooks/` versions

**Task 3: Update DECISION.md with DDC-style decision tree** -- DONE
- Replaced overlapping ROUTING DECISIONS + CONTEXT LOADING RULES sections
- Added explicit IF/THEN decision tree with "first match wins" semantics
- Explicitly states "Nothing loads at startup except this file and INDEX.md"
- Fixes contradictions 1-4 from PRD
- **Result**: 44 lines, clear top-to-bottom evaluation

**Task 4: Consolidate 29 agents to 15 production agents** -- DONE
- Validated: exactly 15 agents in `templates/agents/`, `lib/file-mapping.js`, and `INDEX.md`
- No changes needed -- already in correct state from prior work

**Task 5: Simplify test-driven-handoff.sh** -- DONE
- Created `.claude/hooks/lib/hook-utils.sh` (79 lines) -- shared JSON parsing, Unicode normalization, handoff detection
- Refactored `test-driven-handoff.sh` from 652 to 172 lines (74% reduction)
- Preserved: handoff detection, TDD checkpoint, Unicode normalization, hub return logic
- Removed: redundant validation functions, duplicate JSON parsing, verbose quality scoring
- Updated both `.claude/hooks/` and `templates/hooks/` versions
- `bash -n` syntax check passes

**Task 8: Consolidate TaskMaster commands from 47 to 31** -- DONE
- 6 status commands -> 1 parameterized `set-status.md`
- Consolidated: init (2->1), parse-prd (2->1), list (3->1), expand (2->1), workflows (3->1), setup (2->1), update (3->1), models (2->1)
- Updated `lib/file-mapping.js` tmCommands array (47->31 entries)
- Deleted 24 redundant command files
- `taskmaster-reference.md` already aligned with new structure

### Ready to Start (unblocked, can run in parallel)

**Task 6: Simplify collective-metrics.sh** [MED, deps: 5 DONE]
- Refactor from 270 to ~100 lines using hook-utils.sh
- Add metrics rotation (keep 30 sessions, archive older)

**Task 9: Apply Lullabot checklists to Drupal agents** [MED, deps: 4 DONE]
- Add 5-10 item self-verification checklist to each of 15 agents

**Task 11: Create workflow skills** [MED, deps: 1 DONE, 8 DONE]
- `/implement` - plan-then-execute with verification pass
- `/update-docs` - documentation sync against recent commits
- `/verify-changes` - post-implementation grep for missed references

### Blocked (waiting on dependencies)

**Task 7: Remove redundant hooks + add php-lint** [MED, deps: 2 DONE, 5 DONE, 6 pending]
- Remove `directive-enforcer.sh` and `routing-executor.sh`
- Add postToolUse php-lint hook for PHP syntax checking
- **Only blocked on Task 6 now**

**Task 10: Update docs + prepare v2.0.0 release** [HIGH, deps: 2,3,4,7,8,9,11]
- Update package.json, CHANGELOG, README, USER-GUIDE
- Run full test suite, final validation
- **Blocked on: 7, 9, 11**

## Task Dependency Graph

```
Task 1: Create INDEX.md + JIT infrastructure [DONE]
    |-- Task 2: Rewrite startup hook [DONE]
    |       '-- Task 7: Remove redundant hooks + php-lint [blocked on 6]
    |-- Task 3: Update DECISION.md [DONE]
    |-- Task 4: Consolidate 29->15 agents [DONE]
    |       '-- Task 9: Apply Lullabot checklists [READY]
    |-- Task 5: Simplify test-driven-handoff.sh [DONE]
    |       '-- Task 6: Simplify collective-metrics.sh [READY]
    |               '-- Task 7: (also depends on 6)
    |-- Task 8: Consolidate 47->31 commands [DONE]
    |       '-- Task 11: Create workflow skills [READY]
    '-- (Task 11 also depends on Task 1)

Task 10: Final docs + v2.0.0 release [blocked on 7,9,11]
```

## Key File Locations

```
# v2.0 files (completed)
.claude-collective/INDEX.md                 # Compressed agent/command index + behavioral rules (60 lines)
.claude-collective/DECISION.md              # DDC-style decision tree (44 lines)
.claude-collective/van-context.md           # Routing context, loaded on /van only (69 lines)
.claude-collective/taskmaster-reference.md  # TM quick reference, JIT loaded (90 lines)
.claude-collective/research-framework.md    # Research hypotheses, JIT loaded (56 lines)
.claude-collective/hook-guide.md            # Hook troubleshooting, JIT loaded (26 lines)

# Hooks (updated)
.claude/hooks/load-behavioral-system.sh     # v2.0 startup hook (18 lines)
.claude/hooks/test-driven-handoff.sh        # Refactored handoff hook (172 lines)
.claude/hooks/lib/hook-utils.sh             # Shared hook utilities (79 lines)
.claude/hooks/collective-metrics.sh         # 270 lines - simplifying in Task 6
.claude/hooks/block-destructive-commands.sh # 188 lines (keep as-is)
.claude/hooks/directive-enforcer.sh         # Removing in Task 7
.claude/hooks/routing-executor.sh           # Removing in Task 7

# v1.x files (still present, cleanup in later tasks)
.claude-collective/CLAUDE.md                # v1 behavioral rules - to be replaced
.claude-collective/agents.md                # v1 agent catalog - to be replaced
.claude-collective/quality.md               # v1 QA standards - absorbed into INDEX.md
.claude-collective/research.md              # v1 research framework - replaced
.claude-collective/hooks.md                 # v1 hook guide - replaced
.taskmaster/CLAUDE.md                       # TM full guide - replaced by taskmaster-reference.md

# Infrastructure
lib/file-mapping.js                         # Agent/hook/command template mappings (updated)
templates/agents/                           # 15 agent templates (validated)
templates/commands/tm/                      # 31 command templates (consolidated from 47)
templates/hooks/                            # Hook templates (updated)
templates/hooks/lib/hook-utils.sh           # Shared utils template (new)
docs/research/                              # Lullabot research, comparison analysis
```

## How to Work

1. Run `task-master list` or use MCP `mcp__task-master__get_tasks` to see current status
2. Run `task-master next` to get the next available task
3. Use `task-master show <id>` for full task details including test strategy
4. Set status: `task-master set-status --id=<id> --status=in-progress`
5. When done: `task-master set-status --id=<id> --status=done`
6. After completing a task, check what's unblocked and pick the next one
7. Tasks 6, 9, 11 are all independent -- can run in parallel

## Design Principles for v2.0

- **Lean passive context** (Vercel pattern): INDEX.md is a compressed map, not full docs
- **True JIT loading**: Only load what's needed when it's needed
- **No contradictions**: If we say "only on /van", it must ONLY load on /van
- **15 agents = 15 agents**: Dev repo meta-agents stay in dev repo, not in templates
- **Hooks do one thing well**: No 740-line hooks. Extract shared utils.
- **Commands are parameterized**: One `set-status` command, not six `to-done/to-pending/...` files
