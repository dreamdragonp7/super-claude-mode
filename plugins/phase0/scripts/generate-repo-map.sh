#!/bin/bash
# Generate docs/repo-map.md from project structure
# Usage: bash generate-repo-map.sh

set -e
OUTPUT="docs/repo-map.md"
mkdir -p docs

cat > "$OUTPUT" << 'HEADER'
# Repository Map

HEADER

echo "Generated: $(date +%Y-%m-%d)" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Project type detection
echo "## Project Type" >> "$OUTPUT"
if [ -f "pnpm-workspace.yaml" ]; then echo "pnpm monorepo" >> "$OUTPUT"
elif [ -f "lerna.json" ]; then echo "Lerna monorepo" >> "$OUTPUT"
elif [ -f "package.json" ]; then echo "Node.js project" >> "$OUTPUT"
elif [ -f "pyproject.toml" ]; then echo "Python project" >> "$OUTPUT"
else echo "Unknown" >> "$OUTPUT"
fi
echo "" >> "$OUTPUT"

# Structure
echo "## Structure" >> "$OUTPUT"
echo '```' >> "$OUTPUT"
find . -maxdepth 3 -type d \
    -not -path '*/node_modules/*' \
    -not -path '*/.git/*' \
    -not -path '*/__pycache__/*' \
    -not -path '*/.venv/*' \
    -not -path '*/.next/*' \
    -not -path '*/dist/*' \
    2>/dev/null | head -40 | sort >> "$OUTPUT"
echo '```' >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Entry points table
echo "## Entry Points" >> "$OUTPUT"
echo "| Entry | Path |" >> "$OUTPUT"
echo "|-------|------|" >> "$OUTPUT"
[ -f "apps/api/main.py" ] && echo "| API | apps/api/main.py |" >> "$OUTPUT"
[ -f "apps/web/src/app/page.tsx" ] && echo "| Web | apps/web/src/app/page.tsx |" >> "$OUTPUT"
[ -f "src/index.ts" ] && echo "| Main | src/index.ts |" >> "$OUTPUT"
[ -f "main.py" ] && echo "| Main | main.py |" >> "$OUTPUT"
echo "" >> "$OUTPUT"

echo "✅ Generated $OUTPUT"
