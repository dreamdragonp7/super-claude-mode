---
description: Detailed inventory of what exists vs what patterns.yaml expects
argument-hint: [path]
---

# Audit Inventory: What Exists vs What's Expected

Show a detailed side-by-side comparison of what your codebase has vs what patterns.yaml says it should have.

---

## Input

Path to inventory: $ARGUMENTS (defaults to entire project if not specified)

---

## Step 1: Load patterns.yaml

Read patterns.yaml and extract:
- All feature types and their required files
- All component patterns
- Expected directory structure

If patterns.yaml doesn't exist:
- Suggest running `/planning-sync` first
- Or proceed with basic inventory (no expected comparison)

---

## Step 2: Scan Codebase

Launch **file-scanner** agent (Haiku):

Prompt: "Create a complete inventory of [path]:
- All React components (with their test files, index files)
- All API routes (with their schema files, test files)
- All Python modules
- All hooks, stores, utilities
- Group by type and show file counts"

---

## Step 3: Compare Against Patterns

For each component pattern in patterns.yaml:

```
COMPONENT INVENTORY: React Components
---

Pattern: react_component
Required: .tsx, index.ts
Optional: .test.tsx, .stories.tsx

| Component | .tsx | index.ts | .test.tsx | .stories | Status |
|-----------|------|----------|-----------|----------|--------|
| Button    |  Y   |    Y     |     Y     |    Y     |   OK   |
| Modal     |  Y   |    Y     |     N     |    N     |  WARN  |
| Card      |  Y   |    N     |     N     |    N     |  FAIL  |
| Header    |  Y   |    Y     |     Y     |    N     |   OK   |
| Footer    |  Y   |    Y     |     N     |    N     |  WARN  |

Summary: 5 components
- Fully compliant: 2 (40%)
- Warning (missing optional): 2 (40%)
- Failing (missing required): 1 (20%)
```

---

## Step 4: Feature Type Inventory

For each feature type in patterns.yaml:

```
FEATURE INVENTORY
---

Feature Type: full-stack
Required: model, route, schema, component, hook, tests

| Feature    | model | route | schema | component | hook | tests | Status |
|------------|-------|-------|--------|-----------|------|-------|--------|
| auth       |   Y   |   Y   |   Y    |     Y     |  Y   |   Y   |   OK   |
| payments   |   Y   |   Y   |   N    |     N     |  N   |   P   |  FAIL  |
| trajectory |   Y   |   Y   |   Y    |     Y     |  Y   |   Y   |   OK   |

Feature Type: api-only
Required: route, schema, tests

| Feature    | route | schema | tests | Status |
|------------|-------|--------|-------|--------|
| health     |   Y   |   Y    |   Y   |   OK   |
| metrics    |   Y   |   N    |   N   |  FAIL  |

P = Partial (some tests exist)
```

---

## Step 5: Orphaned Code Detection

Find code that doesn't match any pattern:

```
ORPHANED CODE (no pattern match)
---

These files/directories don't match any pattern in patterns.yaml:

- apps/web/src/legacy/           (14 files) - No matching feature type
- apps/api/routers/deprecated.py (1 file)  - No matching pattern
- core/experiments/              (8 files)  - No matching feature type

Consider:
1. Adding patterns for these if they're intentional
2. Migrating to standard patterns
3. Removing if deprecated
```

---

## Step 6: Directory Structure Check

Compare actual vs expected structure:

```
DIRECTORY STRUCTURE
---

Expected (from patterns.yaml):
apps/
  api/
    routers/     Y
    schemas/     Y
    middleware/  N (missing)
  web/
    src/
      components/  Y
      hooks/       Y
      features/    N (missing)
      stores/      Y

core/
  features/    Y
  ssp/         Y
  calendar/    Y
  training/    Y

infrastructure/
  database/       Y
  data_providers/ Y
  training/       Y

Missing directories: 2
- apps/api/middleware/
- apps/web/src/features/
```

---

## Step 7: Output Summary

```
AUDIT INVENTORY: [path]
---

COMPONENTS
- React components: 15 total
  - Compliant: 10 (67%)
  - Warnings: 3 (20%)
  - Failing: 2 (13%)

- API routes: 8 total
  - Compliant: 6 (75%)
  - Failing: 2 (25%)

FEATURES
- Full-stack: 3 defined, 2 complete
- API-only: 2 defined, 1 complete

GAPS
- Missing required files: 7
- Missing optional files: 12
- Orphaned code: 3 directories

STRUCTURE
- Expected directories: 12
- Present: 10
- Missing: 2

Run /audit-fix to generate missing files.
Run /audit-run for full compliance check with visualizations.
---
```

---

## Related Commands

- `/audit-run` - Full compliance check with visualizations
- `/audit-fix` - Auto-generate missing files using Hygen
- `/audit-templates` - Show available Hygen templates
