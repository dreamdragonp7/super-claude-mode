#!/bin/bash
# Phase 0 v3.0 - Pre-command pattern checks
# Warns before /dev-flow or /bug-hunt if no recent task capsule

# Read input from stdin
INPUT=$(cat)

# Try to parse prompt (if jq available)
if command -v jq &> /dev/null; then
    PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)
else
    # No jq, allow through
    exit 0
fi

# If no prompt extracted, allow through
if [ -z "$PROMPT" ]; then
    exit 0
fi

# Check for /dev-flow or /bug-hunt commands
if echo "$PROMPT" | grep -qiE '^/dev-flow|^/bug-hunt'; then

    # Check for recent task capsule (modified in last 24 hours)
    if [ -d "docs/taskcaps" ]; then
        RECENT_CAPSULE=$(find docs/taskcaps -name "*.md" -mtime -1 2>/dev/null | head -1)
        if [ -z "$RECENT_CAPSULE" ]; then
            # No recent capsule - warn
            cat << 'EOF'
{"systemMessage": "💡 No recent task capsule found. Consider running /phase0 first to:\n- Map codebase context\n- Generate boilerplate\n- Create a task plan\n\nContinuing without capsule..."}
EOF
            exit 0
        fi
    else
        # No taskcaps directory - warn
        cat << 'EOF'
{"systemMessage": "💡 No task capsules directory found. Consider running /phase0 first to create a task plan."}
EOF
        exit 0
    fi

    # Check for patterns.yaml
    if [ -f "patterns.yaml" ]; then
        # Good - patterns exist
        :
    else
        cat << 'EOF'
{"systemMessage": "💡 No patterns.yaml found. Consider running /planning sync to define codebase patterns."}
EOF
        exit 0
    fi
fi

# Check for /phase0 command
if echo "$PROMPT" | grep -qiE '^/phase0'; then
    CONTEXT_MSG=""

    if [ ! -f "patterns.yaml" ]; then
        CONTEXT_MSG="💡 No patterns.yaml found - /phase0 will offer to create one. "
    fi

    if [ ! -f "ARCHITECTURE.md" ]; then
        CONTEXT_MSG="${CONTEXT_MSG}No ARCHITECTURE.md - /phase0 will scan for context."
    fi

    if [ -n "$CONTEXT_MSG" ]; then
        echo "{\"systemMessage\": \"$CONTEXT_MSG\"}"
    fi
fi

exit 0
