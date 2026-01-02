---
description: View and manage patterns.yaml - the single source of truth for how your codebase SHOULD look
argument-hint: [subcommand] [type]
---

# Planning: Manage Codebase Patterns

patterns.yaml is the brain of Super Claude Mode. It defines the ideal state of your codebase. Every command reads it, every hook checks it, every plugin follows it.

This is where the deep planning happens. Take your time here. Everything else flows from these decisions.

---

## Subcommands

- `/planning` - View summary of current patterns.yaml
- `/planning add [type]` - Add new pattern interactively (feature, component, boundary, anti-pattern)
- `/planning sync` - Auto-discover patterns from existing codebase
- `/planning validate` - Check patterns.yaml is valid, templates exist

---

## /planning (no arguments)

Show summary of current patterns.yaml.

### Step 1: Check for patterns.yaml

```bash
if [ -f "patterns.yaml" ]; then echo "found"; else echo "not found"; fi
```

If NOT found:
- Tell user: "No patterns.yaml found."
- Offer: "Run `/planning sync` to auto-generate from codebase, or copy the template:"
- Show: `cp ~/.claude/plugins/marketplaces/super-claude-mode/plugins/phase0/templates/patterns-template.yaml ./patterns.yaml`

### Step 2: Parse and Summarize

Read patterns.yaml and extract:
- Number of Python boundary rules
- Number of TypeScript boundary rules
- Number of component patterns
- Number of feature types
- Number of anti-patterns

### Step 3: Show Recent Compliance

If ARCHITECTURE.md exists, show:
- Last audit timestamp
- Compliance percentage
- Number of gaps

### Step 4: Output Format

```
📐 patterns.yaml Summary
───────────────────────────────────────

Python Boundaries: X rules
├── core/ cannot import apps/, infrastructure/
├── infrastructure/ cannot import apps/
└── ...

TypeScript Boundaries: X rules
├── web cannot import mobile
└── ...

Component Patterns: X defined
├── react_component: .tsx, index.ts required; .test.tsx optional
├── api_router: route.py required; schema.py related
└── ...

Feature Types: X defined
├── full-stack: model + route + schema + component + hook + tests
├── api-only: route + schema + tests
└── ...

Anti-Patterns: X defined
├── console.log (warning)
├── any type (error)
└── ...

───────────────────────────────────────
Last Audit: [timestamp or "Never"]
Compliance: [X% or "Unknown - run /audit"]
───────────────────────────────────────
```

---

## /planning add [type]

Interactive wizard to add new patterns to patterns.yaml.

### Valid types:
- `feature` - Add a new feature type
- `component` - Add a new component pattern
- `boundary` - Add a new import boundary rule
- `anti-pattern` - Add a new anti-pattern to detect

### Flow for `/planning add feature`

**Step 1**: Ask feature name via AskUserQuestion:
"What's this feature type called? (e.g., 'ml-pipeline', 'background-job')"

**Step 2**: Ask required files via checkboxes:
"What files does a [name] feature need?"
Options:
- Database model (core/models/)
- API route (apps/api/routers/)
- API schema (apps/api/schemas/)
- Service layer (core/services/)
- React component (apps/web/src/features/)
- React hook (apps/web/src/hooks/)
- Background job (apps/worker/)

**Step 3**: Ask test requirements:
"What tests are required?"
Options:
- Unit test for each file
- Integration test
- E2E test
- API contract test

**Step 4**: Update patterns.yaml:
- Read current patterns.yaml
- Add new feature type to `feature_types` section
- Write back to patterns.yaml
- Confirm: "Added '[name]' feature type to patterns.yaml"

### Flow for `/planning add component`

**Step 1**: Ask component type:
"What type of component?"
Options: React component, React hook, API router, Python service

**Step 2**: Ask required files:
"What files should every [type] have?"
Options vary by type (checkboxes)

**Step 3**: Update patterns.yaml with new component pattern

### Flow for `/planning add boundary`

**Step 1**: Ask module to protect:
"What module should be protected?" (text input)

**Step 2**: Ask forbidden imports:
"What should it NOT be allowed to import?" (multi-select or text)

**Step 3**: Ask reason:
"Why this boundary?" (text input)

**Step 4**: Ask severity:
Options: error, warning, info

**Step 5**: Update patterns.yaml with new boundary rule

### Flow for `/planning add anti-pattern`

**Step 1**: Ask pattern:
"What pattern should be flagged?" (text or regex)

**Step 2**: Ask file types:
"Which file types?" (checkboxes: .ts, .tsx, .py, etc.)

**Step 3**: Ask message:
"What should developers do instead?" (text)

**Step 4**: Ask severity:
Options: error, warning, info

**Step 5**: Update patterns.yaml with new anti-pattern

---

## /planning sync

Scan existing codebase and auto-discover patterns. This is the "onboarding" command for new projects.

### Step 1: Launch Discovery Agents (Parallel)

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

### Step 2: Synthesize Discoveries

Combine agent results to identify:
- **Component patterns**: What files typically go together?
- **Feature structure**: How are features organized?
- **Import boundaries**: What modules don't import each other?
- **Anti-patterns already present**: Common issues to flag

### Step 3: Present Discoveries via CLI Questions

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

### Step 4: Write patterns.yaml

After user confirms selections:
- If patterns.yaml exists, merge new patterns
- If patterns.yaml doesn't exist, create from template with discovered patterns
- Confirm what was added

### Step 5: Suggest Next Steps

```
✅ patterns.yaml created/updated with discovered patterns

Next steps:
1. Review patterns.yaml and customize as needed
2. Run /audit to check current compliance
3. Run /audit fix to generate missing files
```

---

## /planning validate

Check that patterns.yaml is valid and complete.

### Checks Performed:

1. **YAML Syntax**: Parse patterns.yaml, report any syntax errors

2. **Path References**: Check that referenced paths exist
   - Feature type file patterns
   - Component pattern locations
   - Source of truth files

3. **Rule Conflicts**: Check for contradictory rules
   - Circular boundary dependencies
   - Overlapping component patterns

4. **Hygen Templates**: Check that required templates exist
   - For each feature type's hygen_template
   - For each hygen_mappings entry

5. **Completeness**: Check for missing sections
   - Are all recommended sections present?

### Output Format:

```
Validating patterns.yaml...

✅ Valid YAML syntax
✅ All 4 feature types have valid structure
✅ All 3 component patterns are consistent
✅ Boundary rules have no conflicts

⚠️ Missing Hygen templates:
   - feature/ml-pipeline (no template found)
   - component/with-store (no template found)

   Create with: npx hygen generator new --name [template]
   Or run: /audit templates to see available templates

⚠️ 2 paths in patterns don't exist yet:
   - apps/worker/ (referenced by background-job feature)
   - core/ml/ (referenced by ml-pipeline feature)

   These may be intentional (future structure)

✅ patterns.yaml is valid
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

/planning uses only Haiku agents (~$0.02-0.03 total for /planning sync).
The heavy work is done by cheap pattern matching, not LLM reasoning.

---

## Integration with Other Commands

- **/audit**: Reads patterns.yaml, compares to reality
- **/phase0**: Reads patterns.yaml to know what files to generate
- **/dev-flow**: Reads patterns.yaml to enforce patterns during development
- **/pr-review**: Reads patterns.yaml to check PR compliance
