#!/usr/bin/env bash
# Dev-Flow Phase Reminder Hook
# Runs on UserPromptSubmit to inject phase context

set -euo pipefail

# Read stdin for hook input (JSON)
INPUT=$(cat)

# Extract transcript path if available
TRANSCRIPT_PATH=$(echo "$INPUT" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "")

# Try to detect current phase from transcript
CURRENT_PHASE=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    # Look for the most recent phase announcement
    CURRENT_PHASE=$(grep -o "Phase [0-9]* of 12" "$TRANSCRIPT_PATH" 2>/dev/null | tail -1 || echo "")
fi

# Output context reminder as JSON
if [ -n "$CURRENT_PHASE" ]; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "DEV-FLOW REMINDER: You are currently in ${CURRENT_PHASE}. Always announce the phase at the start of your response using the format: **Phase X of 12: [Phase Name]** followed by Next: Phase Y - [Next Phase Name]"
  }
}
EOF
else
    # No phase detected yet, remind about workflow
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "DEV-FLOW: If this is a /dev-flow task, ensure you announce phases using: **Phase X of 12: [Phase Name]** at the start of each phase."
  }
}
EOF
fi

exit 0
