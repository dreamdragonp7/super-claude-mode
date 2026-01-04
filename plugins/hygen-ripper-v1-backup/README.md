# Hygen Ripper

Rip UI patterns from websites. Repair code using templates. The extraction and repair powerhouse for Super Claude Mode.

## What It Does

**RIP**: See a beautiful component on the web? Grab it, templatize it, reuse it forever.

**REPAIR**: Compare your ideal architecture (patterns.yaml) against reality (ARCHITECTURE.md) and fix the gaps using Hygen templates.

## Installation

```bash
# Already part of super-claude-mode marketplace
/plugin install hygen-ripper@super-claude-mode
```

## Commands

| Command | Description |
|---------|-------------|
| `/rip [url]` | Rip UI from website using Playwright |
| `/rip` | Paste mode - manually input HTML/CSS |
| `/repair` | Fix gaps between patterns.yaml and ARCHITECTURE.md |
| `/templates` | List/search/manage your template library |

## Quick Start

### Rip a Component

```
/rip https://stripe.com/pricing

> Which component?
.pricing-card

> Ripped! Template at ~/.hygen-templates/component/ripped/pricing-card/
> Use: hygen component ripped pricing-card
```

### Repair Your Codebase

```
/repair

> Gap Analysis: 5 gaps found
> - Missing: Button component (template: component/new)
> - Structure: API route missing schema (template: api/schema)
>
> Proceed? [Y/n]

> 4/5 gaps fixed
> 1 requires manual intervention (boundary violation)
```

### Browse Templates

```
/templates search button

> Found 3 matches:
> 1. component/ripped/stripe-btn (95%)
> 2. component/new (70%)
> 3. ui/icon-button (60%)
```

## Architecture

### Agents

| Agent | Model | Role |
|-------|-------|------|
| extractor | Haiku | DOM + CSS extraction, fast & cheap |
| templater | Opus | Generate quality Hygen templates |
| scanner | Haiku | Find gaps (runs 5x in parallel) |
| architect | Opus | Design and execute repairs |
| indexer | Haiku | Maintain template index |

### Skills

- **hygen-mastery** - EJS syntax, prompt.js, best practices
- **repair-patterns** - Gap detection, anti-unification, template fitting

### Hooks

- **PreCompact** - Saves repair progress before memory compaction

## Template Storage

All templates go to `~/.hygen-templates/` (global, available in all projects).

```
~/.hygen-templates/
├── .hygen-index.json      # Master index
├── component/
│   ├── new/               # Created templates
│   └── ripped/            # Ripped from web
│       └── stripe-btn/
├── api/
└── test/
```

## Origins

Templates are tagged by origin:

| Origin | Meaning |
|--------|---------|
| `created` | Built from your own code patterns |
| `ripped` | Extracted from websites |
| `downloaded` | From template marketplaces |
| `modified` | Customized from another source |

## Requirements

- Playwright MCP (for web ripping)
- Hygen CLI (`npm i -g hygen`)
- `HYGEN_TMPLS` env var pointing to `~/.hygen-templates`

## Part of Super Claude Mode

This plugin works best with:
- **phase0** - patterns.yaml management, ARCHITECTURE.md generation
- **dev-flow** - Feature development workflow
- **bug-hunt** - Debugging workflow

---

Made with the Super Claude Mode team
