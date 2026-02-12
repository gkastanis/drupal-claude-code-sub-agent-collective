const path = require('path');

/**
 * File mapping configuration for collective component installation
 * Defines where each template component should be installed in target projects
 */
class FileMapping {
  constructor(projectRoot, options = {}) {
    this.projectRoot = projectRoot;
    this.options = options;

    // Base installation paths
    this.paths = {
      claude: path.join(projectRoot, '.claude'),
      collective: path.join(projectRoot, '.claude-collective'),
      skills: path.join(projectRoot, '.claude', 'skills'),
      rules: path.join(projectRoot, '.claude', 'rules'),
      agentMemory: path.join(projectRoot, '.claude', 'agent-memory'),
      root: projectRoot
    };
  }

  /**
   * Get comprehensive file mapping for installation
   * @returns {Array} Array of mapping objects with source and target paths
   */
  getFileMapping() {
    return [
      // Core behavioral system
      ...this.getBehavioralMapping(),
      
      // Collective behavioral system
      ...this.getCollectiveMapping(),
      
      // Agent definitions  
      ...this.getAgentMapping(),
      
      // Agent library files
      ...this.getAgentLibMapping(),
      
      // Hook scripts
      ...this.getHookMapping(),
      
      // Command templates
      ...this.getCommandMapping(),

      // Rules directory (.claude/rules/)
      ...this.getRulesMapping(),

      // Agent memory seed files
      ...this.getAgentMemoryMapping(),

      // Skills
      ...this.getSkillMapping(),

      // Testing framework
      ...this.getTestMapping(),

      // Test scripts directory
      ...this.getScriptsMapping(),

      // Configuration files
      ...this.getConfigMapping(),
      
      // Documentation
      ...this.getDocumentationMapping()
    ];
  }

  getBehavioralMapping() {
    return [
      {
        source: 'CLAUDE.md',
        target: path.join(this.paths.root, 'CLAUDE.md'),
        type: 'behavioral',
        required: true,
        overwrite: this.options.force || false,
        description: 'Main behavioral directive file'
      }
    ];
  }

  getCollectiveMapping() {
    const collectiveFiles = [
      {
        file: 'CLAUDE.md',
        required: true,
        description: 'Collective behavioral rules and prime directives'
      },
      {
        file: 'DECISION.md',
        required: true, 
        description: 'Global decision engine for auto-delegation'
      },
      {
        file: 'agents.md',
        required: true,
        description: 'Available specialized agent catalog'
      },
      {
        file: 'hooks.md',
        required: true,
        description: 'Hook system integration requirements'
      },
      {
        file: 'quality.md',
        required: true,
        description: 'Quality gates and TDD reporting standards'
      },
      {
        file: 'research.md',
        required: true,
        description: 'Research hypotheses and validation metrics'
      },
      {
        file: 'INDEX.md',
        required: true,
        description: 'Compressed agent/command index with behavioral rules'
      },
      {
        file: 'van-context.md',
        required: false,
        description: 'Routing context (JIT: loaded on /van only)'
      },
      {
        file: 'taskmaster-reference.md',
        required: false,
        description: 'TaskMaster quick reference (JIT: loaded on TM commands)'
      },
      {
        file: 'research-framework.md',
        required: false,
        description: 'Research hypotheses and metrics (JIT: loaded on research tasks)'
      },
      {
        file: 'hook-guide.md',
        required: false,
        description: 'Hook troubleshooting guide (JIT: loaded on hook debugging)'
      }
    ];

    return collectiveFiles.map(file => ({
      source: path.join('.claude-collective', file.file),
      target: path.join(this.paths.collective, file.file),
      type: 'collective',
      required: file.required,
      overwrite: true,
      description: file.description
    }));
  }

