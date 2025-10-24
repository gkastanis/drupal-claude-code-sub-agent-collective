# Drupal Web Development Claude Code Sub-Agent Collective

🚀 **Production-ready Drupal development using AI agents coordinated through Claude Code**

Transform natural language requests into production-ready Drupal modules, themes, and complete sites with specialized AI agents that understand Drupal architecture, security, and best practices.

## What Is This?

A sophisticated multi-agent system adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective), specifically designed for Drupal CMS development. Instead of focusing on TDD, this version specializes in:

- ✅ **Drupal Architecture** - Content types, modules, themes
- ✅ **Drupal Best Practices** - Coding standards, security review
- ✅ **Configuration Management** - Config export/import, deployment
- ✅ **Performance Optimization** - Caching, query optimization
- ✅ **Browser Validation** - Real Playwright testing
- ✅ **Production Ready** - Security reviewed, standards compliant

## Quick Example

**You say:**
```
Create a custom block that displays the 5 most recent articles with featured images
```

**What happens automatically:**
1. 🏗️ Architect agent designs the approach (block plugin with EntityQuery)
2. 💻 Module Dev agent implements following Drupal standards
3. 🔒 Security agent reviews for vulnerabilities and compliance
4. 🧪 Functional Test agent validates in real browser with Playwright
5. ✅ **You get**: Production-ready custom module, tested and documented

**Time:** ~15 minutes | **Cost:** $0 (uses Claude Code)

## Features

### 15 Specialized Drupal Agents

**Core Work Agents:**
- **Drupal Architect** - Site architecture, content modeling
- **Module Development** - Custom modules with hooks, plugins, services
- **Theme Development** - Twig templates, preprocess, SCSS
- **Configuration Management** - Config export, update hooks
- **Content & Migration** - Migrations, content architecture
- **Security & Compliance** - Security review, Drupal standards
- **Performance & DevOps** - Caching, deployment, optimization

**Quality Gate Agents:**
- **Drupal Standards Gate** - phpcs validation
- **Security Gate** - Vulnerability scanning
- **Performance Gate** - Query and cache analysis
- **Accessibility Gate** - WCAG compliance
- **Integration Gate** - Module compatibility

**Testing Agents:**
- **Functional Testing** - Playwright browser automation
- **Unit Testing** - PHPUnit with Drupal test base
- **Visual Regression** - Screenshot comparison

### Four Complexity Levels

**Level 1**: Simple edits (direct execution)
- "Add an email field to Article content type"
- "Enable the Pathauto module"
- Time: ~1 minute

**Level 2**: Feature development (2-4 agents)
- "Create a custom block with recent articles"
- "Add custom field formatter for phone numbers"
- Time: ~15 minutes

**Level 3**: Multi-component systems (5-9 agents)
- "Build an FAQ system with categories and voting"
- "Create a member directory with filtering"
- Time: ~90 minutes

**Level 4**: Full projects (8-12+ agents)
- "Build a university department site from PRD"
- "Create an e-commerce platform"
- Time: ~4 hours

## Documentation

### 📘 Core Documentation
- **[QUICK_START.md](QUICK_START.md)** - Get started in 15 minutes
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete installation and configuration
- **[CLAUDE.md](CLAUDE.md)** - Agent orchestration instructions (the heart of the system)

### 📗 Reference Documentation
- **[EXAMPLE_WORKFLOWS.md](EXAMPLE_WORKFLOWS.md)** - Real-world agent interaction examples
- **[TDD_VS_DRUPAL_COMPARISON.md](TDD_VS_DRUPAL_COMPARISON.md)** - How this differs from the TDD version

### 🎯 Recommended Reading Order
1. Start with **QUICK_START.md** (5 min read)
2. Follow **SETUP_GUIDE.md** for installation (15 min)
3. Review **EXAMPLE_WORKFLOWS.md** to see agents in action (10 min)
4. Reference **CLAUDE.md** when customizing (advanced)

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

# 2. Setup your Drupal project
cd /path/to/drupal
npx task-master-ai init
npx task-master-ai models --setMain claude-code/sonnet

# 3. Install Drupal dev tools
composer require --dev drupal/coder phpstan/phpstan
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer

