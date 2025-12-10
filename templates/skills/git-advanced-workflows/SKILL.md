# Git Advanced Workflows

name: git-advanced-workflows
description: >
  This skill should be used when cleaning commit history, cherry-picking commits between branches,
  finding bug-introducing commits with bisect, working on multiple branches simultaneously with
  worktrees, or recovering from Git mistakes using reflog.

---

## Core Techniques

### Interactive Rebase

Clean up commit history before merging.

```bash
# Rebase last N commits
git rebase -i HEAD~5

# Rebase entire branch onto main
git rebase -i main

# Rebase onto specific commit
git rebase -i abc123
```

**Interactive commands:**
- `pick` - keep commit as-is
- `reword` - change commit message
- `edit` - stop to amend commit
- `squash` - combine with previous, keep message
- `fixup` - combine with previous, discard message
- `drop` - remove commit

**Example: Squash feature commits**
```bash
# Before: multiple WIP commits
git rebase -i main
# Change 'pick' to 'squash' for commits to combine
# Save and edit the combined message
```

### Cherry-Pick

Apply specific commits to another branch.

```bash
# Single commit
git cherry-pick abc123

# Multiple commits
git cherry-pick abc123 def456

# Range of commits (exclusive start)
git cherry-pick abc123..def456

# Stage only, don't commit
git cherry-pick -n abc123

# Edit message before committing
git cherry-pick -e abc123
```

**Hotfix workflow:**
```bash
# On main: fix critical bug
git commit -m "Fix security vulnerability"

# Apply to release branches
git checkout release-2.0
git cherry-pick main

git checkout release-1.9
git cherry-pick main
```

### Git Bisect

Binary search to find bug-introducing commit.

```bash
# Start bisect
git bisect start

# Mark current (broken) as bad
git bisect bad

# Mark known-good commit
git bisect good v1.0.0

# Git checks out middle commit
# Test and mark:
git bisect good  # or
git bisect bad

# Repeat until found
# Git reports: "abc123 is the first bad commit"

# Return to original state
git bisect reset
```

**Automated bisect:**
```bash
# Run test script automatically
git bisect start HEAD v1.0.0
git bisect run npm test

# Or with custom script
git bisect run ./test-bug.sh
```

### Git Worktrees

Work on multiple branches simultaneously without stashing.

```bash
# Create worktree for feature branch
git worktree add ../project-feature feature-branch

# Create worktree with new branch
git worktree add -b hotfix ../project-hotfix main

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../project-feature

# Clean up stale worktrees
git worktree prune
```

**Use case: Review PR while continuing work**
```bash
# Main work continues in ./project
cd project

# Create worktree to review PR
git worktree add ../project-review pr-branch
cd ../project-review
# Review, test, then remove
git worktree remove ../project-review
```

### Reflog Recovery

Recover from mistakes - Git remembers everything for ~90 days.

```bash
# View all reference changes
git reflog

# View reflog for specific branch
git reflog show feature-branch

# Output example:
# abc123 HEAD@{0}: commit: Add feature
# def456 HEAD@{1}: checkout: moving from main to feature
# ghi789 HEAD@{2}: reset: moving to HEAD~3
```

**Recovery scenarios:**

```bash
# Recover deleted branch
git reflog
# Find: abc123 HEAD@{5}: commit: Last commit on deleted-branch
git checkout -b deleted-branch abc123

# Undo accidental reset
git reflog
# Find commit before reset
git reset --hard HEAD@{2}

# Recover dropped commits from rebase
git reflog
# Find original branch tip
git reset --hard HEAD@{5}
```

## Safety Guidelines

### Force Push Safely

```bash
# ❌ Never use --force on shared branches
git push --force  # DANGEROUS

# ✅ Use --force-with-lease (fails if remote changed)
git push --force-with-lease
```

### Backup Before Risky Operations

```bash
# Create backup branch before rebase
git branch backup-feature feature-branch
git checkout feature-branch
git rebase -i main

# If things go wrong
git checkout feature-branch
git reset --hard backup-feature
```

### Abort In-Progress Operations

```bash
# Abort rebase
git rebase --abort

# Abort merge
git merge --abort

# Abort cherry-pick
git cherry-pick --abort

# Abort revert
git revert --abort
```

## Common Workflows

### Clean Feature Branch Before PR

```bash
# Ensure you're on feature branch
git checkout feature-branch

# Rebase onto latest main
git fetch origin
git rebase -i origin/main

# Squash WIP commits, reword messages
# Resolve any conflicts
git push --force-with-lease
```

### Autosquash Workflow

```bash
# Make fixup commits during development
git commit --fixup=abc123
git commit --fixup=def456

# Automatically squash when rebasing
git rebase -i --autosquash main
```

### Split a Commit

```bash
git rebase -i HEAD~3
# Mark commit to split as 'edit'

# When stopped at that commit:
git reset HEAD~
git add -p  # Stage parts interactively
git commit -m "First part"
git add -p
git commit -m "Second part"
git rebase --continue
```

### Partial Cherry-Pick

```bash
# Cherry-pick specific files only
git cherry-pick -n abc123
git reset HEAD
git add specific-file.php
git commit -m "Partial cherry-pick: specific-file.php"
git checkout -- .  # Discard remaining changes
```

## Quick Reference

| Task | Command |
|------|---------|
| Squash last 3 commits | `git rebase -i HEAD~3` |
| Apply commit to branch | `git cherry-pick abc123` |
| Find bad commit | `git bisect start && git bisect bad && git bisect good v1.0` |
| Work on 2 branches | `git worktree add ../other-dir branch` |
| Recover deleted branch | `git reflog && git checkout -b branch abc123` |
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo last commit (discard) | `git reset --hard HEAD~1` |
| Safe force push | `git push --force-with-lease` |

## Common Mistakes to Avoid

1. **Rebasing shared branches** - Only rebase local/unpushed commits
2. **Using `--force` instead of `--force-with-lease`** - Risk overwriting others' work
3. **Not creating backups** - Always backup before risky operations
4. **Bisecting with uncommitted changes** - Stash or commit first
5. **Forgetting to clean up worktrees** - Run `git worktree prune` periodically
6. **Not aborting failed operations** - Use `--abort` to return to clean state
