# Fork Integration Guide - Drupal Sub-Agent Collective

## Strategy: Fork + Replace with Drupal Version

You're forking the TDD version and replacing it with Drupal-specific content. Perfect approach!

## Step-by-Step Integration

### 1. Fork the Repository

```bash
# Fork on GitHub first, then clone locally
git clone https://github.com/YOUR-USERNAME/claude-code-sub-agent-collective.git
cd claude-code-sub-agent-collective
```

### 2. Understand Current Repository Structure

The original repo has:
```
claude-code-sub-agent-collective/
├── .claude/
│   ├── CLAUDE.md              # TDD-focused orchestration
│   └── commands/              # Old command files (can delete)
├── README.md                  # TDD version documentation
├── docs/                      # Original documentation
└── examples/                  # TDD examples
```

### 3. Replace Key Files

**REPLACE these files completely:**

```bash
# Back up originals (optional)
mkdir _original_backup
cp .claude/CLAUDE.md _original_backup/
cp README.md _original_backup/

# Replace with Drupal versions
cp /path/to/downloaded/CLAUDE.md .claude/CLAUDE.md
cp /path/to/downloaded/README.md README.md
```

### 4. Add New Drupal Documentation

Create a `docs/` directory structure:

```bash
mkdir -p docs

# Copy all documentation
cp /path/to/downloaded/QUICK_START.md docs/
cp /path/to/downloaded/SETUP_GUIDE.md docs/
cp /path/to/downloaded/EXAMPLE_WORKFLOWS.md docs/
cp /path/to/downloaded/TDD_VS_DRUPAL_COMPARISON.md docs/
cp /path/to/downloaded/ARCHITECTURE_DIAGRAMS.md docs/
```

### 5. Update README Links

Edit `README.md` to point to the new docs structure:

```markdown
### 📘 Core Documentation
- **[docs/QUICK_START.md](docs/QUICK_START.md)** - Get started in 15 minutes
- **[docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)** - Complete installation
- **[.claude/CLAUDE.md](.claude/CLAUDE.md)** - Agent orchestration

### 📗 Reference Documentation
- **[docs/EXAMPLE_WORKFLOWS.md](docs/EXAMPLE_WORKFLOWS.md)** - Real examples
- **[docs/TDD_VS_DRUPAL_COMPARISON.md](docs/TDD_VS_DRUPAL_COMPARISON.md)** - How this differs
- **[docs/ARCHITECTURE_DIAGRAMS.md](docs/ARCHITECTURE_DIAGRAMS.md)** - Visual architecture
```

### 6. Clean Up Old TDD Files (Optional)

```bash
# Remove old TDD-specific command files if they exist
rm -rf .claude/commands/

# Or keep them in backup
mv .claude/commands _original_backup/ 2>/dev/null || true
```

### 7. Create Drupal-Specific Examples

Create `examples/` directory:

```bash
mkdir -p examples/drupal

# Create example files (I'll provide content below)
touch examples/drupal/custom-block-plugin.md
touch examples/drupal/event-management-system.md
touch examples/drupal/migration-example.md
```

### 8. Update Repository Metadata

**Edit `.gitignore`** to add Drupal-specific ignores:

```gitignore
# Drupal specific
web/sites/*/files
web/sites/*/private
web/core
web/modules/contrib
web/themes/contrib
web/profiles/contrib
vendor/
config/sync/
*.sql
*.sql.gz

# Task Master
.task-master/

# Drupal cache
web/sites/default/files/php

# Environment files
.env
.env.local
```

**Update `LICENSE`** if needed (check if you want to maintain same license)

### 9. Create Branch Strategy

```bash
# Create feature branch for Drupal adaptation
git checkout -b drupal-adaptation

# Commit your changes
git add .
git commit -m "Adapt sub-agent collective for Drupal development

- Replace CLAUDE.md with Drupal-specific orchestration
- Add 15 specialized Drupal agents
- Replace TDD workflow with Drupal architecture workflow
- Add comprehensive Drupal documentation
- Include real-world Drupal examples"

# Push to your fork
git push origin drupal-adaptation
```

### 10. Final Repository Structure

After integration, you should have:

```
your-fork/
├── .claude/
│   └── CLAUDE.md                    # ⭐ Drupal orchestration
├── docs/
│   ├── QUICK_START.md
│   ├── SETUP_GUIDE.md
│   ├── EXAMPLE_WORKFLOWS.md
│   ├── TDD_VS_DRUPAL_COMPARISON.md
│   └── ARCHITECTURE_DIAGRAMS.md
├── examples/
│   └── drupal/
│       ├── custom-block-plugin.md
│       ├── event-management-system.md
│       └── migration-example.md
├── _original_backup/                # Optional - for reference
│   ├── CLAUDE.md
│   └── README.md
├── .gitignore
├── LICENSE
└── README.md                        # Drupal version

```

## What to Keep from Original

