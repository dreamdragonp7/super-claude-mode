---
description: Fresh scan of codebase, update ARCHITECTURE.md, compare to patterns.yaml, report gaps
argument-hint: [subcommand] [path]
---

# Audit: Reality Check

/audit is your reality check. It always does a FRESH scan (never trusts old data), writes results to ARCHITECTURE.md, then compares reality to your ideal (patterns.yaml).

**The flow:**
1. Scan codebase fresh (Haiku agents + real tools)
2. Write results to ARCHITECTURE.md (overwrite, never append)
3. Compare ARCHITECTURE.md to patterns.yaml
4. Report gaps

---

## Subcommands

- `/audit [path]` - Full compliance check (default: entire project)
- `/audit fix [path]` - Auto-generate missing files using Hygen
- `/audit inventory [path]` - Detailed inventory of what exists vs expected
- `/audit templates` - Show available Hygen templates

---

## /audit [path]

Full compliance check. Path is optional (defaults to entire project).

### Step 1: Check Prerequisites

Check for patterns.yaml:
- If NOT found: "No patterns.yaml found. Run `/planning sync` to create one."

### Step 2: Fresh Scan (Parallel Agents)

Launch 3 Haiku agents in parallel for cheap scanning:

**file-scanner agent:**
- "Find all components, routes, models, hooks, stores, tests in [path]"
- Returns: File inventory by type and directory

**import-tracer agent:**
- "Map all import statements in [path], build dependency graph"
- Returns: Import map, internal vs external dependencies

**pattern-checker agent:**
- "Check [path] against patterns.yaml rules, report violations"
- Returns: Violations list with file:line references

### Step 3: Run Real Tools (If Available)

**Python Boundaries (if Python files exist):**

Check if import-linter is installed:
```bash
which import-linter || pip show import-linter
```

If available, run:
```bash
import-linter
```
Parse output for violations.

If NOT available, fall back to grep-based checking using patterns.yaml rules.

**TypeScript Boundaries (if TS files exist):**

Check if eslint-plugin-boundaries is configured:
```bash
grep -r "boundaries" eslint.config.* .eslintrc* 2>/dev/null
```

If available, run:
```bash
npx eslint . --plugin boundaries --format json 2>/dev/null
```
Parse JSON for violations.

If NOT available, fall back to grep-based checking.

### Step 4: Write ARCHITECTURE.md

Create/overwrite ARCHITECTURE.md at project root with fresh scan results:

```markdown
# Architecture

Generated: [timestamp]
Scanned: [path or "entire project"]
Patterns: patterns.yaml (version [X])

## Overview

| Category | Count |
|----------|-------|
| Python modules | X |
| TypeScript modules | X |
| React components | X |
| API routes | X |
| Hooks | X |
| Test files | X |

## Module Structure

### core/
- models/ (X files)
- services/ (X files)
- ...

### apps/api/
- routers/ (X files)
- schemas/ (X files)
- ...

### apps/web/
- components/ (X directories)
- hooks/ (X files)
- features/ (X directories)
- ...

## Component Inventory

### React Components

| Component | .tsx | .test.tsx | index.ts | Status |
|-----------|------|-----------|----------|--------|
| Button | ✓ | ✓ | ✓ | ✅ |
| Modal | ✓ | ✗ | ✓ | ⚠️ |
| ... | | | | |

### API Routes

| Route | route.py | schema.py | test.py | Status |
|-------|----------|-----------|---------|--------|
| users | ✓ | ✓ | ✓ | ✅ |
| ... | | | | |

## Dependencies

### Import Graph
- core/ imports: [nothing external] ✅
- apps/api imports: core, infrastructure
- apps/web imports: packages/shared
- ...

### External Dependencies
- Python: [list from pyproject.toml/requirements.txt]
- TypeScript: [list from package.json]

## Boundary Status

### Python (import-linter)
[Tool: import-linter | grep fallback]
Violations: X

[List violations if any]

### TypeScript (eslint-boundaries)
[Tool: eslint-plugin-boundaries | grep fallback]
Violations: X

[List violations if any]

## Anti-Patterns Detected

| Pattern | Count | Severity | Files |
|---------|-------|----------|-------|
| console.log | X | warning | file1.ts:10, ... |
| any type | X | error | file2.ts:5, ... |
| ... | | | |

## Test Coverage Estimate

- Components with tests: X/Y (Z%)
- Routes with tests: X/Y (Z%)
- Hooks with tests: X/Y (Z%)
- Overall estimate: ~Z%

## Source of Truth Files

| File | Last Modified | Lock Level |
|------|--------------|------------|
| patterns.yaml | [date] | high |
| ... | | |
```

