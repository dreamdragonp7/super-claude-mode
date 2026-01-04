#!/usr/bin/env bash
# Phase0 boundary enforcement
# BLOCKS writes outside allowed locations

set -euo pipefail

# Get the file that was written (from environment or stdin)
WRITTEN_FILE="${TOOL_INPUT_PATH:-}"

if [ -z "$WRITTEN_FILE" ]; then
  exit 0  # No file info, can't check
fi

# Determine current command context
CURRENT_CMD="${CLAUDE_CURRENT_COMMAND:-unknown}"

# Define allowed write locations per command
case "$CURRENT_CMD" in
  "phase0"|"/phase0")
    # /phase0 can ONLY write to /.phase0/capsules/
    if [[ ! "$WRITTEN_FILE" =~ ^\.?/?\.phase0/capsules/ ]]; then
      echo "BLOCKED: /phase0 can only write to /.phase0/capsules/"
      echo "Attempted: $WRITTEN_FILE"
      exit 1
    fi
    ;;
  "phase0:audit"|"/phase0:audit")
    # /phase0:audit can write to ARCHITECTURE.md and /.phase0/reports/
    if [[ ! "$WRITTEN_FILE" =~ ^(ARCHITECTURE\.md|\.?/?\.phase0/reports/|docs/dep) ]]; then
      echo "BLOCKED: /phase0:audit can only write to ARCHITECTURE.md or /.phase0/reports/"
      echo "Attempted: $WRITTEN_FILE"
      exit 1
    fi
    ;;
  "phase0:patterns"|"/phase0:patterns")
    # /phase0:patterns can ONLY write to patterns.yaml
    if [[ ! "$WRITTEN_FILE" =~ ^patterns\.yaml$ ]]; then
      echo "BLOCKED: /phase0:patterns can only write to patterns.yaml"
      echo "Attempted: $WRITTEN_FILE"
      exit 1
    fi
    ;;
  *)
    # Unknown command, allow (might be user direct action)
    ;;
esac

exit 0