### ✅ Keep These:
- **LICENSE** - Maintain attribution
- **Git history** - Shows evolution
- **.github/** - If there are CI/CD workflows (adapt as needed)
- **Contributing guidelines** - Adapt for Drupal focus

### ❌ Replace These:
- **.claude/CLAUDE.md** - Replace with Drupal version
- **README.md** - Replace with Drupal version
- **Documentation** - Replace with Drupal-specific docs

### 🔄 Adapt These:
- **Examples** - Replace TDD examples with Drupal examples
- **Tests** - If there are any, adapt for Drupal testing
- **Scripts** - Replace with Drupal helper scripts

## Using Your Fork Locally

### Initial Setup

```bash
# 1. Clone your fork
git clone https://github.com/YOUR-USERNAME/claude-code-sub-agent-collective.git drupal-agent-collective
cd drupal-agent-collective

# 2. Install MCP servers
claude mcp add task-master -s user -- npx -y --package=task-master-ai task-master-ai
claude mcp add playwright -s user -- npx -y playwright-mcp-server

# 3. Navigate to your Drupal project
cd /path/to/your/drupal/site

# 4. Create symbolic link or copy CLAUDE.md
mkdir -p .claude
cp /path/to/drupal-agent-collective/.claude/CLAUDE.md .claude/

# OR create symbolic link
ln -s /path/to/drupal-agent-collective/.claude/CLAUDE.md .claude/CLAUDE.md

# 5. Initialize Task Master
npx task-master-ai init
npx task-master-ai models --setMain claude-code/sonnet

# 6. Start using Claude Code!
```

### Workflow

```bash
# In your Drupal project directory
cd /path/to/drupal/site

# Open Claude Code
# The .claude/CLAUDE.md file will be automatically read

# Start with a simple task
claude
> "Add a boolean field 'Featured' to the Article content type"

# Or a more complex task
> "Create a custom block plugin that displays recent articles"
```

## Keeping Your Fork Updated

### Track Original Repository (Optional)

If you want to pull updates from the original TDD repo:

```bash
# Add original as upstream
git remote add upstream https://github.com/vanzan01/claude-code-sub-agent-collective.git

# Fetch updates
git fetch upstream

# But DON'T merge - your version is fundamentally different
# Instead, cherry-pick specific improvements if needed
```

### Maintaining Your Drupal Fork

```bash
# Make improvements
git checkout -b feature/improved-security-agent
# Make changes
git commit -am "Improve security agent validation"
git push origin feature/improved-security-agent

# Merge to main
git checkout main
git merge feature/improved-security-agent
git push origin main
```

## Sharing Your Fork

### Make it Public

1. **GitHub Settings** → Make repository public
2. **Update README.md** to credit original:
   ```markdown
   ## Credits
   
   Adapted from [claude-code-sub-agent-collective](https://github.com/vanzan01/claude-code-sub-agent-collective) 
   by vanzan01, specifically modified for Drupal CMS development.
   ```

3. **Add topics** on GitHub:
   - drupal
   - drupal-development
   - ai-agents
   - claude-code
   - drupal-modules
   - automation

### Share with Your Team

```bash
# Team members can clone your fork
git clone https://github.com/YOUR-USERNAME/claude-code-sub-agent-collective.git

# Follow QUICK_START.md
```

## Testing Your Integration

### Verify Everything Works

```bash
# 1. Check CLAUDE.md is readable
cat .claude/CLAUDE.md | head -n 20

# 2. Verify MCP servers
claude mcp list
# Should show: task-master, playwright

# 3. Test in Drupal project
cd /path/to/drupal
claude
> "What agents are available?"
# Claude should describe the 15 Drupal agents

# 4. Run simple test
> "Add a text field 'Subtitle' to Basic Page content type"
# Should execute directly via Drush
```

## Customizing for Your Agency

### Agency-Specific Additions

Create `AGENCY_CUSTOMIZATIONS.md`:

```markdown
# [Your Agency] Drupal Sub-Agent Customizations

## Custom Agents
- **Brand Compliance Agent** - Ensures brand guidelines
- **Performance Monitoring Agent** - Integrates with New Relic

## Custom Workflows
- **Client Approval Gate** - Adds approval step
- **Deployment Pipeline** - Integrates with Acquia/Pantheon

## Custom Scripts
- Deploy to staging
- Backup before changes
- Performance benchmarking
```

### Add to `.claude/CLAUDE.md`

Append your agency-specific agents and workflows to the CLAUDE.md file.

## Troubleshooting Integration

### Issue: Claude doesn't see CLAUDE.md

```bash
# Verify location
ls -la .claude/CLAUDE.md

# Must be in project root/.claude/
pwd  # Should be in Drupal project root
```

### Issue: Task Master not initializing

```bash
# Reinstall in Drupal project
cd /path/to/drupal
rm -rf .task-master
npx task-master-ai init
```

### Issue: Git conflicts with original

```bash
# If you accidentally merged upstream
git reset --hard origin/drupal-adaptation
# Your Drupal version is preserved
```

## Success Checklist

After integration, verify:

- ✅ `.claude/CLAUDE.md` contains Drupal orchestration
- ✅ `README.md` describes Drupal version
- ✅ All docs in `docs/` directory
- ✅ Examples are Drupal-specific
- ✅ MCP servers installed
- ✅ Can run simple Drupal tasks
- ✅ Agents coordinate properly
- ✅ Credits original project
- ✅ Git history preserved
- ✅ Team can clone and use

## Next Steps

1. **Test thoroughly** with various Drupal tasks
2. **Document your learnings** in agency wiki
3. **Share with team** and train them
4. **Iterate on agents** based on real usage
5. **Contribute back** improvements to original if applicable

---

**You now have a fully-integrated Drupal Sub-Agent Collective fork! 🚀**

Your fork is ready for:
- Agency-wide use
- Client projects
- Custom enhancements
- Team collaboration
- Production Drupal development
