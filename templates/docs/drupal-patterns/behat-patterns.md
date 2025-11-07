# Behat Testing Patterns for Drupal

Reference documentation for Behat functional testing. **Read when you need Behat examples.**

## Basic Gherkin Structure

```gherkin
Feature: User login
  As a site visitor
  I want to log in
  So that I can access my account

  @login
  Scenario: Successful login
    Given I am an anonymous user
    When I visit "/user/login"
    And I fill in "Username" with "admin"
    And I fill in "Password" with "admin"
    And I press "Log in"
    Then I should see "Member for"
```

## Drupal-Specific Steps

```gherkin
# Content creation
Given "article" content:
  | title         | body           | status |
  | Test Article  | Test body text | 1      |

# User creation
Given users:
  | name  | mail           | status | roles  |
  | admin | admin@test.com | 1      | admin  |

# Login/logout
Given I am logged in as a user with the "admin" role
Given I am an anonymous user

# Form interactions
When I fill in "Title" with "Test"
And I select "Published" from "Status"
And I press "Save"

# Assertions
Then I should see "Article created"
And the response status code should be 200
```

## Running Tests

```bash
# All tests
ddev robo behat

# Specific tag
ddev robo behat @login

# Specific file
vendor/bin/behat features/user-login.feature
```

## behat.yml Configuration

```yaml
default:
  suites:
    default:
      contexts:
        - Drupal\DrupalExtension\Context\DrupalContext
        - Drupal\DrupalExtension\Context\MinkContext
  extensions:
    Drupal\MinkExtension:
      base_url: http://localhost
      browserkit_http: ~
    Drupal\DrupalExtension:
      blackbox: ~
      api_driver: 'drupal'
      drupal:
        drupal_root: 'web'
```

## Limitations

**NO JavaScript support** - Use Playwright/Cypress for AJAX/JavaScript testing
Server-side only - Forms, navigation, content validation
