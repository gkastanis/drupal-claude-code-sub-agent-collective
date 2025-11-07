# Quality Assurance and Validation

## Phase Gate Requirements
- All subtasks must complete successfully
- Quality validation must pass
- Research metrics collected when applicable
- Documentation updated when needed
- No directive violations recorded

## Handoff Validation Contracts
```yaml
# Drupal-specific handoff contract
handoff:
  requiredContext: ["user_request", "drupal_context", "selected_agent"]
  validationRules: ["context_completeness", "agent_availability", "capability_match"]
  successCriteria: ["implementation_complete", "standards_compliant", "security_validated"]
  fallbackProcedures: ["retry_with_context", "escalate_to_routing", "report_failure"]
```

## Drupal-Specific Quality Gates

### Security & Compliance Gate (@security-compliance-agent)
**CRITICAL**: All custom modules and themes MUST pass security review before deployment.

```
## SECURITY, COMPLIANCE & QUALITY REVIEW: PASS ✅

**Module**: my_module
**Standards Check**: PASS (0 errors, 0 warnings)
**Static Analysis**: PASS
**Security Review**: PASS
**Accessibility**: PASS (WCAG 2.1 AA)
**Integration**: PASS

### Validated Items:
✅ No SQL injection vulnerabilities
✅ XSS protection implemented
✅ Access control on all routes
✅ Input sanitization proper
✅ No hardcoded credentials
✅ Dependency injection used
✅ Proper error handling
✅ Accessibility compliance (WCAG 2.1 AA)
✅ Dependencies declared correctly
✅ Configuration exportable
✅ No deprecated code

**Next Agent**: functional-testing-agent
```

### Testing Options (When Requested)

**PHPUnit Testing (@unit-testing-agent)** - Optional:
- Unit tests: Fast, isolated, mocked dependencies
- Kernel tests: Entity queries, services, plugins
- Functional tests: Complete workflows, forms, access control
- Coverage reporting available when tests are written

**Behat Testing (@functional-testing-agent)** - Optional:
- Server-side functional validation
- Gherkin scenarios for user workflows
- **Limitation**: NO JavaScript/AJAX testing
- Execution: `ddev robo behat @tag`

**Visual Regression (@visual-regression-agent)** - Optional:
- BackstopJS screenshot comparison
- Multiple viewport testing (mobile, tablet, desktop)
- Diff threshold: <0.1% for approval

## Quality Completion Reporting Standard

All Drupal implementation agents use standardized quality completion reporting:

```
## 🚀 MODULE DEVELOPMENT COMPLETE
✅ Implementation complete and functional
✅ Drupal coding standards validated (0 errors, 0 warnings)
✅ Security review passed
✅ Accessibility compliance verified (WCAG 2.1 AA)
📊 Tests: [X]/[Y] passing (if tests were requested)
📊 Code Coverage: [X]% (if tests were requested)
```

## Agent Coverage Matrix

### Development Agents
- **@drupal-architect**: Architecture documentation with field planning
- **@module-development-agent**: Custom modules with dependency injection
- **@theme-development-agent**: Themes with Twig templates and SCSS
- **@configuration-management-agent**: Config export/import and update hooks
- **@content-migration-agent**: Migration modules with rollback support

### Testing Agents
- **@unit-testing-agent**: PHPUnit test suite completion reporting
- **@functional-testing-agent**: Behat scenarios completion reporting
- **@visual-regression-agent**: Visual test baseline completion reporting

### Quality Gates
- **@security-compliance-agent**: Security validation and standards compliance
- **@performance-devops-agent**: Performance optimization and deployment readiness

## Drupal Coding Standards Validation

**PHP_CodeSniffer (REQUIRED)**:
```bash
./vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom/MODULE_NAME/
# Expected: 0 errors, 0 warnings
```

**PHPStan (RECOMMENDED)**:
```bash
./vendor/bin/phpstan analyse web/modules/custom/MODULE_NAME/
# Expected: No errors
```

**drupal-check (Deprecation Detection)**:
```bash
drupal-check web/modules/custom/MODULE_NAME/
# Expected: No deprecated code
```

## Accessibility Compliance (WCAG 2.1 AA)

**Required Checks**:
- ✅ Semantic HTML structure (proper heading hierarchy)
- ✅ All images have alt text
- ✅ Form fields properly labeled
- ✅ Keyboard navigation functional
- ✅ Color contrast ratios ≥4.5:1 (text) and ≥3:1 (UI components)
- ✅ No heading hierarchy skips
- ✅ ARIA attributes used appropriately

## Hub Controller Responsibility

**CRITICAL**: The hub controller MUST display the complete quality completion report to users exactly as received from agents. Never summarize, truncate, or paraphrase these reports - they demonstrate:
- Rigorous Drupal best practices adherence
- Quality-first development approach
- Comprehensive quality assurance
- Professional Drupal development standards
- Security and accessibility compliance

## Competitive Advantage

This Drupal-focused quality methodology provides:
- **Security-first development** with mandatory security gates
- **Accessibility compliance** built into the workflow
- **Drupal coding standards** enforced automatically
- **Optional testing** (unit, functional, visual) when requested
- **Research-backed decisions** via Context7 integration
