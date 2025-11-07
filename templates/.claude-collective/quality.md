# Quality Assurance and Validation

## Phase Gate Requirements
- All subtasks must complete successfully
- Test contracts must pass validation
- Research metrics must be collected
- Documentation must be updated
- No directive violations recorded

## Handoff Validation Contracts
```yaml
# Drupal-specific handoff contract
handoff:
  requiredContext: ["user_request", "drupal_context", "selected_agent"]
  validationRules: ["context_completeness", "agent_availability", "capability_match"]
  successCriteria: ["implementation_complete", "tests_passing", "standards_compliant"]
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

### Testing Coverage Requirements

**PHPUnit Testing (@unit-testing-agent)**:
- Unit tests: Fast, isolated, mocked dependencies
- Kernel tests: Entity queries, services, plugins
- Functional tests: Complete workflows, forms, access control
- **Minimum Coverage**: 80%

**Behat Testing (@functional-testing-agent)**:
- Server-side functional validation
- Gherkin scenarios for user workflows
- **Limitation**: NO JavaScript/AJAX testing
- Execution: `ddev robo behat @tag`

**Visual Regression (@visual-regression-agent)**:
- BackstopJS screenshot comparison
- Multiple viewport testing (mobile, tablet, desktop)
- Diff threshold: <0.1% for approval

## TDD Completion Reporting Standard

All Drupal implementation agents use standardized TDD completion reporting:

```
## 🚀 MODULE DEVELOPMENT COMPLETE - TDD APPROACH
✅ Tests written first (RED phase)
✅ Implementation passes all tests (GREEN phase)
✅ Code refactored for quality (REFACTOR phase)
✅ Drupal coding standards validated (0 errors, 0 warnings)
📊 Test Results: [X]/[Y] passing
📊 Code Coverage: [X]%
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

**CRITICAL**: The hub controller MUST display the complete TDD completion report to users exactly as received from agents. Never summarize, truncate, or paraphrase these reports - they demonstrate:
- Rigorous Drupal best practices adherence
- Test-first development approach
- Comprehensive quality assurance
- Professional Drupal development standards
- Measurable test coverage and quality metrics

## Competitive Advantage

This Drupal-focused TDD methodology provides:
- **Security-first development** with mandatory security gates
- **Accessibility compliance** built into the workflow
- **Drupal coding standards** enforced automatically
- **Multi-layer testing** (unit, functional, visual)
- **Research-backed decisions** via Context7 integration