  getAgentMapping() {
    const allAgents = [
      // Core Coordination
      'routing-agent.md',

      // Core Drupal Work Agents
      'drupal-architect.md',
      'module-development-agent.md',
      'theme-development-agent.md',
      'configuration-management-agent.md',
      'content-migration-agent.md',

      // Quality & Security (consolidated gates)
      'security-compliance-agent.md',
      'performance-devops-agent.md',

      // Testing Agents
      'functional-testing-agent.md',
      'unit-testing-agent.md',
      'visual-regression-agent.md',

      // Project Management & Coordination
      'enhanced-project-manager-agent.md',
      'research-agent.md',
      'workflow-agent.md',

      // Documentation
      'semantic-architect-agent.md'
    ];

    const minimalAgents = [
      'routing-agent.md',
      'drupal-architect.md',
      'module-development-agent.md',
      'security-compliance-agent.md'
    ];

    const agents = this.options.minimal ? minimalAgents : allAgents;

    return agents.map(agent => ({
      source: path.join('agents', agent),
      target: path.join(this.paths.claude, 'agents', agent),
      type: 'agent',
      required: agent === 'routing-agent.md' || agent === 'drupal-architect.md',
      overwrite: true,
      description: `Agent definition: ${agent.replace('.md', '')}`
    }));
  }

  getAgentLibMapping() {
    // Agent library files (currently none - reserved for future use)
    const libFiles = [];

    return libFiles.map(libFile => ({
      source: path.join('agents', 'lib', libFile),
      target: path.join(this.paths.claude, 'agents', 'lib', libFile),
      type: 'agent-lib',
      required: false,
      overwrite: true,
      description: `Agent library file: ${libFile}`
    }));
  }

  getRulesMapping() {
    const rules = [
      {
        file: 'drupal-services.md',
        description: 'Dependency injection, Entity API, service registration rules'
      },
      {
        file: 'drupal-security.md',
        description: 'Input sanitization, XSS prevention, access control rules'
      },
      {
        file: 'translation-rules.md',
        description: 't() usage, .po file conventions, msgctxt rules'
      },
      {
        file: 'code-quality.md',
        description: 'Grep after changes, magic numbers, multi-location removal'
      },
      {
        file: 'css-conventions.md',
        description: 'BEM methodology, specific selectors, asset management'
      },
      {
        file: 'error-handling.md',
        description: 'Exception hierarchy, narrow catch, fail fast rules'
      },
      {
        file: 'testing-verification.md',
        description: 'Verification requirements, script storage, escaping rules'
      }
    ];

    return rules.map(rule => ({
      source: path.join('.claude', 'rules', rule.file),
      target: path.join(this.paths.rules, rule.file),
      type: 'rules',
      required: false,
      overwrite: true,
      description: rule.description
    }));
  }

  getAgentMemoryMapping() {
    const agents = [
      'drupal-architect',
      'module-development-agent',
      'security-compliance-agent',
      'research-agent',
      'configuration-management-agent'
    ];

    return agents.map(agent => ({
      source: path.join('agent-memory', agent, 'MEMORY.md'),
      target: path.join(this.paths.agentMemory, agent, 'MEMORY.md'),
      type: 'agent-memory',
      required: false,
      overwrite: false, // Don't overwrite existing agent memories
      description: `Agent memory seed: ${agent}`
    }));
  }

  getHookMapping() {
    const hooks = [
      {
        file: 'collective-metrics.sh',
        required: true,
        description: 'Collects performance and research metrics'
      },
      {
        file: 'load-behavioral-system.sh',
        required: true,
        description: 'Loads collective behavioral system during SessionStart events'
      },
      {
        file: 'block-destructive-commands.sh',
        required: true,
        description: 'Blocks dangerous destructive commands before execution'
      },
      {
        file: 'block-sensitive-files.sh',
        required: true,
        description: 'Blocks Read/Grep access to sensitive Drupal configuration files (.env, settings.php, etc.)'
      },
      {
        file: 'semantic-docs-update-hook.sh',
        required: false,
        description: 'Reminds to update semantic documentation after development tasks complete'
      },
      {
        file: 'test-driven-handoff.sh',
        required: true,
        description: 'Detects and processes agent handoff patterns with TDD validation'
      },
      {
        file: 'pre-compact-state.sh',
        required: true,
        description: 'Saves agent state before context compaction for recovery'
      },
      {
        file: 'subagent-context-inject.sh',
        required: true,
        description: 'Injects project context and validates agent name on spawn'
      },
      {
        file: 'teammate-quality-gate.sh',
        required: false,
        description: 'Advisory verification reminder for TeammateIdle and TaskCompleted events'
      },
      {
        file: 'collective-statusline.sh',
        required: true,
        description: 'Enhanced statusline showing context usage, git branch, version, tasks, and handoffs'
      },
      {
        file: 'lib/hook-utils.sh',
        required: true,
        description: 'Shared hook utilities: JSON parsing, Unicode normalization, handoff detection'
      }
    ];

    return hooks.map(hook => ({
      source: path.join('hooks', hook.file),
      target: path.join(this.paths.claude, 'hooks', hook.file),
      type: 'hook',
      required: hook.required,
      executable: true,
      overwrite: true,
      description: hook.description
    }));
  }

