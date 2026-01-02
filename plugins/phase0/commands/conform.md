---
description: Auto-fix pattern violations using Hygen templates - generates missing files
argument-hint: [path] [--dry-run]
---

# Conform: Auto-Fix Pattern Violations

You are helping a developer fix codebase pattern violations automatically. This command generates missing files using Hygen templates.

## Why Conform Exists

- Manual file creation is tedious and error-prone
- Templates ensure consistency across the codebase
- Hygen scaffolding uses 0 LLM tokens (FREE!)
- Fix many issues in one command

---

## Input

Path to conform: $ARGUMENTS
- `--dry-run` flag shows what would be generated without creating files

---

## Step 1: Run Audit First

Internally run `/audit [path]` to get the list of violations.

Categorize violations into:
- **Auto-fixable**: Missing test files, missing index.ts, missing schemas
- **Manual-fix required**: Import violations, architecture issues, anti-patterns

---

## Step 2: Check Hygen Templates

Verify Hygen templates exist for auto-fixable issues:

```bash
ls _templates/
```

Expected templates:
- `feature/new/` - Component + hook + test + index
- `api/endpoint/` - Router + schema + test
- `component/new/` - Just component files
- `task-capsule/new/` - Task capsule

If templates missing, inform user:
"Hygen templates not found. Run `/scaffold` to set up templates first."

---

## Step 3: Plan Fixes

Present the fix plan to user:

```
┌─────────────────────────────────────────────────────────────┐
│ CONFORM PLAN: [path]                                        │
│ Mode: [dry-run | apply]                                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ WILL GENERATE (via Hygen):                                  │
│ ─────────────────────────                                   │
│ + apps/web/src/components/Button/Button.test.tsx            │
│ + apps/web/src/components/Modal/Modal.test.tsx              │
│ + apps/web/src/components/Card/index.ts                     │
│ + apps/web/src/components/Toast/index.ts                    │
│ + apps/api/schemas/monitoring.py                            │
│ + apps/api/schemas/streaming.py                             │
│ + tests/api/test_story.py                                   │
│                                                             │
│ Files to generate: [N]                                      │
│ Estimated time: < 5 seconds                                 │
│ LLM cost: $0.00 (Hygen is free!)                            │
│                                                             │
│ CANNOT AUTO-FIX (manual action required):                   │
│ ─────────────────────────────────────────                   │
│ ! lantern.trm imports infrastructure.database               │
│   → Refactor to use dependency injection                    │
│ ! apps/web imports apps/api directly                        │
│   → Use API client instead of direct imports                │
│ ! 3 files have `any` type                                   │
│   → Add proper TypeScript types                             │
│                                                             │
│ Manual fixes needed: [N]                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 4: Await User Confirmation

If NOT dry-run:
- Ask: "Generate [N] files? (y/n)"
- Wait for user approval before proceeding

If dry-run:
- Show plan and stop
- Tell user: "Run without `--dry-run` to apply changes"

---

## Step 5: Execute Hygen Commands

For each missing file, run appropriate Hygen generator:

**Missing test file:**
```bash
cd [project-root]
npx hygen component test --name [ComponentName]
```

**Missing index.ts:**
```bash
npx hygen component index --name [ComponentName]
```

**Missing API schema:**
```bash
npx hygen api schema --name [endpoint-name]
```

**Missing API test:**
```bash
npx hygen api test --name [endpoint-name]
```

Report each generated file as it's created.

---

## Step 6: Post-Generation Validation

After all files generated:

1. Run linters to check generated code:
   ```bash
   ruff check [generated-python-files]
   eslint [generated-ts-files]
   ```

2. If lint errors, attempt auto-fix:
   ```bash
   ruff check --fix [files]
   eslint --fix [files]
   ```

3. Report final status.

---

## Step 7: Summary Report

```
┌─────────────────────────────────────────────────────────────┐
│ CONFORM COMPLETE                                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ GENERATED:                                                  │
│ ✓ Button.test.tsx                                           │
│ ✓ Modal.test.tsx                                            │
│ ✓ Card/index.ts                                             │
│ ✓ monitoring.py (schema)                                    │
│ ✓ test_story.py                                             │
│                                                             │
│ LINT STATUS:                                                │
│ ✓ All generated files pass linting                          │
│                                                             │
│ REMAINING MANUAL FIXES:                                     │
│ • Fix import in lantern/trm/model.py:45                     │
│ • Add types in apps/web/src/lib/api.ts:23                   │
│                                                             │
│ Next steps:                                                 │
│ 1. Review generated files                                   │
│ 2. Fill in test implementations (TODOs marked)              │
│ 3. Fix manual issues listed above                           │
│ 4. Run `/audit` again to verify compliance                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Agent Reference

This command primarily uses Bash/Hygen, not agents. Agents are only used if `/audit` needs to run first.

| Tool | Purpose |
|------|---------|
| Hygen | FREE scaffolding (0 LLM tokens) |
| Ruff | Python linting |
| ESLint | TypeScript linting |

---

## Cost Optimization

This command is essentially FREE because:
- Hygen templates are deterministic (no LLM)
- Linting is local tooling
- Only audit step uses Haiku (~$0.02)

---

## Creating New Hygen Templates

If you need a new template type:

1. Create template directory:
   ```bash
   mkdir -p _templates/[generator]/[action]
   ```

2. Add prompt.js for interactive input:
   ```javascript
   module.exports = {
     prompt: ({ inquirer }) => {
       return inquirer.prompt([
         { type: 'input', name: 'name', message: 'Name:' }
       ])
     }
   }
   ```

3. Add template files with `.t` extension:
   ```
   ---
   to: path/to/<%= name %>.tsx
   ---
   // Template content with <%= name %> interpolation
   ```

4. Run `/scaffold` to use the new template.
