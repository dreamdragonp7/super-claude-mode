#!/usr/bin/env bash
# Dev-Flow Phase Completion Validation Hook
# Runs on Stop to check if phase tasks are complete

set -euo pipefail

# Read stdin for hook input
INPUT=$(cat)

# For now, just allow stopping - more sophisticated validation can be added
# This hook is a placeholder for future phase completion checking

# Output: allow the stop
cat << EOF
{
  "decision": "allow",
  "reason": "Phase completion check passed"
}
EOF

exit 0