  getCommandMapping() {
    const commands = [
      // Core collective commands
      'autocompact.md',
      'continue-handoff.md',
      'mock.md',
      'reset-handoff.md',
      'setup-sandbox.md',
      'van.md',

      // Workflow commands
      'implement.md',
      'update-docs.md',
      'verify-changes.md',

      // Testing commands
      'drupal-verify.md'
    ];

    const mappings = [];

    // Map core commands
    for (const command of commands) {
      mappings.push({
        source: path.join('commands', command),
        target: path.join(this.paths.claude, 'commands', command),
        type: 'command',
        required: false,
        overwrite: true,
        description: `Command template: ${command.replace('.md', '')}`
      });
    }

    // Map TaskMaster command structure
    const tmCommands = [
      // Reference commands
      'help.md',
      'learn.md',
      'tm-main.md',

      // Task operations
      'add-task/add-task.md',
      'show/show-task.md',
      'next/next-task.md',
      'set-status/set-status.md',
      'remove-task/remove-task.md',

      // Subtask operations
      'add-subtask/add-subtask.md',
      'add-subtask/convert-task-to-subtask.md',
      'remove-subtask/remove-subtask.md',
      'clear-subtasks/clear-all-subtasks.md',
      'clear-subtasks/clear-subtasks.md',

      // Task updates (consolidated)
      'update/update.md',

      // Dependencies
      'add-dependency/add-dependency.md',
      'remove-dependency/remove-dependency.md',
      'validate-dependencies/validate-dependencies.md',
      'fix-dependencies/fix-dependencies.md',

      // Analysis & planning
      'analyze-complexity/analyze-complexity.md',
      'complexity-report/complexity-report.md',
      'expand/expand.md',
      'list/list.md',

      // Project setup (consolidated)
      'init/init.md',
      'parse-prd/parse-prd.md',
      'setup/install.md',
      'models/models.md',

      // Utilities
      'generate/generate-tasks.md',
      'status/project-status.md',
      'sync-readme/sync-readme.md',
      'utils/analyze-project.md',

      // Workflows (consolidated)
      'workflows/workflow.md'
    ];

    // Map TaskMaster commands
    for (const tmCommand of tmCommands) {
      mappings.push({
        source: path.join('commands', 'tm', tmCommand),
        target: path.join(this.paths.claude, 'commands', 'tm', tmCommand),
        type: 'command',
        required: false,
        overwrite: true,
        description: `TaskMaster command: ${tmCommand.replace('.md', '')}`
      });
    }

    return mappings;
  }

