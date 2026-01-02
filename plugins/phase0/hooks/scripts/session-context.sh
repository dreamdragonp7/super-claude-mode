#!/bin/bash
# Phase 0 v3.0 - Session startup context
# Shows patterns.yaml status, ARCHITECTURE.md age, recent capsules

echo "🎯 Super Claude Mode v3.0"
echo ""

# === PATTERNS.YAML (The Ideal) ===
if [ -f "patterns.yaml" ]; then
    echo "📐 **patterns.yaml**: Found"

    # Count rules (simple grep counts)
    FEATURE_TYPES=$(grep -c "^  - id:" patterns.yaml 2>/dev/null || echo "0")
    BOUNDARIES=$(grep -c "cannot_import:" patterns.yaml 2>/dev/null || echo "0")
    ANTI_PATTERNS=$(grep -c "^  - id:" patterns.yaml 2>/dev/null || echo "0")

    echo "   Feature types: $FEATURE_TYPES | Boundaries: $BOUNDARIES"

    # Quick boundary check with real tools (if available)
    if command -v import-linter &> /dev/null; then
        PYTHON_VIOLATIONS=$(import-linter 2>&1 | grep -c "VIOLATED" || echo "0")
        if [ "$PYTHON_VIOLATIONS" -gt 0 ]; then
            echo "   ⚠️ Python boundary violations: $PYTHON_VIOLATIONS"
        fi
    fi
else
    echo "💡 **patterns.yaml**: Not found"
    echo "   Run /planning sync to auto-generate"
    echo "   Or: cp ~/.claude/plugins/.../templates/patterns-template.yaml ./patterns.yaml"
fi
echo ""

# === ARCHITECTURE.MD (The Reality) ===
if [ -f "ARCHITECTURE.md" ]; then
    # Check age
    if [ "$(uname)" == "Darwin" ]; then
        ARCH_TIME=$(stat -f %m ARCHITECTURE.md 2>/dev/null || echo "0")
    else
        ARCH_TIME=$(stat -c %Y ARCHITECTURE.md 2>/dev/null || echo "0")
    fi
    NOW=$(date +%s)
    AGE_HOURS=$(( (NOW - ARCH_TIME) / 3600 ))

    if [ "$AGE_HOURS" -gt 24 ]; then
        echo "🏗️ **ARCHITECTURE.md**: ⚠️ ${AGE_HOURS}h old (stale)"
        echo "   Run /audit to refresh"
    else
        echo "🏗️ **ARCHITECTURE.md**: Updated ${AGE_HOURS}h ago"
    fi
else
    echo "🏗️ **ARCHITECTURE.md**: Not found"
    echo "   Run /audit to generate"
fi
echo ""

# === GENERATED DOCS ===
DOCS_FOUND=""
if [ -f "docs/repo-map.md" ]; then
    DOCS_FOUND="${DOCS_FOUND}repo-map "
fi
if [ -f "docs/feature-map.md" ]; then
    DOCS_FOUND="${DOCS_FOUND}feature-map "
fi
if [ -f "docs/NOW.md" ]; then
    DOCS_FOUND="${DOCS_FOUND}NOW "
fi

if [ -n "$DOCS_FOUND" ]; then
    echo "📚 **Atlas docs**: $DOCS_FOUND"
fi

# === TASK CAPSULES ===
if [ -d "docs/taskcaps" ]; then
    RECENT=$(find docs/taskcaps -name "*.md" -mtime -3 -type f 2>/dev/null | sort -r | head -3)
    if [ -n "$RECENT" ]; then
        echo ""
        echo "📋 **Recent Task Capsules**:"
        echo "$RECENT" | while read capsule; do
            NAME=$(basename "$capsule" .md)
            echo "   - $NAME"
        done
    fi
fi

# === HYGEN TEMPLATES ===
if [ -d "_templates" ]; then
    TEMPLATE_COUNT=$(find _templates -mindepth 2 -maxdepth 2 -type d 2>/dev/null | wc -l | tr -d ' ')
    if [ "$TEMPLATE_COUNT" -gt 0 ]; then
        echo ""
        echo "🔧 **Hygen templates**: $TEMPLATE_COUNT available"
    fi
fi

echo ""
echo "─────────────────────────────────────────"
echo "/phase0 [task]  → Start new work"
echo "/audit          → Check pattern compliance"
echo "/planning       → Manage patterns.yaml"
echo "─────────────────────────────────────────"

exit 0
