---
description: Fresh scan of codebase, generate ARCHITECTURE.md + visual graphs, compare to patterns.yaml
argument-hint: [path]
---

# Audit: Full Compliance Check with Visualization

/audit-run is your reality check. It always does a FRESH scan (never trusts old data), runs REAL tools for visualization, writes results to ARCHITECTURE.md + SVG graphs, then compares reality to your ideal (patterns.yaml).

**v4.0 adds:** Mandatory tool verification, madge dependency graphs, depcruise visualizations, Mermaid diagrams in ARCHITECTURE.md, intermediate JSON for scripting.

---

## Input

Path to scan: $ARGUMENTS (defaults to entire project if not specified)

---

## Phase 1: Tool Verification (MANDATORY)

First, verify ALL required tools are installed. This phase is BLOCKING - abort if any tool is missing.

```bash
echo "Checking required tools..."
echo ""

# Check each tool
echo "madge:" && which madge && madge --version 2>/dev/null | head -1 || echo "MISSING"
echo "graphviz:" && which dot && dot -V 2>&1 | head -1 || echo "MISSING"
echo "depcruise:" && which depcruise && depcruise --version 2>/dev/null | head -1 || echo "MISSING"
echo "hygen:" && which hygen || echo "MISSING"
```

**If ANY tool is missing:**

```
AUDIT ABORTED: Missing required tools

Install missing tools:
- madge:     npm install -g madge
- graphviz:  sudo apt install graphviz  (or brew install graphviz)
- depcruise: npm install -g dependency-cruiser
- hygen:     npm install -g hygen

After installing, run /audit-run again.
```

**All tools present -> proceed to Phase 2.**

---

## Phase 2: Check Prerequisites

Check for patterns.yaml:
- If NOT found: "No patterns.yaml found. Run `/planning-sync` to create one."
- If found: Note version and extract rules for comparison

Check for docs/ directory:
```bash
mkdir -p docs
```

---

## Phase 3: Parallel Agent Scanning (4 agents)

Launch 4 Haiku agents in parallel for cheap scanning:

**file-scanner agent:**
- "Find all components, routes, models, hooks, stores, tests in [path]"
- Returns: File inventory by type and directory

**import-tracer agent:**
- "Map all import statements in [path], build dependency graph"
- Returns: Import map, internal vs external dependencies

**pattern-checker agent:**
- "Check [path] against patterns.yaml rules, report violations"
- Returns: Violations list with file:line references

**boundary-validator agent:**
- "Check import boundaries in [path] against patterns.yaml boundary rules"
- Returns: Boundary violations with file:line references

---

## Phase 4: Run Real Tools (MANDATORY)

These tools MUST run. They are not optional fallbacks.

**madge - Dependency Graph:**
```bash
# Detect project type and run appropriate madge command
if ls *.ts tsconfig.json 2>/dev/null | head -1; then
  # TypeScript project
  madge --image docs/dep-graph.svg --extensions ts,tsx --exclude '^(node_modules|\.next|dist|build)' . 2>/dev/null
elif ls *.py pyproject.toml 2>/dev/null | head -1; then
  # Python project - madge doesn't support Python, skip with note
  echo "Note: madge is JavaScript/TypeScript only. Python deps not visualized."
else
  madge --image docs/dep-graph.svg --exclude '^(node_modules|\.next|dist|build)' .
fi
```

**depcruise - Dependency Validation + Graph:**
```bash
# Check if .dependency-cruiser.js config exists
if [ -f ".dependency-cruiser.js" ] || [ -f ".dependency-cruiser.cjs" ]; then
  depcruise --output-type dot . 2>/dev/null | dot -T svg > docs/dep-cruise.svg
else
  # Use default rules (--no-config required when no config file)
  depcruise --no-config --output-type dot --exclude "node_modules|\.next|dist" . 2>/dev/null | dot -T svg > docs/dep-cruise.svg
fi
```

**import-linter (Python projects only):**
```bash
# Only run if Python files exist
if ls *.py **/*.py 2>/dev/null | head -1; then
  if [ -f ".importlinter" ] || grep -q "importlinter" pyproject.toml 2>/dev/null; then
    import-linter 2>/dev/null || echo "import-linter: no config found"
  else
    echo "import-linter: no .importlinter config, skipping"
  fi
fi
```

**eslint-plugin-boundaries (TypeScript projects only):**
```bash
# Only run if TypeScript and boundaries plugin configured
if ls *.ts tsconfig.json 2>/dev/null | head -1; then
  if grep -r "boundaries" eslint.config.* .eslintrc* 2>/dev/null | head -1; then
    npx eslint . --plugin boundaries --format json 2>/dev/null | head -100 || echo "eslint-boundaries: check failed"
  else
    echo "eslint-boundaries: not configured, using agent results"
  fi
fi
```

