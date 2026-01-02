# Hygen-Ripper v2.0 - The Template Powerhouse

**Rip. Stage. Promote. Compare.**

## Philosophy

> Templates are never corrupted mid-operation thanks to atomic staging.

## Commands (4 total)

| Command | Purpose |
|---------|---------|
| `/hygen-rip <url>` | Extract from web → staging |
| `/hygen-rip --from-gaps` | Generate from gaps.json → staging |
| `/hygen-promote <id>` | Staging → _templates (atomic) |
| `/hygen-templates` | List, search, info, refresh |
| `/hygen-compare <path>` | Code vs template review (read-only) |

## The Staging Workflow

```
/hygen-rip → /.ripper/staging/<id>/
     │
     ▼
(validate, preview, confirm)
     │
     ▼
/hygen-promote → _templates/ or ~/.hygen-templates/
```

**Why?** Atomic safety. Preview before commit. No corruption.

## Storage

```
/.ripper/
├── staging/<id>/          # Temporary work area
│   ├── prompt.js
│   ├── component.ejs.t
│   └── manifest.yaml
└── index/
    └── .hygen-index.json  # Template catalog
```

## Cross-Plugin Integration

Reads from phase0:
- `/.phase0/reports/gaps.json` (for --from-gaps)
- `/.phase0/capsules/*/capsule.yaml` (for context)

## Single-Writer Principle

- `/hygen-rip` → writes ONLY to `/.ripper/staging/`
- `/hygen-promote` → writes to `_templates/` (ONLY this command can)
- `/hygen-templates` → read-only
- `/hygen-compare` → read-only

## Hooks

- **PostToolUse**: Blocks rip from writing to _templates directly

## What's Removed (from v1.x)

- ❌ /repair (split: detection→phase0:audit, fixes→hygen-rip --from-gaps)
- ❌ Direct template writes (now staging-first)

## Cost

~$0.04 per /hygen-rip (Haiku + Opus)