### Step 5: Compare to patterns.yaml

For each rule in patterns.yaml, check against ARCHITECTURE.md:

**Component pattern check:**
- patterns.yaml says: React components need .tsx, .test.tsx, index.ts
- ARCHITECTURE.md shows: Modal missing .test.tsx, Card missing index.ts
- Gap: 2 components have missing files

**Boundary check:**
- patterns.yaml says: apps/web cannot import from apps/mobile
- ARCHITECTURE.md shows: 1 violation in api.ts
- Gap: 1 boundary violation

**Anti-pattern check:**
- patterns.yaml says: no console.log
- ARCHITECTURE.md shows: 3 occurrences
- Gap: 3 anti-pattern violations

### Step 6: Output Report

```
📊 Audit Complete
───────────────────────────────────────

ARCHITECTURE.md updated: [timestamp]

Comparing to patterns.yaml...

BOUNDARIES
├── Python (import-linter): ✅ Clean
└── TypeScript (eslint-boundaries): ⚠️ 1 violation
    └── apps/web/src/lib/api.ts:15 imports from apps/mobile

COMPONENT PATTERNS
├── React components: 12/15 compliant (80%)
│   ├── Missing .test.tsx: Modal, Card
│   └── Missing index.ts: Card
└── API routes: 8/8 compliant ✅

ANTI-PATTERNS
├── console.log: 3 found (should be 0)
└── any type: 2 found (should be 0)

SUMMARY
───────────────────────────────────────
Total gaps: 8
├── Auto-fixable: 3 (missing files)
└── Manual fix needed: 5 (boundary, anti-patterns)

Compliance: 87%

Run /audit fix to auto-generate missing files.
───────────────────────────────────────
```

---

## /audit fix [path]

Auto-generate missing files using Hygen templates.

### Step 1: Get Current Gaps

Check if ARCHITECTURE.md is recent (< 1 hour):
- If recent, use it
- If stale or missing, run /audit first

### Step 2: Identify Auto-Fixable Gaps

From ARCHITECTURE.md, find gaps that can be auto-fixed:
- Missing test files
- Missing index.ts exports
- Missing schema files

Cannot auto-fix:
- Import boundary violations (need refactoring)
- Anti-patterns (need code changes)
- Logic issues

### Step 3: Check Hygen Templates

Verify templates exist for each fix:

```bash
ls _templates/
```

If templates missing, inform user:
"Missing Hygen template for [X]. Run `/audit templates` to see available."

### Step 4: Present Fix Plan

```
AUDIT FIX PLAN: [path]
───────────────────────────────────────

WILL GENERATE (via Hygen):
├── Modal.test.tsx
│   Template: npx hygen component test --name Modal
│
├── Card.test.tsx
│   Template: npx hygen component test --name Card
│
├── Card/index.ts
│   Template: npx hygen component index --name Card
│
└── monitoring schema
    Template: npx hygen api schema --name monitoring

Files to generate: 4
LLM cost: $0.00 (Hygen is deterministic)

CANNOT AUTO-FIX:
├── Boundary: apps/web/src/lib/api.ts:15 imports from apps/mobile
│   → Refactor to use packages/shared instead
│
├── Anti-pattern: console.log in 3 files
│   → Replace with proper logger
│
└── Anti-pattern: any type in 2 files
    → Add proper type definitions

Manual fixes needed: 5
───────────────────────────────────────

Generate 4 files? [Yes] [No] [Dry-run first]
```

### Step 5: Execute Hygen Commands

For each auto-fixable gap, run the appropriate Hygen command:

```bash
# Example commands
npx hygen component test --name Modal
npx hygen component test --name Card
npx hygen component index --name Card
npx hygen api schema --name monitoring
```

Report each generated file.

### Step 6: Post-Generation Validation

Run linters on generated files:
```bash
ruff check [python-files] --fix
npx eslint [ts-files] --fix
```

### Step 7: Summary

```
AUDIT FIX COMPLETE
───────────────────────────────────────

GENERATED:
✓ apps/web/src/components/Modal/Modal.test.tsx
✓ apps/web/src/components/Card/Card.test.tsx
✓ apps/web/src/components/Card/index.ts
✓ apps/api/schemas/monitoring.py

LINT STATUS: All generated files pass ✓

REMAINING (manual fix):
• Fix boundary violation in api.ts
• Replace console.log in 3 files
• Add types in 2 files

Next steps:
1. Review generated files (they have TODOs)
2. Fill in test implementations
3. Fix manual issues listed above
4. Run /audit again to verify
───────────────────────────────────────
```

