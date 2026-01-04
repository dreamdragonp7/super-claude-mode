# Phase0 v5.0 - The Context Compiler

**Minimal. Focused. Machine-readable.**

## Philosophy

> "Don't make me re-explain everything"

Phase0 creates YAML capsules that persist context across sessions and plugins.

## Commands (3 total)

| Command | Purpose |
|---------|---------|
| `/phase0 <task>` | Intake → questions → capsule creation → handoff |
| `/phase0:audit` | Reality check → ARCHITECTURE.md + gaps.json |
| `/phase0:patterns` | Manage patterns.yaml (create or refine) |

## The Two-File System

```
patterns.yaml (THE IDEAL)   -   ARCHITECTURE.md (THE REALITY)   =   THE GAP
```

## Storage

All phase0 outputs go to `/.phase0/`:

```
/.phase0/
├── capsules/<slug>/capsule.yaml   # Task handoff
└── reports/gaps.json              # Machine-readable gaps
```

## Capsule Contract

Other plugins read `capsule.yaml`:
- `/dev-flow --capsule <slug>`
- `/bug-hunt --capsule <slug>`
- `/hygen-rip --from-gaps`

## Single-Writer Principle

- Phase0 owns `/.phase0/**`
- Phase0 owns `patterns.yaml` (via /phase0:patterns)
- Phase0 owns `ARCHITECTURE.md` (via /phase0:audit)
- **Nothing else**

## Hooks

- **PostToolUse**: Blocks writes outside allowed locations
- **Stop**: Fast YAML validation

## What's Removed (from v4.x)

- ❌ /planning-view, /planning-add, /planning-sync, /planning-validate (merged into /phase0:patterns)
- ❌ /audit-run, /audit-inventory, /audit-templates (merged into /phase0:audit)
- ❌ /focus, /atlas (scope creep)
- ❌ Exposed agents (now internal implementation)

## Cost

~$0.05 per /phase0 invocation (mostly Haiku agents)
