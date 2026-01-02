---
name: template-patterns
description: Knowledge about Hygen templates as canonical code patterns. Use this skill when agents need to understand how to read templates, match them to violations, and use them for repair (not just scaffolding).
---

# Template Patterns: The Library of Alexandria

This skill encodes knowledge about using Hygen templates as **canonical truth** for code patterns.

## Core Philosophy

**Templates are not just scaffolding tools - they are the authoritative reference for how code SHOULD look.**

```
Traditional view:  Templates → Generate NEW code
Alexandria view:   Templates → Source of truth for CORRECT patterns
                            → Generate new code (scaffolding)
                            → Fix existing code (repair)
                            → Validate code correctness (audit)
```

## The Three-Pillar System

```
┌─────────────────────────────────────────────────────────────────┐
│                    CODEBASE GOVERNANCE                          │
├─────────────────────────────────────────────────────────────────┤
│  patterns.yaml    │  WHAT should exist  │  Architecture rules   │
│  ARCHITECTURE.md  │  WHAT does exist    │  Reality snapshot     │
│  _templates/      │  HOW it should look │  Canonical code       │
└─────────────────────────────────────────────────────────────────┘
```

## Template Categories

### Scaffolding Templates (Create New)

These templates generate completely new files:

| Template | Purpose | When to Use |
|----------|---------|-------------|
| `api/full-endpoint` | Complete REST endpoint | New API feature |
| `component/new` | React component | New UI feature |
| `core/use-case` | Business logic | New use case |
| `core/domain-model` | Domain entity | New domain concept |
| `infra/repository` | Database access | New entity persistence |
| `test/e2e` | End-to-end test | New page/flow |
| `test/gauntlet` | ML validation test | New model check |
| `db/migration` | Schema migration | Database change |
| `shared/type` | TypeScript types | New shared interface |
| `store/new` | Zustand store | New state management |

### Injection Templates (Add to Existing)

These templates ADD to existing files:

| Template | Purpose | What It Injects |
|----------|---------|-----------------|
| `component/index` | Barrel export | Adds export to index.ts |
| `api/full-endpoint` | Router registration | Adds import to __init__.py |
| `shared/type` | Type export | Adds export to types/index.ts |

### Repair Reference Templates

These templates show **correct patterns** for fixing existing code:

| Template | Pattern It Shows | Common Violations |
|----------|------------------|-------------------|
| `api/full-endpoint` | Error handling, DI, pagination | Missing try/except, raw errors |
| `component/new` | Typing, hooks, exports | Missing types, bad patterns |
| `core/use-case` | Result pattern, logging | Missing error handling |
| `infra/data-provider` | Rate limiting, caching | No retry logic |

## Reading Templates for Repair

When using templates as repair reference:

### 1. Identify the Relevant Template

```
Violation: alerts.py missing error handling
Pattern type: API endpoint
Template: api/full-endpoint
```

### 2. Extract the Correct Pattern

Read the template's `.ejs.t` file and extract the pattern:

```python
# From api/full-endpoint/router.ejs.t
@router.get("/{item_id}")
async def get_item(item_id: str):
    try:
        result = await service.get(item_id)
        if not result:
            raise HTTPException(status_code=404, detail="Not found")
        return result
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error: {e}")
        raise HTTPException(status_code=500, detail="Internal error")
```

### 3. Compare to Existing Code

```python
# Existing alerts.py (WRONG)
@router.get("/{alert_id}")
async def get_alert(alert_id: str):
    result = await alert_service.get_alert(alert_id)
    return result  # No error handling!
```

### 4. Generate Repair Diff

Transform existing code to match template pattern.

## Template Structure Reference

### Standard Template Directory

```
_templates/<category>/<action>/
├── prompt.js          # CLI arguments/prompts
├── <main>.ejs.t       # Primary generated file
├── inject-*.ejs.t     # Files to inject into
├── README.md          # Pattern documentation (optional)
└── _exemplar/         # Rendered example (optional)
```

### Template Frontmatter Options

```ejs
---
to: path/to/output.py           # Output location
inject: true                     # Inject into existing file
append: true                     # Add to end of file
prepend: true                    # Add to start of file
before: "# MARKER"              # Inject before marker
after: "# MARKER"               # Inject after marker
skip_if: "pattern"              # Skip if pattern exists
sh: "command"                   # Run shell after generation
unless_exists: true             # Only create if missing
---
```

### Template Variables

```ejs
<%= name %>                      # Raw variable
<%= h.changeCase.pascal(name) %> # PascalCase
<%= h.changeCase.snake(name) %>  # snake_case
<%= h.changeCase.kebab(name) %>  # kebab-case
<%= h.changeCase.camel(name) %>  # camelCase
<%= locals.optional %>           # Optional variable
```

## Hygen Commands Reference

### Scaffolding Commands

```bash
# API endpoint
hygen api full-endpoint --name alerts

# React component
hygen component new --Name AlertPanel --dir alerts

# Use case
hygen core use-case --name ProcessAlert

# Domain model
hygen core domain-model --name Alert

# Repository
hygen infra repository --name alert --table alerts

# E2E test
hygen test e2e --page alerts

# Barrel export
hygen component index --path src/components/alerts --files "A.tsx,B.tsx" --exportType named

# Database migration
hygen db migration --name add_alerts_table

# Shared type
hygen shared type --name Alert
```

### Common Flags

```bash
--dry-run        # Show what would be generated
--help           # Show template help
```

## Template-to-Pattern Mapping

### patterns.yaml Feature Types → Templates

| Pattern Type | Template |
|--------------|----------|
| api_endpoint | `api/full-endpoint` |
| react_component | `component/new` |
| use_case | `core/use-case` |
| domain_model | `core/domain-model` |
| repository | `infra/repository` |
| data_provider | `infra/data-provider` |
| gauntlet_test | `test/gauntlet` |
| e2e_test | `test/e2e` |
| integration_test | `test/integration` |
| typescript_type | `shared/type` |
| zustand_store | `store/new` |
| db_migration | `db/migration` |
| barrel_export | `component/index` |

### Anti-Patterns → Template Shows Correct Way

| Anti-Pattern | Template Reference | What It Shows |
|--------------|-------------------|---------------|
| Missing error handling | `api/full-endpoint` | Proper try/except |
| Missing types | `component/new` | Proper TypeScript |
| Missing barrel export | `component/index` | Proper re-exports |
| Missing pagination | `api/full-endpoint` | page/per_page pattern |
| Missing logging | `core/use-case` | Proper logger usage |
| Missing rate limiting | `infra/data-provider` | Rate limiter pattern |

## Using This Skill

### In /audit-repair

The repair-analyzer agent should:
1. Identify violation type
2. Find matching template (use mapping above)
3. Read template file content
4. Extract correct pattern
5. Compare to existing code
6. Generate repair diff

### In /bug-hunt

When fixing bugs:
1. Identify code area
2. Check if a template covers this pattern
3. Reference template for correct structure
4. Ensure fix follows template pattern

### In /dev-flow

When implementing features:
1. Check if template exists for this feature type
2. Use Hygen to scaffold if possible
3. Follow template patterns even for custom code

## Key Insight

**Templates are the "constitution" of your codebase.**

- `patterns.yaml` says WHAT should exist
- `ARCHITECTURE.md` shows WHAT does exist
- `_templates/` shows HOW things should look

When all three align, your codebase is compliant.
When they diverge, /audit-repair brings them back together.
