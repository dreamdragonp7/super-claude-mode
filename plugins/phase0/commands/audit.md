---
description: Audit codebase against patterns.yaml - shows gaps between what EXISTS and what SHOULD exist
argument-hint: [path]
---

# Audit: Pattern Compliance Check

You are helping a developer understand how their codebase compares to defined patterns. This command reveals gaps, violations, and technical debt.

## Why Audit Exists

- Codebases drift from ideal patterns over time
- Manual review misses systematic issues
- patterns.yaml defines the ideal; /audit shows reality
- Cheap scanning finds problems; developers fix them

---

## Input

Path to audit: $ARGUMENTS (default: entire project)

---

## Step 1: Check for patterns.yaml

First, check if patterns.yaml exists in project root.

If NOT found:
- Tell user: "No patterns.yaml found. Run `/atlas` to generate project documentation, or copy the template from the phase0 plugin."
- Suggest: `cp ~/.claude/plugins/marketplaces/super-claude-mode/plugins/phase0/templates/patterns.yaml ./patterns.yaml`
- Stop here until user provides patterns.yaml

If found, proceed to Step 2.

---

## Step 2: Python Layer Validation (CHEAP)

Launch **boundary-validator** agent (Haiku):
- "Analyze Python imports in [path] against the layer rules in patterns.yaml"
- Agent will grep for import statements and check against forbidden patterns

Wait for results.

---

## Step 3: TypeScript Boundary Check (CHEAP)

Launch **boundary-validator** agent (Haiku):
- "Analyze TypeScript/JavaScript imports in [path] against the boundary rules in patterns.yaml"
- Agent will check for cross-package imports that violate rules

Wait for results.

---

## Step 4: Component Pattern Scan (CHEAP)

Launch **pattern-checker** agent (Haiku):
- "Scan [path] for components matching patterns in patterns.yaml. Report missing required files."
- Agent will:
  - Find all component directories
  - Check for required files (tests, index.ts, etc.)
  - List what's missing

Wait for results.

---

## Step 5: Anti-Pattern Detection (CHEAP)

Launch **pattern-checker** agent (Haiku):
- "Grep for anti-patterns defined in patterns.yaml within [path]"
- Agent will search for:
  - Relative imports in Python
  - `any` types in TypeScript
  - Hardcoded secrets
  - Console.log statements

Wait for results.

---

## Step 6: Synthesize Report

Compile all agent results into a structured audit report:

```
┌─────────────────────────────────────────────────────────────┐
│ AUDIT REPORT: [path]                                        │
│ Generated: [timestamp]                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ PYTHON LAYER VIOLATIONS                                     │
│ [List violations or "✓ All layers correctly isolated"]      │
│                                                             │
│ TYPESCRIPT BOUNDARY VIOLATIONS                              │
│ [List violations or "✓ All boundaries respected"]           │
│                                                             │
│ COMPONENT PATTERN GAPS                                      │
│ [pattern-name] ([location]):                                │
│   ✓ [N] fully compliant                                     │
│   ✗ [N] missing [file-type]: [list]                         │
│                                                             │
│ ANTI-PATTERNS DETECTED                                      │
│ [severity] [pattern-name]: [count] occurrences              │
│   - [file:line] [context]                                   │
│                                                             │
│ SOURCE OF TRUTH FILES                                       │
│ [List any that have been modified recently]                 │
│                                                             │
│ SUMMARY                                                     │
│ Total issues: [N]                                           │
│ - Errors: [N] (must fix)                                    │
│ - Warnings: [N] (should fix)                                │
│ - Info: [N] (nice to fix)                                   │
│                                                             │
│ Run `/conform [path]` to auto-fix [N] of these issues       │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 7: Suggest Next Steps

Based on findings, suggest:
- If many gaps: "Consider running `/conform` to auto-generate missing files"
- If layer violations: "Manual refactoring needed to fix import structure"
- If anti-patterns: "Search and replace or use IDE refactoring tools"
- If clean: "🎉 Codebase is well-aligned with patterns!"

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| boundary-validator | Haiku | CHEAP import boundary checking |
| pattern-checker | Haiku | CHEAP component pattern scanning |

---

## Cost Optimization

All scanning uses Haiku (~$0.02 total). No Opus needed for audit - just pattern matching.

---

## Integration with Phase 0

When running `/phase0`, the audit results should be included in the task capsule under "Technical Debt Found" section. This helps developers understand existing issues before adding new code.
