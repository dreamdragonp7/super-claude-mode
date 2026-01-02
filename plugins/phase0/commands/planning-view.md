---
description: View summary of current patterns.yaml
---

# Planning: View Patterns Summary

Show a summary of your current patterns.yaml - the single source of truth for how your codebase SHOULD look.

---

## Step 1: Check for patterns.yaml

```bash
if [ -f "patterns.yaml" ]; then echo "found"; else echo "not found"; fi
```

If NOT found:
- Tell user: "No patterns.yaml found."
- Offer: "Run `/planning-sync` to auto-generate from codebase, or copy the template:"
- Show: `cp ~/.claude/plugins/marketplaces/super-claude-mode/plugins/phase0/templates/patterns-template.yaml ./patterns.yaml`

---

## Step 2: Parse and Summarize

Read patterns.yaml and extract:
- Number of Python boundary rules
- Number of TypeScript boundary rules
- Number of component patterns
- Number of feature types
- Number of anti-patterns

---

## Step 3: Show Recent Compliance

If ARCHITECTURE.md exists, show:
- Last audit timestamp
- Compliance percentage
- Number of gaps

---

## Step 4: Output Format

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
Compliance: [X% or "Unknown - run /audit-run"]
───────────────────────────────────────
```

---

## Related Commands

- `/planning-add` - Add new patterns interactively
- `/planning-sync` - Auto-discover patterns from codebase
- `/planning-validate` - Check patterns.yaml validity
