#!/bin/bash
# Phase 0 v3.0 - Stop hook
# Reminds about incomplete DoD items and stale ARCHITECTURE.md

# Check for active task capsule (modified today)
if [ -d "docs/taskcaps" ]; then
    TODAY=$(date +%Y-%m-%d)
    ACTIVE=$(find docs/taskcaps -name "${TODAY}*.md" -type f 2>/dev/null | head -1)

    if [ -n "$ACTIVE" ]; then
        # Check if Definition of Done has unchecked items
        UNCHECKED=$(grep -c "\- \[ \]" "$ACTIVE" 2>/dev/null || echo "0")
        CHECKED=$(grep -c "\- \[x\]" "$ACTIVE" 2>/dev/null || echo "0")

        if [ "$UNCHECKED" -gt 0 ]; then
            echo ""
            echo "📋 **Active Task Capsule**: $(basename $ACTIVE)"
            echo "   Definition of Done: $CHECKED complete, $UNCHECKED remaining"
            echo "   Consider updating before ending session."
        fi
    fi
fi

# Check ARCHITECTURE.md staleness
if [ -f "ARCHITECTURE.md" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        ARCH_TIME=$(stat -f %m ARCHITECTURE.md 2>/dev/null || echo "0")
    else
        ARCH_TIME=$(stat -c %Y ARCHITECTURE.md 2>/dev/null || echo "0")
    fi
    NOW=$(date +%s)
    AGE_HOURS=$(( (NOW - ARCH_TIME) / 3600 ))

    if [ "$AGE_HOURS" -gt 8 ]; then
        echo ""
        echo "🏗️ ARCHITECTURE.md is ${AGE_HOURS}h old."
        echo "   If you made significant changes, run /audit next session."
    fi
fi

# Always allow stop (warnings only, not blocking)
exit 0
