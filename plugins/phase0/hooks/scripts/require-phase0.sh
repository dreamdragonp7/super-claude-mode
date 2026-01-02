#!/bin/bash
# Require Phase 0 before dev-flow or bug-hunt
# Exit 0 = allow, Exit with JSON block = modify

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt' 2>/dev/null)

# Check if jq failed (not installed)
if [ $? -ne 0 ]; then
  # jq not available, allow by default
  exit 0
fi

# Check if this looks like a dev-flow or bug-hunt request
if echo "$PROMPT" | grep -qiE '(/dev-flow|/bug-hunt|implement|build feature|fix bug|add feature)'; then
  # Check for recent task capsule (last 24 hours)
  if [ -d "docs/taskcaps" ]; then
    RECENT_CAPSULE=$(find docs/taskcaps -name "*.md" -mtime -1 2>/dev/null | head -1)

    if [ -z "$RECENT_CAPSULE" ]; then
      # No recent capsule - suggest phase0
      echo '{"systemMessage": "💡 **Phase 0 Recommended**: No recent task capsule found. Consider running `/phase0` first to map context and create a task capsule. This helps preserve context across sessions."}'
      exit 0
    fi
  else
    # No taskcaps directory - suggest phase0
    echo '{"systemMessage": "💡 **Phase 0 Recommended**: No task capsules directory found. Run `/phase0` to set up context tracking."}'
    exit 0
  fi
fi

# Allow the prompt
exit 0
