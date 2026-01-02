---
description: List, search, and manage your Hygen template library
argument-hint: [list|search|info|refresh] [query]
---

# /hygen-templates - Template Library Manager

**Purpose**: View and manage all Hygen templates. Search by name, tags, or origin.

---

## Subcommands

- `/hygen-templates` or `/hygen-templates list` - List all templates
- `/hygen-templates search <query>` - Search by name/tags
- `/hygen-templates info <name>` - Show template details
- `/hygen-templates refresh` - Rebuild index from disk

---

## /hygen-templates list

### Phase 1: Read Index

```bash
# Check for index
INDEX_FILE="${HYGEN_TMPLS:-.}/.hygen-index.json"
if [ -f "$INDEX_FILE" ]; then
  echo "Index found"
else
  echo "Index missing - will scan"
fi
```

If missing, trigger refresh first.

### Phase 2: Display by Origin

```
## Template Library

### Created (from your code)
| Template | Description | Tags |
|----------|-------------|------|
| component/new | Basic React component | react, typescript |
| api/router | FastAPI router | python, fastapi |
| test/unit | Unit test scaffold | testing, pytest |

### Ripped (from websites)
| Template | Source | Date | Tags |
|----------|--------|------|------|
| component/ripped/stripe-btn | stripe.com | 2025-01-02 | button, tailwind |
| component/ripped/notion-card | notion.so | 2025-01-01 | card, clean |

### Global (~/.hygen-templates/)
| Template | Description | Tags |
|----------|-------------|------|
| api/full-endpoint | Complete REST endpoint | api, fastapi |
| component/lazy | Code-split component | react, suspense |

Total: [X] templates
```

---

## /hygen-templates search <query>

### Search Algorithm

1. Split query into terms: "button payment" → ["button", "payment"]
2. For each template, calculate score:
   - Name contains term: +10
   - Tag matches term: +5
   - Description contains term: +3
   - Source URL contains term: +2
3. Return sorted by score

### Output

```
## Search: "button payment"

Found 3 matches:

1. component/ripped/stripe-btn (95%)
   Tags: button, payment, tailwind
   Source: stripe.com
   Usage: hygen component ripped stripe-btn

2. component/button (70%)
   Tags: button, basic
   Origin: created
   Usage: hygen component button

3. test/button-integration (40%)
   Tags: testing, button
   Origin: downloaded
   Usage: hygen test button-integration
```

---

## /hygen-templates info <name>

Show detailed template information:

```
## Template: component/ripped/stripe-btn

METADATA
├── Origin: ripped
├── Source: https://stripe.com/pricing
├── Ripped: 2025-01-02
├── Tags: button, payment, tailwind

FILES
├── prompt.js (3 prompts)
├── component.ejs.t (47 lines)
└── index.ejs.t (3 lines)

PROMPTS
| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | input | - | Component name (PascalCase) |
| variant | select | primary | primary, secondary, outline |
| size | select | md | sm, md, lg |

PREVIEW
┌────────────────────────────────────────┐
│ export function <%= Name %>({         │
│   variant = '<%= variant %>',         │
│   size = '<%= size %>'                │
│ }) {                                  │
│   return <button className={...}>     │
│     ...                               │
│   </button>                           │
│ }                                     │
└────────────────────────────────────────┘

USAGE
└── hygen component ripped stripe-btn
```

---

## /hygen-templates refresh

Rebuild index from disk:

### Phase 1: Scan Directories

```bash
# Find all Hygen templates
find "${HYGEN_TMPLS:-_templates}" -name "*.ejs.t" -type f 2>/dev/null | \
  xargs -I{} dirname {} | sort -u
```

### Phase 2: Extract Metadata

For each template directory:
- Read prompt.js for variables
- Read _origin.json for metadata
- Infer origin from path

### Phase 3: Write Index

```json
{
  "version": "1.0.0",
  "lastUpdated": "2025-01-02T15:00:00Z",
  "templates": {
    "component/new": {
      "origin": "created",
      "description": "Basic React component",
      "tags": ["react", "typescript"],
      "variables": ["name", "withTest"]
    }
  }
}
```

### Output

```
## Index Refreshed

Scanned: ~/.hygen-templates/, _templates/
Found: 24 templates

By origin:
├── Created: 8
├── Ripped: 5
├── Downloaded: 11

New since last refresh: 2
Removed: 0

Index saved to .hygen-index.json
```

---

## Writes

- `.hygen-index.json` (only on refresh)

**Read-only** for list, search, info.
