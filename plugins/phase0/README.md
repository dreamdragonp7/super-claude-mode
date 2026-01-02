# Phase 0 Plugin v2.0

Pre-flight exploration, pattern enforcement, and context management for Super Claude Mode.

## What Is Phase 0?

Phase 0 is a **required first step** before running `/dev-flow` or `/bug-hunt`. It ensures context is mapped, patterns are checked, and work is captured before diving into implementation.

## Why Phase 0?

| Problem | Solution |
|---------|----------|
| Context drift after compaction | Task capsules persist across sessions |
| Phases get skipped | Hooks enforce running phase0 first |
| Token waste on scanning | Haiku agents are 10x cheaper |
| Wrong assumptions | Scanning finds what exists before building |
| Codebase drift from patterns | /audit checks compliance |
| Missing boilerplate files | /conform auto-generates them |

## Commands

| Command | Purpose | Cost |
|---------|---------|------|
| `/phase0 [task]` | Full pre-flight with task capsule creation | ~$0.07 |
| `/focus [topic]` | Quick context mapping without capsule | ~$0.02 |
| `/atlas` | Generate/update repo documentation | ~$0.05 |
| `/scaffold [template] [name]` | Deterministic code generation | FREE |
| `/audit [path]` | Check pattern compliance (NEW!) | ~$0.02 |
| `/inventory [path]` | List everything in codebase (NEW!) | ~$0.02 |
| `/conform [path]` | Auto-fix pattern violations (NEW!) | FREE |

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| file-scanner | Haiku | CHEAP file finding |
| import-tracer | Haiku | CHEAP dependency tracing |
| test-finder | Haiku | CHEAP test discovery |
| context-synthesizer | Opus | Smart analysis |
| pattern-checker | Haiku | CHEAP component pattern scanning (NEW!) |
| boundary-validator | Haiku | CHEAP import boundary checking (NEW!) |
| conformance-fixer | Opus | Smart fix planning (NEW!) |

## Skills

| Skill | Purpose |
|-------|---------|
| ultra-scientist | 2M IQ personality mode |
| repo-atlas | Documentation system knowledge |
| task-capsules | Capsule format and lifecycle |
| phase0-guide | Workflow guidance |
| code-audit | Audit/conform system knowledge (NEW!) |

## Hooks

| Event | Action |
|-------|--------|
| UserPromptSubmit | Suggests /phase0 if no recent capsule |
| PreCompact | Auto-saves to dev-journal.md |
| SessionStart | Lists capsules, docs, patterns.yaml status |
| Stop | Warns if Definition of Done incomplete |

## The Workflow

```
User Request
     │
     ▼
┌─────────────────┐
│    /phase0      │ ← Map context, create capsule
└─────────────────┘
     │
     ▼
┌─────────────────┐
│    /audit       │ ← Check pattern compliance (optional)
└─────────────────┘
     │
     ▼
┌─────────────────┐
│   /conform      │ ← Fix gaps automatically (optional)
└─────────────────┘
     │
     ▼
┌─────────────────┐
│  /dev-flow OR   │ ← Now has context + clean patterns
│  /bug-hunt      │
└─────────────────┘
```

## The Code Audit System (v2.0)

### patterns.yaml

Single source of truth for codebase patterns:

```yaml
python_layers:        # Import boundary rules
typescript_boundaries: # Module boundaries
component_patterns:   # Required files per component
anti_patterns:        # Patterns to detect and flag
```

Copy the template to your project:
```bash
cp ~/.claude/plugins/marketplaces/super-claude-mode/plugins/phase0/templates/patterns.yaml ./
```

### /audit

Checks compliance against patterns.yaml:
- Python layer violations (core→apps import forbidden)
- TypeScript boundary violations (web→mobile import forbidden)
- Missing required files (tests, index.ts, schemas)
- Anti-patterns (console.log, `any` types, relative imports)

### /conform

Auto-fixes using Hygen templates:
- Generates missing test files
- Creates missing index.ts exports
- Scaffolds missing API schemas
- FREE (no LLM tokens - Hygen is deterministic)

### /inventory

Lists everything in the codebase:
- Components, hooks, stores (frontend)
- Routers, schemas, services (backend)
- Tests and coverage estimate
- Key configuration files

## Installation

This plugin is part of the super-claude-mode marketplace.

```bash
# Already installed if you have super-claude-mode
# Restart Claude Code to load v2.0
```

## Usage

```bash
# Start with phase0
/phase0 Add user authentication with OAuth

# Check pattern compliance
/audit apps/web

# Auto-fix gaps
/conform apps/web

# Quick context mapping
/focus authentication

# Update documentation
/atlas

# Generate boilerplate
/scaffold feature:new auth-flow

# List everything
/inventory apps/
```

## Philosophy

"Don't make the model remember the repo—make the repo tell the model."

- Files persist. Memory doesn't. Externalize everything.
- Cheap scanning first. Expensive thinking after.
- Templates for structure. Claude for logic.
- Single source of truth (patterns.yaml) for all enforcement.

## Tools Integration

The plugin works with industry-standard tools:

| Tool | Purpose | Install |
|------|---------|---------|
| import-linter | Python boundary enforcement | `pip install import-linter` |
| eslint-plugin-boundaries | TypeScript boundaries | `npm i -D eslint-plugin-boundaries` |
| Hygen | Scaffolding templates | `npm i -g hygen` |
| Repomix | AI-friendly repo packing | `npm i -g repomix` |
