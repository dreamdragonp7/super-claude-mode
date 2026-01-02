---
name: task-capsules
description: Knowledge about task capsule creation and management. Use when creating, referencing, or updating task capsules.
---

# Task Capsule System

## What Is A Task Capsule?

A task capsule is a markdown file that captures everything Claude needs to know about a specific task:
- Goal and scope
- Relevant files
- Plan and steps
- Risks and blockers
- Definition of Done

## Why Task Capsules?

1. **Survive Compaction**: Files persist when context is summarized
2. **Cross-Session**: New sessions can read and continue
3. **Git Tracked**: History of decisions preserved
4. **Enforce Discipline**: Forces thinking before coding

## Location

`docs/taskcaps/YYYY-MM-DD-<slug>.md`

Examples:
- `docs/taskcaps/2025-01-01-add-ltm-training-endpoint.md`
- `docs/taskcaps/2025-01-01-fix-memory-leak-in-tokenizer.md`

## Template

```markdown
# Task: [Title]

## Goal
[What we're trying to achieve - be specific]

## Non-Goals
[What we're explicitly NOT doing]

## Relevant Files
[Discovered during /phase0 scanning]
- path/to/file1.py (reason)
- path/to/file2.tsx (reason)

## Plan
1. [Step one]
2. [Step two]
3. [Step three]

## Risks
[From synthesis agent]
- Risk 1: Description (High/Med/Low)
- Risk 2: Description (High/Med/Low)

## Definition of Done
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Tests pass
- [ ] No regressions

## Progress
[Updated as work proceeds]
- [x] Completed step
- [ ] In progress...

## Blockers
[Any current blockers]

## Notes
[Additional context, decisions, learnings]
```

## Lifecycle

1. **Created** by `/phase0` command
2. **Updated** during development
3. **Referenced** by hooks on session start
4. **Completed** when Definition of Done checked
5. **Archived** (stays in git history)

## Hook Integration

- `SessionStart`: Lists recent capsules
- `PreCompact`: Notes active capsules in journal
- `Stop`: Warns if Definition of Done incomplete
- `UserPromptSubmit`: Suggests /phase0 if no recent capsule

## Best Practices

1. **One task, one capsule**: Don't combine unrelated work
2. **Update during work**: Keep Progress section current
3. **Be specific**: Vague goals lead to scope creep
4. **List files discovered**: Future sessions need this
5. **Check off when done**: Satisfying AND useful
