#!/usr/bin/env bash
set -euo pipefail

# Save repair progress to dev-journal before memory compaction
JOURNAL="docs/dev-journal.md"

if [ -f "$JOURNAL" ]; then
    echo ""
    echo "---"
    echo "## Repair Session $(date '+%Y-%m-%d %H:%M')"
    echo ""
    echo "Context compaction occurring. Repair progress saved."
    echo ""
fi
