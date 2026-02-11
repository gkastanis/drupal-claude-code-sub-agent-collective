# Lullabot Project Patterns - Research for Future Implementation

**Research Date:** 2025-12-17
**Researcher:** Claude Code Collective Analysis
**Source Project:** [lullabot-project](https://github.com/Lullabot/lullabot-project) v4.4.0
**Target Project:** drupal-claude-code-sub-agent-collective v1.8.3

---

## Executive Summary

Analysis of the Lullabot Project reveals 8 patterns that could significantly improve our project's maintainability, testability, and user experience. This document captures the research findings for future implementation planning.

---

## Pattern 1: Content Filtering System

### Priority: HIGH
### Complexity: MEDIUM
### Files to Create: `lib/content-filters.js`, updates to `installer.js`

### Description

A pipeline-based content transformation system that processes file contents during copy operations. Allows extraction, removal, and transformation of content using regex patterns.

### Lullabot Implementation

```javascript
// src/utils/content-filters.js (key excerpts)

const FILTER_TYPES = {
  FRONTMATTER_REMOVAL: 'frontmatter-removal',
  EXTRACT_CONTENT: 'extract-content',
  LINE_RANGE: 'line-range',
  REMOVE_LINES: 'remove-lines'
};

function removeFrontmatter(content) {
  return content.replace(/^---\n.*?\n---\s*\n?/s, '');
}

function extractContent(content, pattern, flags = '', group = 0) {
  const regex = new RegExp(pattern, flags);
  const match = regex.exec(content);
  return match && match[group] !== undefined ? match[group].trim() : content;
}

function extractLineRange(content, start, end) {
  const lines = content.split('\n');
  return lines.slice(start - 1, end).join('\n');
}

function removeLines(content, pattern, flags = '') {
  const regex = new RegExp(pattern, flags);
  return content.split('\n').filter(line => !regex.test(line)).join('\n');
}

async function processContent(content, filters, filePath, verbose = false) {
  let processedContent = content;
  for (const filter of filters) {
    switch (filter.type) {
      case 'frontmatter-removal':
        processedContent = removeFrontmatter(processedContent);
        break;
      case 'extract-content':
        processedContent = extractContent(processedContent, filter.pattern, filter.flags, filter.group);
        break;
      // ... etc
    }
  }
  return processedContent;
}
```

### Configuration Example

```yaml
# How filters are configured in their YAML
agents-md:
  type: "copy-files"
  source: "templates/AGENTS.md"
  target: "AGENTS.md"
  filters:
    - type: "frontmatter-removal"
    - type: "extract-content"
      pattern: "`````(.*?)`````"
      flags: "s"
      group: 1
    - type: "remove-lines"
      pattern: "^#.*DEBUG"
      flags: "gm"
```

### Our Implementation Plan

1. Create `lib/content-filters.js` with filter functions
2. Add `filters` property to FileMapping items
3. Call filter pipeline in `installMappedFile()`
4. Add validation for filter configurations

### Use Cases for Our Project

- Strip YAML frontmatter from agent templates
- Extract specific sections from larger documentation
- Remove development comments from production files
- Transform Drupal-specific placeholders

---

## Pattern 2: Dry-Run Mode

### Priority: HIGH
### Complexity: LOW
### Files to Modify: `bin/install-collective.js`, `lib/installer.js`

### Description

Preview all installation changes without making any modifications. Essential for users who want to understand what will be installed before committing.

### Lullabot Implementation

```javascript
// CLI option
.option('--dry-run', 'Preview changes without making them')

// In installer
async install() {
  if (this.options.dryRun) {
    console.log(chalk.cyan('DRY RUN - No changes will be made\n'));

    for (const mapping of mappings) {
      const exists = await fs.pathExists(mapping.target);
      const action = exists ? (mapping.overwrite ? 'OVERWRITE' : 'SKIP') : 'CREATE';
      console.log(`[${action}] ${mapping.target}`);
    }

    return { success: true, dryRun: true, actions: mappings.length };
  }
  // ... actual installation
}
```

### Our Implementation Plan

1. Add `--dry-run` flag to CLI
2. Create `previewInstallation()` method
3. Show CREATE/OVERWRITE/SKIP for each file
4. Display summary of changes

---

## Pattern 3: Installation Tracking (Manifest File)

### Priority: HIGH
### Complexity: MEDIUM
### Files to Create: `lib/manifest-manager.js`

### Description

Track installed files with version and hash information to enable smart updates and detect manual modifications.

### Lullabot Implementation

```yaml
# .lullabot-project.yml (generated after installation)
version: "4.4.0"
tool: "cursor"
project: "drupal"
installedAt: "2025-12-17T00:00:00.000Z"
files:
  AGENTS.md:
    hash: "sha256:abc123..."
    version: "4.4.0"
    source: "remote:prompt_library/drupal/AGENTS.md"
  .cursor/rules/agents.md:
    hash: "sha256:def456..."
    version: "4.4.0"
    source: "local:wrappers/cursor.md"
```

```javascript
// File change detection
async function detectChangedFiles(manifest, projectDir) {
  const changedFiles = [];

  for (const [filePath, fileInfo] of Object.entries(manifest.files)) {
    const fullPath = path.join(projectDir, filePath);

    if (await fs.pathExists(fullPath)) {
      const currentHash = await computeFileHash(fullPath);
      if (currentHash !== fileInfo.hash) {
        changedFiles.push({
          path: filePath,
          reason: 'modified',
          installedHash: fileInfo.hash,
          currentHash: currentHash
        });
      }
    }
  }

  return changedFiles;
}
```

### Our Implementation Plan

1. Create `.claude-collective-manifest.json` after installation
2. Store file hashes, versions, sources
3. Detect modifications before updates
4. Prompt user about changed files
5. Enable selective updates

---

## Pattern 4: YAML-Based Configuration

### Priority: MEDIUM
### Complexity: HIGH
### Files to Create: `config/config.yml`, `lib/config-loader.js`

### Description

Replace JavaScript-based file mapping with declarative YAML configuration for easier maintenance and extensibility.

### Lullabot Implementation

```yaml
# config/config.yml (simplified)
shared_tasks:
  rules:
    name: "Project Rules"
    type: "remote-copy-files"
    repository:
      url: "https://github.com/Lullabot/prompt_library"
      type: "branch"
      target: "main"
    source: "{project-type}/rules/"
    target: ".ai/rules/"

  wrapper:
    name: "Tool Wrapper"
    type: "copy-files"
    source: "wrappers/{tool}.md"

tools:
  cursor:
    name: "Cursor"
    tasks:
      rules: "@shared_tasks.rules"
      wrapper:
        extends: "@shared_tasks.wrapper"
        target: ".cursor/rules/agents.md"

  claude:
    name: "Claude Code"
    tasks:
      rules: "@shared_tasks.rules"
      wrapper:
        extends: "@shared_tasks.wrapper"
        target: "CLAUDE.md"

projects:
  drupal:
    name: "Drupal"
    tasks:
      agents-md:
        type: "remote-copy-files"
        source: "drupal/AGENTS.md"
```

### Key Features

- **Shared task references**: `@shared_tasks.taskname`
- **Task inheritance**: `extends: "@shared_tasks.base"`
- **Variable substitution**: `{tool}`, `{project-type}`
- **Project-specific overrides**

### Our Implementation Plan

1. Design YAML schema for our agents/hooks/commands
2. Create config loader with reference resolution
3. Support inheritance and variable substitution
4. Migrate FileMapping to YAML-driven
5. Keep backward compatibility

---

## Pattern 5: Remote Repository Integration

### Priority: MEDIUM
### Complexity: HIGH
### Files to Create: `lib/git-operations.js`

### Description

Pull templates and rules from remote Git repositories with caching and version pinning.

### Lullabot Implementation

```javascript
// src/git-operations.js (key functions)

async function validateRepository(repository, verbose) {
  // Check if repository is accessible
  const git = simpleGit();
  await git.listRemote([repository.url]);
}

async function getOrCloneRepository(repository, verbose) {
  const cacheDir = path.join(os.tmpdir(), 'lullabot-project-cache');
  const repoHash = crypto.createHash('md5').update(repository.url).digest('hex');
  const localPath = path.join(cacheDir, repoHash);

  if (await fs.pathExists(localPath)) {
    // Update existing clone
    const git = simpleGit(localPath);
    await git.fetch();
    await git.checkout(repository.target);
    return localPath;
  }

  // Shallow clone for efficiency
  const git = simpleGit();
  await git.clone(repository.url, localPath, ['--depth', '1', '--branch', repository.target]);

  return localPath;
}

async function copyFilesFromRemote(tempDir, source, target, verbose, dependencies, items) {
  // Copy files with glob pattern matching
  const files = await glob(path.join(tempDir, source, '**/*'));
  // ... copy logic with filtering
}
```

### Configuration

```yaml
repository:
  url: "https://github.com/Lullabot/prompt_library"
  type: "branch"   # or "tag"
  target: "main"   # branch name or tag
```

### Our Implementation Plan

1. Add `simple-git` dependency
2. Create git operations module
3. Implement clone caching
4. Support branch and tag references
5. Add to FileMapping as source type

### Use Cases

- Pull Drupal-specific rules from community repo
- Version-pinned agent definitions
- Shared templates across projects

---

## Pattern 6: Multi-Tool Support (Wrapper Pattern)

### Priority: LOW
### Complexity: MEDIUM
### Files to Create: `templates/wrappers/`

### Description

Support multiple AI coding tools (Cursor, Claude, Windsurf, Copilot) from a single source of truth.

### Lullabot Implementation

**Central file:** `AGENTS.md` - Contains all AI instructions

**Tool-specific wrappers:**
```markdown
<!-- wrappers/cursor.md -->
<!-- Lullabot Project Start - DO NOT EDIT -->
@AGENTS.md
<!-- Lullabot Project End -->

<!-- Your custom Cursor rules below -->
```

```markdown
<!-- wrappers/claude.md -->
<!-- Lullabot Project Start - DO NOT EDIT -->
@AGENTS.md
<!-- Lullabot Project End -->
```

### Key Concept

- `AGENTS.md` = Source of truth
- Tool wrappers import AGENTS.md using `@` syntax
- User customizations go outside managed sections
- Updates only modify content between markers

### Our Implementation Plan

1. Consider if multi-tool support is needed
2. Create wrapper templates for each tool
3. Use marker comments for managed sections
4. Preserve user content during updates

---

## Pattern 7: Comprehensive CI/CD Pipeline

### Priority: MEDIUM
### Complexity: LOW
### Files to Create/Modify: `.github/workflows/ci.yml`, `.github/workflows/release.yml`

### Description

Robust CI/CD with parallel jobs, automated releases, and comprehensive validation.

### Lullabot Implementation

**CI Workflow (ci.yml):**
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm test
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v4

  lint:
    runs-on: ubuntu-latest
    steps:
      - run: npm run lint
      - run: npm run format:check
      - name: Check for auto-fixable issues
        run: |
          npm run lint:fix
          if [ -n "$(git status --porcelain)" ]; then
            echo "Auto-fixable issues found"
            exit 1
          fi

  build:
    runs-on: ubuntu-latest
    steps:
      - run: npm start -- --help
      - run: npm start -- --version
```

**Release Workflow (release.yml):**
```yaml
on:
  release:
    types: [published]

jobs:
  publish:
    steps:
      - run: npm test
      - run: npm run lint
      - name: Sync version from Git tag
        run: |
          VERSION=${GITHUB_REF##*/}
          VERSION=${VERSION#v}
          npm version $VERSION --no-git-tag-version
      - run: npm publish --access public
      - name: Verify publication
        run: npm view "$PACKAGE_NAME@$VERSION"
```

### Our Implementation Plan

1. Add lint job to CI workflow
2. Add format check
3. Create release.yml for automated NPM publishing
4. Add version sync from Git tags
5. Add publication verification

---

## Pattern 8: Dependency Injection for Testability

### Priority: MEDIUM
### Complexity: MEDIUM
### Files to Modify: All `lib/*.js` files

### Description

Inject all dependencies as parameters to enable complete unit testing without mocks.

### Lullabot Implementation

```javascript
// Before (hard to test)
async function promptUser(options, config) {
  const answers = await inquirer.prompt([...]);
  // ...
}

// After (fully testable)
async function promptUser(options, config, promptFn, getTasksFn) {
  const answers = await promptFn([...]);
  const tasks = await getTasksFn(config);
  // ...
}

// Factory for backward compatibility
function createPrompter(dependencies = {}) {
  const {
    promptFn = inquirer.prompt,
    getTasksFn = getTasks,
    chalk = defaultChalk
  } = dependencies;

  return {
    promptUser: (options, config) => promptUser(options, config, promptFn, getTasksFn),
    // ... other methods
  };
}
```

### Testing Example

```javascript
describe('promptUser', () => {
  it('should handle tool selection', async () => {
    const mockPrompt = jest.fn()
      .mockResolvedValueOnce({ tool: 'cursor' })
      .mockResolvedValueOnce({ project: 'drupal' });

    const result = await promptUser(
      {},
      mockConfig,
      mockPrompt,
      mockGetTasks
    );

    expect(result.tool).toBe('cursor');
    expect(mockPrompt).toHaveBeenCalledTimes(2);
  });
});
```

### Our Implementation Plan

1. Identify all external dependencies in each module
2. Refactor to accept dependencies as parameters
3. Create factory functions for backward compatibility
4. Update tests to use dependency injection
5. Remove mock overrides where possible

---

## Implementation Roadmap

### Phase 1: Quick Wins (1-2 days)
1. [ ] Add dry-run mode
2. [ ] Improve CI/CD pipeline
3. [ ] Add installation manifest

### Phase 2: Core Improvements (3-5 days)
4. [ ] Implement content filtering system
5. [ ] Add update tracking with change detection
6. [ ] Refactor for dependency injection

### Phase 3: Advanced Features (1-2 weeks)
7. [ ] YAML configuration system
8. [ ] Remote repository integration
9. [ ] Multi-tool wrapper support

---

## File References

### Lullabot Source Files Analyzed

| File | Purpose | Lines |
|------|---------|-------|
| `src/cli.js` | Refactored CLI with DI | ~200 |
| `src/prompts.js` | User prompts with DI | ~320 |
| `src/utils/content-filters.js` | Filter pipeline | ~310 |
| `src/git-operations.js` | Remote repo handling | ~250 |
| `src/file-operations.js` | File handling | ~400 |
| `src/task-types/multi-step.js` | Task orchestration | ~220 |
| `config/config.yml` | YAML configuration | ~300 |
| `.github/workflows/ci.yml` | CI pipeline | ~105 |
| `.github/workflows/release.yml` | Release automation | ~135 |

### Key Takeaways

1. **Testability First**: Every function should be testable in isolation
2. **Configuration as Data**: YAML reduces code complexity
3. **Pipelines Over Monoliths**: Small composable functions
4. **User Safety**: Dry-run and backups prevent disasters
5. **Track Everything**: Manifests enable smart updates

---

## Appendix: Code Snippets for Reference

### A. Content Filter Validation

```javascript
function validateFilterConfig(filters) {
  const errors = [];

  for (const [index, filter] of filters.entries()) {
    if (!Object.values(FILTER_TYPES).includes(filter.type)) {
      errors.push(`Filter ${index + 1}: Invalid type '${filter.type}'`);
    }

    if (filter.type === 'extract-content' && !filter.pattern) {
      errors.push(`Filter ${index + 1}: Missing 'pattern' for extract-content`);
    }

    if (filter.type === 'line-range') {
      if (filter.start === undefined || filter.end === undefined) {
        errors.push(`Filter ${index + 1}: Missing 'start' or 'end' for line-range`);
      }
    }

    // Validate regex syntax
    if (filter.pattern) {
      try {
        new RegExp(filter.pattern, filter.flags || '');
      } catch (error) {
        errors.push(`Filter ${index + 1}: Invalid regex - ${error.message}`);
      }
    }
  }

  return errors;
}
```

### B. File Hash Computation

```javascript
const crypto = require('crypto');

async function computeFileHash(filePath) {
  const content = await fs.readFile(filePath);
  return crypto.createHash('sha256').update(content).digest('hex');
}

async function createManifest(installedFiles, version) {
  const manifest = {
    version,
    installedAt: new Date().toISOString(),
    files: {}
  };

  for (const file of installedFiles) {
    manifest.files[file.relativePath] = {
      hash: await computeFileHash(file.absolutePath),
      version,
      source: file.source
    };
  }

  return manifest;
}
```

### C. Shared Task Resolution

```javascript
function resolveTaskConfig(taskRef, sharedTasks, tool, projectType) {
  // Direct reference: "@shared_tasks.rules"
  if (typeof taskRef === 'string' && taskRef.startsWith('@shared_tasks.')) {
    const taskName = taskRef.replace('@shared_tasks.', '');
    return substituteVariables(sharedTasks[taskName], tool, projectType);
  }

  // Extended reference: { extends: "@shared_tasks.wrapper", ... }
  if (taskRef.extends) {
    const baseName = taskRef.extends.replace('@shared_tasks.', '');
    const baseConfig = sharedTasks[baseName];
    return {
      ...substituteVariables(baseConfig, tool, projectType),
      ...taskRef
    };
  }

  return taskRef;
}
```

---

*Document generated from Lullabot Project analysis for drupal-claude-code-sub-agent-collective improvement planning.*
