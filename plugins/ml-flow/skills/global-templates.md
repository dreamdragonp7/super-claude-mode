---
name: global-templates
description: Knowledge about the global Hygen templates system (Library of Alexandria). Use when agents need to find, read, or use templates for scaffolding or repair.
---

# Global Hygen Templates (Library of Alexandria)

## Overview

The global Hygen templates at `~/.hygen-templates/` are the canonical source of truth for code patterns across all projects. Templates serve three purposes: SCAFFOLD, REFERENCE, and REPAIR.

## Location

```bash
export HYGEN_TMPLS=~/.hygen-templates
```

Templates are available in ANY project via this environment variable.

## Template Inventory

| Category | Templates | Purpose |
|----------|-----------|---------|
| **api/** | full-endpoint, router, schema | FastAPI REST endpoints |
| **component/** | new, index, lazy, test | React components |
| **core/** | use-case, domain-model | Business logic (Clean Architecture) |
| **db/** | migration | SQLite/PostgreSQL migrations |
| **infra/** | repository, data-provider | Database access, external APIs |
| **store/** | new | Zustand state management |
| **test/** | e2e, integration, gauntlet, use-case | Testing patterns |
| **shared/** | type | TypeScript type definitions |
| **web/** | feature | Full feature scaffolding |

## Usage

```bash
# Generate new API endpoint
hygen api full-endpoint --name alerts

# Generate new React component
hygen component new --Name Button --dir ui

# Generate E2E test
hygen test e2e --page feed

# Generate ML training script
hygen ml training --name trajectory
```

## Template Philosophy

1. **SCAFFOLD** - Generate new files following correct patterns
2. **REFERENCE** - When writing code manually, consult templates for correct patterns
3. **REPAIR** - Fix existing code to match canonical patterns

## For ML Projects

When building ML features, check for templates:

```bash
# List available ML templates
ls ~/.hygen-templates/ml/

# Common ML templates
hygen ml model --name TRM
hygen ml training --name trajectory
hygen ml evaluation --name calibration
hygen ml dataloader --name features
```

## Template Structure

Each template has:
- `prompt.js` - Interactive prompts for parameters
- `*.ejs.t` - Template files with EJS templating

Example template file:
```ejs
---
to: <%= h.src() %>/models/<%= name %>.py
---
"""<%= Name %> Model Implementation."""

import torch
import torch.nn as nn

class <%= Name %>(nn.Module):
    """<%= description %>"""

    def __init__(self, config):
        super().__init__()
        # Implementation...
```

## When to Use Templates

- Creating new files that match existing patterns
- Ensuring consistency across the codebase
- Scaffolding repetitive structures (tests, endpoints, components)
- Onboarding new code to match project conventions
