#!/bin/bash
# Generate docs/feature-map.md from features.yaml
# Usage: bash generate-feature-map.sh

set -e
INPUT="features.yaml"
OUTPUT="docs/feature-map.md"

if [ ! -f "$INPUT" ]; then
    echo "❌ features.yaml not found. Create it first or run /atlas."
    exit 1
fi

mkdir -p docs

cat > "$OUTPUT" << 'HEADER'
# Feature Map

Auto-generated from features.yaml

HEADER

echo "Generated: $(date +%Y-%m-%d)" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Parse features.yaml and generate markdown
echo "## Features" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Simple YAML parsing with grep/sed
grep -E "^  - id:" "$INPUT" | while read -r line; do
    ID=$(echo "$line" | sed 's/.*id: //')
    echo "### $ID" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
done

echo "---" >> "$OUTPUT"
echo "Edit features.yaml and re-run to update." >> "$OUTPUT"

echo "✅ Generated $OUTPUT"
