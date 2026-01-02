---
description: Targeted context mapping for a specific topic or area of the codebase
argument-hint: [topic]
---

# Focus: Targeted Context Mapping

Map relevant code for a specific topic without creating a full task capsule.

## Topic
$ARGUMENTS

---

## Actions

### 1. Keyword Search

Launch **file-scanner** agent (Haiku):
- "Search for '$ARGUMENTS' and related terms across the codebase"

### 2. Dependency Mapping

Launch **import-tracer** agent (Haiku):
- "Trace imports for files matching '$ARGUMENTS'"

### 3. Test Coverage

Launch **test-finder** agent (Haiku):
- "Find tests covering '$ARGUMENTS' functionality"

### 4. Documentation Check

Search for:
- Mentions in CLAUDE.md
- ADRs in docs/decisions/
- READMEs in relevant directories
- Inline documentation

---

## Output Format

Present findings as:

```
## Focus: [Topic]

### Primary Files
- path/to/file1.py (main implementation)
- path/to/file2.tsx (UI component)

### Secondary Files
- path/to/utils.py (shared utilities)
- path/to/types.ts (type definitions)

### Test Coverage
- tests/unit/test_topic.py
- tests/integration/test_topic_flow.py

### Patterns to Follow
- [Existing pattern 1]
- [Existing pattern 2]

### Gotchas
- [Known issue 1]
- [Constraint to be aware of]

### Documentation
- CLAUDE.md mentions [X]
- ADR-001 covers [Y]
```

---

## When to Use

- Quick exploration before detailed work
- Understanding a specific area
- Finding examples to reference
- Checking test coverage for an area
