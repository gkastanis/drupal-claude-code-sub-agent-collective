# Contributing to Drupal Claude Code Collective

Welcome to the Drupal-focused AI agent collective! This project provides specialized agents for Drupal 10/11 development with quality gate validation. Your contributions help make Drupal development more efficient and standardized.

## 🎯 Testing & Contribution Goals

We're looking for feedback and contributions in these key areas:

### 🤖 **Agent System**
- Test agent coordination for Drupal development workflows
- Identify gaps in Drupal-specific knowledge
- Evaluate code quality and adherence to Drupal standards

### 🏗️ **Drupal Project Coverage**
- Test with different Drupal project types (small sites, custom modules, enterprise projects)
- Test with varying complexity levels (simple content sites to complex integrations)
- Report which Drupal patterns and workflows work best with agents

### ⚡ **Quality & Standards**
- Validate Drupal coding standards enforcement (PHPCS, PHPStan)
- Test security compliance and accessibility (WCAG 2.1 AA)
- Test performance optimization recommendations
- Identify areas where quality gates could be improved

### 🔧 **Context7 Integration**
- Test agent usage of Context7 Drupal documentation
- Report accuracy of recommendations against current Drupal best practices
- Suggest improvements to documentation references

## 🚀 How to Contribute

### 1. **Testing & Feedback**

#### Try the Drupal Agent Collective
```bash
# Install the collective in your Drupal project
npx drupal-claude-collective init

# Use agents for Drupal development tasks
# Example: "Create a custom block showing recent articles"
# The collective will route to appropriate specialized agents

# Report your experience!
```

#### **What We Want to Know:**
- 📊 **Success Rate**: Did agents produce working Drupal code?
- 🎯 **Standards Compliance**: Did code pass PHPCS/PHPStan validation?
- 🔒 **Security Quality**: Were security best practices followed?
- 🐛 **Issues Encountered**: What failed and how did you work around it?
- 💡 **Agent Effectiveness**: Which agents were most/least helpful?

### 2. **Bug Reports**

#### **High Priority Issues:**
- Agent coordination failures
- Incorrect Drupal API usage
- Quality gate false positives/negatives
- Context7 integration errors
- Standards validation issues

#### **Bug Report Template:**
```markdown
## Bug Description
Brief description of what went wrong

## Steps to Reproduce
1. Install collective in Drupal project
2. Request specific task (e.g., "Create custom block plugin")
3. Observe failure at [specific point]

## Expected Behavior
What should have happened

## Actual Behavior
What actually happened

## Environment
- OS: [Windows/macOS/Linux/WSL]
- Claude Code Version: [version]
- Drupal Version: [10.x or 11.x]
- Project Type: [Small site/Custom modules/Enterprise/Migration]
- DDEV Version: [version]

## Error Output
```
[Include any error messages or logs]
```

## Agent State
- Which agent was active when failure occurred
- Specific Drupal context (content types, modules, etc.)
- Any partial code generated
```

### 3. **Feature Requests & Improvements**

#### **Areas for Enhancement:**
- **New Drupal Patterns**: Commerce, webforms, headless Drupal, multisite
- **Agent Capabilities**: Advanced migration, deployment automation, multilingual sites
- **Quality Standards**: Enhanced Behat testing, security hardening, performance audits
- **Developer Experience**: Better Context7 integration, error recovery, agent suggestions

#### **Feature Request Template:**
```markdown
## Feature Description
What capability would you like to see added?

## Use Case
Why is this feature important? What problem does it solve?

## Proposed Implementation
If you have ideas on how it could work

## Priority
How important is this to your workflow?
```

### 4. **Code Contributions**

#### **Contribution Areas:**

##### 🤖 **Agent Enhancements**
- Improve Drupal API knowledge and accuracy
- Enhance Context7 documentation usage
- Better Drupal best practices enforcement
- Add support for more Drupal patterns (Commerce, Webforms, etc.)

##### 🔧 **Quality Gate Improvements**
- Enhanced PHPCS/PHPStan validation
- Better security analysis patterns
- Improved performance recommendations
- Accessibility compliance validation

##### 📚 **Documentation & Guides**
- Drupal version-specific guides
- DDEV integration improvements
- Troubleshooting documentation
- Example workflows and use cases

##### ⚡ **Testing & Reliability**
- Behat test generation improvements
- PHPUnit test coverage
- Error recovery mechanisms
- Integration testing

#### **Development Setup:**
```bash
# Clone the repository
git clone https://github.com/gkastanis/drupal-claude-code-sub-agent-collective.git
cd drupal-claude-code-sub-agent-collective

# Install dependencies
npm install

# Run tests
npm run test:jest

# Test NPX installation
npx . init --force
```

