---
description: List, search, and manage your Hygen template library
argument-hint: [list|search|info] [query]
---

# /templates - Manage Your Template Library

View and manage all Hygen templates in `~/.hygen-templates/`.

## Usage

- `/templates` or `/templates list` - List all templates grouped by origin
- `/templates search [query]` - Search templates by name or tags
- `/templates info [name]` - Show detailed info about a template
- `/templates refresh` - Rebuild the index from disk

---

## /templates list

### Step 1: Read Index

```
Read ~/.hygen-templates/.hygen-index.json
```

If missing, run indexer agent to build it.

### Step 2: Display by Origin

```
## 📚 Template Library

### 🔧 Created (from your code)
| Template | Description | Tags |
|----------|-------------|------|
| component/new | Basic React component | react, typescript |
| api/router | FastAPI router | python, fastapi |

### 🌐 Ripped (from websites)
| Template | Source | Date | Tags |
|----------|--------|------|------|
| component/ripped/stripe-btn | stripe.com | 2025-01-02 | button, tailwind |

### 📦 Downloaded (from marketplaces)
| Template | Source | Tags |
|----------|--------|------|
| test/e2e | hygen-community | playwright, testing |

### ✏️ Modified (customized)
| Template | Original | Tags |
|----------|----------|------|
| component/card-v2 | component/card | card, variant |

Total: X templates
```

---

## /templates search [query]

Launch **indexer** agent (Haiku):

Prompt: "Search templates for '[query]'.
Check: template names, descriptions, tags, source URLs.
Return matches ranked by relevance."

Output:
```
## Search: "[query]"

Found 3 matches:

1. component/ripped/pricing-card (95% match)
   Tags: card, pricing, tailwind
   Source: stripe.com

2. component/card (70% match)
   Tags: card, basic
   Origin: created

3. test/component (40% match)
   Tags: testing, card
   Origin: downloaded
```

---

## /templates info [name]

Read template files and display:

```
## Template: component/ripped/stripe-btn

**Origin:** ripped
**Source:** https://stripe.com/pricing
**Ripped:** 2025-01-02
**Tags:** button, payment, tailwind

### Files
- prompt.js (3 prompts: name, variant, size)
- component.ejs.t (47 lines)
- index.ejs.t (3 lines)

### Variables
| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | input | - | Component name (PascalCase) |
| variant | select | primary | primary, secondary, outline |
| size | select | md | sm, md, lg |

### Preview
\`\`\`tsx
export function <%= Name %>({ variant = '<%= variant %>', size = '<%= size %>' }) {
  return <button className={styles[variant][size]}>...</button>
}
\`\`\`

### Usage
\`\`\`bash
hygen component ripped stripe-btn
\`\`\`
```

---

## /templates refresh

Launch **indexer** agent (Haiku):

Prompt: "Scan ~/.hygen-templates/ directory recursively.
For each template (directory with .ejs.t files):
- Extract name from path
- Read prompt.js for variables
- Detect origin from _origin.json or guess from path
- Extract tags from content

Rebuild .hygen-index.json with fresh data."

Output:
```
## Index Refreshed

Scanned: ~/.hygen-templates/
Found: X templates
New: Y templates added
Removed: Z templates (deleted from disk)

Index saved to .hygen-index.json
```