# 4. Copy CLAUDE.md to your project
mkdir -p .claude
cp CLAUDE.md .claude/

# Done! Start using Claude Code
```

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions.

## Usage Examples

### Simple Task (Level 1)
```
Add a "Featured" boolean field to the Article content type
```

### Feature Development (Level 2)
```
Create a custom block plugin that displays:
- Site logo
- Site name
- Custom tagline (configurable)
- Social media links
```

### Complex System (Level 3)
```
Build an event management system with:
- Event content type (date, location, registration limit)
- Registration form (name, email, message)
- Admin view showing registrations
- Email notifications
- Calendar view
```

### Full Project (Level 4)
```
Build a university department website from this PRD:
[Attach PRD document with requirements]
```

## How It Works

### 1. Orchestration via CLAUDE.md
Main Claude reads instructions in `.claude/CLAUDE.md` to:
- Assess task complexity (Level 1-4)
- Route to appropriate agents
- Coordinate multi-agent workflows
- Ensure quality gate validation

### 2. Agent Coordination
- **Task Master MCP**: Maintains project state and task dependencies
- **Agents**: Specialized for Drupal development aspects
- **Quality Gates**: Binary validation (PASS/FAIL)
- **Error Recovery**: Failed gates loop back for fixes

### 3. Tool Integration
- **Drush**: Drupal CLI operations
- **Composer**: Dependency management
- **Playwright**: Browser automation testing
- **phpcs/phpstan**: Code quality validation

### 4. Output
- Production-ready Drupal code
- Passes all quality gates
- Browser-tested functionality
- Security reviewed
- Properly documented
- Configuration exported

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Main Claude Orchestrator                   │
│                  (Reads CLAUDE.md for routing)                │
└───────────────────────┬─────────────────────────────────────┘
                        │
          ┌─────────────┴──────────────┐
          │                            │
    ┌─────▼──────┐            ┌───────▼────────┐
    │   Level 1   │            │   Level 2-4    │
    │   Direct    │            │  Multi-Agent   │
    │  Execution  │            │  Coordination  │
    └─────────────┘            └───────┬────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
              ┌─────▼─────┐      ┌────▼─────┐     ┌─────▼──────┐
              │   Core    │      │ Quality  │     │   Test     │
              │   Work    │      │  Gates   │     │  Agents    │
              │  Agents   │      │ (PASS/   │     │            │
              │   (7)     │      │  FAIL)   │     │    (3)     │
              └───────────┘      └──────────┘     └────────────┘
                    │                  │                  │
                    └──────────────────┼──────────────────┘
                                       │
                              ┌────────▼─────────┐
                              │  Production-     │
                              │  Ready Output    │
                              └──────────────────┘
```

## Technology Stack

### Required
- **Drupal**: 10.x or 11.x
- **PHP**: 8.1+
- **Drush**: 12+
- **Composer**: Latest
- **Node.js**: 18+

### MCP Servers
- **Task Master**: Project coordination and state management
- **Playwright**: Browser-based functional testing

### Code Quality Tools
- **PHP_CodeSniffer**: Drupal coding standards (Drupal, DrupalPractice)
- **PHPStan**: Static analysis
- **PHPUnit**: Unit and kernel testing

### Optional
- **Redis/Memcached**: Caching (performance optimization)
- **Drush Site Aliases**: Multi-environment support
- **Git**: Version control (highly recommended)

## Quality Standards

All deliverables automatically meet:

✅ **Drupal Coding Standards** - Passes phpcs validation
✅ **Security** - No vulnerabilities, proper sanitization
✅ **Performance** - Efficient queries, proper caching
✅ **Accessibility** - WCAG 2.1 AA minimum
✅ **Browser Tested** - Validated with Playwright
✅ **Documentation** - Inline comments and README
✅ **Configuration** - Exportable for deployment

## Comparison to Original

| Aspect | TDD Version | Drupal Version (This) |
|--------|-------------|----------------------|
| Focus | Test-Driven Development | Drupal CMS Development |
| Agents | 19 generic | 15 Drupal-specialized |
| Testing | Write tests first | Drupal test frameworks |
| Output | General apps | Drupal modules/themes |
| Standards | Generic linters | Drupal coding standards |
| Tools | npm/jest | drush/composer/phpcs |