#### **Pull Request Guidelines:**
1. **Focus on Single Issues**: One PR per bug fix or feature
2. **Test Your Changes**: Validate with Drupal 10 and 11 projects
3. **Run All Tests**: Ensure `npm run test:jest` passes (118 tests)
4. **Document Changes**: Update README and CHANGELOG as needed
5. **Include Examples**: Show before/after behavior with Drupal code examples
6. **Follow Standards**: Use Drupal coding standards in examples

## 🧪 Testing Scenarios

### **Test Cases We Need Coverage For:**

#### **Drupal Project Types:**
- [ ] Small site with custom content types
- [ ] Custom module development (blocks, plugins, services)
- [ ] Custom theme with Twig templates
- [ ] Content migration from Drupal 7 or external source
- [ ] Headless Drupal with JSON:API
- [ ] Multisite architecture
- [ ] Drupal Commerce site

#### **Complexity Levels:**
- [ ] Simple site (content types, views, basic theming)
- [ ] Medium complexity (custom modules, integrations, migrations)
- [ ] Complex features (custom workflows, API integrations, performance optimization)
- [ ] Enterprise project (multisite, custom distribution, advanced security)

#### **Development Scenarios:**
- [ ] New Drupal 10/11 site from scratch
- [ ] Adding custom functionality to existing site
- [ ] Upgrading from Drupal 9 to 10/11
- [ ] Migrating content from another CMS
- [ ] Refactoring and code quality improvements
- [ ] Performance optimization and caching strategies

### **Success Metrics:**
- **Completion Rate**: % of tasks that produce working Drupal code
- **Standards Compliance**: Code passing PHPCS/PHPStan/security validation
- **Quality Score**: Code quality, Behat testing, WCAG 2.1 AA accessibility
- **Drupal Best Practices**: Adherence to Drupal API and architectural patterns

## 🤝 Community Guidelines

### **Contribution Etiquette:**
1. **Be Honest**: Report failures and limitations honestly
2. **Be Specific**: Detailed feedback is more helpful than general comments
3. **Be Drupal-Focused**: Keep suggestions relevant to Drupal 10/11 best practices
4. **Be Constructive**: Suggest improvements, not just criticisms
5. **Be Collaborative**: Help other contributors troubleshoot issues

### **Communication Channels:**
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General feedback and questions
- **Pull Requests**: Code contributions and improvements

## 🏆 Recognition

### **Contributor Recognition:**
- Contributors will be recognized in release notes
- Significant contributors will be credited in repository documentation
- Code contributors may be invited to participate in roadmap planning

### **Types of Contributions We Value:**
- **Bug Discovery**: Finding and reporting agent or quality gate issues
- **Drupal Expertise**: Adding new Drupal patterns and best practices
- **Quality Improvements**: Enhancing standards validation and testing
- **Documentation**: Improving guides, examples, and troubleshooting
- **Agent Enhancements**: Improving Context7 integration and Drupal knowledge

## 🔮 Vision for the Future

### **Short-term Goals:**
- Enhanced Context7 integration with more Drupal documentation sources
- Support for Drupal Commerce and Webform development
- Improved multilingual site development patterns
- Better performance optimization recommendations

### **Long-term Vision:**
- **Drupal 12 Readiness**: Early adoption of Drupal 12 patterns and APIs
- **Headless Drupal**: Advanced support for decoupled architectures
- **CI/CD Integration**: Automated deployment workflows for Drupal
- **Module Ecosystem**: Agents specialized for popular contrib modules
- **Enterprise Features**: Multisite, advanced caching, high-availability patterns

### **Research Questions We're Exploring:**
- How can AI agents best learn Drupal's evolving best practices?
- What's the optimal balance between automation and developer control?
- Can agents effectively recommend contrib vs custom solutions?
- How do we maintain code quality at scale with AI assistance?

## 💡 Getting Started

### **New to the Drupal Collective?**
1. **Start Simple**: Try a basic custom block or content type task
2. **Read the Docs**: Familiarize yourself with the 14 specialized Drupal agents
3. **Join Discussions**: Connect with other contributors
4. **Share Results**: Report both successes and areas for improvement

### **Experienced Drupal Developer?**
1. **Test Complex Patterns**: Try migrations, commerce, or headless architectures
2. **Compare Quality**: How do agent recommendations compare to manual development?
3. **Technical Review**: Analyze Context7 integration and quality gates
4. **Contribute Expertise**: Help improve Drupal best practices and patterns

---

**Ready to enhance Drupal development with AI agents?**

Your feedback and contributions are essential for making this tool valuable for the Drupal community.

**Let's build better Drupal sites together!** 🚀