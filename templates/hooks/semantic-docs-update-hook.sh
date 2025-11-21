#!/bin/bash

# semantic-docs-update-hook.sh
# Triggers after development tasks complete to remind about semantic documentation updates
#
# This hook checks if completed tasks involve custom module changes and prompts
# to update semantic documentation accordingly.

# Get the task status and related information
TASK_STATUS="${1:-}"
TASK_DESCRIPTION="${2:-}"
TASK_FILES="${3:-}"

# Only proceed if task is marked as done
if [ "$TASK_STATUS" != "done" ] && [ "$TASK_STATUS" != "completed" ]; then
  exit 0
fi

# Check if any custom modules were modified
# Look for paths like: modules/custom/, web/modules/custom/, or custom module names
if echo "$TASK_FILES" | grep -qE "(modules/custom/|web/modules/custom/)"; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📝 SEMANTIC DOCUMENTATION UPDATE REMINDER"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "⚠️  Development task completed with custom module changes."
  echo ""
  echo "The following modules may need documentation updates:"

  # Extract module names from file paths
  MODULE_PATHS=$(echo "$TASK_FILES" | grep -oE "(modules/custom/|web/modules/custom/)[a-z_]+" | sort -u)

  if [ -n "$MODULE_PATHS" ]; then
    echo "$MODULE_PATHS" | while read -r path; do
      MODULE_NAME=$(basename "$path")
      echo "  • $MODULE_NAME"
    done
  fi

  echo ""
  echo "Consider running:"
  echo "  'Use the semantic-architect-agent to update documentation for [module_name]'"
  echo ""
  echo "Or if this is a new feature:"
  echo "  'Use the semantic-architect-agent to document [module_name] feature'"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi

# Also check if task description mentions documentation-worthy activities
if echo "$TASK_DESCRIPTION" | grep -qiE "(implement|create|refactor|add.*service|add.*controller|new.*module)"; then
  # Only show this if we didn't already show the custom modules message
  if ! echo "$TASK_FILES" | grep -qE "(modules/custom/|web/modules/custom/)"; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📝 DOCUMENTATION REMINDER"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This task involved implementation work that may benefit from"
    echo "semantic documentation (Logic-to-Code mappings)."
    echo ""
    echo "Consider documenting if you've added:"
    echo "  • New business logic or validation rules"
    echo "  • Services with complex methods"
    echo "  • Event subscribers or hooks"
    echo "  • Custom controllers or forms"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
  fi
fi

exit 0
