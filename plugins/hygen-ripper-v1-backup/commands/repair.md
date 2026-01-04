---
description: Compare patterns.yaml (ideal) vs ARCHITECTURE.md (reality) and repair code using templates
argument-hint: [scope]
---

# /repair - Fix Code Gaps Using Templates

Compare what your codebase SHOULD look like (patterns.yaml) vs what it ACTUALLY looks like (ARCHITECTURE.md), then repair gaps using Hygen templates.

## Usage

- `/repair` - Full codebase repair
- `/repair components` - Only repair component gaps
- `/repair api` - Only repair API layer gaps

---

## Phase 1: Gap Detection

### Step 1: Read the Two Files

```
Read patterns.yaml (THE IDEAL)
Read ARCHITECTURE.md (THE REALITY)
```

If either is missing:
```
⚠️ Missing required file: [file]

Run /audit-run first to generate ARCHITECTURE.md
Run /planning-view to check patterns.yaml
```

### Step 2: Compute Diff

Compare the two files and identify:
- **Missing components**: In patterns.yaml but not in ARCHITECTURE.md
- **Extra components**: In ARCHITECTURE.md but not in patterns.yaml
- **Structure violations**: Components that exist but don't match pattern
- **Boundary violations**: Imports that cross layer boundaries

Output gap list:
```
## Gap Analysis

Found X gaps between ideal and reality:

1. [MISSING] component/Button - defined in patterns but doesn't exist
2. [STRUCTURE] api/routes/users.py - missing schema file per API pattern
3. [BOUNDARY] core/features imports from infrastructure (forbidden)
...
```

---

## Phase 2: Deep Code Scan (5 Haiku Agents)

Launch 5 **scanner** agents in PARALLEL to find additional issues:

**Scanner 1 - Structure**: "Scan for components that don't match their pattern's required files"
**Scanner 2 - Missing Files**: "Find patterns that should have tests but don't"
**Scanner 3 - Boundaries**: "Find all import boundary violations across layers"
**Scanner 4 - Coverage**: "Find code not covered by any pattern in patterns.yaml"
**Scanner 5 - Staleness**: "Find code that looks auto-generated but may be outdated"

Combine results into master gap list.

---

## Phase 3: Template Matching

For each gap, check if a template exists to fix it:

```
Read ~/.hygen-templates/.hygen-index.json
Match gaps to available templates:

Gap: Missing Button component
Match: component/new or component/ripped/[similar]

Gap: API route missing schema
Match: api/full-endpoint or api/schema
```

Present to user:
```
## Repair Plan

| Gap | Severity | Template | Action |
|-----|----------|----------|--------|
| Missing Button | High | component/new | Generate |
| API schema | Medium | api/schema | Generate |
| Boundary violation | High | (manual) | Refactor |

Proceed with repairs? [Y/n]
```

---

## Phase 4: Execute Repairs

For each approved repair, launch **architect** agent (Opus):

Prompt: "Repair this gap using the matched template.

Gap: [description]
Template: [template path]
Existing code context: [relevant files]

Tasks:
1. Analyze how template should fit into existing code
2. Run hygen command OR generate files directly if template needs customization
3. Update any barrel exports (index.ts files)
4. Verify the repair resolves the gap

Be surgical - minimal changes, maximum impact."

---

## Phase 5: Verification

After all repairs:

1. Re-run gap detection
2. Compare before/after gap count
3. Update ARCHITECTURE.md if significant changes

Output:
```
## Repair Complete

Gaps fixed: X/Y
Remaining gaps: Z (require manual intervention)

Files created:
- src/components/Button/Button.tsx
- src/components/Button/index.ts

Files modified:
- src/components/index.ts (added export)

Run /audit-run to refresh ARCHITECTURE.md
```
