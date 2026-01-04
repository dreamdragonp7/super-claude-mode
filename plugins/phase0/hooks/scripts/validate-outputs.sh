#!/usr/bin/env bash
# Phase0 output validation (fast, runs on Stop)
# Validates YAML syntax, doesn't run heavy tests

set -euo pipefail

# Check if any capsules were written this session
CAPSULE_DIR=".phase0/capsules"

if [ -d "$CAPSULE_DIR" ]; then
  # Find recently modified capsules (last 5 minutes)
  RECENT=$(find "$CAPSULE_DIR" -name "capsule.yaml" -mmin -5 2>/dev/null || true)

  for capsule in $RECENT; do
    # Validate YAML syntax
    if command -v yq &>/dev/null; then
      if ! yq eval '.' "$capsule" >/dev/null 2>&1; then
        echo "WARNING: Invalid YAML in $capsule"
      fi
    elif command -v python3 &>/dev/null; then
      if ! python3 -c "import yaml; yaml.safe_load(open('$capsule'))" 2>/dev/null; then
        echo "WARNING: Invalid YAML in $capsule"
      fi
    fi

    # Check required fields exist
    if command -v yq &>/dev/null; then
      for field in version slug goal handoff; do
        if [ "$(yq eval ".$field" "$capsule" 2>/dev/null)" = "null" ]; then
          echo "WARNING: Missing required field '$field' in $capsule"
        fi
      done
    fi
  done
fi

# Check patterns.yaml if modified
if [ -f "patterns.yaml" ]; then
  # Quick YAML syntax check
  if command -v yq &>/dev/null; then
    if ! yq eval '.' patterns.yaml >/dev/null 2>&1; then
      echo "WARNING: Invalid YAML syntax in patterns.yaml"
    fi
  fi
fi

exit 0
