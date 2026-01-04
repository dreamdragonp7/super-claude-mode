---
description: Add new pattern interactively (feature, component, boundary, anti-pattern)
argument-hint: [type]
---

# Planning: Add Pattern

Interactive wizard to add new patterns to patterns.yaml.

---

## Valid Types

- `feature` - Add a new feature type
- `component` - Add a new component pattern
- `boundary` - Add a new import boundary rule
- `anti-pattern` - Add a new anti-pattern to detect

If no type provided, ask via AskUserQuestion:
"What type of pattern do you want to add?"
Options: feature, component, boundary, anti-pattern

---

## Flow for `feature`

**Step 1**: Ask feature name via AskUserQuestion:
"What's this feature type called? (e.g., 'ml-pipeline', 'background-job')"

**Step 2**: Ask required files via checkboxes:
"What files does a [name] feature need?"
Options:
- Database model (core/models/)
- API route (apps/api/routers/)
- API schema (apps/api/schemas/)
- Service layer (core/services/)
- React component (apps/web/src/features/)
- React hook (apps/web/src/hooks/)
- Background job (apps/worker/)

**Step 3**: Ask test requirements:
"What tests are required?"
Options:
- Unit test for each file
- Integration test
- E2E test
- API contract test

**Step 4**: Update patterns.yaml:
- Read current patterns.yaml
- Add new feature type to `feature_types` section
- Write back to patterns.yaml
- Confirm: "Added '[name]' feature type to patterns.yaml"

---

## Flow for `component`

**Step 1**: Ask component type:
"What type of component?"
Options: React component, React hook, API router, Python service

**Step 2**: Ask required files:
"What files should every [type] have?"
Options vary by type (checkboxes)

**Step 3**: Update patterns.yaml with new component pattern

---

## Flow for `boundary`

**Step 1**: Ask module to protect:
"What module should be protected?" (text input)

**Step 2**: Ask forbidden imports:
"What should it NOT be allowed to import?" (multi-select or text)

**Step 3**: Ask reason:
"Why this boundary?" (text input)

**Step 4**: Ask severity:
Options: error, warning, info

**Step 5**: Update patterns.yaml with new boundary rule

---

## Flow for `anti-pattern`

**Step 1**: Ask pattern:
"What pattern should be flagged?" (text or regex)

**Step 2**: Ask file types:
"Which file types?" (checkboxes: .ts, .tsx, .py, etc.)

**Step 3**: Ask message:
"What should developers do instead?" (text)

**Step 4**: Ask severity:
Options: error, warning, info

**Step 5**: Update patterns.yaml with new anti-pattern

---

## Related Commands

- `/planning-view` - View current patterns summary
- `/planning-sync` - Auto-discover patterns from codebase
- `/planning-validate` - Check patterns.yaml validity
