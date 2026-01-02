#!/usr/bin/env bash
# Hygen-ripper boundary enforcement
# BLOCKS writes to _templates/ except from /hygen-promote

set -euo pipefail

WRITTEN_FILE="${TOOL_INPUT_PATH:-}"

if [ -z "$WRITTEN_FILE" ]; then
  exit 0
fi

CURRENT_CMD="${CLAUDE_CURRENT_COMMAND:-unknown}"

# Check if trying to write to _templates
if [[ "$WRITTEN_FILE" =~ _templates/ ]] || [[ "$WRITTEN_FILE" =~ \.hygen-templates/ ]]; then
  # Only /hygen-promote can write here
  if [[ ! "$CURRENT_CMD" =~ "hygen-promote" ]]; then
    echo "BLOCKED: Only /hygen-promote can write to _templates/"
    echo "Use /hygen-rip to stage first, then /hygen-promote to finalize"
    echo "Attempted: $WRITTEN_FILE"
    exit 1
  fi
fi

# /hygen-rip can only write to staging
if [[ "$CURRENT_CMD" =~ "hygen-rip" ]]; then
  if [[ ! "$WRITTEN_FILE" =~ \.ripper/staging/ ]]; then
    echo "BLOCKED: /hygen-rip can only write to /.ripper/staging/"
    echo "Attempted: $WRITTEN_FILE"
    exit 1
  fi
fi

exit 0