  getSkillMapping() {
    const skillFiles = [
      // Semantic docs skill - main documentation files
      {
        file: 'semantic-docs/SKILL.md',
        required: false,
        description: 'Semantic documentation navigator skill definition'
      },
      {
        file: 'semantic-docs/SEARCH.md',
        required: false,
        description: 'Advanced search patterns for semantic documentation'
      },
      {
        file: 'semantic-docs/ENTITY-LOOKUP.md',
        required: false,
        description: 'Entity schema reference and lookup guide'
      },
      // Semantic docs skill - scripts
      {
        file: 'semantic-docs/scripts/find-feature.sh',
        required: false,
        executable: true,
        description: 'Find full technical spec for a feature'
      },
      {
        file: 'semantic-docs/scripts/find-logic-id.sh',
        required: false,
        executable: true,
        description: 'Find Logic ID and return code mapping'
      },
      {
        file: 'semantic-docs/scripts/trace-code.sh',
        required: false,
        executable: true,
        description: 'Trace from Logic ID to actual source code'
      },
      {
        file: 'semantic-docs/scripts/find-entity.sh',
        required: false,
        executable: true,
        description: 'Find entity schema by name'
      },
      {
        file: 'semantic-docs/scripts/find-user-story.sh',
        required: false,
        executable: true,
        description: 'Find user story and linked Logic IDs'
      },
      {
        file: 'semantic-docs/scripts/list-features.sh',
        required: false,
        executable: true,
        description: 'List all documented features'
      },
      // Condition-based waiting skill - eliminate flaky tests
      {
        file: 'condition-based-waiting/SKILL.md',
        required: false,
        description: 'Replace arbitrary sleeps with condition polling for reliable tests'
      },
      // Git advanced workflows skill - history management and recovery
      {
        file: 'git-advanced-workflows/SKILL.md',
        required: false,
        description: 'Rebase, cherry-pick, bisect, worktrees, and reflog recovery'
      },
      // Drupal-specific skills (v2.1)
      {
        file: 'drupal-entity-api/SKILL.md',
        required: false,
        description: 'Field type matrix, entity CRUD, view modes, content modeling'
      },
      {
        file: 'drupal-service-di/SKILL.md',
        required: false,
        description: 'Service definitions, DI patterns, interface design'
      },
      {
        file: 'drupal-caching/SKILL.md',
        required: false,
        description: 'Cache bins, tags, contexts, invalidation, external backends'
      },
      {
        file: 'drupal-security-patterns/SKILL.md',
        required: false,
        description: 'OWASP prevention, access control, input sanitization'
      },
      {
        file: 'drupal-coding-standards/SKILL.md',
        required: false,
        description: 'PHPCS, PHPStan, naming conventions, code style'
      },
      {
        file: 'drupal-hook-patterns/SKILL.md',
        required: false,
        description: 'OOP hooks (D11), form alters, entity hooks, legacy bridges'
      },
      {
        file: 'twig-templating/SKILL.md',
        required: false,
        description: 'Template patterns, filters, theme suggestions, BEM components'
      },
      // Browser automation skill
      {
        file: 'agent-browser/SKILL.md',
        required: false,
        description: 'CLI browser automation for testing and interaction'
      },
      // Docs-first discovery skill
      {
        file: 'discover/SKILL.md',
        required: false,
        description: 'Docs-first discovery for efficient codebase exploration'
      },
      {
        file: 'discover/scripts/discover.sh',
        required: false,
        executable: true,
        description: 'Main discovery entry point with feature lookup and search'
      },
      {
        file: 'discover/scripts/prime.sh',
        required: false,
        executable: true,
        description: 'Load business index for session context priming'
      },
      // PRD generator skill
      {
        file: 'prd/SKILL.md',
        required: false,
        description: 'Structured PRD generator with clarifying questions and user stories'
      },
      // Drupal testing skill
      {
        file: 'drupal-testing/SKILL.md',
        required: false,
        description: 'Curl smoke tests, drush eval, test script patterns'
      },
      // Verification gate skill
      {
        file: 'verification-before-completion/SKILL.md',
        required: false,
        description: 'Verification gate - test before claiming completion'
      }
    ];

    return skillFiles.map(skill => ({
      source: path.join('skills', skill.file),
      target: path.join(this.paths.claude, 'skills', skill.file),
      type: 'skill',
      required: skill.required,
      executable: skill.executable || false,
      overwrite: true,
      description: skill.description
    }));
  }

