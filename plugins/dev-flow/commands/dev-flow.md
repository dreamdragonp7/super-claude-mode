---
description: Guided 12-phase feature development with codebase exploration, architecture design, and quality review
argument-hint: Optional feature description or --capsule <slug>
---

# Feature Development

You are helping a developer build a new feature. Follow a systematic 12-phase approach across 4 meta-phases: Discovery, Design, Implementation, and Quality.

## Execution Rule

At the START of each phase, ALWAYS announce:

**Phase X of 12: [Phase Name]**
Next: Phase Y - [Next Phase Name]

Then proceed with the phase actions. This helps track progress through the workflow.

---

## Capsule Support (Optional)

Check if `$ARGUMENTS` contains `--capsule`:

```
If --capsule <slug> provided:
  1. Read /.phase0/capsules/<slug>/capsule.yaml
  2. Extract: goal, constraints, key_files, risks, decisions_made
  3. Pre-fill Phase 1 context with capsule data
  4. Announce: "Loaded capsule: <slug>"
  5. Skip user questions in Phase 1 - use capsule answers

If no --capsule:
  1. Proceed normally with Phase 1 questions
  2. This is fine - capsules are optional
```

---

## Core Principles

- **Ask clarifying questions**: Identify ambiguities early. Ask about requirements, edge cases, and integration points before designing.
- **Understand before acting**: Read and comprehend existing code patterns before proposing architecture.
- **Read files identified by agents**: Use agents to find important files, then read them to build context.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code.
- **Leave no stone unturned**: Address ALL design considerations regardless of complexity.
- **Use TodoWrite**: Track all progress throughout.
- **Follow patterns.yaml**: Respect project boundaries and component patterns.

---

## Pre-Phase: patterns.yaml Check

**Before Phase 1, silently check for patterns.yaml**:

1. Use Glob to check if `patterns.yaml` exists in the project root.

2. **If found**:
   - Read it to understand project structure
   - Note `source_of_truth` files for Phase 2
   - Note `component_patterns` for Phase 4
   - Note `boundaries` for architecture decisions
   - Briefly mention: "Using patterns.yaml for project conventions."

3. **If not found**:
   - Continue without it
   - Briefly mention: "No patterns.yaml found. Consider running /planning to define project patterns."

4. Check if ARCHITECTURE.md exists - read for current reality snapshot.

**Then proceed immediately to Phase 1.**

---

## Phase 1 of 12: Business Analysis

> **Current**: Phase 1 - Business Analysis
> **Next**: Phase 2 - Technical Architecture

**Goal**: Understand WHAT needs to be built and WHY

Initial request: $ARGUMENTS

**Actions**:

1. Create todo list with all 12 phases.

2. **Get the feature description** (check in this order):

   **A) Arguments provided?** → Use `$ARGUMENTS` as the feature request.

   **B) No arguments?** → Ask the user:
   - What problem are they solving?
   - What should the feature do?
   - Who are the users?
   - Any constraints or requirements?

3. Launch `code-explorer` agent to understand business context:
   - "Explore existing features similar to [feature] to understand business patterns and user flows."

4. Summarize the feature requirements and confirm with user.

**When complete**: Proceed to Phase 2.

---

## Phase 2 of 12: Technical Architecture

> **Current**: Phase 2 - Technical Architecture
> **Next**: Phase 3 - Risk Assessment

**Goal**: Understand the existing codebase and technical landscape

**Actions**:

1. Launch 2-3 `code-explorer` agents in parallel. Each agent should:
   - Trace through related code comprehensively
   - Target different aspects (architecture, similar features, tech stack)
   - Return 5-10 key files to read

   **Example agent prompts**:
   - "Map the high-level architecture and module boundaries for [feature area]"
   - "Find existing patterns for [data flow/API/components] that this feature should follow"
   - "Analyze the integration points where this feature will connect"

2. Once agents return, read all identified files to build deep understanding.
3. Present a summary of the technical landscape.

**When complete**: Proceed to Phase 3.

---

## Phase 3 of 12: Risk Assessment

> **Current**: Phase 3 - Risk Assessment
> **Next**: Phase 4 - Architecture Design

**Goal**: Identify risks, edge cases, and security concerns

**Actions**:

1. Launch `code-explorer` agent focused on risk:
   - "Identify security concerns, edge cases, and potential failure modes for [feature]"
   - "Analyze dependencies and breaking change risks"

2. Review findings and compile risk list.
3. Present risks to user. Ask if any should block or modify the design.

**When complete**: Proceed to Phase 4.

---

## Phase 4 of 12: Architecture Design

> **Current**: Phase 4 - Architecture Design
> **Next**: Phase 5 - API Design

**Goal**: Design multiple implementation approaches with trade-offs

**Actions**:

1. Launch 2-3 `code-architect` agents in parallel with different focuses:
   - **Minimal approach**: Smallest change, maximum reuse of existing code
   - **Clean architecture**: Best maintainability, elegant abstractions
   - **Pragmatic balance**: Speed + quality, practical trade-offs

   Each agent should return:
   - Proposed file structure
   - Component responsibilities
   - Data flow design
   - Build sequence

2. Review all approaches and form your recommendation.
3. Present to user:
   - Brief summary of each approach
   - Trade-offs comparison
   - **Your recommendation with reasoning**
   - Ask user which approach they prefer

**When complete**: Proceed to Phase 5 (after user selects approach).

---

## Phase 5 of 12: API Design

> **Current**: Phase 5 - API Design
> **Next**: Phase 6 - Test Strategy

**Goal**: Define API contracts and schemas

**Actions**:

