# AGENTS.md - AI Agent Steering File

This file provides guidance to AI agents (Claude, Copilot, etc.) working in this codebase.

## Project Overview
[Brief description of what this project does]

## Key Concepts
- **Concept 1**: Explanation
- **Concept 2**: Explanation
- **Concept 3**: Explanation

## Architecture
[Brief architecture overview or link to docs]

## Conventions

### Naming
- Files: `kebab-case.ts`
- Components: `PascalCase`
- Functions: `camelCase`
- Constants: `SCREAMING_SNAKE_CASE`

### Code Style
- [Style rule 1]
- [Style rule 2]
- [Style rule 3]

### Testing
- Unit tests: `tests/unit/` or `__tests__/`
- Integration tests: `tests/integration/`
- Test naming: `test_<what>_<scenario>`

## Common Tasks

### Adding a new feature
1. Run `/phase0` to map context
2. Create task capsule
3. Run `/dev-flow` to implement

### Fixing a bug
1. Run `/phase0` to map context
2. Create task capsule
3. Run `/bug-hunt` to investigate and fix

### Adding an API endpoint
1. Create route in `api/routes/`
2. Create schema in `api/schemas/`
3. Add tests in `tests/api/`

## Things to Avoid
- [Anti-pattern 1]
- [Anti-pattern 2]
- [Anti-pattern 3]

## Important Files
| File | Purpose |
|------|---------|
| CLAUDE.md | Full project documentation |
| features.yaml | Feature registry |
| docs/NOW.md | Current focus |
| docs/taskcaps/ | Task capsules |

## Getting Help
- Check CLAUDE.md for detailed docs
- Check docs/decisions/ for ADRs
- Check docs/taskcaps/ for recent context