  getTestMapping() {
    return [
      // Test package configuration
      {
        source: path.join('.claude-collective', 'package.json'),
        target: path.join(this.paths.collective, 'package.json'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Test framework package configuration'
      },
      
      // Jest configuration
      {
        source: path.join('.claude-collective', 'jest.config.js'),
        target: path.join(this.paths.collective, 'jest.config.js'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Jest testing framework configuration'
      },
      
      // Metrics reporting script
      {
        source: path.join('.claude-collective', 'metrics-report.js'),
        target: path.join(this.paths.collective, 'metrics-report.js'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Metrics collection and reporting system'
      },
      
      // Test suite files
      {
        source: path.join('.claude-collective', 'tests', 'agents', 'tdd-validation.test.js'),
        target: path.join(this.paths.collective, 'tests', 'agents', 'tdd-validation.test.js'),
        type: 'test',
        required: true,
        overwrite: true,
        description: 'TDD validation agent tests'
      },
      
      {
        source: path.join('.claude-collective', 'tests', 'contracts', 'contract-validation.test.js'),
        target: path.join(this.paths.collective, 'tests', 'contracts', 'contract-validation.test.js'),
        type: 'test',
        required: true,
        overwrite: true,
        description: 'Contract validation tests'
      },
      
      {
        source: path.join('.claude-collective', 'tests', 'contracts', 'advanced-contract.test.js'),
        target: path.join(this.paths.collective, 'tests', 'contracts', 'advanced-contract.test.js'),
        type: 'test',
        required: true,
        overwrite: true,
        description: 'Advanced contract validation tests'
      },
      
      {
        source: path.join('.claude-collective', 'tests', 'handoffs', 'agent-handoff.test.js'),
        target: path.join(this.paths.collective, 'tests', 'handoffs', 'agent-handoff.test.js'),
        type: 'test',
        required: true,
        overwrite: true,
        description: 'Agent handoff validation tests'
      },
      
      {
        source: path.join('.claude-collective', 'tests', 'setup.js'),
        target: path.join(this.paths.collective, 'tests', 'setup.js'),
        type: 'test',
        required: true,
        overwrite: true,
        description: 'Test suite setup and utilities'
      },
      
      // Create initial metrics directory
      {
        source: path.join('.claude-collective', 'metrics', 'metrics-20250812.json'),
        target: path.join(this.paths.collective, 'metrics', 'baseline.json'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Baseline metrics configuration'
      }
    ];
  }

  getScriptsMapping() {
    return [{
      source: path.join('scripts', 'tests', 'index.md'),
      target: path.join(this.paths.root, 'scripts', 'tests', 'index.md'),
      type: 'scripts',
      required: false,
      overwrite: false,
      description: 'Test scripts index seed file'
    }];
  }

  getConfigMapping() {
    return [
      // Claude settings
      {
        source: 'settings.json.template',
        target: path.join(this.paths.claude, 'settings.json'),
        type: 'config',
        required: true,
        overwrite: this.options.force || false,
        description: 'Claude Code hook configuration'
      },

      // Sensitive files configuration
      {
        source: path.join('.claude', 'sensitive-files.json'),
        target: path.join(this.paths.claude, 'sensitive-files.json'),
        type: 'config',
        required: true,
        overwrite: false,  // Don't overwrite user customizations
        description: 'Sensitive file patterns for Read/Grep blocking'
      },
      
      // Vitest configuration for TDD validation (root level)
      {
        source: 'vitest.config.js',
        target: path.join(this.paths.root, 'vitest.config.js'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Vitest configuration for TDD hooks validation'
      },
      
      // Vitest configuration in .claude-collective (where dependencies are)
      {
        source: path.join('.claude-collective', 'vitest.config.js'),
        target: path.join(this.paths.collective, 'vitest.config.js'),
        type: 'config',
        required: true,
        overwrite: true,
        description: 'Vitest configuration in collective directory with dependencies'
      }
    ];
  }

  getDocumentationMapping() {
    return [
      {
        source: path.join('docs', 'README.md'),
        target: path.join(this.paths.claude, 'docs', 'README.md'),
        type: 'docs',
        required: false,
        overwrite: true,
        description: 'Collective system documentation'
      },

      {
        source: path.join('docs', 'TROUBLESHOOTING.md'),
        target: path.join(this.paths.claude, 'docs', 'TROUBLESHOOTING.md'),
        type: 'docs',
        required: false,
        overwrite: true,
        description: 'Troubleshooting guide'
      },

      {
        source: path.join('docs', 'AGENT-HANDOFF-SCHEMA.md'),
        target: path.join(this.paths.claude, 'docs', 'AGENT-HANDOFF-SCHEMA.md'),
        type: 'docs',
        required: false,
        overwrite: true,
        description: 'Standardized agent handoff schema specification'
      }
    ];
  }

  /**
   * Get filtered mapping based on installation type
   * @param {string} installationType - 'full', 'minimal', 'testing-only'
   * @returns {Array} Filtered mapping array
   */
  getFilteredMapping(installationType = 'full') {
    const allMappings = this.getFileMapping();
    
    switch (installationType) {
      case 'minimal':
        return allMappings.filter(mapping => 
          mapping.required || 
          (mapping.type === 'agent' && mapping.source.includes('routing-agent'))
        );
        
      case 'testing-only':
        return allMappings.filter(mapping => 
          mapping.type === 'test' || 
          mapping.type === 'config' ||
          mapping.type === 'collective' ||
          (mapping.type === 'behavioral' && mapping.required)
        );
        
      case 'hooks-only':
        return allMappings.filter(mapping =>
          mapping.type === 'hook' ||
          mapping.type === 'config' ||
          mapping.type === 'collective' ||
          (mapping.type === 'behavioral' && mapping.required)
        );
        
      case 'full':
      default:
        return allMappings;
    }
  }

  /**
   * Get directory structure that needs to be created
   * @returns {Array} Array of directory paths
   */
  getDirectoryStructure() {
    const mapping = this.getFileMapping();
    const dirs = new Set();
    
    // Extract unique directories from target paths
    mapping.forEach(item => {
      const dir = path.dirname(item.target);
      dirs.add(dir);
      
      // Add parent directories recursively
      let parentDir = path.dirname(dir);
      while (parentDir !== this.projectRoot && parentDir !== '/') {
        dirs.add(parentDir);
        parentDir = path.dirname(parentDir);
      }
    });
    
    return Array.from(dirs).sort();
  }

  /**
   * Validate file mapping for conflicts and requirements
   * @returns {Object} Validation results
   */
  validateMapping() {
    const mapping = this.getFileMapping();
    const issues = [];
    const warnings = [];
    
    // Check for target path conflicts
    const targetPaths = new Set();
    mapping.forEach(item => {
      if (targetPaths.has(item.target)) {
        issues.push(`Duplicate target path: ${item.target}`);
      }
      targetPaths.add(item.target);
    });
    
    // Check required files
    const requiredFiles = mapping.filter(item => item.required);
    if (requiredFiles.length === 0) {
      issues.push('No required files defined');
    }
    
    // Check for potential overwrites without force flag
    if (!this.options.force) {
      const overwriteFiles = mapping.filter(item => item.overwrite);
      overwriteFiles.forEach(item => {
        warnings.push(`Will overwrite: ${item.target}`);
      });
    }
    
    return {
      valid: issues.length === 0,
      issues,
      warnings,
      totalFiles: mapping.length,
      requiredFiles: requiredFiles.length
    };
  }

  /**
   * Get mapping summary for display
   * @returns {Object} Summary object
   */
  getSummary() {
    const mapping = this.getFileMapping();
    const byType = {};
    
    mapping.forEach(item => {
      if (!byType[item.type]) {
        byType[item.type] = [];
      }
      byType[item.type].push(item);
    });
    
    return {
      totalFiles: mapping.length,
      byType,
      directories: this.getDirectoryStructure().length,
      requiredFiles: mapping.filter(item => item.required).length,
      optionalFiles: mapping.filter(item => !item.required).length
    };
  }
}

module.exports = { FileMapping };