# Quick Start Guide - Drupal Sub-Agent Collective

## 🚀 Get Started in 15 Minutes

### Prerequisites Checklist
- ☐ Claude Code CLI installed
- ☐ Working Drupal 10/11 site
- ☐ Drush 12+ available
- ☐ Composer configured
- ☐ PHP 8.1+ with dev tools

### Installation (5 minutes)

```bash
# 1. Install MCP servers
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
claude mcp add playwright -s user -- npx -y playwright-mcp-server
npx playwright install

# 2. Navigate to your Drupal project
cd /path/to/your/drupal

# 3. Initialize Task Master
npx task-master-ai init
npx task-master-ai models --setMain claude-code/sonnet --setResearch claude-code/sonnet

# 4. Install Drupal dev tools
composer require --dev drupal/coder phpstan/phpstan
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer

# 5. Copy CLAUDE.md to your project
mkdir -p .claude
# Place CLAUDE.md in .claude/ directory
```

### Your First Task (5 minutes)

Open Claude Code and try this:

```
Add a "Featured" boolean field to the Article content type
```

Expected result:
- Claude recognizes this as Level 1
- Executes directly using Drush
- Field is added instantly
- Caches are cleared

Verify:
```bash
drush field:list article
```

### Your First Feature (15 minutes)

Try a Level 2 task:

```
Create a custom block plugin that displays the site logo, site name, and a custom tagline that can be configured in the block settings
```

Expected workflow:
1. @architect plans the approach
2. @module-dev creates the custom module
3. @security validates code
4. @functional-test tests in browser
5. Module is ready to use

Verify:
```bash
drush pm:list --type=module --status=enabled | grep custom
```

### Project Structure

After setup, your project should have:

```
your-drupal-project/
├── .claude/
│   ├── CLAUDE.md                 # Orchestration instructions
│   └── agent-config.json         # Agent permissions (optional)
├── .task-master/                 # Task Master state (auto-created)
│   ├── config.json
│   └── tasks/
├── web/
│   ├── modules/custom/           # Your custom modules
│   ├── themes/custom/            # Your custom themes
│   └── sites/default/
│       └── files/
├── config/sync/                  # Exported configurations
├── vendor/
├── composer.json
└── tests/                        # Playwright tests (created as needed)
```

## 📋 Task Complexity Guide

### Level 1: Direct Execution (No agents)
**Time: 1-2 minutes**

Examples:
- "Add a text field to Basic Page content type"
- "Enable the Pathauto module"
- "Clear all caches"
- "Update site name to 'My Website'"

What happens: Claude executes immediately via Drush/CLI

### Level 2: Feature Development (2-4 agents)
**Time: 10-20 minutes**

Examples:
- "Create a block showing recent articles"
- "Add a custom field formatter"
- "Create a view displaying events"
- "Implement custom form validation"

What happens:
```
@architect → @module-dev → @security → @functional-test
```

### Level 3: Multi-Component System (5-9 agents)
**Time: 45-90 minutes**

Examples:
- "Build an FAQ system with categories"
- "Create a member directory with filtering"
- "Implement a job posting system"
- "Build a document library with access control"

What happens:
```
PM coordination via Task Master
Multiple agents working in phases
All quality gates validate
Comprehensive testing
```

### Level 4: Full Project (8-12+ agents)
**Time: 3-6 hours**

Examples:
- "Build a university department site from this PRD"
- "Create an e-commerce platform"
- "Develop a news/media site with workflow"
- "Build a membership site with subscriptions"

What happens:
```
PM breaks into phases
All agents involved
Multiple validation cycles
Production-ready deliverable
```

## 🎯 Common Tasks & Expected Outcomes

### Content Architecture
```
"Create a Resource content type with file upload, category taxonomy, and access restrictions"
```
**Outcome**: Content type with fields, permissions, views

### Custom Module
```
"Build a module that adds a 'Print PDF' button to article pages"
```
**Outcome**: Custom module with PDF generation, tested

### Theme Component
```
"Create a hero section component for the homepage with image, heading, and CTA button"
```
**Outcome**: Twig template, CSS, Paragraph type if needed

### Views & Display
```
"Create a filterable grid view of products with AJAX pagination"
```
**Outcome**: Views configuration, optional AJAX customization

### Integration
```
"Integrate with Mailchimp API for newsletter signups"
```
**Outcome**: Custom module with API integration, secure key storage

### Migration
```
"Migrate content from WordPress export file"
```
**Outcome**: Migration module with plugins, tested migration

## 🔍 Troubleshooting

### "Task Master not initializing"
```bash
rm -rf .task-master
npx task-master-ai init --force
```

### "MCP server not responding"
```bash
claude mcp list
claude mcp remove task-master
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
```

