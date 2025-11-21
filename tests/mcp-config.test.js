/**
 * @file mcp-config.test.js
 * @description Tests for MCP configuration generation and validation
 */

const MCPConfigManager = require('../lib/mcp-config-manager');
const fs = require('fs-extra');
const path = require('path');

describe('MCPConfigManager', () => {
  let mcpManager;

  beforeEach(() => {
    mcpManager = new MCPConfigManager();
  });

  describe('Server Definitions', () => {
    test('should have all required server definitions', () => {
      const definitions = mcpManager.getServerDefinitions();

      expect(definitions).toHaveProperty('task-master');
      expect(definitions).toHaveProperty('playwright');
      expect(definitions).toHaveProperty('context7');
    });

    test('Task Master should be marked as required', () => {
      const definitions = mcpManager.getServerDefinitions();

      expect(definitions['task-master'].required).toBe(true);
    });

    test('Optional servers should not be marked as required', () => {
      const definitions = mcpManager.getServerDefinitions();

      expect(definitions.playwright.required).toBe(false);
      expect(definitions.context7.required).toBe(false);
    });

    test('All servers should have resource usage metadata', () => {
      const definitions = mcpManager.getServerDefinitions();

      Object.values(definitions).forEach(server => {
        expect(server.resourceUsage).toBeDefined();
        expect(server.resourceUsage.memory).toBeDefined();
        expect(server.resourceUsage.cpu).toBeDefined();
      });
    });
  });

  describe('Configuration Generation', () => {
    test('should generate default config with Task Master only', () => {
      const config = mcpManager.generateConfig({});
      const parsed = JSON.parse(config);

      expect(parsed.mcpServers).toBeDefined();
      expect(parsed.mcpServers['task-master']).toBeDefined();
      expect(parsed.mcpServers.playwright).toBeUndefined();
      expect(parsed.mcpServers.context7).toBeUndefined();
    });

    test('should include Playwright when withPlaywright is true', () => {
      const config = mcpManager.generateConfig({ withPlaywright: true });
      const parsed = JSON.parse(config);

      expect(parsed.mcpServers['task-master']).toBeDefined();
      expect(parsed.mcpServers.playwright).toBeDefined();
      expect(parsed.mcpServers.context7).toBeUndefined();
    });

    test('should include Context7 when withContext7 is true', () => {
      const config = mcpManager.generateConfig({ withContext7: true });
      const parsed = JSON.parse(config);

      expect(parsed.mcpServers['task-master']).toBeDefined();
      expect(parsed.mcpServers.playwright).toBeUndefined();
      expect(parsed.mcpServers.context7).toBeDefined();
    });

    test('should include all servers when withAllMcps is true', () => {
      const config = mcpManager.generateConfig({ withAllMcps: true });
      const parsed = JSON.parse(config);

      expect(parsed.mcpServers['task-master']).toBeDefined();
      expect(parsed.mcpServers.playwright).toBeDefined();
      expect(parsed.mcpServers.context7).toBeDefined();
    });

    test('should set correct profile metadata', () => {
      const defaultConfig = JSON.parse(mcpManager.generateConfig({}));
      expect(defaultConfig.meta.profile).toBe('default');

      const playwrightConfig = JSON.parse(mcpManager.generateConfig({ withPlaywright: true }));
      expect(playwrightConfig.meta.profile).toBe('with-playwright');

      const context7Config = JSON.parse(mcpManager.generateConfig({ withContext7: true }));
      expect(context7Config.meta.profile).toBe('with-context7');

      const fullConfig = JSON.parse(mcpManager.generateConfig({ withAllMcps: true }));
      expect(fullConfig.meta.profile).toBe('full');

      const customConfig = JSON.parse(mcpManager.generateConfig({
        withPlaywright: true,
        withContext7: true
      }));
      expect(customConfig.meta.profile).toBe('custom-full');
    });

    test('should include version in metadata', () => {
      const config = mcpManager.generateConfig({ version: '1.2.3' });
      const parsed = JSON.parse(config);

      expect(parsed.meta.version).toBe('1.2.3');
    });

    test('should include generatedBy in metadata', () => {
      const config = mcpManager.generateConfig({});
      const parsed = JSON.parse(config);

      expect(parsed.meta.generatedBy).toBe('drupal-claude-collective');
    });

    test('should generate valid JSON', () => {
      const config = mcpManager.generateConfig({ withAllMcps: true });

      expect(() => JSON.parse(config)).not.toThrow();
    });
  });

  describe('Configuration Validation', () => {
    test('should validate default config successfully', () => {
      const config = mcpManager.generateConfig({});
      const parsed = JSON.parse(config);
      const validation = mcpManager.validateConfig(parsed);

      expect(validation.valid).toBe(true);
      expect(validation.errors).toHaveLength(0);
    });

    test('should validate full config successfully', () => {
      const config = mcpManager.generateConfig({ withAllMcps: true });
      const parsed = JSON.parse(config);
      const validation = mcpManager.validateConfig(parsed);

      expect(validation.valid).toBe(true);
      expect(validation.errors).toHaveLength(0);
    });

    test('should fail validation for missing Task Master', () => {
      const invalidConfig = {
        mcpServers: {
          playwright: { command: 'npx', args: [], env: {} }
        }
      };

      const validation = mcpManager.validateConfig(invalidConfig);

      expect(validation.valid).toBe(false);
      expect(validation.errors).toContain('Task Master server is required but not found in configuration');
    });

    test('should fail validation for missing mcpServers object', () => {
      const invalidConfig = { meta: { version: '1.0.0' } };

      const validation = mcpManager.validateConfig(invalidConfig);

      expect(validation.valid).toBe(false);
      expect(validation.errors.length).toBeGreaterThan(0);
    });

    test('should fail validation for invalid server definition', () => {
      const invalidConfig = {
        mcpServers: {
          'task-master': {
            // Missing required fields
            description: 'Test'
          }
        }
      };

      const validation = mcpManager.validateConfig(invalidConfig);

      expect(validation.valid).toBe(false);
    });

    test('should validate server command field', () => {
      const invalidConfig = {
        mcpServers: {
          'task-master': {
            args: [],
            env: {}
            // Missing command
          }
        }
      };

      const validation = mcpManager.validateConfig(invalidConfig);

      expect(validation.valid).toBe(false);
      expect(validation.errors.some(err => err.includes('command'))).toBe(true);
    });

    test('should validate server args field', () => {
      const invalidConfig = {
        mcpServers: {
          'task-master': {
            command: 'npx',
            args: 'invalid', // Should be array
            env: {}
          }
        }
      };

      const validation = mcpManager.validateConfig(invalidConfig);

      expect(validation.valid).toBe(false);
      expect(validation.errors.some(err => err.includes('args'))).toBe(true);
    });
  });

  describe('Required and Optional Servers', () => {
    test('should correctly identify required servers', () => {
      const required = mcpManager.getRequiredServers();

      expect(required).toContain('task-master');
      expect(required).toHaveLength(1);
    });

    test('should correctly identify optional servers', () => {
      const optional = mcpManager.getOptionalServers();

      expect(optional).toContain('playwright');
      expect(optional).toContain('context7');
      expect(optional).toHaveLength(2);
    });
  });

  describe('Resource Usage Estimation', () => {
    test('should calculate resource usage for default config', () => {
      const config = JSON.parse(mcpManager.generateConfig({}));
      const usage = mcpManager.getResourceUsage(config);

      expect(usage.memory).toBe('~20MB');
      expect(usage.cpu).toBe('Low');
      expect(usage.servers).toBe(1);
    });

    test('should calculate resource usage with Playwright', () => {
      const config = JSON.parse(mcpManager.generateConfig({ withPlaywright: true }));
      const usage = mcpManager.getResourceUsage(config);

      expect(usage.memory).toBe('~220MB');
      expect(usage.cpu).toBe('High');
      expect(usage.servers).toBe(2);
    });

    test('should calculate resource usage for full config', () => {
      const config = JSON.parse(mcpManager.generateConfig({ withAllMcps: true }));
      const usage = mcpManager.getResourceUsage(config);

      expect(usage.memory).toBe('~250MB');
      expect(usage.cpu).toBe('High');
      expect(usage.servers).toBe(3);
    });

    test('should handle unknown servers gracefully', () => {
      const customConfig = {
        mcpServers: {
          'task-master': { command: 'npx', args: [], env: {} },
          'unknown-server': { command: 'npx', args: [], env: {} }
        }
      };

      const usage = mcpManager.getResourceUsage(customConfig);

      expect(usage).toBeDefined();
      expect(usage.servers).toBe(2);
    });
  });

  describe('Server Warnings', () => {
    test('Playwright should have zombie process warning', () => {
      const definitions = mcpManager.getServerDefinitions();

      expect(definitions.playwright.warning).toBeDefined();
      expect(definitions.playwright.warning).toContain('zombie');
    });

    test('Task Master and Context7 should not have warnings', () => {
      const definitions = mcpManager.getServerDefinitions();

      expect(definitions['task-master'].warning).toBeUndefined();
      expect(definitions.context7.warning).toBeUndefined();
    });
  });

  describe('Template File Existence', () => {
    test('should have template file', () => {
      const templatePath = path.join(__dirname, '../templates/.mcp.json.template');

      expect(fs.existsSync(templatePath)).toBe(true);
    });

    test('template file should be valid Handlebars', () => {
      const templatePath = path.join(__dirname, '../templates/.mcp.json.template');
      const templateContent = fs.readFileSync(templatePath, 'utf8');

      // Check for Handlebars conditional syntax
      expect(templateContent).toContain('{{#if includePlaywright}}');
      expect(templateContent).toContain('{{#if includeContext7}}');
    });
  });
});
