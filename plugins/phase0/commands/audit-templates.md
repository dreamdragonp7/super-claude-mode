---
description: Show available Hygen templates for generating files
---

# Audit Templates: Available Generators

Show what Hygen templates are available for generating boilerplate files.

---

## Step 1: Check for Hygen

```bash
which hygen || echo "Hygen not installed. Run: npm install -g hygen"
```

---

## Step 2: List Available Templates

```bash
if [ -d "_templates" ]; then
  echo "Templates found:"
  ls -la _templates/
else
  echo "No _templates directory found"
fi
```

---

## Step 3: Show Template Details

For each template directory, show:
- What it generates
- Required arguments
- Example usage

```
AVAILABLE TEMPLATES
---

component/
  test/     - Generate component test file
             Usage: npx hygen component test --name ComponentName
             Creates: ComponentName.test.tsx

  index/    - Generate component barrel export
             Usage: npx hygen component index --name ComponentName
             Creates: ComponentName/index.ts

api/
  endpoint/ - Generate API route + schema
             Usage: npx hygen api endpoint --name routename
             Creates: routers/routename.py, schemas/routename.py

  schema/   - Generate Pydantic schema only
             Usage: npx hygen api schema --name schemaname
             Creates: schemas/schemaname.py

feature/
  new/      - Generate full feature scaffold
             Usage: npx hygen feature new --name featurename
             Creates: component, hook, route, schema, tests

task-capsule/
  new/      - Generate task capsule template
             Usage: npx hygen task-capsule new --name task-slug
             Creates: docs/taskcaps/YYYY-MM-DD-task-slug.md
```

---

## Step 4: Show patterns.yaml Mappings

If patterns.yaml exists, show how feature types map to templates:

```
PATTERNS.YAML -> HYGEN MAPPINGS
---

Feature Type: full-stack
  Hygen command: npx hygen feature new --name [name]
  Generates:
    - apps/web/src/components/[Name]/
    - apps/web/src/hooks/use[Name].ts
    - apps/api/routers/[name].py
    - apps/api/schemas/[name].py
    - tests/unit/test_[name].py

Feature Type: api-only
  Hygen command: npx hygen api endpoint --name [name]
  Generates:
    - apps/api/routers/[name].py
    - apps/api/schemas/[name].py
    - tests/api/test_[name]_api.py

Component Type: react_component
  Hygen command: npx hygen component test --name [Name]
  Generates:
    - [Name].test.tsx
```

---

## Step 5: Missing Template Check

Compare patterns.yaml feature types to available templates:

```
TEMPLATE COVERAGE
---

Feature types with templates: 3/4
- full-stack: component, api/endpoint
- api-only: api/endpoint
- frontend-only: component
- ml-pipeline: NO TEMPLATE

Missing templates:
- feature/ml-pipeline (for ml-pipeline feature type)

Create with:
  npx hygen generator new --name ml-pipeline
  # Then add templates to _templates/ml-pipeline/
```

---

## Step 6: How to Create New Templates

```
CREATING NEW TEMPLATES
---

1. Generate template scaffold:
   npx hygen generator new --name mytemplate

2. Edit generated files in _templates/mytemplate/

3. Template file structure:
   _templates/
     mytemplate/
       new/
         prompt.js     # Interactive prompts
         index.ts.t    # Template for index.ts
         component.tsx.t  # Template for component

4. Template syntax (EJS):
   ---
   to: apps/web/src/components/<%= name %>/<%= name %>.tsx
   ---
   export function <%= name %>() {
     return <div><%= name %></div>
   }

5. Update patterns.yaml hygen_mappings section
```

---

## Output Summary

```
AUDIT TEMPLATES
---

Templates directory: _templates/
Total generators: 4
Total actions: 8

GENERATORS:
- component (test, index)
- api (endpoint, schema)
- feature (new)
- task-capsule (new)

COVERAGE:
- Feature types covered: 3/4
- Missing templates: 1

Use /audit-fix to generate missing files with these templates.
---
```

---

## Related Commands

- `/audit-run` - Full compliance check with visualizations
- `/audit-fix` - Auto-generate missing files using Hygen
- `/audit-inventory` - Detailed inventory of what exists vs expected
