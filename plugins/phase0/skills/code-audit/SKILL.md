---
name: code-audit
description: Knowledge about the code audit and conformance system. Use when explaining patterns.yaml, /audit, /conform, or boundary enforcement.
---

# Code Audit & Conformance System

## What This System Does

The code audit system helps maintain codebase quality by:
1. **Defining patterns** in `patterns.yaml` (single source of truth)
2. **Auditing compliance** with `/audit` command
3. **Auto-fixing gaps** with `/conform` command
4. **Listing inventory** with `/inventory` command

## The Philosophy

"Don't pay Claude to discover what a grep can find."

- Cheap Haiku agents scan for violations ($0.02)
- Expensive Opus only used for intelligent fixes
- Hygen templates generate boilerplate for FREE
- patterns.yaml defines the rules once, tools enforce everywhere

## patterns.yaml Structure

```yaml
# Single source of truth for codebase patterns

python_layers:        # Import boundary rules for Python
typescript_boundaries: # Module boundaries for TypeScript
component_patterns:   # What files should exist for each component type
naming_conventions:   # How things should be named
source_of_truth:      # Critical files that define contracts
anti_patterns:        # Patterns to detect and flag
```

## Commands

| Command | Purpose | Cost |
|---------|---------|------|
| `/audit [path]` | Check compliance against patterns | ~$0.02 |
| `/inventory [path]` | List everything that exists | ~$0.02 |
| `/conform [path]` | Auto-fix using Hygen templates | ~$0.00 (FREE!) |

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| pattern-checker | Haiku | Find component structure gaps |
| boundary-validator | Haiku | Check import boundaries |
| conformance-fixer | Opus | Plan and execute fixes |

## Integration with CI/CD

The patterns in patterns.yaml can be enforced automatically:

**Python (import-linter):**
```bash
pip install import-linter
lint-imports --config patterns.yaml
```

**TypeScript (eslint-plugin-boundaries):**
```bash
npm install -D eslint-plugin-boundaries
# Configure in eslint.config.js
```

## Industry Tools We Integrate With

| Tool | Language | Purpose |
|------|----------|---------|
| import-linter | Python | Enforce layer boundaries |
| eslint-plugin-boundaries | TypeScript | Enforce module boundaries |
| Hygen | Any | Generate missing files (FREE) |
| Ruff | Python | Format and lint generated code |
| ESLint | TypeScript | Lint generated code |

## Workflow

```
1. Create patterns.yaml (or copy template)
   ↓
2. Run /audit to see gaps
   ↓
3. Run /conform to auto-fix what's possible
   ↓
4. Manually fix remaining issues
   ↓
5. Add patterns.yaml enforcement to CI/CD
```

## Best Practices

1. **Start small**: Define 3-5 critical patterns first
2. **Automate early**: Add to pre-commit/CI as soon as patterns exist
3. **Review quarterly**: Remove obsolete rules, add new patterns
4. **Document why**: Each pattern should have a reason

## Integration with Phase 0

When running `/phase0`:
- Audit results are included in task capsule
- Technical debt is visible before starting new work
- Developers know what gaps exist in the affected area
