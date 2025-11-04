#!/bin/bash
# directive-enforcer.sh
# Claude Code Sub-Agent Collective - Directive Enforcement Hook
# Validates behavioral directives before tool execution

# Set up logging
LOG_FILE="/tmp/directive-enforcer.log"
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
    echo "[$(timestamp)] $1" >> "$LOG_FILE"
}

# Initialize environment variables if not set
USER_PROMPT=${USER_PROMPT:-""}
TOOL_NAME=${TOOL_NAME:-""}
CLAUDE_PROJECT_DIR=${CLAUDE_PROJECT_DIR:-"/mnt/h/Active/taskmaster-agent-claude-code"}

log "DIRECTIVE ENFORCEMENT TRIGGERED - Tool: $TOOL_NAME"

# DIRECTIVE 1: NEVER IMPLEMENT DIRECTLY
# Block direct implementation when hub-and-spoke pattern should be used
check_direct_implementation() {
    local prompt="$1"
    local tool="$2"
    
    # Check for implementation-related activities
    if [[ "$tool" == "Write" || "$tool" == "Edit" || "$tool" == "MultiEdit" ]]; then
        # Look for direct implementation phrases that violate hub-and-spoke
        if echo "$prompt" | grep -qi -E "(implement|create.*code|write.*function|add.*feature|build.*component)"; then
            # Check if this is coming from a specialized agent (allowed)
            if ! echo "$prompt" | grep -qi "@.*-agent"; then
                log "DIRECTIVE 1 VIOLATION: Direct implementation detected without agent routing"
                echo "❌ DIRECTIVE VIOLATION: Direct implementation attempted"
                echo "🔄 REQUIRED ACTION: Route through @routing-agent for proper agent selection"
                echo "📋 VIOLATION: NEVER IMPLEMENT DIRECTLY - Use hub-and-spoke pattern"
                return 1
            fi
        fi
    fi
    return 0
}

# DIRECTIVE 2: COLLECTIVE ROUTING PROTOCOL  
# Ensure requests flow through proper routing channels
check_routing_protocol() {
    local prompt="$1"
    
    # Check for peer-to-peer agent communication violations
    if echo "$prompt" | grep -qi -E "(@[a-z-]*agent.*@[a-z-]*agent|direct.*communication|bypass.*routing)"; then
        log "DIRECTIVE 2 VIOLATION: Peer-to-peer agent communication detected"
        echo "❌ ROUTING VIOLATION: Peer-to-peer agent communication not allowed"
        echo "🔄 REQUIRED ACTION: Route all requests through @routing-agent hub"
        return 1
    fi
    
    return 0
}

# DIRECTIVE 3: QUALITY GATE VALIDATION
# Ensure handoffs include proper quality validation
check_quality_gate_validation() {
    local prompt="$1"
    local tool="$2"

    # Check for handoff scenarios without quality validation
    if echo "$prompt" | grep -qi -E "(handoff|hand.*off|transfer.*to|route.*to.*agent)"; then
        if ! echo "$prompt" | grep -qi -E "(quality.*gate|security|standards|validate|verify|phpcs|review)"; then
            log "DIRECTIVE 3 WARNING: Handoff without explicit quality validation mentioned"
            echo "⚠️  QUALITY GATE WARNING: Handoff detected without quality validation"
            echo "📋 RECOMMENDATION: Include security-compliance-agent validation in handoff"
            # Don't block, just warn
        fi
    fi

    return 0
}

# Security validation - prevent malicious command injection
validate_security() {
    local prompt="$1"
    
    # Check for basic command injection patterns
    if echo "$prompt" | grep -qi -E "(rm -rf|curl |wget |;s*rm|;s*curl|;s*wget)"; then
        log "SECURITY VIOLATION: Potential command injection detected"
        echo "🚨 SECURITY VIOLATION: Potentially malicious input detected"
        return 1
    fi
    
    return 0
}

# Main enforcement logic
main() {
    log "Starting directive enforcement for tool: $TOOL_NAME"
    
    # Run all validation checks
    if ! validate_security "$USER_PROMPT"; then
        exit 1
    fi
    
    if ! check_direct_implementation "$USER_PROMPT" "$TOOL_NAME"; then
        exit 1
    fi
    
    if ! check_routing_protocol "$USER_PROMPT"; then
        exit 1
    fi

    check_quality_gate_validation "$USER_PROMPT" "$TOOL_NAME"

    log "All directive checks passed for tool: $TOOL_NAME"
    return 0
}

# Execute main function
main "$@"