1. Based on chosen architecture, determine API needs:
   - REST endpoints? → Launch `backend-architect` agent
   - GraphQL? → Launch `graphql-architect` agent
   - Internal APIs only? → Skip to contracts definition

2. Agent should design:
   - Endpoint/query definitions
   - Request/response schemas
   - Error handling patterns
   - Authentication/authorization requirements

3. Present API contract to user for approval.

**When complete**: Proceed to Phase 6.

---

## Phase 6 of 12: Test Strategy

> **Current**: Phase 6 - Test Strategy
> **Next**: Phase 7 - Backend Implementation

**Goal**: Plan testing approach before implementation

**Actions**:

1. Launch `tdd-orchestrator` agent:
   - "Design test strategy for [feature]. Include unit tests, integration tests, and critical path E2E tests."

2. Agent should define:
   - Test categories and coverage goals
   - Critical paths to test
   - Mock/fixture requirements
   - TDD approach if applicable

3. Present test plan to user.

**IMPORTANT**: After Phase 6, wait for explicit user approval before proceeding to implementation.

**When complete**: Ask user to approve the full design (architecture + API + tests) before proceeding.

---

## Phase 7 of 12: Backend Implementation

> **Current**: Phase 7 - Backend Implementation
> **Next**: Phase 8 - Frontend Implementation

**Goal**: Implement backend services and APIs

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:

1. Wait for explicit user approval of the design from Phases 4-6.

2. Launch `feature-writer` agent with backend focus:
   - Provide: Approved architecture, target files, API contracts
   - Focus: Services, APIs, business logic, data access

3. Agent will:
   - Create/modify backend files
   - Follow project conventions
   - Run tests after implementation

4. Review implementation and update todos.

**When complete**: Proceed to Phase 8.

---

## Phase 8 of 12: Frontend Implementation

> **Current**: Phase 8 - Frontend Implementation
> **Next**: Phase 9 - Integration

**Goal**: Implement frontend components and UI

**Actions**:

1. Launch `feature-writer` agent with frontend focus:
   - Provide: Approved architecture, target files, component designs
   - Focus: Components, UI, state management, API integration

2. Agent will:
   - Create/modify frontend files
   - Follow project conventions
   - Run tests after implementation

3. Review implementation and update todos.

**When complete**: Proceed to Phase 9.

---

## Phase 9 of 12: Integration

> **Current**: Phase 9 - Integration
> **Next**: Phase 10 - Quality Review

**Goal**: Connect components and finalize data flow

**Actions**:

1. Launch `feature-writer` agent with integration focus:
   - Provide: Backend and frontend implementations
   - Focus: Glue code, data pipelines, configuration

2. Agent will:
   - Wire up components
   - Add configuration
   - Ensure data flows correctly

3. Run integration tests.

**When complete**: Proceed to Phase 10.

---

## Phase 10 of 12: Quality Review

> **Current**: Phase 10 - Quality Review
> **Next**: Phase 11 - Test Execution

**Goal**: Catch bugs, security issues, and convention violations

**Actions**:

1. Launch 3 `code-reviewer` agents in parallel with different focuses:
   - **Simplicity/DRY/Elegance**: Code quality and maintainability
   - **Bugs/Security**: Functional correctness and vulnerabilities
   - **Conventions/Abstractions**: Project patterns and best practices

   Each agent should:
   - Use confidence scoring (0-100)
   - Only report issues with confidence >= 80
   - Provide specific file:line references

2. Consolidate findings and identify highest severity issues.
3. Present findings to user and ask what they want to fix.
4. If fixes needed, use `feature-writer` to address them.

**When complete**: Proceed to Phase 11.

---

## Phase 11 of 12: Test Execution

> **Current**: Phase 11 - Test Execution
> **Next**: Phase 12 - Summary

**Goal**: Run tests and validate coverage

**Actions**:

1. Launch `tdd-orchestrator` agent:
   - "Execute test suite for [feature]. Validate coverage meets requirements."

2. Run all relevant tests:
   - Unit tests
   - Integration tests
   - E2E tests if applicable

3. Report results. If failures:
   - Use `feature-writer` to fix issues
   - Re-run tests until passing

**When complete**: Proceed to Phase 12.

---

## Phase 12 of 12: Summary

> **Current**: Phase 12 - Summary
> **Next**: Done!

**Goal**: Document what was accomplished

**Actions**:

1. Mark all todos complete.
2. Summarize:
   - What was built
   - Key architectural decisions
   - Files created/modified
   - Test coverage achieved
   - Suggested next steps (deployment, monitoring, etc.)

**When complete**: Feature development finished!

---

## Agent Reference

**code-explorer** (yellow):
- Traces execution paths, maps architecture
- Returns key files to read
- Used in: Phases 1-3

**code-architect** (green):
- Designs implementation blueprints
- Makes confident architectural decisions
- Used in: Phase 4

**backend-architect** (sonnet):
- API design (REST/GraphQL/gRPC)
- Microservices patterns
- Used in: Phase 5

**graphql-architect** (sonnet):
- GraphQL schema design
- Federation, caching, real-time
- Used in: Phase 5

**tdd-orchestrator** (sonnet):
- Test strategy design
- Red-green-refactor coordination
- Used in: Phases 6, 11

**feature-writer** (opus):
- Implements approved designs
- Has Edit/Write tools
- Used in: Phases 7-10

**code-reviewer** (red):
- Bugs, security, conventions
- Confidence >= 80 filter
- Used in: Phase 10

---

## Skills Available

- **architecture-patterns**: Clean Architecture, Hexagonal, DDD
- **api-design-principles**: REST/GraphQL patterns, pagination, error handling
- **microservices-patterns**: Saga, Circuit Breaker, Event Bus
