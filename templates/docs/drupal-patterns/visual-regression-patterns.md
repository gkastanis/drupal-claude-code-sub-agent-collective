# Visual Regression Testing Patterns

Reference documentation for visual regression testing in Drupal. **Read this using the Read tool when you need specific examples.**

## Tool Comparison

| Tool | Best For | Browser Support | Drupal Integration |
|------|----------|----------------|-------------------|
| **BackstopJS** | Drupal sites | Chromium | Excellent |
| **Percy** | CI/CD pipelines | All major | Good |
| **Playwright** | Complex interactions | Chromium, Firefox, WebKit | Excellent |

## BackstopJS Setup

### Installation
```bash
npm install --save-dev backstopjs
npx backstop init
```

### Basic Configuration
```javascript
// backstop.json
{
  "id": "drupal_visual_regression",
  "viewports": [
    {"label": "phone", "width": 375, "height": 667},
    {"label": "tablet", "width": 768, "height": 1024},
    {"label": "desktop", "width": 1920, "height": 1080}
  ],
  "scenarios": [
    {
      "label": "Homepage",
      "url": "http://localhost/",
      "selectors": ["document"],
      "delay": 1000,
      "misMatchThreshold": 0.1
    }
  ],
  "paths": {
    "bitmaps_reference": "backstop_data/bitmaps_reference",
    "bitmaps_test": "backstop_data/bitmaps_test",
    "html_report": "backstop_data/html_report"
  },
  "engine": "puppeteer"
}
```

### Advanced Scenarios
```javascript
{
  "scenarios": [
    // Mobile navigation
    {
      "label": "Mobile Navigation",
      "url": "http://localhost/",
      "clickSelector": ".mobile-menu-toggle",
      "postInteractionWait": 500,
      "selectors": [".mobile-navigation"]
    },
    // Autocomplete
    {
      "label": "Search Autocomplete",
      "keyPressSelectors": [{
        "selector": "#edit-search",
        "keyPress": "drupal"
      }],
      "postInteractionWait": 1000
    },
    // Hover state
    {
      "label": "Navigation Hover",
      "hoverSelector": ".menu-item:first-child",
      "selectors": [".region-primary-menu"]
    }
  ]
}
```

## Commands
```bash
# Create reference screenshots
npx backstop reference

# Run tests
npx backstop test

# Approve changes
npx backstop approve

# Open report
npx backstop openReport
```

## Percy Integration
```bash
# Install
npm install --save-dev @percy/cli @percy/puppeteer

# Snapshot
npx percy snapshot snapshots.yml
```

```yaml
# snapshots.yml
static:
  base-url: http://localhost
  snapshots:
    - name: Homepage
      url: /
    - name: Article Page
      url: /node/1
      widths: [375, 768, 1280]
```

## Playwright Visual Testing

```javascript
// tests/visual.spec.js
import { test, expect } from '@playwright/test';

test('homepage visual', async ({ page }) => {
  await page.goto('http://localhost');
  await expect(page).toHaveScreenshot('homepage.png');
});

test('responsive layout', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 });
  await page.goto('http://localhost');
  await expect(page).toHaveScreenshot('mobile-homepage.png');
});
```

## Component Testing
```javascript
// Component isolation
{
  "label": "Button Component",
  "url": "http://localhost/styleguide",
  "selectors": [".component-button"],
  "hideSelectors": [".demo-code"],
  "removeSelectors": [".demo-wrapper"]
}
```

## CI/CD Integration

### GitHub Actions
```yaml
- name: Visual Regression
  run: |
    npx backstop reference --config=backstop.json
    npx backstop test --config=backstop.json
```

### GitLab CI
```yaml
visual_tests:
  script:
    - npm install
    - npx backstop test
  artifacts:
    paths:
      - backstop_data/html_report
```

## Best Practices

- **Threshold**: 0.1% mismatch tolerance
- **Delay**: 1-2s for dynamic content
- **Hide**: Clock widgets, animations
- **Remove**: Live data, timestamps
- **Wait**: AJAX complete before capture
- **Viewports**: Mobile (375), Tablet (768), Desktop (1920)
