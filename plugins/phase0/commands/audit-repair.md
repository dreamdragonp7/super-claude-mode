---
description: Multi-phase code repair using Hygen templates as canonical truth. Scans violations, matches to templates, analyzes gaps, plans repairs, and executes fixes.
argument-hint: "[--phase N] [--dry-run] [--priority P1|P2|P3] [--file path]"
---

# /audit-repair - The Library of Alexandria

Multi-phase code repair that uses Hygen templates as the **canonical source of truth** for how code SHOULD look.

**Philosophy:** Templates aren't just for scaffolding NEW code - they're the authoritative reference for CORRECT code structure.

---

## Prerequisites (Auto-checked at start)

Before ANY phase, the command MUST:

1. **Read patterns.yaml** - Understand WHAT should exist
2. **Read ARCHITECTURE.md** - Understand WHAT does exist
3. **Scan _templates/** - Understand HOW things should look

If any are missing, inform user and offer to generate them.

---

## The 6 Phases

```
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 1: SCAN        │ Haiku agents (parallel, cheap)         │
│  PHASE 2: MATCH       │ Haiku agent (template mapping)         │
│  PHASE 3: ANALYZE     │ Opus agent (deep understanding)        │
│  PHASE 4: PLAN        │ Opus agent (repair strategy)           │
│  PHASE 5: EXECUTE     │ Opus agent (implement fixes)           │
│  PHASE 6: VERIFY      │ Haiku agent (confirm compliance)       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 0: Prerequisites

**CRITICAL: This runs BEFORE Phase 1**

```
📋 AUDIT-REPAIR: Prerequisites Check
───────────────────────────────────────

Checking required files...
```

1. Check if `patterns.yaml` exists:
   - If YES: Read it, extract feature types and required files
   - If NO: Warn user, offer to run `/planning-sync`

2. Check if `ARCHITECTURE.md` exists:
   - If YES: Read it, extract current compliance status and violations
   - If NO: Warn user, offer to run `/audit-run`

3. Check if `_templates/` exists:
   - If YES: List all available templates
   - If NO: ABORT - cannot repair without templates

```
✓ patterns.yaml found (18 feature types defined)
✓ ARCHITECTURE.md found (last updated: 2 hours ago)
✓ _templates/ found (24 generators available)

Current compliance: 78% (12 violations detected)

Proceed to Phase 1? [Yes] [View violations first]
```

---

## Phase 1: SCAN (Haiku Agents - Parallel)

Launch 3 Haiku agents IN PARALLEL for cheap, fast scanning:

### Agent 1: template-scanner
```
Prompt: "Scan the _templates/ directory and create a complete inventory.
For each template, extract:
- Generator name (e.g., api/full-endpoint)
- What files it generates
- What pattern it represents
- Any repair metadata if present

Return structured inventory."
```

### Agent 2: pattern-checker
```
Prompt: "Compare current codebase against patterns.yaml.
Find ALL violations:
- Missing required files
- Files in wrong locations
- Missing barrel exports (index.ts)
- Anti-patterns detected
- Boundary violations

Return categorized violation list with file paths."
```

### Agent 3: file-scanner
```
Prompt: "Scan existing code that MIGHT need repair.
Look for:
- Components without tests
- API routes without proper error handling
- Missing type definitions
- Inconsistent patterns vs similar files

Return list of candidates for template-based repair."
```

**Wait for all 3 agents to complete.**

```
📋 Phase 1 Complete: Scan Results
───────────────────────────────────────

template-scanner: 24 templates inventoried
├── api/: 3 generators (full-endpoint, router, schema)
├── component/: 4 generators (new, test, index, lazy)
├── core/: 2 generators (use-case, domain-model)
├── infra/: 2 generators (data-provider, repository)
├── test/: 4 generators (gauntlet, use-case, integration, e2e)
├── store/: 1 generator (new)
├── db/: 1 generator (migration)
└── shared/: 1 generator (type)

pattern-checker: 12 violations found
├── Missing files: 4
├── Missing barrel exports: 4
├── Anti-patterns: 2
├── Boundary violations: 2
└── Total: 12

file-scanner: 8 repair candidates identified
├── Components without tests: 3
├── Routes without error handling: 2
├── Missing types: 3
└── Total: 8

Proceed to Phase 2? [Yes] [View details]
```

---

## Phase 2: MATCH (Haiku Agent)

Launch template-matcher agent to map violations to templates:

### Agent: template-matcher
```
Prompt: "Given the violations from Phase 1 and the template inventory,
map each violation to the MOST RELEVANT template.

For each violation, determine:
- Which template shows the correct pattern
- Fix type: SCAFFOLD (new file) or REPAIR (modify existing)
- Confidence: HIGH/MEDIUM/LOW

Return mapping table."
```

```
📋 Phase 2 Complete: Template Matching
───────────────────────────────────────

VIOLATION → TEMPLATE MAPPING:

✅ Hygen-Fixable (8 items):
│
├── Missing: feed/index.ts
│   └── Template: component/index (SCAFFOLD, HIGH confidence)
│
├── Missing: lantern/index.ts
│   └── Template: component/index (SCAFFOLD, HIGH confidence)
│
├── Missing: e2e tests
│   └── Template: test/e2e (SCAFFOLD, HIGH confidence)
│
├── Route missing error handling: alerts.py
│   └── Template: api/full-endpoint (REPAIR, MEDIUM confidence)
│
├── Missing repository pattern: ticker_repository.py
│   └── Template: infra/repository (SCAFFOLD, HIGH confidence)
│
└── ... (3 more)

⚠️ Manual Repair Needed (4 items):
│
├── Boundary violation: core/training imports from lantern/
│   └── No template - needs architectural refactor
│
├── Deprecated store still present
│   └── No template - needs deletion
│
└── ... (2 more)

Proceed to Phase 3? [Yes] [Skip to specific item]
```

---

## Phase 3: ANALYZE (Opus Agent)

Launch repair-analyzer agent for DEEP analysis:

### Agent: repair-analyzer
```
Prompt: "For each Hygen-fixable violation:

1. READ the relevant template files (.ejs.t, prompt.js)
2. READ the existing code (if REPAIR type)
3. UNDERSTAND the gap between template pattern and existing code
4. DETERMINE exact fix needed

For SCAFFOLD fixes:
- What Hygen command to run
- What arguments to pass
- Expected output files

For REPAIR fixes:
- What the template says code SHOULD look like
- What the existing code ACTUALLY looks like
- Specific changes needed (as diff)

Return detailed analysis for each item."
```

```
📋 Phase 3 Complete: Deep Analysis
───────────────────────────────────────

ITEM 1: feed/index.ts (SCAFFOLD)
─────────────────────────────────
Template: component/index
Analysis:
├── Directory contains: FeedList.tsx, TickerRow.tsx, FeedFilters.tsx
├── Export pattern detected: Named exports (export function)
├── Template supports: --exportType named
└── Command: hygen component index --path apps/web/src/components/feed --files "FeedList.tsx,TickerRow.tsx,FeedFilters.tsx" --exportType named

Expected output:
```typescript
export { FeedList } from './FeedList';
export { TickerRow } from './TickerRow';
export { FeedFilters } from './FeedFilters';
```

ITEM 4: alerts.py (REPAIR)
─────────────────────────────────
Template: api/full-endpoint
Analysis:
├── Template shows: Try/except with HTTPException, proper status codes
├── Existing code: Missing error handling on lines 23-45
├── Gap: No exception handling, returns raw errors
└── Repair type: PATCH (add error handling wrapper)

Diff preview:
```diff
@router.get("/{alert_id}")
async def get_alert(alert_id: str):
-    result = await service.get_alert(alert_id)
-    return result
+    try:
+        result = await service.get_alert(alert_id)
+        if not result:
+            raise HTTPException(status_code=404, detail="Alert not found")
+        return result
+    except Exception as e:
+        raise HTTPException(status_code=500, detail=str(e))
```

... (6 more items analyzed)

Proceed to Phase 4? [Yes] [Modify analysis]
```

---

## Phase 4: PLAN (Opus Agent)

Launch repair-planner agent to create execution plan:

### Agent: repair-planner
```
Prompt: "Create an optimal repair plan based on the analysis.

Consider:
- Dependencies between fixes (order matters)
- Risk level of each fix
- Rollback strategy
- Test coverage after fix

Group fixes by priority:
- P1: Low risk, Hygen scaffold (just add files)
- P2: Medium risk, Hygen + patch (modify existing)
- P3: High risk, needs careful review

Return execution plan with order and risk assessment."
```

```
📋 Phase 4 Complete: Repair Plan
───────────────────────────────────────

EXECUTION PLAN (8 items):

PRIORITY 1 - Low Risk (Scaffold only)
───────────────────────────────────────
Order matters: None (independent)
Rollback: Delete generated files

1. [SCAFFOLD] feed/index.ts
   Risk: LOW | Confidence: HIGH
   Command: hygen component index --path ... --exportType named

2. [SCAFFOLD] lantern/index.ts
   Risk: LOW | Confidence: HIGH
   Command: hygen component index --path ... --exportType named

3. [SCAFFOLD] sheets/index.ts
   Risk: LOW | Confidence: HIGH
   Command: hygen component index --path ...

4. [SCAFFOLD] more/index.ts
   Risk: LOW | Confidence: HIGH
   Command: hygen component index --path ...

PRIORITY 2 - Medium Risk (Scaffold + Integrate)
───────────────────────────────────────
Order matters: Repository before tests
Rollback: Git stash

5. [SCAFFOLD] ticker_repository.py
   Risk: MEDIUM | Confidence: HIGH
   Command: hygen infra repository --name ticker
   Integration: Update imports in use cases

6. [SCAFFOLD] e2e/feed.spec.ts
   Risk: MEDIUM | Confidence: HIGH
   Command: hygen test e2e --page feed --actions "load,filter,click"
   Integration: Add to playwright config

PRIORITY 3 - Medium Risk (Patch existing)
───────────────────────────────────────
Order matters: None
Rollback: Git diff

7. [REPAIR] alerts.py error handling
   Risk: MEDIUM | Confidence: MEDIUM
   Action: Apply diff from Phase 3 analysis

8. [REPAIR] watchlist.py pagination
   Risk: MEDIUM | Confidence: MEDIUM
   Action: Apply diff from Phase 3 analysis

ESTIMATED IMPACT:
├── Compliance before: 78%
├── Compliance after: 94% (estimated)
├── Files created: 6
├── Files modified: 2
└── Risk level: LOW-MEDIUM

Execute plan? [Yes, all] [P1 only] [Review each] [Abort]
```

---

## Phase 5: EXECUTE (Opus Agent)

Launch repair-executor agent to implement fixes:

### Agent: repair-executor
```
Prompt: "Execute the repair plan step by step.

For SCAFFOLD items:
- Run the Hygen command
- Verify file was created
- Show generated content

For REPAIR items:
- Show the diff
- Apply the patch
- Verify syntax is valid

After each item:
- Report success/failure
- If failure, offer retry or skip

Get user approval before modifying existing files."
```

```
📋 Phase 5: Executing Repairs
───────────────────────────────────────

[1/8] SCAFFOLD: feed/index.ts
$ hygen component index --path apps/web/src/components/feed --files "FeedList.tsx,TickerRow.tsx,FeedFilters.tsx" --exportType named

✓ Created: apps/web/src/components/feed/index.ts
  Content:
  ```typescript
  export { FeedList } from './FeedList';
  export { TickerRow } from './TickerRow';
  export { FeedFilters } from './FeedFilters';
  ```

[2/8] SCAFFOLD: lantern/index.ts
$ hygen component index --path apps/web/src/components/lantern --files "LanternStatus.tsx,TrainingProgress.tsx" --exportType named

✓ Created: apps/web/src/components/lantern/index.ts

[3/8] SCAFFOLD: sheets/index.ts
✓ Created: apps/web/src/components/sheets/index.ts

[4/8] SCAFFOLD: more/index.ts
✓ Created: apps/web/src/components/more/index.ts

[5/8] SCAFFOLD: ticker_repository.py
$ hygen infra repository --name ticker --table tickers --operations "get,list,create,update"

✓ Created: infrastructure/database/repositories/ticker_repository.py

[6/8] SCAFFOLD: e2e/feed.spec.ts
$ hygen test e2e --page feed --actions "load,filter,click"

✓ Created: apps/web/e2e/feed.spec.ts

[7/8] REPAIR: alerts.py error handling
Applying diff to apps/api/routers/alerts.py...

Preview:
```diff
@router.get("/{alert_id}")
async def get_alert(alert_id: str):
-    result = await service.get_alert(alert_id)
-    return result
+    try:
+        result = await service.get_alert(alert_id)
+        if not result:
+            raise HTTPException(status_code=404, detail="Alert not found")
+        return result
+    except Exception as e:
+        raise HTTPException(status_code=500, detail=str(e))
```

Apply this change? [Yes] [No] [Edit first]
✓ Applied

[8/8] REPAIR: watchlist.py pagination
✓ Applied

───────────────────────────────────────
EXECUTION COMPLETE

✓ Scaffolded: 6 files
✓ Repaired: 2 files
✗ Failed: 0

Proceed to Phase 6 (verification)? [Yes]
```

---

## Phase 6: VERIFY (Haiku Agent)

Launch repair-verifier agent to confirm fixes:

### Agent: repair-verifier
```
Prompt: "Verify that all repairs were successful.

Checks:
1. All scaffolded files exist and have valid syntax
2. All repaired files pass linting
3. No new violations introduced
4. TypeScript compiles (if applicable)
5. Python imports resolve (if applicable)

Run /audit-run equivalent to get new compliance score.

Return verification report."
```

```
📋 Phase 6: Verification
───────────────────────────────────────

Running verification checks...

File Existence:
✓ apps/web/src/components/feed/index.ts
✓ apps/web/src/components/lantern/index.ts
✓ apps/web/src/components/sheets/index.ts
✓ apps/web/src/components/more/index.ts
✓ infrastructure/database/repositories/ticker_repository.py
✓ apps/web/e2e/feed.spec.ts

Syntax Validation:
✓ TypeScript: No errors
✓ Python: No syntax errors

Lint Check:
✓ ESLint: 0 errors, 2 warnings (pre-existing)
✓ Ruff: 0 errors

Compliance Re-scan:
├── Before: 78% (12 violations)
├── After: 94% (4 violations)
└── Improved: +16%

Remaining Violations (manual fix needed):
1. Boundary: core/training imports lantern/ (architectural)
2. Deprecated: predictionStore.ts still exists
3. Boundary: infrastructure imports lantern/
4. Console.log: 3 statements in production code

───────────────────────────────────────
✅ AUDIT-REPAIR COMPLETE

Summary:
├── Files created: 6
├── Files modified: 2
├── Compliance: 78% → 94%
├── Violations fixed: 8
├── Violations remaining: 4 (need manual intervention)
└── Time: 2m 34s

Next steps:
• Fix remaining violations manually
• Run tests: pytest tests/ -v
• Commit changes: git add -A && git commit -m "fix: audit-repair compliance fixes"
```

---

## CLI Options

```bash
/audit-repair                    # Full 6-phase workflow
/audit-repair --phase 1          # Run only Phase 1 (scan)
/audit-repair --phase 3          # Start from Phase 3 (requires prior phases)
/audit-repair --dry-run          # Show plan but don't execute
/audit-repair --priority P1      # Only execute P1 (low risk) items
/audit-repair --file path/to/file # Repair specific file only
/audit-repair --template api/full-endpoint # Use specific template
```

---

## Integration with Other Commands

- **Reads from /audit-run**: Uses ARCHITECTURE.md for current state
- **Reads from /planning-view**: Uses patterns.yaml for rules
- **Can trigger /dev-flow**: For complex repairs beyond templates
- **Updates /audit-run**: Refreshes compliance after repairs

---

## Cost Estimate

| Phase | Agent | Model | Est. Cost |
|-------|-------|-------|-----------|
| 1 | template-scanner | Haiku | $0.005 |
| 1 | pattern-checker | Haiku | $0.005 |
| 1 | file-scanner | Haiku | $0.005 |
| 2 | template-matcher | Haiku | $0.005 |
| 3 | repair-analyzer | Opus | $0.05 |
| 4 | repair-planner | Opus | $0.03 |
| 5 | repair-executor | Opus | $0.05 |
| 6 | repair-verifier | Haiku | $0.005 |
| **Total** | | | **~$0.16** |

---

## Why This Command Exists

1. **Templates are canonical truth** - Not just scaffolding, but reference material
2. **Repair > Recreate** - Fix existing code, don't start over
3. **Multi-phase control** - User sees progress, can intervene
4. **Cost optimized** - Haiku for scanning, Opus for intelligence
5. **Locked in** - Plugin components persist across sessions
