#!/bin/bash
# Phase 0 v3.0 - Pre-compaction journal
# Saves session context before compaction

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

Auto-generated session summaries. Preserves context across compaction.

---

HEADER
fi

# Append session marker
cat >> "$JOURNAL" << SESSION

## Session: $TIMESTAMP

**Trigger**: $TRIGGER

### Context State
SESSION

# Note patterns.yaml state
if [ -f "patterns.yaml" ]; then
    echo "- patterns.yaml: Present" >> "$JOURNAL"
else
    echo "- patterns.yaml: Not found" >> "$JOURNAL"
fi

# Note ARCHITECTURE.md state
if [ -f "ARCHITECTURE.md" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        ARCH_TIME=$(stat -f %m ARCHITECTURE.md 2>/dev/null || echo "0")
    else
        ARCH_TIME=$(stat -c %Y ARCHITECTURE.md 2>/dev/null || echo "0")
    fi
    NOW=$(date +%s)
    AGE_HOURS=$(( (NOW - ARCH_TIME) / 3600 ))
    echo "- ARCHITECTURE.md: ${AGE_HOURS}h old" >> "$JOURNAL"
else
    echo "- ARCHITECTURE.md: Not found" >> "$JOURNAL"
fi

# List recent task capsules
echo "" >> "$JOURNAL"
echo "### Active Capsules" >> "$JOURNAL"
if [ -d "docs/taskcaps" ]; then
    CAPSULE_COUNT=0
    find docs/taskcaps -name "*.md" -mtime -7 -exec basename {} \; 2>/dev/null | while read capsule; do
        echo "- $capsule" >> "$JOURNAL"
        ((CAPSULE_COUNT++))
    done
    if [ "$CAPSULE_COUNT" -eq 0 ]; then
        echo "- (none in last 7 days)" >> "$JOURNAL"
    fi
else
    echo "- (no taskcaps directory)" >> "$JOURNAL"
fi

echo "" >> "$JOURNAL"
echo "---" >> "$JOURNAL"

# Backup transcript if path provided
if [ -n "$TRANSCRIPT" ] && [ "$TRANSCRIPT" != "null" ] && [ -f "$TRANSCRIPT" ]; then
    BACKUP_DIR="$HOME/.claude/backups"
    mkdir -p "$BACKUP_DIR"
    cp "$TRANSCRIPT" "$BACKUP_DIR/session-$(date +%s)-$TRIGGER.jsonl" 2>/dev/null
fi

exit 0
