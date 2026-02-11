# Sticky Agent Routing for Follow-Up Messages

**Status**: DEFERRED - Future implementation
**Research Date**: 2025-12-18
**Priority**: Medium

---

## Problem Statement

When user sends follow-up messages after `/van` routes to an agent:
1. First message routes correctly to specialized agent
2. Agent completes and returns result to main Claude
3. User sends follow-up → treated as "normal question" (DECISION.md line 26)
4. Follow-up goes to plain Claude, not back to the agent

**Root Cause**: DECISION.md says "For normal questions: Use standard Claude behavior"

---

## Proposed Solution: Active Session Tracking

Track which agent session is "active" and route follow-ups to that agent until the session ends.

### New File: `.claude/handoff/ACTIVE_SESSION.json`

```json
{
  "timestamp": "2025-12-18T10:30:00Z",
  "agent": "module-development-agent",
  "original_task": "build a custom block",
  "status": "active",
  "is_implementation_agent": true
}
```

**Session ends when:**
- User says `/done` (explicit end)
- Agent hands off to non-implementation agent
- User starts new `/van` request (replaces session)

### Modified Logic in DECISION.md

```
Before "For normal questions":
1. CHECK ACTIVE SESSION: Read `.claude/handoff/ACTIVE_SESSION.json` if exists
2. IF active session exists AND not expired:
   - Re-route to the same agent with follow-up context
3. ELSE: Use standard Claude behavior
```

---

## Files to Modify (When Implementing)

| File | Changes |
|------|---------|
| `.claude-collective/DECISION.md` | Add active session check logic |
| `.claude/hooks/test-driven-handoff.sh` | Create ACTIVE_SESSION.json on agent delegation |
| `.claude/commands/done.md` | **NEW** - End session command |
| `.claude/commands/van.md` | Document session behavior |
| `templates/` versions | Same changes for template distribution |

---

## Implementation Steps

### Step 1: Update DECISION.md (add session check)

Add before line 24:
```markdown
#### 3. ACTIVE SESSION ROUTING (Follow-Up Messages)
**Before applying "normal question" handling:**
1. **CHECK ACTIVE SESSION**: Read `.claude/handoff/ACTIVE_SESSION.json` if exists
2. **VALIDATE**: Check if agent is implementation type
3. **RE-ROUTE**: If active implementation session, delegate follow-up to same agent with context:
   - Include original task context
   - Include agent's previous output summary
   - Let agent continue the conversation
4. **FALLBACK**: If no active session, use standard Claude behavior
```

### Step 2: Update test-driven-handoff.sh

Add function to manage session:
```bash
IMPLEMENTATION_AGENTS="module-development-agent|theme-development-agent|component-implementation-agent|feature-implementation-agent|infrastructure-implementation-agent|testing-implementation-agent|configuration-management-agent|content-migration-agent|performance-devops-agent|drupal-architect"

# On agent delegation (before Task call)
create_active_session() {
  local agent_name=$1
  local task_description=$2
  local is_impl="false"
  if echo "$agent_name" | grep -qE "^($IMPLEMENTATION_AGENTS)$"; then
    is_impl="true"
  fi
  echo "{\"timestamp\": \"$(date -Iseconds)\", \"agent\": \"$agent_name\", \"original_task\": \"$task_description\", \"status\": \"active\", \"is_implementation_agent\": $is_impl}" > .claude/handoff/ACTIVE_SESSION.json
}

# On explicit /done command
clear_active_session() {
  rm -f .claude/handoff/ACTIVE_SESSION.json
}
```

### Step 3: Add `/done` command

New file: `.claude/commands/done.md`
```markdown
# /done - End Active Agent Session

Clear the active session and return to standard routing.

1. Remove `.claude/handoff/ACTIVE_SESSION.json`
2. Confirm session ended
3. Ready for new `/van` request
```

---

## Design Decisions

1. **Session TTL**: No auto-expire - sessions persist until explicit `/done` command
2. **Agent Scope**: Implementation agents only (not research agents)

**Implementation Agents (sticky routing enabled):**
- module-development-agent
- theme-development-agent
- component-implementation-agent
- feature-implementation-agent
- infrastructure-implementation-agent
- testing-implementation-agent
- configuration-management-agent
- content-migration-agent
- performance-devops-agent
- drupal-architect

**Non-sticky Agents (one-shot, no session):**
- research-agent
- security-compliance-agent
- quality-agent

---

## Tradeoff Analysis

### What You WIN

| Benefit | Why It Matters |
|---------|----------------|
| **Seamless follow-ups** | "add caching too" just works without re-routing |
| **Context retention** | Agent remembers what it was building |
| **Natural workflow** | Feels like working with one person, not re-explaining |
| **Fewer /van calls** | Start once, iterate many times |

### What You LOSE

| Cost | Impact |
|------|--------|
| **Must remember /done** | If you forget, unrelated messages go to wrong agent |
| **Wrong routing sticks** | If initial routing was bad, follow-ups go to wrong agent too |
| **Complexity** | More state to manage, more potential bugs |
| **Forced context** | Agent might try to relate unrelated follow-up to old task |

### Risk Scenario

```
User: "/van design event system"          → drupal-architect (correct)
Agent: *designs architecture*
User: "what's the weather today?"         → drupal-architect (WRONG - should be plain Claude)
Agent: *confused, tries to relate weather to Drupal*
```

### Mitigation Options (Future Consideration)

1. **Smart detection**: If follow-up seems unrelated, don't route (harder to implement)
2. **Timeout**: Session expires after X minutes of inactivity
3. **Keyword escape**: Certain phrases bypass sticky routing ("hey claude", "quick question")

---

## Alternative Considered

**Option B: Require explicit `/continue`**
- User must say `/continue` to resume agent
- Simpler but more friction

**Rejected because**: User's original complaint is about seamless flow being broken

---

## Testing (When Implemented)

Add test cases to `tests/handoffs/agent-handoff.test.js`:
- Session created on agent delegation
- Session persists across messages
- Session cleared on agent completion
- Follow-up routes to same agent
- Expired session falls back to Claude

---

*Document created from routing research session - ready for future implementation*