---

## Phase 5: Generate Intermediate JSON

Create a structured JSON snapshot for scripting:

```bash
# Write to /tmp/arch-audit.json
```

JSON structure:
```json
{
  "generated": "2025-01-02T12:00:00Z",
  "project": "[project-name]",
  "scanned_path": "[path]",
  "summary": {
    "total_files": 847,
    "total_imports": 1243,
    "pattern_violations": 3,
    "boundary_violations": 1
  },
  "modules": [
    {"name": "core", "files": 45, "purpose": "Business logic"},
    {"name": "apps/api", "files": 23, "purpose": "API routes"}
  ],
  "boundaries": {
    "python": {"violations": 0, "tool": "import-linter"},
    "typescript": {"violations": 1, "tool": "eslint-boundaries"}
  },
  "patterns": {
    "compliant": 12,
    "total": 15,
    "gaps": ["Modal missing test", "Card missing index"]
  },
  "artifacts": {
    "dep_graph": "docs/dep-graph.svg",
    "dep_cruise": "docs/dep-cruise.svg",
    "architecture": "ARCHITECTURE.md"
  }
}
```

---

## Phase 6: Write ARCHITECTURE.md

Create/overwrite ARCHITECTURE.md at project root with fresh scan results.

**IMPORTANT:** Include Mermaid diagrams for visual architecture in the markdown itself.

```markdown
# Architecture

Generated: [timestamp]
Scanned: [path or "entire project"]
Patterns: patterns.yaml (version [X])

## System Overview

[Mermaid diagram showing module relationships]

## Quick Stats

| Category | Count |
|----------|-------|
| Python modules | X |
| TypeScript modules | X |
| React components | X |
| API routes | X |
| Hooks | X |
| Test files | X |

## Visual Artifacts

- **Dependency Graph**: [docs/dep-graph.svg](docs/dep-graph.svg)
- **Dependency Cruise**: [docs/dep-cruise.svg](docs/dep-cruise.svg)

[Full module structure, component inventory, dependencies, boundary status, anti-patterns, test coverage]
```

---

## Phase 7: Compare to patterns.yaml

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

---

## Phase 8: Show Git Diff

Show what changed since last audit:

```bash
git diff ARCHITECTURE.md 2>/dev/null | head -100
```

---

## Phase 9: Output Report

```
AUDIT v4.0 COMPLETE
---

TOOLS VERIFIED
- madge 8.0.0
- graphviz 2.43.0
- depcruise 17.2.0
- import-linter 2.9
- hygen 6.2.11

AGENTS (4 parallel)
- file-scanner: [X] files found
- import-tracer: [X] imports mapped
- pattern-checker: [X] violations
- boundary-validator: [X] boundary issues

TOOLS EXECUTED
- madge -> docs/dep-graph.svg ([X] modules)
- depcruise -> docs/dep-cruise.svg
- import-linter -> [X] Python violations
- eslint-boundaries -> [X] TypeScript violations

ARTIFACTS GENERATED
- ARCHITECTURE.md ([X] lines)
- docs/dep-graph.svg
- docs/dep-cruise.svg
- /tmp/arch-audit.json

COMPARING TO patterns.yaml...

BOUNDARIES
- Python (import-linter): Clean
- TypeScript (eslint-boundaries): 1 violation

COMPONENT PATTERNS
- React components: 12/15 compliant (80%)
- API routes: 8/8 compliant

ANTI-PATTERNS
- console.log: 3 found (should be 0)
- any type: 2 found (should be 0)

SUMMARY
---
Total gaps: 8
- Auto-fixable: 3 (missing files)
- Manual fix needed: 5 (boundary, anti-patterns)

Compliance: 87%

Run /audit-fix to auto-generate missing files.
---
```

---

## Related Commands

- `/audit-fix` - Auto-generate missing files using Hygen
- `/audit-inventory` - Detailed inventory of what exists vs expected
- `/audit-templates` - Show available Hygen templates

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| file-scanner | Haiku | CHEAP file/component discovery |
| import-tracer | Haiku | CHEAP dependency mapping |
| pattern-checker | Haiku | CHEAP pattern/boundary checking |
| boundary-validator | Haiku | CHEAP boundary violation detection |

---

## Cost Estimate

| Phase | Cost |
|-------|------|
| 4 Haiku agents | ~$0.02 |
| Real tools | $0.00 (local) |
| Synthesis | ~$0.01 |
| **Total** | **~$0.03** |
