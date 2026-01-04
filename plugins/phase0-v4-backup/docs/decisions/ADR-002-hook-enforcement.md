# ADR-002: Hook Enforcement Policy

## Status
Accepted

## Context
Developers skip important phases in workflows:
- Jumping to /dev-flow without context mapping
- Forgetting to create task capsules
- Losing context on session compaction

We need enforcement without being annoying.

## Decision
Use **soft enforcement** via hooks:

| Hook | Behavior |
|------|----------|
| UserPromptSubmit | SUGGEST /phase0 (don't block) |
| PreCompact | AUTO-SAVE to journal |
| SessionStart | SHOW recent capsules |
| Stop | WARN about incomplete items |

Key principle: **Suggest, don't block.** Users can ignore suggestions.

## Consequences

### Good
- Non-intrusive - won't frustrate users
- Educational - reminds about best practices
- Flexible - can be ignored for trivial tasks
- Auto-saves context on compaction (always helpful)

### Bad
- Can still be ignored (enforcement is soft)
- May need to tighten later if phases still get skipped

## Future Consideration
If phases continue to be skipped, consider:
- Hard blocking (exit code 2) for /dev-flow without capsule
- Required confirmation to proceed without phase0