### "Drupal coding standards failing"
```bash
# Reinstall coder
composer remove --dev drupal/coder
composer require --dev drupal/coder
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
```

### "Module not being enabled"
```bash
drush cr
drush pm:list --status=enabled
drush en your_module -y
```

### "Agent seems stuck"
- Check .task-master/tasks/ for task status
- Clear Task Master state if needed
- Try simpler task first to verify setup

## 💡 Pro Tips

### 1. Start Small, Build Up
- Begin with Level 1 tasks
- Move to Level 2 features
- Graduate to Level 3 systems
- Attempt Level 4 only when confident

### 2. Be Specific in Requests
**Bad**: "Make a form"
**Good**: "Create a contact form with fields for name, email, phone, and message. Add validation for email format and required fields. Send submissions to admin@example.com"

### 3. Leverage Drupal Patterns
The agents know Drupal best practices. Let them suggest:
- Whether to use contrib modules vs custom
- Proper entity types for your data
- Caching strategies
- Security patterns

### 4. Review Generated Code
While agents follow Drupal standards, always review:
- Custom module code
- Configuration exports
- Security implementations
- Performance implications

### 5. Use Version Control
```bash
git add -A
git commit -m "Add [feature] via Claude agent collective"
```

### 6. Test in Development First
Never run agent tasks directly on production:
- Use local development environment
- Or use dedicated dev/staging server
- Test thoroughly before deploying

### 7. Document Custom Decisions
When agents make architectural choices, document them:
```bash
# Add to your project's README.md
echo "## Custom Modules" >> README.md
echo "- event_management: Handles event registration system" >> README.md
```

## 📚 Next Steps

### Week 1: Learn the System
- ✅ Complete installation
- ✅ Run 5+ Level 1 tasks
- ✅ Complete 3+ Level 2 features
- ✅ Review generated code
- ✅ Understand agent workflow

### Week 2: Build Features
- ✅ Attempt Level 3 project
- ✅ Customize CLAUDE.md for your needs
- ✅ Create project-specific patterns
- ✅ Build confidence with agents

### Week 3: Optimize Workflow
- ✅ Add custom scripts
- ✅ Create templates for common tasks
- ✅ Share learnings with team
- ✅ Document your patterns

### Month 2+: Advanced Usage
- ✅ Level 4 full projects
- ✅ Custom MCP servers
- ✅ Team collaboration
- ✅ Production deployments

## 🎓 Learning Resources

### Drupal Resources
- [Drupal.org Documentation](https://www.drupal.org/docs)
- [Drupal API Reference](https://api.drupal.org)
- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)

### Claude Code Resources
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [MCP Server Documentation](https://github.com/anthropics/anthropic-sdk)

### Example Projects
See EXAMPLE_WORKFLOWS.md for:
- Complete Level 2 example (Recent Articles Block)
- Complete Level 3 example (Event Management System)
- Agent interaction patterns
- Expected outputs

## 🤝 Best Practices

### DO:
✅ Provide clear, detailed requirements
✅ Let agents suggest Drupal-native solutions
✅ Review security-critical code
✅ Export configurations after features
✅ Test in development environment
✅ Use version control
✅ Document architectural decisions

### DON'T:
❌ Skip security reviews
❌ Test directly on production
❌ Ignore Drupal coding standards
❌ Forget to clear caches
❌ Overlook performance implications
❌ Neglect accessibility
❌ Skip configuration exports

## 🎉 Success Metrics

You'll know the system is working when:

1. **Level 1 tasks complete in < 2 minutes**
2. **Level 2 features are production-ready**
3. **Code passes all quality gates**
4. **Functional tests validate behavior**
5. **Security reviews pass**
6. **Configuration is exportable**
7. **You're spending time on architecture, not boilerplate**

## 📞 Getting Help

### If Something Doesn't Work:
1. Check the SETUP_GUIDE.md
2. Review EXAMPLE_WORKFLOWS.md
3. Verify MCP server status: `claude mcp list`
4. Check Task Master state: `ls -la .task-master/tasks/`
5. Review agent logs in Claude Code

### Common Issues:
- **MCPs not connecting**: Reinstall MCP servers
- **Drupal standards fail**: Check phpcs installation
- **Tasks not coordinating**: Reset Task Master
- **Agents not responding**: Check CLAUDE.md location

## 🚀 Ready to Build!

You now have a fully-functional Drupal development collective that can:
- Build custom modules following Drupal standards
- Create themes with modern best practices
- Implement security and performance optimization
- Test everything automatically in browsers
- Deliver production-ready code

Start with a simple task and build from there. The agents will coordinate automatically based on complexity!

---

**Remember**: The agents are tools to augment your Drupal development, not replace your judgment. Always review generated code, especially for security-critical features, and test thoroughly before deploying.

**Happy Drupal development! 🚀**
