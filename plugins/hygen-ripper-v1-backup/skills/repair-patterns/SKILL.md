---
name: repair-patterns
description: Knowledge about code repair using templates, gap detection, and anti-unification. Use when analyzing codebases for pattern compliance.
---

# Repair Patterns

How to detect gaps between ideal patterns and reality, then repair using templates.

## The Two-File System

| File | Purpose | Source of Truth For |
|------|---------|---------------------|
| patterns.yaml | THE IDEAL | How code SHOULD look |
| ARCHITECTURE.md | THE REALITY | What actually exists |

**The gap between them = work to do**

## Gap Types

### 1. Missing Components
Pattern defined but component doesn't exist.
```yaml
# patterns.yaml
components:
  Button:
    files: [Button.tsx, Button.test.tsx, index.ts]
```
Reality: Button/ directory doesn't exist.

### 2. Structure Violations
Component exists but doesn't match pattern.
```
Expected: Button.tsx, Button.test.tsx, index.ts
Actual: Button.tsx (missing test and index)
```

### 3. Boundary Violations
Imports cross forbidden layer boundaries.
```yaml
# patterns.yaml
boundaries:
  core:
    cannot_import: [apps, infrastructure]
```
Reality: `core/service.py` imports from `apps/api/`.

### 4. Undocumented Code
Code exists but no pattern covers it.
```
File: src/utils/legacy-helper.ts
Matches: No pattern in patterns.yaml
```

## Anti-Unification

Algorithm for finding what varies between similar code:

```
Instance 1: function Button({ label }) { return <button>{label}</button> }
Instance 2: function Icon({ name }) { return <i className={name}/> }

Anti-unification result:
function <%= Name %>({ <%= prop %> }) { return <<%= tag %> ...><%= content %></<%= tag %>> }

Variables identified:
- Name: component name
- prop: main prop name
- tag: HTML element
- content: inner content
```

## Template Matching

For each gap, find best matching template:

| Gap Type | Template Match Strategy |
|----------|------------------------|
| Missing component | component/new or similar ripped |
| Missing test | test/component |
| Missing API route | api/full-endpoint |
| Missing index | (generate inline, 3 lines) |

## Repair Priorities

| Severity | Gap Type | Action |
|----------|----------|--------|
| Critical | Boundary violations | Must fix - breaks architecture |
| High | Missing components | Generate from template |
| Medium | Structure violations | Add missing files |
| Low | Undocumented code | Add to patterns.yaml or delete |

## Repair Workflow

```
1. DETECT
   Read patterns.yaml + ARCHITECTURE.md
   Compute diff → gap list

2. SCAN
   5 Haiku agents in parallel
   Deep code review for hidden issues

3. MATCH
   For each gap, find template
   Present repair plan to user

4. EXECUTE
   Run hygen or direct write
   Update barrel exports
   Wire up registrations

5. VERIFY
   Re-run detection
   Confirm gaps resolved
```

## Template Fitting

When template doesn't perfectly match:

1. **Customize variables** - Add project-specific defaults
2. **Adjust paths** - Match project structure
3. **Add wiring** - Include in index, register routes
4. **Skip optional** - Don't generate unused files

## Index Structure

```json
{
  "templates": {
    "component/new": {
      "repairs": ["missing-component", "structure-violation"],
      "generates": ["*.tsx", "*.test.tsx", "index.ts"]
    }
  }
}
```
