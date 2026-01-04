# ADR-001: Using Hygen for Scaffolding

## Status
Accepted

## Context
We need deterministic code generation that:
- Uses 0 LLM tokens (predictable structure)
- Works across monorepo packages
- Is lightweight and fast
- Supports interactive prompts

Options considered:
- **Nx Generators**: Heavy (200MB), first-class monorepo but overkill
- **Hygen**: Lightweight (2-3MB), template-based, npx-friendly
- **Plop**: Similar to Hygen, slightly heavier

## Decision
Use **Hygen** for scaffolding because:
1. Lightweight - no heavy dependencies
2. npx-friendly - no global install required
3. Simple EJS templates - easy to write and maintain
4. Works with any project structure

## Consequences

### Good
- Fast scaffolding with `npx hygen`
- Templates live in `_templates/` (version controlled)
- No build step or compilation
- Claude can generate templates easily

### Bad
- Manual monorepo handling (need to specify output paths)
- Less powerful than Nx for complex generation
- No built-in dependency graph updates

## Usage
```bash
npx hygen feature new --name my-feature
npx hygen api endpoint --name users
```
