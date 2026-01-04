---
description: Reality check - scan codebase, generate ARCHITECTURE.md + gaps.json, run real tools
argument-hint: [--scope <path>]
---

# /phase0:audit - The Reality Check

**Purpose**: Generate a fresh snapshot of what the codebase ACTUALLY looks like. Compare against patterns.yaml (THE IDEAL) to produce THE REALITY.

**Outputs**:
- `ARCHITECTURE.md` - Human-readable architecture snapshot
- `/.phase0/reports/gaps.json` - Machine-readable gap list (consumed by /hygen-rip --from-gaps)

---

## Input

Optional scope: $ARGUMENTS (defaults to entire project)

---

## Phase 1: Tool Verification

Verify required tools are installed:

```bash
echo "=== Tool Check ==="
command -v madge && madge --version 2>/dev/null | head -1 || echo "madge: MISSING (npm i -g madge)"
command -v dot && dot -V 2>&1 | head -1 || echo "graphviz: MISSING (apt install graphviz)"
command -v depcruise && depcruise --version 2>/dev/null | head -1 || echo "depcruise: MISSING (npm i -g dependency-cruiser)"
```

Continue even if some tools missing - note in output.

---

## Phase 2: Read patterns.yaml

If patterns.yaml exists:
- Extract boundary rules
- Extract component patterns
- Extract anti-patterns
- Extract feature types

This becomes THE IDEAL to compare against.

---

## Phase 3: Parallel Agent Scanning (4 internal agents)

Launch 4 scans in parallel (Haiku, cheap):

**1. File Scanner**
- Inventory all components, routes, models, hooks, stores
- Categorize by type and location

**2. Import Tracer**
- Map all import statements
- Build dependency graph
- Identify internal vs external deps

**3. Pattern Checker**
- For each component pattern in patterns.yaml
- Check if required files exist
- List what's missing

**4. Boundary Validator**
- Check all imports against boundary rules
- Flag violations with file:line

---

## Phase 4: Run Real Tools

Execute visualization tools:

```bash
# Dependency graph (TypeScript/JS only)
if [ -f "tsconfig.json" ] || ls *.ts 2>/dev/null | head -1; then
  madge --image docs/dep-graph.svg --extensions ts,tsx --exclude 'node_modules|\.next|dist' . 2>/dev/null || echo "madge: failed"
fi

# Dependency cruise visualization
if command -v depcruise &>/dev/null; then
  if [ -f ".dependency-cruiser.js" ]; then
    depcruise --output-type dot . 2>/dev/null | dot -T svg > docs/dep-cruise.svg
  else
    depcruise --no-config --output-type dot --exclude "node_modules" . 2>/dev/null | dot -T svg > docs/dep-cruise.svg
  fi
fi
```

---

## Phase 5: Synthesize Results

Combine agent results + tool outputs into:

**Gap Analysis**:
- Components missing required files
- Boundary violations
- Anti-pattern occurrences
- Orphaned code (no pattern match)

**Compliance Calculation**:
```
compliance_pct = (compliant_components / total_components) * 100
```

---

## Phase 6: Write Outputs

### ARCHITECTURE.md (project root)

```markdown
# Architecture

Generated: [timestamp]
Scanned: [scope or "entire project"]
Patterns: patterns.yaml [found/not found]

## Quick Stats

| Category | Count |
|----------|-------|
| Python modules | X |
| TypeScript modules | X |
| React components | X |
| API routes | X |
| Test files | X |

## Compliance: X%

### Boundaries
- Python: [X violations]
- TypeScript: [X violations]

### Component Patterns
| Pattern | Compliant | Total | % |
|---------|-----------|-------|---|
| react_component | X | Y | Z% |
| api_endpoint | X | Y | Z% |

### Gaps Found
[List of gaps with severity]

## Visual Artifacts
- [docs/dep-graph.svg](docs/dep-graph.svg)
- [docs/dep-cruise.svg](docs/dep-cruise.svg)
```

### /.phase0/reports/gaps.json

```json
{
  "generated": "YYYY-MM-DDTHH:MM:SSZ",
  "compliance_pct": 87,
  "total_gaps": 5,
  "gaps": [
    {
      "type": "missing_file",
      "severity": "high",
      "component": "Button",
      "location": "src/components/Button/",
      "missing": "Button.test.tsx",
      "pattern": "react_component",
      "fix_template": "component/test"
    },
    {
      "type": "boundary_violation",
      "severity": "high",
      "file": "core/service.py",
      "line": 15,
      "import": "from apps.api import something",
      "rule": "core cannot import apps"
    }
  ]
}
```

---

## Phase 7: Report

```
/phase0:audit COMPLETE
════════════════════════════════════════════

Scanned: [scope]
Duration: [time]

TOOLS
├── madge: [success/failed/skipped]
├── depcruise: [success/failed/skipped]
└── graphviz: [success/failed/skipped]

AGENTS (4 parallel)
├── file-scanner: [X] files
├── import-tracer: [X] imports
├── pattern-checker: [X] patterns
└── boundary-validator: [X] boundaries

RESULTS
├── Compliance: [X]%
├── Total gaps: [X]
│   ├── High severity: [X]
│   ├── Medium severity: [X]
│   └── Low severity: [X]
└── Boundary violations: [X]

OUTPUTS
├── ARCHITECTURE.md (updated)
└── /.phase0/reports/gaps.json

NEXT
├── Fix gaps: /hygen-rip --from-gaps
├── Refine patterns: /phase0:patterns
└── Start work: /phase0 <task>

════════════════════════════════════════════
```

---

## Writes (ONLY these locations)

- `ARCHITECTURE.md` (project root)
- `/.phase0/reports/gaps.json`
- `docs/dep-graph.svg` (via madge)
- `docs/dep-cruise.svg` (via depcruise)

**NEVER writes to**: `patterns.yaml`, `_templates/`, source code

---

## Cost

| Phase | Model | Estimated Cost |
|-------|-------|----------------|
| 4 Agents | Haiku×4 | ~$0.02 |
| Real tools | Local | $0.00 |
| Synthesis | Internal | ~$0.01 |
| **Total** | | **~$0.03** |
