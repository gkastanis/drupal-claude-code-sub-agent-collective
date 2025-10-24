#!/bin/bash
# mock-deliverable-generator.sh
# Generates mock deliverables for hook validation during mock agent execution

LOG_FILE="/tmp/mock-deliverable-generator.log"
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
log() { echo "[$(timestamp)] $1" >> "$LOG_FILE"; }

EVENT=${EVENT:-""}
SUBAGENT_NAME=${SUBAGENT_NAME:-""}
AGENT_OUTPUT=${AGENT_OUTPUT:-""}

log "Mock Deliverable Generator - Event: $EVENT, Agent: $SUBAGENT_NAME"

# Only generate on SubagentStop for mock agents
if [[ "$EVENT" != "SubagentStop" ]]; then
    exit 0
fi

# Only for mock agents
if [[ "$SUBAGENT_NAME" != mock-* ]]; then
    exit 0
fi

MOCK_DIR="/tmp/mock-deliverables"
mkdir -p "$MOCK_DIR"

generate_mock_deliverables() {
    local agent="$1"
    
    case "$agent" in
        "mock-prd-research-agent")
            log "Generating PRD research deliverables"
            cat > "$MOCK_DIR/prd-analysis.md" << 'EOF'
# PRD Analysis Results

## Technical Stack Research
- Drupal 10/11 with PHP 8.1+
- Composer dependency management
- Custom module architecture patterns

## Task Breakdown
- Custom Modules: 3 modules identified
- Entity Integration: Custom entity types with field API
- Testing Strategy: PHPUnit + Behat functional tests
EOF
            ;;
            
        "mock-project-manager-agent")
            log "Generating project management deliverables"
            cat > "$MOCK_DIR/project-plan.json" << 'EOF'
{
  "phases": [
    { "name": "Setup", "status": "complete" },
    { "name": "Implementation", "status": "ready" },
    { "name": "Testing", "status": "pending" }
  ],
  "dependencies": [],
  "timeline": "2 weeks"
}
EOF
            ;;
            
        "mock-implementation-agent")
            log "Generating implementation deliverables"
            cat > "$MOCK_DIR/EventBlock.php" << 'EOF'
<?php

namespace Drupal\event_management\Plugin\Block;

use Drupal\Core\Block\BlockBase;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Provides an 'Event List' Block.
 *
 * @Block(
 *   id = "event_list_block",
 *   admin_label = @Translation("Event List Block"),
 *   category = @Translation("Custom"),
 * )
 */
class EventBlock extends BlockBase {

  /**
   * {@inheritdoc}
   */
  public function build() {
    return [
      '#theme' => 'event_list',
      '#events' => $this->getEvents(),
      '#cache' => ['max-age' => 3600],
    ];
  }

  protected function getEvents() {
    // Event loading logic
    return [];
  }
}
EOF

            cat > "$MOCK_DIR/EventBlockTest.php" << 'EOF'
<?php

namespace Drupal\Tests\event_management\Kernel;

use Drupal\KernelTests\KernelTestBase;

/**
 * Tests the Event Block plugin.
 *
 * @group event_management
 */
class EventBlockTest extends KernelTestBase {

  protected static $modules = ['event_management', 'block', 'node'];

  public function testBlockRendering() {
    $block = \Drupal::service('plugin.manager.block')
      ->createInstance('event_list_block');

    $build = $block->build();
    $this->assertArrayHasKey('#theme', $build);
    $this->assertEquals('event_list', $build['#theme']);
  }
}
EOF

            cat > "$MOCK_DIR/phpunit-results.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
  <testsuite name="Event Management" tests="15" failures="0" errors="0">
    <testcase name="testBlockRendering" class="EventBlockTest" time="0.123"/>
    <testcase name="testEntityCreation" class="EventEntityTest" time="0.089"/>
  </testsuite>
</testsuites>
EOF
            ;;
            
        "mock-testing-agent")
            log "Generating testing deliverables"
            cat > "$MOCK_DIR/behat-results.html" << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Behat Test Results</title></head>
<body>
  <h1>Mock Behat Test Results</h1>
  <p>✅ All 12 scenarios passed</p>
  <p>📊 Feature Coverage: 95%</p>
  <p>🧪 PHPUnit: 15 tests passed</p>
</body>
</html>
EOF

            cat > "$MOCK_DIR/phpunit-coverage.xml" << 'EOF'
<?xml version="1.0"?>
<coverage>
  <project timestamp="1705320000">
    <metrics files="15" loc="850" ncloc="620"
            classes="12" methods="48" coveredmethods="46"
            statements="220" coveredstatements="209"/>
  </project>
</coverage>
EOF
            ;;
            
        "mock-quality-gate-agent")
            log "Generating quality gate deliverables"
            cat > "$MOCK_DIR/phpcs-report.json" << 'EOF'
{
  "totals": {
    "errors": 0,
    "warnings": 0,
    "fixable": 0
  },
  "files": {},
  "standard": "Drupal,DrupalPractice",
  "lastRun": "2025-01-15T10:30:00Z"
}
EOF

            cat > "$MOCK_DIR/performance-metrics.json" << 'EOF'
{
  "pageLoadTime": 850,
  "dbQueries": 15,
  "cacheHitRate": 94,
  "performanceScore": 92,
  "accessibility": 98
}
EOF
            ;;
            
        "mock-completion-agent")
            log "Generating completion deliverables"
            cat > "$MOCK_DIR/delivery-manifest.json" << 'EOF'
{
  "deliveryId": "mock-delivery-001",
  "modules": ["event_management", "member_directory", "faq_system"],
  "phpunitTestsPassing": 15,
  "behatScenariosPassing": 12,
  "coveragePercent": 95,
  "phpcsCompliant": true,
  "securityReviewPassed": true,
  "configExported": true,
  "deliveryTimestamp": "2025-01-15T10:45:00Z"
}
EOF
            ;;
    esac
    
    log "Generated mock deliverables for $agent in $MOCK_DIR"
    return 0
}

# Generate deliverables for the current agent
generate_mock_deliverables "$SUBAGENT_NAME"

exit 0