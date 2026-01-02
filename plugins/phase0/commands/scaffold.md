---
description: Invoke deterministic scaffolding generators (Hygen) for common patterns
argument-hint: [generator:template] [name]
---

# Scaffold: Deterministic Code Generation

Generate boilerplate with 0 LLM tokens using Hygen templates.

## Philosophy

**Don't pay Claude to generate predictable structure.**

- File scaffolding is deterministic
- Claude's value is in logic, wiring, edge cases
- Templates ensure consistency
- Save tokens for smart work

---

## Usage

```
/scaffold feature:new my-feature
/scaffold api:endpoint users
/scaffold component:new Button
/scaffold task-capsule:new add-auth-feature
```

---

## Available Generators

### feature:new
Creates a full feature scaffold:
- Component file
- Hook file
- Test file
- Index export

```bash
npx hygen feature new --name [name]
```

### api:endpoint
Creates API endpoint scaffold:
- Route file
- Schema file
- Test file

```bash
npx hygen api endpoint --name [name]
```

### component:new
Creates React component:
- Component file
- Styles (if applicable)
- Test file

```bash
npx hygen component new --name [name]
```

### task-capsule:new
Creates task capsule from template:
- docs/taskcaps/YYYY-MM-DD-[name].md

```bash
npx hygen task-capsule new --name [name]
```

---

## Template Location

Templates live in `_templates/` at project root:

```
_templates/
├── feature/
│   └── new/
│       ├── prompt.js
│       ├── component.tsx.t
│       ├── hook.ts.t
│       └── test.tsx.t
├── api/
│   └── endpoint/
│       ├── prompt.js
│       ├── route.py.t
│       └── test.py.t
├── component/
│   └── new/
│       └── ...
└── task-capsule/
    └── new/
        └── capsule.md.t
```

---

## Creating New Templates

1. Create directory: `_templates/[generator]/[action]/`
2. Add prompt.js for interactive prompts
3. Add .t files for generated content
4. Use EJS syntax: `<%= name %>`, `<%= h.changeCase.pascal(name) %>`

Example template (`component.tsx.t`):
```ejs
---
to: src/components/<%= name %>/<%= name %>.tsx
---
import React from 'react';

interface <%= h.changeCase.pascal(name) %>Props {
  // TODO: Define props
}

export function <%= h.changeCase.pascal(name) %>({ }: <%= h.changeCase.pascal(name) %>Props) {
  return (
    <div>
      {/* TODO: Implement <%= name %> */}
    </div>
  );
}
```

---

## When to Use

- Creating new features (use template, then Claude fills logic)
- Adding API endpoints (consistent structure)
- New components (follows project patterns)
- Task capsules (consistent format)

---

## Integration with Phase 0

After /phase0 creates a task capsule:
1. User approves plan
2. Run `/scaffold` for needed structure
3. Run `/dev-flow` to implement logic

This separates:
- **Scaffolding** (free, deterministic)
- **Implementation** (Claude's value-add)
