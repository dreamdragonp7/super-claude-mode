---
description: Compare existing code against templates to find improvement opportunities
argument-hint: <path> [template]
---

# /hygen-compare - Template-Driven Code Review

**Purpose**: Compare existing code against your best templates. Find where code could be improved to match template patterns.

**Philosophy**: Templates are THE IDEAL. Existing code is THE REALITY. Show the gap.

**Key**: This is READ-ONLY. Shows suggestions but makes NO changes.

---

## Input

- `<path>` - Path to file or directory to compare
- `[template]` - Optional specific template to compare against (auto-detects if omitted)

---

## Phase 1: Identify Target

```bash
TARGET="$1"

if [ -d "$TARGET" ]; then
  echo "Comparing directory: $TARGET"
  TYPE="directory"
elif [ -f "$TARGET" ]; then
  echo "Comparing file: $TARGET"
  TYPE="file"
else
  echo "ERROR: Path not found: $TARGET"
  exit 1
fi
```

---

## Phase 2: Detect Component Type

If template not specified, auto-detect:

```
Path: src/components/Button/Button.tsx

Detection:
├── Location matches: apps/web/src/components/**
├── Extension: .tsx
├── Has default export: yes
├── Returns JSX: yes
└── Detected: react_component
```

Find best matching template:
1. Check _templates/ for local templates
2. Check ~/.hygen-templates/ for global
3. Match based on component type

---

## Phase 3: Read Both Sides

### Existing Code
```typescript
// src/components/Button/Button.tsx
export function Button({ label }) {
  return <button>{label}</button>
}
```

### Template Pattern
```typescript
// From component/new/component.ejs.t
export function <%= Name %>({
  <%= props %>
}: <%= Name %>Props) {
  // ... proper typing, error handling, etc.
}
```

---

## Phase 4: Launch Analysis (Scanner + Architect Agents)

**Scanner Agent (Haiku×3)** - Parallel analysis:
1. **Structure scan**: File organization, exports, imports
2. **Pattern scan**: Code patterns vs template patterns
3. **Quality scan**: Types, error handling, tests

**Architect Agent (Opus)** - Synthesize findings:
- What's different between code and template
- Which differences are improvements vs gaps
- Priority ranking of suggestions

---

## Phase 5: Generate Comparison Report

```
## Code Review: src/components/Button/

Compared against: component/new (react_component pattern)

═══════════════════════════════════════════════════════════════

### STRUCTURE COMPARISON

| Aspect | Your Code | Template | Status |
|--------|-----------|----------|--------|
| TypeScript types | Missing | Props interface | GAP |
| Error boundary | No | Optional | OK |
| Default export | Yes | Yes | MATCH |
| Test file | Missing | Required | GAP |
| Index barrel | Missing | Required | GAP |

### PATTERN COMPARISON

Template enforces:
✗ Props interface (Button doesn't have ButtonProps)
✗ Explicit return type
✓ Functional component
✗ JSDoc documentation
✗ Error handling wrapper

### CODE DIFF (conceptual)

Your code:
```tsx
export function Button({ label }) {
  return <button>{label}</button>
}
```

Template suggests:
```tsx
interface ButtonProps {
  label: string;
  variant?: 'primary' | 'secondary';
  onClick?: () => void;
}

/**
 * Button component
 * @example <Button label="Click me" />
 */
export function Button({
  label,
  variant = 'primary',
  onClick,
}: ButtonProps): JSX.Element {
  return (
    <button
      className={styles[variant]}
      onClick={onClick}
    >
      {label}
    </button>
  );
}
```

### SUGGESTIONS (prioritized)

| Priority | Suggestion | Effort |
|----------|------------|--------|
| HIGH | Add ButtonProps interface | 5 min |
| HIGH | Create Button.test.tsx | 10 min |
| MEDIUM | Add index.ts barrel | 1 min |
| LOW | Add JSDoc comments | 3 min |

═══════════════════════════════════════════════════════════════

SUMMARY
├── Compliance: 40%
├── High-priority gaps: 2
├── Estimated fix time: ~20 min
└── Template used: component/new

TO FIX
├── Manual: Apply suggestions above
├── Auto: /hygen-rip --from-gaps (if gaps.json exists)
└── Regenerate: hygen component new --name Button --force

═══════════════════════════════════════════════════════════════
```

---

## Phase 6: Optional Deep Dive

If user wants more detail:

```
Want to see more?

[Show full template]
[Show line-by-line diff]
[Compare another file]
[Done]
```

---

## Writes

**NOTHING** - This command is purely read-only and advisory.

---

## Cross-Plugin Integration

Can read:
- `/.phase0/reports/gaps.json` - to show which gaps are already known
- `patterns.yaml` - to understand project conventions
- `/.phase0/capsules/*/capsule.yaml` - for context

---

## Cost

| Phase | Model | Cost |
|-------|-------|------|
| Scanner×3 | Haiku | ~$0.015 |
| Architect | Opus | ~$0.03 |
| **Total** | | **~$0.05** |
