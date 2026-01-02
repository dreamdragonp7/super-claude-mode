---
description: Pre-flight exploration - restate task, map context, create task capsule before /dev-flow or /bug-hunt
argument-hint: [task-description]
---

# Phase 0: Pre-Flight Exploration

You are helping a developer prepare for feature work or bug fixing. This is the REQUIRED first step before /dev-flow or /bug-hunt.

## Why Phase 0 Exists

- Context doesn't persist across sessions
- Diving into work without mapping leads to mistakes
- Task capsules survive compaction and new sessions
- Cheap scanning (Haiku) saves tokens for smart work (Opus)

---

## Step 1: Task Restatement

Initial request: $ARGUMENTS

**Actions**:
1. Restate the task in your own words
2. Identify what is being requested
3. Identify what success looks like
4. Note any ambiguities or assumptions

---

## Step 2: Targeted Questions

Ask 2-4 clarifying questions about:

- **Scope**: What's in, what's out?
- **Constraints**: Performance requirements? Compatibility needs?
- **Dependencies**: What exists? What needs to be built?
- **Acceptance**: How do we know it's done?

Wait for user answers before proceeding.

---

## Step 3: Automated Context Mapping (CHEAP)

Launch 3 Haiku agents IN PARALLEL for cheap scanning:

1. **file-scanner** agent:
   - "Search for keywords related to [task] across the codebase"
   - Returns: List of relevant files

2. **import-tracer** agent:
   - "Trace dependencies for files likely involved in [task]"
   - Returns: Dependency chain

3. **test-finder** agent:
   - "Find tests that cover functionality related to [task]"
   - Returns: Test file list

These use Haiku (cheap) because they're just grep/glob work.

---

## Step 4: Context Synthesis (SMART)

Once Haiku agents return, launch **context-synthesizer** agent (Opus):

- "Synthesize the scanner results. Identify patterns, risks, and key files to understand."

Read the key files identified by the synthesizer.

---

## Step 5: Task Capsule Creation

Create a task capsule at `docs/taskcaps/YYYY-MM-DD-<slug>.md`:

```markdown
# Task: [Title]

## Goal
[What we're trying to achieve]

## Non-Goals
[What we're explicitly NOT doing]

## Relevant Files
[From scanning - list with brief reasons]

## Plan
1. [Step one]
2. [Step two]
3. [Step three]

## Risks
[From synthesis - severity levels]

## Definition of Done
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] Tests pass
- [ ] No regressions

## Progress
[Updated as work proceeds]

## Blockers
[Any current blockers]
```

Ensure `docs/taskcaps/` directory exists.

---

## Step 6: User Approval

Present the task capsule and ask:

"Here's the context map and plan. Approve to proceed to /dev-flow or /bug-hunt?"

Only after approval should user run the next workflow.

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| file-scanner | Haiku | CHEAP file finding |
| import-tracer | Haiku | CHEAP dependency tracing |
| test-finder | Haiku | CHEAP test discovery |
| context-synthesizer | Opus | Smart analysis of scan results |

---

## Skills Available

- **ultra-scientist**: Maximum enthusiasm mode
- **repo-atlas**: Documentation system knowledge
- **task-capsules**: Capsule format and lifecycle
- **phase0-guide**: This workflow guidance
