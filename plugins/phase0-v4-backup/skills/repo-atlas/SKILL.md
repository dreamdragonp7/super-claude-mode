---
name: repo-atlas
description: Knowledge about the Repo Atlas documentation system. Use when discussing repo maps, feature registries, task capsules, or documentation generation.
---

# Repo Atlas Knowledge

## The System

Repo Atlas is a documentation-as-code system that makes the repo self-documenting for AI agents.

### Philosophy

"Don't make the model remember the repo—make the repo tell the model."

Files persist. Memory doesn't. Externalize everything.

### Three Layers

#### Layer 1: Static Truth (Manual)
- `CLAUDE.md` - Architecture overview, commands, conventions
- `features.yaml` - Canonical feature registry
- `docs/decisions/ADR-*.md` - Architectural decisions
- `docs/NOW.md` - Current focus and priorities

#### Layer 2: Generated Truth (Scripts)
- `docs/repo-map.md` - Module structure (auto-generated)
- `docs/feature-map.md` - Feature → files mapping
- `docs/dependency-map.md` - Import graphs

#### Layer 3: Session State (Per-Task)
- `docs/taskcaps/*.md` - Task-specific context
- `PROGRESS.md` - Cross-session continuity
- `docs/dev-journal.md` - Auto-generated log

## File Formats

### features.yaml
```yaml
version: "1.0"
updated: "2025-01-01"
features:
  - id: feature-id
    name: Feature Name
    description: What it does
    status: stable|development|deprecated
    folders:
      - path/to/folder/
    entrypoints:
      - path/to/entry.py
    tests:
      - tests/path/
```

### ADR Format
```markdown
# ADR-001: [Title]

## Status
Accepted | Proposed | Deprecated

## Context
[Why this decision was needed]

## Decision
[What we decided]

## Consequences
[Good and bad outcomes]
```

### NOW.md
```markdown
# Current Focus

Updated: [date]

## This Week
- Priority 1
- Priority 2

## Active Threads
- PR #123: description
- Issue #456: description

## Blockers
- Any blockers

## Next Up
- Future work
```

## Usage Patterns

- Run `/phase0` before `/dev-flow` or `/bug-hunt`
- Run `/atlas` to regenerate documentation
- Run `/focus <topic>` for targeted context
- Check `docs/taskcaps/` for recent capsules
- Reference ADRs for architectural decisions
