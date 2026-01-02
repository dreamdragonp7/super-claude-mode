#!/bin/bash
# Verify task completion before stopping
# Reminds about updating task capsule

# Check for active task capsule (modified today)
if [ -d "docs/taskcaps" ]; then
  TODAY=$(date +%Y-%m-%d)
  ACTIVE=$(find docs/taskcaps -name "${TODAY}*.md" -type f 2>/dev/null | head -1)

  if [ -n "$ACTIVE" ]; then
    # Check if Definition of Done has unchecked items
    UNCHECKED=$(grep -c "\- \[ \]" "$ACTIVE" 2>/dev/null || echo "0")

    if [ "$UNCHECKED" -gt 0 ]; then
      echo "⚠️ **Task Capsule Incomplete**: $ACTIVE has $UNCHECKED unchecked items in Definition of Done."
      echo "Consider updating the capsule before ending the session."
    fi
  fi
fi

# Always allow stop
exit 0
