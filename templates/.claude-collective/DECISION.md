# Global Decision Engine (Always Active)

## AUTO-DELEGATION INFRASTRUCTURE

### DUAL AUTO-DELEGATION SYSTEM
**Two complementary systems handle different handoff trigger points:**

#### 1. MY HANDOFF MESSAGES (DECISION.md logic)
**MANDATORY BEHAVIORAL REQUIREMENT**: On every turn, BEFORE ANY OUTPUT:
1. **CHECK CONTEXT FILE**: Read `.claude/handoff/NEXT_ACTION.json` if exists
2. **EXECUTE DELEGATION**: If file exists with `"action": "delegate"`, use Task tool immediately and delete file
3. **CHECK MY MESSAGE**: Did my previous message end with handoff pattern: `Use the ([a-z0-9-]+) subagent to .+`
4. **NORMALIZE**: Convert Unicode dashes `‑–—−` to `-` before pattern matching
5. **AUTO-DELEGATE**: If pattern found, use Task tool with extracted agent name and STOP
6. **NO ANALYSIS**: Never add explanations, summaries, or behavioral rule loading when auto-delegating
7. **IMMEDIATE EXECUTION**: This takes precedence over all other behavior

#### 2. AGENT HANDOFF MESSAGES (Hook system)
**Handled by hooks (.claude/hooks/test-driven-handoff.sh):**
- Hooks detect handoff patterns in agent completions
- Hooks emit Task() calls automatically with Unicode normalization
- No manual intervention needed

## ROUTING DECISION TREE

Evaluate top-to-bottom. First match wins. Nothing loads at startup except this file and INDEX.md.

IF: Auto-delegation triggered (steps 1-7 above)
  THEN: Execute Task() immediately. Load nothing else. STOP.

IF: `/van` command used
  THEN: Load `van-context.md` for routing matrices and agent details. Route to specialized agent.

IF: TaskMaster command invoked (`/tm:*` or MCP task-master tools)
  THEN: Load `taskmaster-reference.md` on demand for command reference.

IF: Research or analysis request
  THEN: Load `research-framework.md`. Use research-agent.

IF: Hook debugging needed
  THEN: Load `hook-guide.md` for troubleshooting procedures.

IF: Semantic docs task
  THEN: Check `docs/semantic/00_BUSINESS_INDEX.md` for logic-to-code mappings.

IF: Normal conversation (no triggers above)
  THEN: Use standard Claude behavior. No additional context loaded.

---
*Decision logic only. Agent catalog, behavioral rules, and JIT triggers are in INDEX.md.*
