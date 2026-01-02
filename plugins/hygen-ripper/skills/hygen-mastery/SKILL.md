---
name: hygen-mastery
description: Complete reference for Hygen template syntax, EJS, prompt.js, and staging workflow.
---

# Hygen Mastery

## The Staging Workflow

```
/hygen-rip → /.ripper/staging/<id>/
     │
     ▼
(validate, preview)
     │
     ▼
/hygen-promote → _templates/ or ~/.hygen-templates/
```

**Why staging?**
- Atomic writes (all or nothing)
- Preview before commit
- Rollback if errors
- No corruption mid-rip

## Template Structure

```
~/.hygen-templates/
└── generator/
    └── action/
        ├── prompt.js       # Interactive prompts
        └── *.ejs.t         # Template files
```

## EJS Syntax

| Syntax | Purpose | Example |
|--------|---------|---------|
| `<%= var %>` | Output escaped | `<%= name %>` |
| `<%- var %>` | Output raw | `<%- htmlContent %>` |
| `<% code %>` | Execute JS | `<% if (x) { %>` |
| `<% code -%>` | Execute, suppress newline | `<% } -%>` |

**CRITICAL**: Use `-%>` to suppress trailing newlines in conditionals!

## Frontmatter

```yaml
---
to: src/<%= name %>.tsx
force: true              # Overwrite existing
unless_exists: true      # Skip if exists
inject: true             # Inject into existing
after: "// EXPORTS"      # Insert after line
before: "// END"         # Insert before line
skip_if: "already"       # Skip if pattern found
sh: npm install          # Run shell after
---
```

## Built-in Helpers

```javascript
// Case transformations
h.changeCase.camel('foo-bar')     // 'fooBar'
h.changeCase.pascal('foo-bar')    // 'FooBar'
h.changeCase.snake('fooBar')      // 'foo_bar'
h.changeCase.param('fooBar')      // 'foo-bar'
h.changeCase.constant('fooBar')   // 'FOO_BAR'

// Inflection
h.inflection.pluralize('item')    // 'items'
h.inflection.singularize('items') // 'item'
```

## prompt.js (Enquirer)

```javascript
module.exports = [
  {
    type: 'input',
    name: 'name',
    message: 'Component name?',
    validate: v => /^[A-Z]/.test(v) || 'Must be PascalCase',
  },
  {
    type: 'select',      // NOT 'list'!
    name: 'variant',
    message: 'Variant?',
    choices: ['primary', 'secondary'],
  },
  {
    type: 'confirm',
    name: 'withTest',
    message: 'Generate test?',
    initial: true,
  },
];
```

**Types**: input, select, confirm, multiselect, password, number

## File Ordering

```
01_component.ejs.t   # Creates file first
02_index.ejs.t       # Then barrel
03_inject.ejs.t      # Then inject
```

## _origin.json (for ripped templates)

```json
{
  "origin": "ripped",
  "sourceUrl": "https://stripe.com",
  "rippedDate": "2025-01-02",
  "framework": "tailwind",
  "componentType": "button"
}
```

## Common Gotchas

1. Use `select` not `list` (Enquirer vs Inquirer)
2. Use `-%>` for conditionals (prevents blank lines)
3. Use `h.changeCase` for transformations
4. Check `locals.var` for optional variables
5. File ordering via numeric prefixes

## Global Templates

```bash
export HYGEN_TMPLS="$HOME/.hygen-templates"
```

Lookup: local `_templates/` → `HYGEN_TMPLS` → default
