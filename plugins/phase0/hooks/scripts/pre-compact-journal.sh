#!/bin/bash
# Auto-save context before compaction
# Writes to dev-journal.md to preserve session knowledge

INPUT=$(cat)
TRIGGER=$(echo "$INPUT" | jq -r '.trigger' 2>/dev/null || echo "unknown")
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path' 2>/dev/null || echo "")

# Ensure docs directory exists
mkdir -p docs

JOURNAL="docs/dev-journal.md"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

# Create journal if it doesn't exist
if [ ! -f "$JOURNAL" ]; then
  cat > "$JOURNAL" << 'HEADER'
# Development Journal

Auto-generated session summaries. Helps preserve context across sessions.

---

HEADER
fi

# Append session marker
cat >> "$JOURNAL" << SESSION

## Session: $TIMESTAMP

**Compaction trigger**: $TRIGGER

### Summary
[Session was compacted - context preserved in task capsules]

### Active Capsules
SESSION

# List recent task capsules
if [ -d "docs/taskcaps" ]; then
  find docs/taskcaps -name "*.md" -mtime -7 -exec basename {} \; 2>/dev/null | while read capsule; do
    echo "- $capsule" >> "$JOURNAL"
  done
fi

echo "" >> "$JOURNAL"
echo "---" >> "$JOURNAL"

# Backup transcript if path provided
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  BACKUP_DIR="$HOME/.claude/backups"
  mkdir -p "$BACKUP_DIR"
  cp "$TRANSCRIPT" "$BACKUP_DIR/session-$(date +%s)-$TRIGGER.jsonl" 2>/dev/null
fi

exit 0
