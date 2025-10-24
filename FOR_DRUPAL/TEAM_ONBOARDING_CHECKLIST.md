# Team Onboarding Checklist - Drupal Sub-Agent Collective

Use this checklist when onboarding your agency team to the Drupal Sub-Agent Collective system.

## Pre-Onboarding (Team Lead)

### Repository Setup
- [ ] Fork https://github.com/vanzan01/claude-code-sub-agent-collective
- [ ] Replace `.claude/CLAUDE.md` with Drupal version
- [ ] Replace `README.md` with Drupal version
- [ ] Add all documentation to `docs/` directory
- [ ] Add Drupal examples to `examples/drupal/`
- [ ] Update `.gitignore` for Drupal projects
- [ ] Add agency-specific customizations
- [ ] Test on sample Drupal project
- [ ] Document any agency-specific workflows
- [ ] Make repository accessible to team

### Infrastructure Setup
- [ ] Set up shared development environments (if applicable)
- [ ] Configure CI/CD for testing (if applicable)
- [ ] Set up monitoring/analytics (optional)
- [ ] Create internal wiki/documentation
- [ ] Prepare training materials

## Individual Team Member Setup (30-45 minutes)

### Prerequisites Check
- [ ] Claude Code CLI installed and authenticated
- [ ] Node.js 18+ installed (`node --version`)
- [ ] PHP 8.1+ installed (`php --version`)
- [ ] Composer installed (`composer --version`)
- [ ] Git configured with your credentials
- [ ] Access to agency's Drupal projects
- [ ] Code editor setup (VS Code, PhpStorm, etc.)

### Installation Steps

#### 1. Clone Repository (5 min)
- [ ] Clone the agency's fork: `git clone [REPO_URL]`
- [ ] Read `README.md` for overview
- [ ] Read `docs/QUICK_START.md` for setup guide

#### 2. Install MCP Servers (10 min)
```bash
# Task Master
- [ ] Run: claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
- [ ] Verify: claude mcp list | grep task-master

# Playwright
- [ ] Run: claude mcp add playwright -s user -- npx -y playwright-mcp-server
- [ ] Run: npx playwright install
- [ ] Verify: claude mcp list | grep playwright
```

#### 3. Setup Test Drupal Project (10 min)
```bash
# Navigate to a test Drupal site
- [ ] cd /path/to/test/drupal/site

# Install dev tools
- [ ] composer require --dev drupal/coder phpstan/phpstan
- [ ] ./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
- [ ] ./vendor/bin/phpcs -i  # Verify Drupal standards available

# Copy/link CLAUDE.md
- [ ] mkdir -p .claude
- [ ] cp /path/to/fork/.claude/CLAUDE.md .claude/

# Initialize Task Master
- [ ] npx task-master-ai init
- [ ] npx task-master-ai models --setMain claude-code/sonnet
- [ ] ls -la .task-master/  # Verify created
```

#### 4. Verify Setup (10 min)
```bash
# Test MCP connections
- [ ] claude mcp list  # Should show task-master and playwright

# Test Drupal commands
- [ ] drush status  # Should show Drupal site info
- [ ] composer validate  # Should pass

# Test Claude Code
- [ ] Open Claude Code
- [ ] Type: "What agents are available?"
- [ ] Should describe 15 Drupal agents
```

#### 5. Run First Task (5 min)
```bash
# Simple Level 1 test
- [ ] Claude Code: "Add a text field called 'Subtitle' to the Article content type"
- [ ] Should execute via Drush
- [ ] Verify: drush field:list article | grep subtitle
- [ ] Success! ✅
```

## Training & Practice (1-2 hours)

### Level 1: Direct Execution (15 min)
- [ ] Complete 3 examples from `DRUPAL_EXAMPLES.md` Level 1
- [ ] Understand when tasks execute directly
- [ ] Practice Drush command verification

### Level 2: Feature Development (30 min)
- [ ] Complete Example 2.1 (Custom Block Plugin)
- [ ] Observe agent coordination:
  - [ ] @architect plans approach
  - [ ] @module-dev implements
  - [ ] @security reviews
  - [ ] @functional-test validates
- [ ] Review generated code
- [ ] Verify Drupal coding standards

### Level 3: Multi-Component (45 min)
- [ ] Read through Example 3.1 (FAQ System) in detail
- [ ] Understand PM agent coordination via Task Master
- [ ] See how multiple agents work in parallel
- [ ] Review quality gates process

### Level 4: Understanding (15 min)
- [ ] Review Example 4.1 (University Site)
- [ ] Understand phased approach
- [ ] Know when to use Level 4 vs breaking into Level 3 tasks

## Knowledge Verification

