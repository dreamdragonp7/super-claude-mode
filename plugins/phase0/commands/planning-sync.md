---
description: Auto-discover patterns from existing codebase
---

# Planning: Sync Patterns

Scan existing codebase and auto-discover patterns. This is the "onboarding" command for new projects.

---

## Step 1: Launch Discovery Agents (Parallel)

Launch 4 Haiku agents in parallel for cheap scanning:

1. **file-scanner** agent:
   - "Scan the codebase and find all components, hooks, routes, models, services"
   - Returns: File inventory by type

2. **file-scanner** agent (second instance):
   - "Find all test files and map them to implementation files"
   - Returns: Test coverage map

3. **import-tracer** agent:
   - "Analyze import statements across the codebase"
   - Returns: Import patterns and potential boundaries

4. **pattern-checker** agent:
   - "Find common file groupings (e.g., files that always appear together)"
   - Returns: Pattern suggestions

---

## Step 2: Synthesize Discoveries

Combine agent results to identify:
- **Component patterns**: What files typically go together?
- **Feature structure**: How are features organized?
- **Import boundaries**: What modules don't import each other?
- **Anti-patterns already present**: Common issues to flag

---

## Step 3: Present Discoveries via CLI Questions

For each discovered pattern category, ask the user via checkboxes:

**Component Patterns Found:**
```
Found 15 React components:
  - 12 have .tsx file ✓
  - 10 have .test.tsx file (67%)
  - 8 have index.ts (53%)

Suggested pattern: React components should have .tsx, .test.tsx, index.ts
```
Question: "Add this pattern to patterns.yaml?" [Yes] [No] [Modify first]

**Import Boundaries Found:**
```
Found import boundaries:
  - core/ imports: nothing from apps/ ✓
  - apps/api imports: core/ ✓
  - 1 violation: apps/web/src/api.ts imports from apps/mobile
```
Question: "Add boundary rule: apps/web cannot import apps/mobile?" [Yes] [No]

**Anti-Patterns Detected:**
```
Found potential anti-patterns:
  - console.log: 15 occurrences
  - any type: 8 occurrences
  - TODO without context: 23 occurrences
```
Question: "Add these as anti-pattern rules?" (checkboxes for each)

---

## Step 4: Write patterns.yaml

After user confirms selections:
- If patterns.yaml exists, merge new patterns
- If patterns.yaml doesn't exist, create from template with discovered patterns
- Confirm what was added

---

## Step 5: Suggest Next Steps

```
✅ patterns.yaml created/updated with discovered patterns

Next steps:
1. Review patterns.yaml and customize as needed
2. Run /audit to check current compliance
3. Run /audit fix to generate missing files
```

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| file-scanner | Haiku | CHEAP file discovery |
| import-tracer | Haiku | CHEAP dependency analysis |
| pattern-checker | Haiku | CHEAP pattern detection |

---

## Cost Optimization

/planning-sync uses only Haiku agents (~$0.02-0.03 total).
The heavy work is done by cheap pattern matching, not LLM reasoning.

---

## Related Commands

- `/planning-view` - View current patterns summary
- `/planning-add` - Add patterns interactively
- `/planning-validate` - Check patterns.yaml validity
