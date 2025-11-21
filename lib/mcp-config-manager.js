/**
 * @file mcp-config-manager.js
 * @description Manages MCP server configuration generation for project-specific .mcp.json files
 *
 * Purpose:
 * - Generate .mcp.json configurations based on installation flags
 * - Validate MCP server configurations
 * - Provide server definitions and metadata
 *
 * Default Behavior:
 * - Always includes Task Master (required for /van commands)
 * - Excludes Playwright by default (prevents zombie process issues)
 * - Excludes Context7 by default (opt-in)
 *
 * Architecture:
 * - Uses Handlebars template system for conditional rendering
 * - Validates against JSON schema
 * - Provides resource usage metadata for documentation
 */

const fs = require('fs-extra');
const path = require('path');
const Handlebars = require('handlebars');

class MCPConfigManager {
  constructor() {
    this.templatePath = path.join(__dirname, '../templates/.mcp.json.template');
    this.serverDefinitions = {
      'task-master': {
        name: 'Task Master AI',
        description: 'Project management and workflow automation (Required for /van commands)',
        command: 'npx',
        args: ['-y', '--package=task-master-ai', 'task-master-ai'],
        required: true,
        resourceUsage: { memory: '~20MB', cpu: 'Low' }
      },
      'playwright': {
        name: 'Playwright Browser Automation',
        description: 'Visual regression testing and browser automation (High resource usage)',
        command: 'npx',
        args: ['-y', 'playwright-mcp-server'],
        required: false,
        resourceUsage: { memory: '~200MB', cpu: 'High' },
        warning: 'Known issue: May create zombie processes on Linux. Use cleanup scripts if needed.'
      },
      'context7': {
        name: 'Context7 Documentation',
        description: 'Up-to-date library documentation and code examples',
        command: 'npx',
        args: ['-y', '@upstash/context7-mcp'],
        required: false,
        resourceUsage: { memory: '~30MB', cpu: 'Low' }
      }
    };
  }

  /**
   * Generate MCP configuration based on installation options
   *
   * @param {Object} options - Installation options
   * @param {boolean} options.withPlaywright - Include Playwright MCP server
   * @param {boolean} options.withContext7 - Include Context7 MCP server
   * @param {boolean} options.withAllMcps - Include all MCP servers
   * @param {string} options.version - Package version
   * @returns {string} Rendered .mcp.json content
   */
  generateConfig(options = {}) {
    const {
      withPlaywright = false,
      withContext7 = false,
      withAllMcps = false,
      version = 'unknown'
    } = options;

    // Determine which servers to include
    const includePlaywright = withAllMcps || withPlaywright;
    const includeContext7 = withAllMcps || withContext7;

    // Determine profile name for metadata
    let profile = 'default';
    if (withAllMcps) {
      profile = 'full';
    } else if (includePlaywright && includeContext7) {
      profile = 'custom-full';
    } else if (includePlaywright) {
      profile = 'with-playwright';
    } else if (includeContext7) {
      profile = 'with-context7';
    }

    // Load and compile template
    const templateContent = fs.readFileSync(this.templatePath, 'utf8');
    const template = Handlebars.compile(templateContent);

    // Render template with options
    const rendered = template({
      includePlaywright,
      includeContext7,
      version,
      installedAt: new Date().toISOString(),
      profile
    });

    return rendered;
  }

  /**
   * Validate MCP configuration structure
   *
   * @param {Object} config - Parsed .mcp.json configuration
   * @returns {Object} Validation result with { valid: boolean, errors: string[] }
   */
  validateConfig(config) {
    const errors = [];

    // Check top-level structure
    if (!config || typeof config !== 'object') {
      errors.push('Configuration must be a valid JSON object');
      return { valid: false, errors };
    }

    if (!config.mcpServers || typeof config.mcpServers !== 'object') {
      errors.push('Configuration must have "mcpServers" object');
      return { valid: false, errors };
    }

    // Validate Task Master is always present (required)
    if (!config.mcpServers['task-master']) {
      errors.push('Task Master server is required but not found in configuration');
    } else {
      this._validateServerDefinition('task-master', config.mcpServers['task-master'], errors);
    }

    // Validate optional servers if present
    if (config.mcpServers.playwright) {
      this._validateServerDefinition('playwright', config.mcpServers.playwright, errors);
    }

    if (config.mcpServers.context7) {
      this._validateServerDefinition('context7', config.mcpServers.context7, errors);
    }

    // Validate metadata if present
    if (config.meta) {
      if (!config.meta.generatedBy || config.meta.generatedBy !== 'drupal-claude-collective') {
        errors.push('Configuration meta.generatedBy must be "drupal-claude-collective"');
      }
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  /**
   * Validate individual server definition
   *
   * @private
   * @param {string} serverName - Server identifier
   * @param {Object} serverDef - Server definition object
   * @param {string[]} errors - Array to collect errors
   */
  _validateServerDefinition(serverName, serverDef, errors) {
    if (!serverDef.command || typeof serverDef.command !== 'string') {
      errors.push(`Server "${serverName}" must have a valid "command" string`);
    }

    if (!Array.isArray(serverDef.args)) {
      errors.push(`Server "${serverName}" must have "args" array`);
    }

    if (serverDef.env !== undefined && typeof serverDef.env !== 'object') {
      errors.push(`Server "${serverName}" "env" must be an object if present`);
    }
  }

  /**
   * Get server definitions with metadata
   *
   * @returns {Object} Server definitions keyed by server name
   */
  getServerDefinitions() {
    return { ...this.serverDefinitions };
  }

  /**
   * Get list of required servers
   *
   * @returns {string[]} Array of required server names
   */
  getRequiredServers() {
    return Object.entries(this.serverDefinitions)
      .filter(([, def]) => def.required)
      .map(([name]) => name);
  }

  /**
   * Get list of optional servers
   *
   * @returns {string[]} Array of optional server names
   */
  getOptionalServers() {
    return Object.entries(this.serverDefinitions)
      .filter(([, def]) => !def.required)
      .map(([name]) => name);
  }

  /**
   * Get estimated resource usage for a configuration
   *
   * @param {Object} config - Parsed .mcp.json configuration
   * @returns {Object} Resource usage estimate { memory: string, cpu: string }
   */
  getResourceUsage(config) {
    if (!config?.mcpServers) {
      return { memory: 'Unknown', cpu: 'Unknown' };
    }

    const servers = Object.keys(config.mcpServers);
    let totalMemoryMB = 0;
    let maxCpu = 'Low';

    servers.forEach(serverName => {
      const def = this.serverDefinitions[serverName];
      if (def?.resourceUsage) {
        // Extract memory value (e.g., "~20MB" -> 20)
        const memoryMatch = def.resourceUsage.memory.match(/(\d+)/);
        if (memoryMatch) {
          totalMemoryMB += parseInt(memoryMatch[1]);
        }

        // Track highest CPU usage
        if (def.resourceUsage.cpu === 'High') {
          maxCpu = 'High';
        } else if (def.resourceUsage.cpu === 'Medium' && maxCpu === 'Low') {
          maxCpu = 'Medium';
        }
      }
    });

    return {
      memory: `~${totalMemoryMB}MB`,
      cpu: maxCpu,
      servers: servers.length
    };
  }
}

module.exports = MCPConfigManager;
