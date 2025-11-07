# Quality Assurance and Validation

## Phase Gate Requirements
- All subtasks complete successfully
- Quality validation must pass
- Research metrics collected when applicable
- Documentation updated when needed
- No directive violations recorded

## Handoff Validation
```yaml
handoff:
  requiredContext: ["user_request", "drupal_context", "selected_agent"]
  validationRules: ["context_completeness", "agent_availability", "capability_match"]
  successCriteria: ["implementation_complete", "standards_compliant", "security_validated"]
```

## Security & Compliance Gate

**@security-compliance-agent** validates:
- Drupal coding standards (PHP_CodeSniffer: 0 errors, 0 warnings)
- Security (SQL injection, XSS, access control, input sanitization)
- WCAG 2.1 AA accessibility
- Integration (dependencies, config export, no deprecated code)
- Static analysis (PHPStan)

**Output**: PASS ✅ or FAIL ❌ with specific remediation needs

## Testing Options (When Requested)

**PHPUnit** (@unit-testing-agent) - Optional:
- Unit, Kernel, Functional tests
- Coverage reporting available

**Behat** (@functional-testing-agent) - Optional:
- Server-side workflows (no JavaScript)
- Gherkin scenarios
- Execution: `ddev robo behat @tag`

**Visual Regression** (@visual-regression-agent) - Optional:
- BackstopJS screenshot comparison
- Multiple viewports (mobile, tablet, desktop)
- Diff threshold: <0.1%

## Quality Completion Reporting

```
## 🚀 MODULE DEVELOPMENT COMPLETE
✅ Implementation complete and functional
✅ Drupal coding standards validated (0 errors, 0 warnings)
✅ Security review passed
✅ Accessibility compliance verified (WCAG 2.1 AA)
📊 Tests: X/Y passing (if tests were requested)
📊 Coverage: X% (if tests were requested)
```

## Code Quality Tools

- **phpcs**: `--standard=Drupal,DrupalPractice`
- **phpstan**: Static analysis
- **drupal-check**: Deprecation detection

## Accessibility (WCAG 2.1 AA)

Required checks:
- Semantic HTML, proper heading hierarchy
- Alt text for images
- Form labels, keyboard navigation
- Color contrast ≥4.5:1 (text), ≥3:1 (UI)
- Appropriate ARIA attributes
