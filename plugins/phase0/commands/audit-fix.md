---
description: Auto-generate missing files using Hygen templates
argument-hint: [path]
---

# Audit Fix: Generate Missing Files

Auto-generate missing files detected by /audit-run using Hygen templates.

---

## Input

Path to fix: $ARGUMENTS (defaults to entire project if not specified)

---

## Step 1: Get Current Gaps

Check if ARCHITECTURE.md is recent (< 1 hour):
- If recent, use it
- If stale or missing, run /audit-run first

```bash
# Check ARCHITECTURE.md age
if [ -f "ARCHITECTURE.md" ]; then
  age=$(( ($(date +%s) - $(stat -c %Y ARCHITECTURE.md 2>/dev/null || stat -f %m ARCHITECTURE.md)) / 60 ))
  if [ $age -gt 60 ]; then
    echo "stale"
  else
    echo "recent"
  fi
else
  echo "missing"
fi
```

---

## Step 2: Identify Auto-Fixable Gaps

From ARCHITECTURE.md and /tmp/arch-audit.json, find gaps that can be auto-fixed:
- Missing test files
- Missing index.ts exports
- Missing schema files

Cannot auto-fix:
- Import boundary violations (need refactoring)
- Anti-patterns (need code changes)
- Logic issues

---

## Step 3: Check Hygen Templates

Verify templates exist for each fix:

```bash
ls _templates/
```

If templates missing, inform user:
"Missing Hygen template for [X]. Run `/audit-templates` to see available."

---

## Step 4: Present Fix Plan

```
AUDIT FIX PLAN: [path]
---

WILL GENERATE (via Hygen):
- Modal.test.tsx
  Template: npx hygen component test --name Modal

- Card.test.tsx
  Template: npx hygen component test --name Card

- Card/index.ts
  Template: npx hygen component index --name Card

- monitoring schema
  Template: npx hygen api schema --name monitoring

Files to generate: 4
LLM cost: $0.00 (Hygen is deterministic)

CANNOT AUTO-FIX:
- Boundary: apps/web/src/lib/api.ts:15 imports from apps/mobile
  -> Refactor to use packages/shared instead

- Anti-pattern: console.log in 3 files
  -> Replace with proper logger

- Anti-pattern: any type in 2 files
  -> Add proper type definitions

Manual fixes needed: 5
---

Generate 4 files? [Yes] [No] [Dry-run first]
```

Use AskUserQuestion to confirm:
- Yes, generate all
- No, cancel
- Dry-run first (show what would be created)

---

## Step 5: Execute Hygen Commands

For each auto-fixable gap, run the appropriate Hygen command:

```bash
npx hygen component test --name Modal
npx hygen component test --name Card
npx hygen component index --name Card
npx hygen api schema --name monitoring
```

Report each generated file.

---

## Step 6: Post-Generation Validation

Run linters on generated files:
```bash
ruff check [python-files] --fix 2>/dev/null
npx eslint [ts-files] --fix 2>/dev/null
```

---

## Step 7: Summary

```
AUDIT FIX COMPLETE
---

GENERATED:
- apps/web/src/components/Modal/Modal.test.tsx
- apps/web/src/components/Card/Card.test.tsx
- apps/web/src/components/Card/index.ts
- apps/api/schemas/monitoring.py

LINT STATUS: All generated files pass

REMAINING (manual fix):
- Fix boundary violation in api.ts
- Replace console.log in 3 files
- Add types in 2 files

Next steps:
1. Review generated files (they have TODOs)
2. Fill in test implementations
3. Fix manual issues listed above
4. Run /audit-run again to verify
---
```

---

## Related Commands

- `/audit-run` - Full compliance check with visualizations
- `/audit-inventory` - Detailed inventory of what exists vs expected
- `/audit-templates` - Show available Hygen templates