### Quiz Yourself
- [ ] Can I explain the 4 complexity levels?
- [ ] Do I know which agents handle which tasks?
- [ ] Do I understand quality gates (PASS/FAIL)?
- [ ] Can I verify generated code quality?
- [ ] Do I know how to troubleshoot common issues?

### Practical Tests
- [ ] Add a field to a content type (Level 1)
- [ ] Create a custom block plugin (Level 2)
- [ ] Explain the agent workflow for a multi-component feature
- [ ] Review generated module code for Drupal standards

## Best Practices Training

### Code Review
- [ ] Always review security-critical code
- [ ] Verify Drupal coding standards compliance
- [ ] Check for proper dependency injection
- [ ] Ensure cache tags are used correctly
- [ ] Verify access control is implemented

### Testing
- [ ] Test in development environment first
- [ ] Run functional tests before deploying
- [ ] Verify mobile responsiveness
- [ ] Check accessibility with WAVE or axe
- [ ] Test with different user roles

### Documentation
- [ ] Document custom architectural decisions
- [ ] Comment complex business logic
- [ ] Update project README when adding features
- [ ] Keep configuration exports up to date

### Version Control
- [ ] Commit after each successful feature
- [ ] Use descriptive commit messages
- [ ] Branch for experimental work
- [ ] Review diffs before pushing

## Team-Specific Workflows

### [Your Agency] Custom Processes
- [ ] [Add agency-specific approval process]
- [ ] [Add agency-specific deployment process]
- [ ] [Add agency-specific code review process]
- [ ] [Add agency-specific documentation requirements]

### Communication
- [ ] Know who to ask for help (team lead, mentor)
- [ ] Share learnings in team chat/wiki
- [ ] Report bugs or limitations
- [ ] Suggest improvements to CLAUDE.md

## Troubleshooting Training

### Common Issues & Solutions

#### MCP Server Issues
- [ ] Know how to reinstall: `claude mcp remove [name] && claude mcp add [name]...`
- [ ] Know how to check status: `claude mcp list`
- [ ] Know where logs are (if applicable)

#### Task Master Issues
- [ ] Know how to reset: `rm -rf .task-master && npx task-master-ai init`
- [ ] Know how to check tasks: `ls .task-master/tasks/`
- [ ] Understand Task Master state management

#### Drupal Issues
- [ ] Know how to clear cache: `drush cr`
- [ ] Know how to check module status: `drush pm:list`
- [ ] Know how to export config: `drush cex`
- [ ] Know how to run standards check: `./vendor/bin/phpcs`

#### Agent Issues
- [ ] Know how to restart if agent seems stuck
- [ ] Know when to break complex tasks into smaller pieces
- [ ] Understand when to intervene vs let agents work

## Resources & Reference

### Documentation
- [ ] Bookmarked agency fork README
- [ ] Bookmarked QUICK_START.md
- [ ] Bookmarked EXAMPLE_WORKFLOWS.md
- [ ] Bookmarked Drupal.org documentation

### Tools
- [ ] Claude Code documentation
- [ ] Drupal API reference
- [ ] phpcs documentation
- [ ] Drush documentation

### Support
- [ ] Team lead contact info: __________________
- [ ] Team chat channel: __________________
- [ ] Internal wiki: __________________
- [ ] Issue tracker: __________________

## Certification (Optional)

### Ready for Production Use
To be certified, demonstrate:
- [ ] Successfully complete 1 Level 1 task
- [ ] Successfully complete 1 Level 2 feature
- [ ] Review generated code for quality and security
- [ ] Troubleshoot a common issue independently
- [ ] Explain the agent workflow to another team member

**Certified by:** __________________ **Date:** __________

## Ongoing Learning

### Week 1
- [ ] Use for simple tasks daily
- [ ] Ask questions when uncertain
- [ ] Document learnings

### Week 2
- [ ] Attempt Level 2 features
- [ ] Review more complex code
- [ ] Optimize workflow

### Month 1
- [ ] Tackle Level 3 projects
- [ ] Customize CLAUDE.md if needed
- [ ] Share best practices with team

### Month 2+
- [ ] Use for production projects
- [ ] Mentor new team members
- [ ] Contribute improvements to fork

## Feedback & Improvement

### Share Your Experience
- [ ] What worked well?
- [ ] What was confusing?
- [ ] What could be improved?
- [ ] What documentation is missing?

### Contribute Back
- [ ] Suggest new examples
- [ ] Improve documentation
- [ ] Add agency-specific patterns
- [ ] Share time savings metrics

---

## Sign-Off

**Team Member:** __________________
**Date Completed:** __________________
**Certified by Team Lead:** __________________

**Ready for Production Use:** YES / NO

**Notes:**
_______________________________________
_______________________________________
_______________________________________

---

**Welcome to AI-powered Drupal development! 🚀**

You're now equipped to build Drupal sites faster and with higher quality using the Sub-Agent Collective system.
