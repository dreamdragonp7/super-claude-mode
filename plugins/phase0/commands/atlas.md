---
description: Generate or update Repo Atlas documentation (repo-map, feature-map, dependency-map)
---

# Atlas: Repository Documentation Generator

Generate self-documenting codebase files that help Claude understand any project.

---

## What Gets Generated

| File | Purpose | Update Frequency |
|------|---------|------------------|
| docs/repo-map.md | Module structure and entry points | On significant changes |
| docs/feature-map.md | Feature → files mapping | When features change |
| docs/dependency-map.md | Import graphs | On dependency changes |
| docs/NOW.md | Current focus and active work | Weekly or as needed |

---

## Step 1: Create docs/ Directory

```bash
mkdir -p docs/decisions docs/taskcaps
```

---

## Step 2: Generate repo-map.md

Scan the project structure and create:

```markdown
# Repository Map

Generated: [date]

## Project Type
[monorepo/single-app/library]

## Structure
```
[directory tree]
```

## Entry Points
| Entry | Path | Purpose |
|-------|------|---------|

## Key Modules
| Module | Path | Responsibility |
|--------|------|----------------|

## Configuration
| Config | Path | Purpose |
|--------|------|---------|
```

---

## Step 3: Generate feature-map.md

If features.yaml exists, generate from it. Otherwise, scan and create:

```markdown
# Feature Map

Generated: [date]

## Features

### [Feature Name]
- **Status**: stable/development/deprecated
- **Entry**: path/to/entrypoint
- **Files**:
  - path/to/impl.py
  - path/to/component.tsx
- **Tests**: path/to/tests/
- **Docs**: [relevant docs]
```

---

## Step 4: Generate dependency-map.md

```markdown
# Dependency Map

Generated: [date]

## External Dependencies
| Package | Version | Purpose |
|---------|---------|---------|

## Internal Dependencies
[Mermaid diagram or text representation of import graph]

## Circular Dependencies
[List any circular imports]

## Heavy Dependencies
[Dependencies that pull in large trees]
```

---

## Step 5: Update NOW.md

Prompt user for:
- Current focus (what are you working on?)
- Active threads (open PRs, issues)
- Blockers (anything stuck?)
- Next priorities

```markdown
# Current Focus

Updated: [date]

## This Week
- [Priority 1]
- [Priority 2]

## Active Threads
- PR #123: [description]
- Issue #456: [description]

## Blockers
- [Blocker if any]

## Next Up
- [Future priority]
```

---

## Usage

Run `/atlas` when:
- Starting work on a new project
- After significant refactoring
- When onboarding new team members
- When Claude seems confused about structure
