---
description: Check patterns.yaml is valid, templates exist
---

# Planning: Validate

Check that patterns.yaml is valid and complete.

---

## Checks Performed

### 1. YAML Syntax
Parse patterns.yaml, report any syntax errors

### 2. Path References
Check that referenced paths exist:
- Feature type file patterns
- Component pattern locations
- Source of truth files

### 3. Rule Conflicts
Check for contradictory rules:
- Circular boundary dependencies
- Overlapping component patterns

### 4. Hygen Templates
Check that required templates exist:
- For each feature type's hygen_template
- For each hygen_mappings entry

### 5. Completeness
Check for missing sections:
- Are all recommended sections present?

---

## Output Format

```
Validating patterns.yaml...

✅ Valid YAML syntax
✅ All 4 feature types have valid structure
✅ All 3 component patterns are consistent
✅ Boundary rules have no conflicts

⚠️ Missing Hygen templates:
   - feature/ml-pipeline (no template found)
   - component/with-store (no template found)

   Create with: npx hygen generator new --name [template]
   Or run: /audit templates to see available templates

⚠️ 2 paths in patterns don't exist yet:
   - apps/worker/ (referenced by background-job feature)
   - core/ml/ (referenced by ml-pipeline feature)

   These may be intentional (future structure)

✅ patterns.yaml is valid
```

---

## Exit Codes

- **Valid**: All checks pass
- **Warnings**: Some optional checks failed (templates missing, paths don't exist yet)
- **Errors**: YAML syntax invalid, rule conflicts found

---

## Related Commands

- `/planning-view` - View current patterns summary
- `/planning-add` - Add patterns interactively
- `/planning-sync` - Auto-discover patterns from codebase