See [TDD_VS_DRUPAL_COMPARISON.md](TDD_VS_DRUPAL_COMPARISON.md) for detailed comparison.

## Real-World Results

### Example: Event Management System
**Task Complexity**: Level 3
**Agents Used**: 9 agents
**Time**: 90 minutes
**Output**:
- Custom event_management module
- Event content type with registration
- Admin views for registration management
- Email notification system
- Calendar view
- 25+ files created
- All tests passing
- Security reviewed
- Configuration exported

### Example: Custom Block Plugin
**Task Complexity**: Level 2
**Agents Used**: 4 agents
**Time**: 15 minutes
**Output**:
- Custom module with block plugin
- Dependency injection
- Proper caching
- Browser tested
- Standards compliant

See [EXAMPLE_WORKFLOWS.md](EXAMPLE_WORKFLOWS.md) for complete walkthroughs.

## Best Practices

### ✅ Do
- Start with Level 1-2 tasks to learn the system
- Provide clear, detailed requirements
- Review generated code, especially security-critical parts
- Test in development environment first
- Use version control
- Export configurations after each feature
- Let agents suggest Drupal-native solutions

### ❌ Don't
- Run untested code on production
- Skip security reviews
- Ignore performance implications
- Forget to clear caches
- Overlook accessibility requirements
- Neglect configuration exports

## Limitations & Considerations

### Current Limitations
- Requires existing Drupal installation
- Task Master MCP can be unstable (workarounds available)
- Best for Drupal 10/11 (may need adjustments for D9)
- Agents work best with clear requirements

### Best Use Cases
✅ Drupal agency project work
✅ Custom module development
✅ Theme customization
✅ Content architecture design
✅ Drupal 10/11 site builds
✅ Configuration management workflows

### Not Ideal For
❌ Drupal 7 or older versions
❌ Non-Drupal PHP projects
❌ Projects requiring TDD methodology
❌ Simple content entry (use Drupal UI)

## Troubleshooting

### Common Issues

**Task Master not initializing:**
```bash
rm -rf .task-master && npx task-master-ai init --force
```

**MCP servers not connecting:**
```bash
claude mcp list
claude mcp remove task-master
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
```

**Drupal standards failing:**
```bash
composer require --dev drupal/coder
./vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
```

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for more troubleshooting.

## Contributing

This is adapted for Drupal web agencies. Contributions welcome:

### Areas for Enhancement
- Custom Drupal-specific MCP servers
- Additional agent types (e.g., Accessibility Specialist)
- Drupal 9 compatibility mode
- Multi-site support
- Advanced caching strategies
- Headless Drupal patterns

### How to Contribute
1. Fork this documentation
2. Enhance agents in CLAUDE.md
3. Add examples to EXAMPLE_WORKFLOWS.md
4. Share your custom scripts
5. Document your patterns

## Credits

Based on [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective) by vanzan01, which is built on [cursor-memory-bank](https://github.com/vanzan01/cursor-memory-bank).

Adapted specifically for Drupal web development with:
- Drupal-specialized agents
- Drupal coding standards integration
- Configuration management workflows
- Drupal-specific testing approaches
- Security and performance patterns

## License

Adapted for Drupal development. See original project for base license.

## Support & Resources

### Drupal Resources
- [Drupal.org](https://www.drupal.org)
- [Drupal API](https://api.drupal.org)
- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)

### Claude Resources
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Claude API Docs](https://docs.anthropic.com)

### This Project
- **Getting Started**: [QUICK_START.md](QUICK_START.md)
- **Installation**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Examples**: [EXAMPLE_WORKFLOWS.md](EXAMPLE_WORKFLOWS.md)
- **Orchestration**: [CLAUDE.md](CLAUDE.md)

## What's Next?

1. 📖 Read [QUICK_START.md](QUICK_START.md) (5 minutes)
2. ⚙️ Follow [SETUP_GUIDE.md](SETUP_GUIDE.md) (15 minutes)
3. 🎮 Try your first Level 1 task
4. 🚀 Build your first Level 2 feature
5. 💪 Tackle a Level 3 system

---

**Transform your Drupal development workflow with AI agents that understand Drupal architecture, security, and best practices!** 🚀

**Built for Drupal agencies, by adapting the best of AI agent orchestration.**
