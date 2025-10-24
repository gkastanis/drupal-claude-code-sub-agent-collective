# Drupal Claude Code Sub-Agent Collective

## 📖 System Overview

Welcome to your Drupal Claude Code Sub-Agent Collective installation! This system provides specialized Drupal development agents with hub-and-spoke coordination for building production-ready Drupal sites.

### What Just Happened?

The collective has been installed in your project with the following components:

#### 🧠 Behavioral Operating System (`CLAUDE.md`)
This file contains the core behavioral directives that govern how the collective operates:
- **Directive 1**: Never implement directly - all work flows through agents
- **Directive 2**: Hub-and-spoke routing - all requests go through @routing-agent
- **Directive 3**: Test-driven validation - handoffs include contract validation

#### 🤖 Agent Definitions (`.claude/agents/`)
Each agent has Drupal-specific capabilities and responsibilities:
- **@routing-agent**: Central hub for semantic request analysis and routing
- **@drupal-architect**: Site architecture, content modeling, module selection
- **@module-development-agent**: Custom Drupal module implementation
- **@theme-development-agent**: Drupal themes with Twig templates
- **@security-compliance-agent**: Drupal coding standards and security validation
- **@functional-testing-agent**: Behat and Playwright testing for Drupal

#### 🪝 Hook Scripts (`.claude/hooks/`)
Enforcement mechanisms that ensure directive compliance:
- **directive-enforcer.sh**: Validates behavioral directives before tool execution
- **collective-metrics.sh**: Collects performance and research metrics
- **test-driven-handoff.sh**: Validates handoff contracts during transitions
- **routing-executor.sh**: Executes routing decisions and agent handoffs

#### 🧪 Testing Framework (`.claude-collective/`)
Complete testing system for validating collective behavior:
- **Jest configuration**: Set up for contract validation testing
- **Test contracts**: Templates for handoff validation
- **Metrics collection**: Research data gathering

## 🚀 Getting Started

### 1. Restart Claude Code
**IMPORTANT**: Restart Claude Code to activate the hook system and agents.

### 2. Test the Installation
Try these commands to verify everything works:

```bash
# Check status
npx drupal-claude-collective status

# Validate installation
npx drupal-claude-collective validate
```

### 3. Try Agent Routing
In Claude Code, try a request like:
> "Route this through @routing-agent to create a custom block plugin showing recent articles"

## 🎯 How to Use the Collective

### Making Requests
Instead of asking Claude directly, route requests through agents:

**❌ Old Way (Direct):**
> "Create a custom field widget"

**✅ New Way (Agent Routed):**
> "Route to @routing-agent: Create a custom field widget for date ranges with Drupal Form API"

### Understanding Agent Routing
The @routing-agent will analyze your request and select the best Drupal agent:
- **Module development tasks** → @module-development-agent
- **Theme development tasks** → @theme-development-agent
- **Testing tasks** → @functional-testing-agent
- **Architecture/planning tasks** → @drupal-architect
- **Security/standards validation** → @security-compliance-agent

### Monitoring Activity
- **Metrics**: Check `.claude-collective/metrics/` for performance data
- **Logs**: Review `/tmp/collective-*.log` for detailed activity
- **Status**: Run `npx drupal-claude-collective status` for health check

## 📊 Research Framework

This collective is designed to prove three key hypotheses:

### H1: JIT Context Loading
**Theory**: Loading context on-demand is more efficient than pre-loading
**Measurement**: Context size, token reduction, load times
**Goal**: >30% reduction in token usage

### H2: Hub-and-Spoke Coordination  
**Theory**: Central routing outperforms peer-to-peer communication
**Measurement**: Routing accuracy, coordination overhead, violations
**Goal**: >95% routing compliance

### H3: Test-Driven Handoffs
**Theory**: Contract-based handoffs improve quality
**Measurement**: Handoff success rates, test pass rates, retry counts
**Goal**: >98% handoff success rate

## 🛡️ Behavioral Directives

The collective enforces three prime directives through hooks:

### Directive 1: Never Implement Directly
- All implementation must flow through specialized agents
- Direct coding by the hub controller is blocked
- Violations trigger re-routing to @routing-agent

### Directive 2: Collective Routing Protocol
- All requests enter through @routing-agent
- No direct agent-to-agent communication allowed
- Hub-and-spoke pattern strictly maintained

### Directive 3: Test-Driven Validation
- Handoffs require test contracts with pre/post conditions
- Failed validation triggers automatic re-routing
- Quality gates ensure delivery standards

## 🔧 Configuration

### Hook Configuration (`.claude/settings.json`)
Controls when and how hooks execute:
- **PreToolUse**: Validates directives before tool execution
- **PostToolUse**: Collects metrics and validates results
- **SubagentStop**: Ensures proper handoff validation

### Agent Configuration (`.claude/agents/*.json`)
Each agent definition includes:
- **Capabilities**: What the agent can do
- **Tools**: Which Claude Code tools they can access
- **Specialization**: Their primary focus area
- **Fallbacks**: Alternative agents if unavailable

### Testing Configuration (`.claude-collective/`)
Jest-based testing framework:
- **Contract templates**: Pre-built validation patterns
- **Test suites**: Handoff, directive, and contract tests
- **Coverage reporting**: Quality metrics and reporting

## 🚨 Important Notes

### System Behavior Changes
With the collective active, Claude Code will behave differently:
- **Routing Required**: Direct implementation requests may be blocked
- **Hook Validation**: Actions are validated before execution
- **Metrics Collection**: Performance data is automatically gathered
- **Quality Gates**: Failed handoffs trigger retries or escalation

### Troubleshooting
If something isn't working:
1. **Restart Claude Code** - Hooks need to be reloaded
2. **Check Status** - Run `npx drupal-claude-collective status`
3. **Validate Installation** - Run `npx drupal-claude-collective validate`
4. **Review Logs** - Check `/tmp/collective-*.log` files
5. **Repair Installation** - Run `npx drupal-claude-collective repair`

### Getting Help
- **Status Command**: `npx drupal-claude-collective status`
- **Validation**: `npx drupal-claude-collective validate`
- **Repair**: `npx drupal-claude-collective repair`
- **Documentation**: Review the files in `.claude/docs/`

## 🔬 Research Participation

By using this collective, you're participating in research on:
- **Multi-agent coordination patterns**
- **Context engineering efficiency** 
- **Test-driven development practices**
- **Behavioral enforcement systems**

Metrics are collected automatically (no personal data) to validate the research hypotheses.

## 🎯 Quick Reference

### Essential Commands
```bash
# Check collective health
npx drupal-claude-collective status

# Validate everything is working
npx drupal-claude-collective validate

# Fix problems
npx drupal-claude-collective repair

# Remove collective
npx drupal-claude-collective clean
```

### Agent Routing Examples
```
"@routing-agent please create a custom block plugin showing recent articles"
"Route to appropriate agent: implement a custom field widget for entity references"
"@routing-agent create an event registration system with Webform integration"
"Route to @drupal-architect: design content model for a member directory"
```

### File Structure
```
.claude/
├── settings.json        # Hook configuration
├── agents/             # Agent definitions  
├── hooks/              # Enforcement scripts
└── docs/               # This documentation

.claude-collective/
├── tests/              # Contract validation
├── metrics/            # Research data
└── package.json        # Testing framework
```

---

**Welcome to the future of Drupal development with AI!** 🚀

The collective is now active and ready to coordinate your Drupal development through intelligent agent routing, coding standards validation, and security compliance.