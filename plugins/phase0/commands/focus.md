---
description: Quick context exploration for a specific topic - no capsule, no boilerplate, just understanding
argument-hint: [topic]
---

# Focus: Quick Context Lookup

/focus is for when you need to understand something quickly without committing to a full task. No capsule created, no boilerplate generated, just exploration.

**Use this when:**
- "How does X work in this codebase?"
- "Where is Y implemented?"
- "What would I need to touch to change Z?"
- Quick research before deciding on approach

---

## Input

Topic to focus on: $ARGUMENTS

---

## Step 1: Keyword Search (Haiku)

Launch **file-scanner** agent (Haiku):

Prompt: "Search for files related to '[topic]' across the codebase. Categorize as:
- Primary (core implementation)
- Secondary (related/helper files)
- Config (configuration files)
- Tests (test files)"

---

## Step 2: Dependency Mapping (Haiku)

Launch **import-tracer** agent (Haiku):

Prompt: "Trace dependencies for code related to '[topic]'.
- What does this code depend on?
- What depends on this code?
- Any circular dependencies?"

---

## Step 3: Test Coverage (Haiku)

Launch **test-finder** agent (Haiku):

Prompt: "Find tests that cover '[topic]'.
- Direct tests
- Integration tests that touch this area
- Coverage gaps"

---

## Step 4: Check patterns.yaml

If patterns.yaml exists, check for:
- Is this a defined feature type?
- What patterns apply to this area?
- Any anti-patterns to watch for?

```
Checking patterns.yaml for '[topic]'...

Patterns applicable:
├── Component type: [if applicable]
├── Required files: [list]
├── Boundary rules: [applicable rules]
└── Anti-patterns: [to avoid]
```

---

## Step 5: Documentation Check

Search for documentation:
- Mentions in CLAUDE.md
- ADRs in docs/decisions/
- READMEs in relevant directories
- Inline documentation
- Comments in patterns.yaml

---

## Output Format

```
🔍 Focus: [topic]
───────────────────────────────────────

PRIMARY FILES (core implementation)
├── path/to/file1.py (main implementation)
├── path/to/file2.tsx (UI component)
└── path/to/file3.ts (hook)

SECONDARY FILES (related)
├── path/to/helper.py
├── path/to/utils.ts
└── path/to/types.ts

DEPENDENCIES
├── Imports: module_a, module_b, external_lib
├── Imported by: consumer1.py:5, consumer2.tsx:12
└── Chain depth: 3 levels

TEST COVERAGE
├── tests/unit/test_topic.py (15 tests)
├── tests/api/test_topic_api.py (8 tests)
└── Coverage estimate: ~75%

PATTERNS (from patterns.yaml)
├── Type: [feature-type if applicable]
├── Required: [files per pattern]
├── Status: [compliant/gaps]
└── Anti-patterns: [none found / list]

DOCUMENTATION
├── CLAUDE.md: [section if exists]
├── ADR: [relevant ADRs]
└── README: [local READMEs]

GOTCHAS
├── [Key implementation detail 1]
├── [Key implementation detail 2]
└── [Potential pitfall]

NEXT STEPS (suggested)
├── Read [critical file] first
├── Understand [pattern] before modifying
└── Run /phase0 if making changes
───────────────────────────────────────
```

---

## When to Use /focus vs /phase0

| Scenario | Use |
|----------|-----|
| "How does auth work?" | /focus |
| "Add OAuth support" | /phase0 |
| "Where's the error handling?" | /focus |
| "Fix the auth bug" | /phase0 → /bug-hunt |
| "What tests cover payments?" | /focus |
| "Add payment feature" | /phase0 → /dev-flow |

**Rule of thumb:**
- /focus = Understanding (no side effects)
- /phase0 = Action (creates capsule, may generate files)

---

## Agent Reference

| Agent | Model | Purpose | Cost |
|-------|-------|---------|------|
| file-scanner | Haiku | CHEAP file finding | ~$0.005 |
| import-tracer | Haiku | CHEAP dependency tracing | ~$0.005 |
| test-finder | Haiku | CHEAP test discovery | ~$0.005 |

**Total /focus cost: ~$0.015**

---

## No Persistence

Unlike /phase0, /focus does NOT:
- Create a task capsule
- Generate any files
- Update patterns.yaml
- Modify ARCHITECTURE.md

It's pure exploration with no side effects.
