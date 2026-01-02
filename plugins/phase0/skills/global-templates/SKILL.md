---
name: global-templates
description: Knowledge about the global Hygen templates system (Library of Alexandria). Use when agents need to find, read, or use templates for scaffolding or repair.
---

# Global Hygen Templates (Library of Alexandria)

## Location

**Path:** `~/.hygen-templates/` (or `$HOME/.hygen-templates/`)
**Environment Variable:** `HYGEN_TMPLS`

Templates are GLOBAL - available in ANY project, not just one codebase.

## Available Templates (24 generators)

### API Templates (api/)
```
api/full-endpoint    - Complete REST endpoint (router + schema + injection)
api/router           - FastAPI router only
api/schema           - Pydantic schemas only
```

### Component Templates (component/)
```
component/new        - React functional component + index
component/index      - Barrel export file (named or default exports)
component/lazy       - Code-split component with Suspense
component/test       - Component test file
```

### Core Templates (core/)
```
core/use-case        - Business logic use case (Clean Architecture)
core/domain-model    - Frozen dataclass with invariants
```

### Database Templates (db/)
```
db/migration         - Versioned SQL migration (up/down)
```

### Infrastructure Templates (infra/)
```
infra/repository     - Repository pattern for DB access
infra/data-provider  - External API provider with rate limiting
```

### Store Templates (store/)
```
store/new            - Zustand store with middleware options
```

### Test Templates (test/)
```
test/e2e             - Playwright E2E test (Page Object pattern)
test/integration     - API integration test (httpx)
test/gauntlet        - ML validation test (P0/P1/P2)
test/use-case        - Use case unit test
```

### Shared Templates (shared/)
```
shared/type          - TypeScript type definitions + export injection
```

### Web Templates (web/)
```
web/feature          - Complete feature (component + hook + test + index)
```

## Using Templates

### From Command Line
```bash
# Must have HYGEN_TMPLS set (added to ~/.bashrc)
export HYGEN_TMPLS="$HOME/.hygen-templates"

# Then use from any directory
hygen api full-endpoint --name alerts
hygen component index --path src/components/feed --files "A.tsx,B.tsx" --exportType named
hygen test e2e --page feed --actions load,click
```

### From Agents

When scanning templates:
```
Directory: ~/.hygen-templates/
├── api/
├── component/
├── core/
├── db/
├── infra/
├── store/
├── test/
├── shared/
└── web/
```

When reading template content:
- Each template has `prompt.js` (arguments) and `*.ejs.t` (output)
- Some have `README.md` with repair invariants
- Some have `inject-*.ejs.t` for adding to existing files

## Template Purposes

Templates serve THREE purposes:

### 1. SCAFFOLD (Generate New)
```bash
hygen api full-endpoint --name alerts
# Creates: routers/alerts.py, schemas/alerts.py
```

### 2. REFERENCE (Correct Pattern)
When fixing code, READ the template to understand correct structure:
```
Template shows: try/except with HTTPException
Existing code: No error handling
Gap: Need to add error handling following template pattern
```

### 3. REPAIR (Fix Existing)
Use `/audit-repair` to:
1. Scan templates
2. Match violations to templates
3. Generate diffs based on template patterns
4. Apply fixes

## Per-Project Override

Projects can have local `_templates/` that override global:
- Hygen checks local first
- Falls back to global `HYGEN_TMPLS`
- Use local for project-specific variations

## Key Files

| File | Purpose |
|------|---------|
| `~/.bashrc` | Sets `HYGEN_TMPLS` environment variable |
| `~/.hygen-templates/` | Global template storage |
| `~/.claude/CLAUDE.md` | Documents template system for Claude |

## Integration with Plugins

All super-claude-mode plugins should:
1. Check `HYGEN_TMPLS` or default to `~/.hygen-templates/`
2. Scan templates when doing compliance checks
3. Reference templates when proposing fixes
4. Use templates for scaffolding when appropriate

## Adding New Templates

```bash
cd ~/.hygen-templates
mkdir -p category/action
# Create prompt.js and *.ejs.t files
```

Template structure:
```
category/action/
├── prompt.js       # CLI prompts/arguments
├── main.ejs.t      # Primary output file
├── inject-*.ejs.t  # Optional: inject into existing files
└── README.md       # Optional: repair invariants
```
