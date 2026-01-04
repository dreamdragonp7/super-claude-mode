---
name: hygen-mastery
description: Deep knowledge of Hygen template syntax, EJS, prompt.js, and best practices. Use when creating or debugging Hygen templates.
---

# Hygen Mastery

Complete reference for creating production-quality Hygen templates.

## Template Structure

```
~/.hygen-templates/
└── generator/
    └── action/
        ├── prompt.js       # Interactive prompts (optional)
        ├── index.js        # Advanced prompting (alternative to prompt.js)
        └── *.ejs.t         # Template files
```

## EJS Syntax

| Syntax | Purpose | Example |
|--------|---------|---------|
| `<%= var %>` | Output escaped | `<%= name %>` |
| `<%- var %>` | Output raw | `<%- htmlContent %>` |
| `<% code %>` | Execute JS | `<% if (x) { %>` |
| `<% code -%>` | Execute, suppress newline | `<% } -%>` |

**Critical**: Use `-%>` to suppress trailing newlines in conditionals!

## Frontmatter

```yaml
---
to: src/<%= name %>.tsx        # Output path (required)
force: true                     # Overwrite existing
unless_exists: true             # Skip if exists
inject: true                    # Inject into existing file
after: "// EXPORTS"             # Insert after this line
before: "// END"                # Insert before this line
skip_if: "already exists"       # Skip if pattern found
sh: npm install                 # Run shell command after
---
```

## Built-in Helpers (h object)

### Case Transformations
```javascript
h.changeCase.camel('foo-bar')     // 'fooBar'
h.changeCase.pascal('foo-bar')    // 'FooBar'
h.changeCase.snake('fooBar')      // 'foo_bar'
h.changeCase.param('fooBar')      // 'foo-bar' (kebab)
h.changeCase.constant('fooBar')   // 'FOO_BAR'
```

### Inflection
```javascript
h.inflection.pluralize('item')    // 'items'
h.inflection.singularize('items') // 'item'
h.inflection.camelize('foo_bar')  // 'FooBar'
```

## prompt.js (Enquirer)

```javascript
module.exports = [
  {
    type: 'input',
    name: 'name',
    message: 'Component name?',
    validate: (v) => /^[A-Z]/.test(v) || 'Must be PascalCase',
  },
  {
    type: 'select',      // NOT 'list'!
    name: 'variant',
    message: 'Variant?',
    choices: ['primary', 'secondary', 'outline'],
  },
  {
    type: 'confirm',
    name: 'withTest',
    message: 'Generate test?',
    initial: true,
  },
  {
    type: 'multiselect',
    name: 'features',
    message: 'Features?',
    choices: [
      { name: 'Loading state', value: 'loading' },
      { name: 'Error handling', value: 'error' },
    ],
  },
];
```

**Available types**: input, select, confirm, multiselect, password, number

## Advanced: index.js

```javascript
module.exports = {
  prompt: async ({ prompter, args }) => {
    if (args.name) return { name: args.name };

    const { name } = await prompter.prompt({
      type: 'input',
      name: 'name',
      message: 'Name?',
    });

    return { name };
  },
};
```

## File Ordering

Templates execute alphabetically. Use numeric prefixes:
```
01_component.ejs.t   # Creates file first
02_index.ejs.t       # Then creates barrel
03_inject.ejs.t      # Then injects into existing
```

## Injection Example

```ejs
---
to: src/components/index.ts
inject: true
after: "// COMPONENT EXPORTS"
skip_if: <%= name %>
---
export { <%= name %> } from './<%= name %>';
```

## Conditional Templates

Skip entire file:
```ejs
---
to: "<%= locals.withTest ? `tests/${name}.test.ts` : null %>"
---
```

## Common Gotchas

1. **Use `select` not `list`** - Enquirer uses different names than Inquirer
2. **Use `-%>` for conditionals** - Prevents blank lines
3. **Check `locals.var`** - Safe access for optional variables
4. **Order matters** - Can't inject into file that doesn't exist yet

## HYGEN_TMPLS

Global templates location:
```bash
export HYGEN_TMPLS="$HOME/.hygen-templates"
```

Lookup order: local `_templates/` → `HYGEN_TMPLS` → default