---

## /audit inventory [path]

Detailed inventory of what exists vs what patterns.yaml expects.

### Output Format:

```
📦 Codebase Inventory
───────────────────────────────────────

REACT COMPONENTS (patterns.yaml: .tsx, .test.tsx, index.ts)

| Component | .tsx | .test.tsx | index.ts | Status |
|-----------|------|-----------|----------|--------|
| Button | ✓ | ✓ | ✓ | ✅ Complete |
| Modal | ✓ | ✗ | ✓ | ⚠️ Missing 1 |
| Card | ✓ | ✗ | ✗ | ❌ Missing 2 |
| Toast | ✓ | ✓ | ✓ | ✅ Complete |
| ... | | | | |

Summary: 12/15 complete (80%)

API ROUTES (patterns.yaml: route.py, schema.py, test.py)

| Route | route.py | schema.py | test.py | Status |
|-------|----------|-----------|---------|--------|
| users | ✓ | ✓ | ✓ | ✅ Complete |
| trajectory | ✓ | ✓ | ✓ | ✅ Complete |
| monitoring | ✓ | ✗ | ✓ | ⚠️ Missing schema |
| ... | | | | |

Summary: 7/8 complete (88%)

FEATURES (by type from patterns.yaml)

| Feature | Type | Expected | Actual | Status |
|---------|------|----------|--------|--------|
| auth | full-stack | 5 files | 5 | ✅ |
| payments | full-stack | 5 files | 3 | ⚠️ Missing 2 |
| trajectory | api-only | 3 files | 3 | ✅ |
| ... | | | | |

HOOKS

| Hook | Implementation | Test | Status |
|------|---------------|------|--------|
| useAuth | ✓ | ✓ | ✅ |
| useTrajectory | ✓ | ✗ | ⚠️ |
| ... | | | |

OVERALL HEALTH SCORE: 85%
───────────────────────────────────────
```

---

## /audit templates

Show available Hygen templates and what they generate.

### Output:

```
🔧 Available Hygen Templates
───────────────────────────────────────

Located in: _templates/

FEATURE TEMPLATES
├── feature/new
│   Creates: Full feature (component + hook + test + index)
│   Usage: npx hygen feature new --name [name]
│   Generates:
│     - src/features/[name]/[Name].tsx
│     - src/features/[name]/use[Name].ts
│     - src/features/[name]/[Name].test.tsx
│     - src/features/[name]/index.ts

API TEMPLATES
├── api/endpoint
│   Creates: API route with schema and test
│   Usage: npx hygen api endpoint --name [name]
│   Generates:
│     - apps/api/routers/[name].py
│     - apps/api/schemas/[name].py
│     - tests/api/test_[name].py
│
├── api/schema
│   Creates: Schema file only
│   Usage: npx hygen api schema --name [name]
│
└── api/test
    Creates: Test file only
    Usage: npx hygen api test --name [name]

COMPONENT TEMPLATES
├── component/new
│   Creates: React component with test
│   Usage: npx hygen component new --name [name]
│
├── component/test
│   Creates: Test file for existing component
│   Usage: npx hygen component test --name [name]
│
└── component/index
    Creates: Index export file
    Usage: npx hygen component index --name [name]

TASK TEMPLATES
└── task-capsule/new
    Creates: Task capsule for /phase0
    Usage: npx hygen task-capsule new --name [name]

MISSING TEMPLATES (defined in patterns.yaml but no template):
├── feature/ml-pipeline - No template found
└── component/with-store - No template found

Create missing with: npx hygen generator new --name [name]
───────────────────────────────────────
```

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| file-scanner | Haiku | CHEAP file/component discovery |
| import-tracer | Haiku | CHEAP dependency mapping |
| pattern-checker | Haiku | CHEAP pattern/boundary checking |

---

## Real Tools Integration

| Tool | Purpose | Fallback |
|------|---------|----------|
| import-linter | Python boundary enforcement | grep for imports |
| eslint-plugin-boundaries | TS boundary enforcement | grep for imports |
| ruff | Python linting | skip |
| eslint | TS linting | skip |

---

## Cost Optimization

- All scanning uses Haiku (~$0.02 total)
- Hygen generation is FREE (no LLM)
- Real tools (import-linter, eslint) are local (no cost)
