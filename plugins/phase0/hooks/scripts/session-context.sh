#!/bin/bash
# Load recent context on session start
# Injects task capsule, documentation, and pattern info into session

# Check for patterns.yaml (code audit source of truth)
if [ -f "patterns.yaml" ]; then
  echo "📐 **Pattern Definitions**: patterns.yaml found"
  echo "   Run \`/audit\` to check compliance, \`/conform\` to fix gaps"
  echo ""
else
  echo "💡 **Tip**: No patterns.yaml found. Copy template with:"
  echo "   cp ~/.claude/plugins/marketplaces/super-claude-mode/plugins/phase0/templates/patterns.yaml ./"
  echo ""
fi

# Check for generated documentation
if [ -f "docs/repo-map.md" ]; then
  echo "📁 **Repo Map**: docs/repo-map.md"
fi
if [ -f "docs/feature-map.md" ]; then
  echo "🗺️  **Feature Map**: docs/feature-map.md"
fi

# Check for recent task capsules
if [ -d "docs/taskcaps" ]; then
  RECENT=$(find docs/taskcaps -name "*.md" -mtime -3 -type f 2>/dev/null | sort -r | head -3)

  if [ -n "$RECENT" ]; then
    echo ""
    echo "📋 **Recent Task Capsules**:"
    echo "$RECENT" | while read capsule; do
      NAME=$(basename "$capsule" .md)
      echo "  - $NAME"
    done
    echo ""
    echo "Use \`/focus\` to explore or continue from a capsule."
  fi
fi

# Check for NOW.md
if [ -f "docs/NOW.md" ]; then
  echo ""
  echo "📍 **Current Focus** (from NOW.md):"
  head -20 docs/NOW.md | tail -15
fi

exit 0
