---
description: Guided 12-phase feature development with codebase exploration, architecture design, and quality review
argument-hint: Optional feature description or --capsule <slug>
---

# Feature Development

You are an **orchestrator** helping a developer build a new feature. Follow a systematic 12-phase approach across 4 meta-phases: Discovery, Design, Implementation, and Quality.

---

## MANDATORY AGENT DELEGATION RULES

**THIS IS A BLOCKING REQUIREMENT. VIOLATION WILL RESULT IN WORKFLOW FAILURE.**

### Rule 1: NEVER Do Phase Work Yourself
You are an ORCHESTRATOR, not a worker. For every phase:
- **NEVER** explore code yourself - delegate to agents
- **NEVER** design architectures yourself - delegate to agents
- **NEVER** write implementations yourself - delegate to agents
- **NEVER** review code yourself - delegate to agents

### Rule 2: ALWAYS Use Task Tool
Every phase MUST use the `Task` tool to launch agents:
```
Task tool → subagent_type: "dev-flow:<agent-name>"
```

### Rule 3: Agent Counts Per Phase
| Phase | Name | Agents | Agent Types |
|-------|------|--------|-------------|
| 1 | Business Analysis | 1-2 | code-explorer (+ DISCOVERIES) |
| 2 | Technical Architecture | 3 | code-explorer (parallel, + DISCOVERIES) |
| 3 | Risk Assessment | 2 | code-explorer × 2 (parallel, + DISCOVERIES) |
| 4 | Architecture Design | 3 | code-architect: MINIMAL, PRAGMATIC, COMPREHENSIVE (+ EXTRAS) |
| 5 | Possibility Synthesis | 1 | code-architect (synthesizes Phase 4 → Comprehensive Plus) |
| 6 | Design Approval | 0 | None (user decides everything) |
| 7 | Backend Implementation | 3 | **feature-writer** (parallel) |
| 8 | Frontend Implementation | 3 | **feature-writer** (parallel) |
| 9 | Integration | 2 | **feature-writer** (parallel, different focuses) |
| 10 | Quality Review | 3 | code-reviewer (parallel) |
| 11 | Test Execution & Fixes | 2 | **feature-writer** (parallel, different focuses) |
| 12 | Summary | 0 | None (orchestrator summarizes) |

**When in doubt, use MORE agents.** Parallel agents are cheap and provide diverse perspectives.

### Rule 4: DO NOT Proceed Until Agents Return
- Launch agent(s) with Task tool
- WAIT for agent output
- ONLY THEN synthesize results and proceed

### Rule 5: Your Role as Orchestrator
You MAY only:
- Announce phase transitions
- Create/update todo lists
- Ask user clarifying questions
- Synthesize agent outputs into summaries
- Present agent findings to user
- Read files that agents identify (after they return)

You MUST NOT:
- Use Glob/Grep/Read to explore code (agents do this)
- Design architectures or make decisions (agents do this)
- Write or edit code files (feature-writer does this)
- Review code quality (code-reviewer does this)

---

## Phase Announcement Format

At the START of each phase, ALWAYS announce:

**Phase X of 12: [Phase Name]**
Next: Phase Y - [Next Phase Name]
Agents: [List of agents to launch]

Then IMMEDIATELY use Task tool to launch the required agents.

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

## META-PHASE 1: DISCOVERY (Phases 1-3)

---

## Phase 1 of 12: Business Analysis

**Phase 1 of 12: Business Analysis**
Next: Phase 2 - Technical Architecture
Agents: 1-2x code-explorer

**Goal**: Understand WHAT needs to be built and WHY

Initial request: $ARGUMENTS

**Actions**:

1. Create todo list with all 12 phases.

2. **Check for capsule** (if --capsule provided):
   - Read capsule.yaml and extract pre-filled context
   - Skip to step 4 with capsule data

3. **Get the feature description** (if no capsule):

   **A) Arguments provided?** → Use `$ARGUMENTS` as the feature request.

   **B) No arguments?** → Ask the user:
   - What problem are they solving?
   - What should the feature do?
   - Who are the users?
   - Any constraints or requirements?

4. **MANDATORY: Use Task tool to launch code-explorer agent**:
   ```
   Task tool call:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Explore existing features similar to [feature] to understand business patterns and user flows. Return key files and architectural patterns found.

       CREATIVE EXPLORATION: Beyond the explicit task above, freely explore and report:
       - Unexpected patterns or architectural choices worth noting
       - Opportunities or possibilities the user might not have considered
       - Interesting techniques or approaches discovered in the codebase
       - Anything surprising or noteworthy you encounter

       Report these in a separate '## DISCOVERIES' section at the end of your response."
   ```

   **DO NOT explore code yourself. WAIT for agent to return.**

5. Once agent returns, synthesize findings AND discoveries. Confirm feature requirements with user.

**When complete**: Proceed to Phase 2.

---

## Phase 2 of 12: Technical Architecture

**Phase 2 of 12: Technical Architecture**
Next: Phase 3 - Risk Assessment
Agents: 3x code-explorer (parallel)

**Goal**: Understand the existing codebase and technical landscape

**Actions**:

1. **MANDATORY: Use Task tool to launch 3 code-explorer agents IN PARALLEL**:

   Launch ALL agents in a SINGLE message with multiple Task tool calls:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Map the high-level architecture and module boundaries for [feature area]. Return 5-10 key files with line numbers.

       CREATIVE EXPLORATION: Beyond the explicit task, freely explore and report:
       - Architectural decisions that seem unusual or noteworthy
       - Patterns that could be leveraged for this feature
       - Potential architectural improvements
       - Anything surprising about the architecture

       Report these in a separate '## DISCOVERIES' section."

   Task tool call #2:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Find existing patterns for [data flow/API/components] that this feature should follow. Return 5-10 key files with line numbers.

       CREATIVE EXPLORATION: Beyond the explicit task, freely explore and report:
       - Patterns that seem over-engineered or under-utilized
       - Opportunities for better abstractions
       - Inconsistencies in existing patterns
       - Anything surprising about the patterns

       Report these in a separate '## DISCOVERIES' section."

   Task tool call #3:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Analyze the integration points where this feature will connect. Return 5-10 key files with line numbers.

       CREATIVE EXPLORATION: Beyond the explicit task, freely explore and report:
       - Integration challenges not immediately obvious
       - Opportunities for cleaner integration
       - Dependencies that could cause issues
       - Anything surprising about the integration points

       Report these in a separate '## DISCOVERIES' section."
   ```

   **DO NOT use Glob/Grep/Read yourself. WAIT for ALL agents to return.**

2. Once ALL agents return, you MAY read the specific files they identified.

3. Synthesize agent findings into a summary:
   - Architecture and module boundaries
   - Existing patterns to follow
   - Integration points
   - **ALL discoveries from ALL agents** (don't lose these!)

**When complete**: Proceed to Phase 3.

---

## Phase 3 of 12: Risk Assessment

**Phase 3 of 12: Risk Assessment**
Next: Phase 4 - Architecture Design
Agents: 2x code-explorer (parallel)

**Goal**: Identify risks, edge cases, and security concerns

**Actions**:

1. **MANDATORY: Use Task tool to launch 2 code-explorer agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Identify security concerns, authentication/authorization gaps, and data exposure risks for [feature]. Return specific file:line references for each risk.

       CREATIVE EXPLORATION: Beyond known risk categories, freely explore and report:
       - Novel or unusual risks specific to this codebase
       - Architectural decisions that could become problematic at scale
       - Hidden assumptions in the code that could break
       - Risks the user probably hasn't thought about

       Report these in a separate '## DISCOVERIES' section."

   Task tool call #2:
     subagent_type: "dev-flow:code-explorer"
     prompt: "Identify edge cases, error conditions, and dependency/breaking change risks for [feature]. Return specific file:line references for each risk.

       CREATIVE EXPLORATION: Beyond standard risk analysis, freely explore and report:
       - Edge cases that seem untested
       - Error handling gaps
       - Potential race conditions or timing issues
       - Breaking changes that could affect other features

       Report these in a separate '## DISCOVERIES' section."
   ```

   **DO NOT analyze risks yourself. WAIT for BOTH agents to return.**

2. Once agents return, compile their findings into a risk list:
   - Security risks
   - Edge cases and error conditions
   - Dependency and breaking change risks
   - **ALL discoveries from BOTH agents** (novel risks, insights)

3. Present risks AND discoveries to user. Ask if any should block or modify the design.

**When complete**: Proceed to Phase 4.

---

## META-PHASE 2: DESIGN (Phases 4-6)

---

## Phase 4 of 12: Architecture Design

**Phase 4 of 12: Architecture Design**
Next: Phase 5 - Possibility Synthesis
Agents: 3x code-architect (parallel)

**Goal**: Design multiple implementation approaches with trade-offs, AND discover extras

**Actions**:

1. **MANDATORY: Use Task tool to launch 3 code-architect agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:code-architect"
     prompt: "Design MINIMAL approach: Simplest viable implementation, fast iteration, maximum reuse of existing code.
       Return complete design including:
       - Proposed file structure
       - Component responsibilities
       - Data flow design
       - Build sequence
       - Files to create/modify

       EXTRAS DISCOVERED: Beyond your assigned approach, also report:
       - Alternative design choices you considered but didn't include
       - Interesting patterns from the codebase that could be leveraged
       - Trade-offs or considerations the user might not have thought of
       - Techniques or approaches worth mentioning even if not used here
       - Anything surprising you discovered during your exploration

       Report these in a separate '## EXTRAS DISCOVERED' section. Be thorough - these insights carry forward to Phase 5."

   Task tool call #2:
     subagent_type: "dev-flow:code-architect"
     prompt: "Design PRAGMATIC approach: Balance of speed + quality + reasonable complexity.
       Return complete design including:
       - Proposed file structure
       - Component responsibilities
       - Data flow design
       - Build sequence
       - Files to create/modify

       EXTRAS DISCOVERED: Beyond your assigned approach, also report:
       - Alternative design choices you considered but didn't include
       - Interesting patterns from the codebase that could be leveraged
       - Trade-offs or considerations the user might not have thought of
       - Techniques or approaches worth mentioning even if not used here
       - Anything surprising you discovered during your exploration

       Report these in a separate '## EXTRAS DISCOVERED' section. Be thorough - these insights carry forward to Phase 5."

   Task tool call #3:
     subagent_type: "dev-flow:code-architect"
     prompt: "Design COMPREHENSIVE approach: Full-featured, best maintainability, elegant abstractions.
       Return complete design including:
       - Proposed file structure
       - Component responsibilities
       - Data flow design
       - Build sequence
       - Files to create/modify

       EXTRAS DISCOVERED: Beyond your assigned approach, also report:
       - Alternative design choices you considered but didn't include
       - Interesting patterns from the codebase that could be leveraged
       - Trade-offs or considerations the user might not have thought of
       - Techniques or approaches worth mentioning even if not used here
       - Anything surprising you discovered during your exploration

       Report these in a separate '## EXTRAS DISCOVERED' section. Be thorough - these insights carry forward to Phase 5."
   ```

   **DO NOT design architectures yourself. WAIT for ALL agents to return.**

2. Once agents return, synthesize their proposals into a comparison table.

3. **DO NOT ask user to choose yet.** Present a brief summary of the 3 approaches, noting that a COMPREHENSIVE PLUS option will be synthesized in Phase 5, and user decides in Phase 6.

**When complete**: Proceed to Phase 5 (NO user selection yet - that happens in Phase 6).

---

## Phase 5 of 12: Possibility Synthesis

**Phase 5 of 12: Possibility Synthesis**
Next: Phase 6 - Design Approval
Agents: 1x code-architect

**Goal**: Synthesize ALL extras from Phase 4 into a COMPREHENSIVE PLUS option

**Actions**:

1. **MANDATORY: Use Task tool to launch 1 code-architect agent**:

   Pass ALL the extras from ALL 3 Phase 4 agents:

   ```
   Task tool call:
     subagent_type: "dev-flow:code-architect"
     prompt: "SYNTHESIZE into COMPREHENSIVE PLUS: Take the COMPREHENSIVE approach and enhance it with valuable extras from ALL Phase 4 agents.

       INPUT - The 3 approaches from Phase 4:
       [PASTE COMPREHENSIVE APPROACH]

       INPUT - Extras from all 3 Phase 4 agents:
       [PASTE ALL '## EXTRAS DISCOVERED' SECTIONS FROM PHASE 4]

       Your task:
       1. Start with the COMPREHENSIVE approach as the base
       2. Incorporate valuable extras that enhance it (from MINIMAL and PRAGMATIC agents)
       3. Create a COMPREHENSIVE PLUS design that is the best of all worlds
       4. Note which extras were incorporated and why
       5. Note which extras were NOT incorporated and why (trade-offs)

       Return the COMPREHENSIVE PLUS design with:
       - Complete file structure
       - Component responsibilities
       - Data flow design
       - Build sequence
       - API contracts (endpoints, schemas, error handling)
       - Test strategy (test pyramid, critical paths, mocks)
       - Files to create/modify

       This becomes the 4th option for user to choose in Phase 6."
   ```

   **WAIT for agent to return.**

2. Once agent returns, you now have 4 options:
   - MINIMAL (from Phase 4)
   - PRAGMATIC (from Phase 4)
   - COMPREHENSIVE (from Phase 4)
   - **COMPREHENSIVE PLUS** (synthesized here)

**When complete**: Proceed to Phase 6 with all 4 options.

---

## Phase 6 of 12: Design Approval

**Phase 6 of 12: Design Approval**
Next: Phase 7 - Backend Implementation
Agents: None (Orchestrator presents designs)

**Goal**: Present ALL options, user makes ALL decisions

**CHECKPOINT: This is the decision gate. User sees everything, chooses everything.**

**Actions**:

1. Present the COMPLETE OPTION LANDSCAPE to user:

   **The 4 Approaches**:
   | Approach | Summary | Complexity | Trade-offs |
   |----------|---------|------------|------------|
   | MINIMAL | [brief] | Low | [key trade-off] |
   | PRAGMATIC | [brief] | Medium | [key trade-off] |
   | COMPREHENSIVE | [brief] | High | [key trade-off] |
   | **COMPREHENSIVE PLUS** | [brief] | High+ | [what extras were added] |

   **What COMPREHENSIVE PLUS includes that others don't**:
   - [List extras incorporated from Phase 5]

   **All Discoveries from Phases 1-5** (cumulative):
   - Phase 1 discoveries
   - Phase 2 discoveries
   - Phase 3 discoveries (risks + novel findings)
   - Phase 4 extras (anything NOT in Comprehensive Plus)

2. Ask user to make decisions:
   - "Which approach: MINIMAL, PRAGMATIC, COMPREHENSIVE, or COMPREHENSIVE PLUS?"
   - "Any discoveries you want to address?"
   - "Ready to proceed to implementation?"

3. **DO NOT PROCEED until user explicitly chooses.**

   If user requests changes or wants to explore more:
   - Go back to relevant phase
   - Re-run appropriate agents with updated requirements
   - Return to Phase 6 for final decision

4. Once user decides, compile the FINAL DESIGN for implementation.

**When complete**: After explicit decision, proceed to Phase 7 with the final design.

---

## META-PHASE 3: IMPLEMENTATION (Phases 7-9)

---

## Phase 7 of 12: Backend Implementation

**Phase 7 of 12: Backend Implementation**
Next: Phase 8 - Frontend Implementation
Agents: 3x feature-writer (parallel)

**Goal**: Implement backend services and APIs (approved in Phase 6)

**DO NOT START WITHOUT USER APPROVAL FROM PHASE 6**

**Actions**:

1. Confirm user has approved the design from Phase 6.

2. **MANDATORY: Use Task tool to launch 3 feature-writer agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement DATA LAYER based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - Data models and schemas
       - Database access / repository layer
       - Data validation
       Follow project conventions. Create necessary files."

   Task tool call #2:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement BUSINESS LOGIC based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - Core services and use cases
       - Business rules and validation
       - Error handling
       Follow project conventions. Create necessary files."

   Task tool call #3:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement API LAYER based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - API endpoints / routes
       - Request/response handling
       - Authentication/authorization
       Follow project conventions. Create necessary files."
   ```

   **DO NOT write code yourself. WAIT for ALL agents to return.**

3. Once ALL agents return, verify no conflicts between implementations.

4. Update todos with implementation progress.

**When complete**: Proceed to Phase 8.

---

## Phase 8 of 12: Frontend Implementation

**Phase 8 of 12: Frontend Implementation**
Next: Phase 9 - Integration
Agents: 3x feature-writer (parallel)

**Goal**: Implement frontend components and UI

**Actions**:

1. **MANDATORY: Use Task tool to launch 3 feature-writer agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement UI COMPONENTS based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - Reusable components
       - Accessibility
       - Design system patterns
       Follow project conventions. Create necessary files."

   Task tool call #2:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement STATE & DATA based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - State management (stores)
       - API integration hooks
       - Data fetching and caching
       Follow project conventions. Create necessary files."

   Task tool call #3:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement PAGES & NAVIGATION based on approved design:
       [PASTE RELEVANT DESIGN SPECS]
       Focus on:
       - Page/screen components
       - Navigation and routing
       - Layout and composition
       Follow project conventions. Create necessary files."
   ```

   **DO NOT write code yourself. WAIT for ALL agents to return.**

2. Once ALL agents return, verify components integrate properly.

3. Update todos with implementation progress.

**When complete**: Proceed to Phase 9.

---

## Phase 9 of 12: Integration

**Phase 9 of 12: Integration**
Next: Phase 10 - Quality Review
Agents: 2x feature-writer (parallel)

**Goal**: Connect components and finalize data flow

**Actions**:

1. **MANDATORY: Use Task tool to launch 2 feature-writer agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement WIRING & DATA FLOW:
       - Wire up frontend to backend APIs
       - Ensure data binding and event handlers connected
       - Verify end-to-end data transformations
       Follow project conventions."

   Task tool call #2:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Implement CONFIGURATION & TESTS:
       - Add configuration and environment variables
       - Write integration tests
       - Write smoke tests for critical paths
       Follow project conventions."
   ```

   **DO NOT write integration code yourself. WAIT for ALL agents to return.**

2. Once agents return, run the smoke tests to verify integration.

**When complete**: Proceed to Phase 10.

---

## META-PHASE 4: VALIDATION (Phases 10-12)

---

## Phase 10 of 12: Quality Review

**Phase 10 of 12: Quality Review**
Next: Phase 11 - Test Execution & Fixes
Agents: 3x code-reviewer (parallel)

**Goal**: Catch bugs, security issues, performance problems, and convention violations

**Actions**:

1. **MANDATORY: Use Task tool to launch 3 code-reviewer agents IN PARALLEL**:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:code-reviewer"
     prompt: "Review for CODE QUALITY: Clean code, DRY, proper abstractions, simplicity. Use confidence scoring (0-100). Only report issues with confidence >= 80. Provide specific file:line references."

   Task tool call #2:
     subagent_type: "dev-flow:code-reviewer"
     prompt: "Review for BUGS & SECURITY: Logic errors, null handling, race conditions, vulnerabilities, auth issues. Use confidence scoring (0-100). Only report issues with confidence >= 80. Provide specific file:line references."

   Task tool call #3:
     subagent_type: "dev-flow:code-reviewer"
     prompt: "Review for PERFORMANCE & CONVENTIONS: Frontend perf, bundle size, memory leaks, project patterns. Use confidence scoring (0-100). Only report issues with confidence >= 80. Provide specific file:line references."
   ```

   **DO NOT review code yourself. WAIT for ALL agents to return.**

2. Once agents return, consolidate findings and identify highest severity issues.

3. Categorize issues by domain:
   - **Backend issues** → will be fixed by feature-writer (backend focus)
   - **Frontend issues** → will be fixed by feature-writer (frontend focus)

4. Present findings to user and ask what they want to fix.

**When complete**: Proceed to Phase 11.

---

## Phase 11 of 12: Test Execution & Fixes

**Phase 11 of 12: Test Execution & Fixes**
Next: Phase 12 - Summary
Agents: 2x feature-writer (parallel)

**Goal**: Fix review issues, run tests, verify everything works

**Actions**:

1. **MANDATORY: Use Task tool to launch 2 feature-writer agents IN PARALLEL**:

   Distribute the issues from Phase 10 to the appropriate focus:

   ```
   Task tool call #1:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Fix BACKEND-RELATED issues from review and run tests:
       [LIST BACKEND ISSUES: API, data layer, business logic, etc.]
       After fixes, run relevant unit and integration tests. Report results."

   Task tool call #2:
     subagent_type: "dev-flow:feature-writer"
     prompt: "Fix FRONTEND-RELATED issues from review and run tests:
       [LIST FRONTEND ISSUES: components, state, performance, etc.]
       After fixes, run relevant unit and E2E tests. Report results."
   ```

   **DO NOT fix code yourself. WAIT for ALL agents to return.**

2. Once agents return, verify all tests pass.

3. If tests fail, launch additional agents to fix failures (same domain split).

4. Present final test results to user.

**When complete**: Proceed to Phase 12.

---

## Phase 12 of 12: Summary

**Phase 12 of 12: Summary**
Next: Done!
Agents: None (Orchestrator summarizes agent outputs)

**Goal**: Document what was accomplished

**Actions** (This is the ONLY phase where you work directly):

1. Mark all todos complete.

2. Synthesize all agent outputs into a comprehensive summary:

   **What Was Built**:
   - Architecture approach chosen (from Phase 6)
   - Backend components (from Phase 7)
   - Frontend components (from Phase 8)
   - Integration (from Phase 9)

   **Key Design Decisions**:
   - Selected approach and rationale
   - Trade-offs made
   - Discoveries that influenced design

   **Files Created/Modified**:
   - Backend files (from feature-writer outputs)
   - Frontend files (from feature-writer outputs)

   **Test Results**:
   - Tests passing? (from Phase 11)
   - Issues found & fixed (from Phase 10-11)

3. Suggest next steps:
   - Deployment considerations
   - Monitoring setup
   - Future enhancements
   - Technical debt to address

**When complete**: Feature development finished!

---

## Agent Reference (4 Active Agents)

All agents have access to ALL 19 skills for maximum flexibility.

### Discovery Agent
**code-explorer** (yellow, opus):
- Traces execution paths, maps architecture, understands patterns
- Tools: READ-ONLY (Glob, Grep, LS, Read, NotebookRead, WebFetch, TodoWrite, WebSearch)
- Used in: Phases 1-3

### Design Agent
**code-architect** (green, opus):
- Designs implementation blueprints with confident decisions
- **Modes**: Architecture Design (Phase 4), Synthesis (Phase 5)
- Tools: READ-ONLY
- Used in: Phases 4-5

### Implementation Agent
**feature-writer** (green, opus):
- Implements all approved designs across all stacks
- **Modes**: Backend, Frontend, Integration, Test Execution
- Tools: **WRITE** (Glob, Grep, Read, Edit, Write, Bash, TodoWrite)
- Used in: Phases 7-9, 11

### Quality Agent
**code-reviewer** (red, opus):
- Reviews with confidence >= 80 filter
- **Checklists**: Frontend Performance, Test Quality
- Tools: READ-ONLY
- Used in: Phase 10

---

## Skills Available (19 Total)

### Architecture & API Design
- **architecture-patterns**: Clean Architecture, Hexagonal, DDD
- **api-design-principles**: REST/GraphQL patterns, pagination, error handling
- **microservices-patterns**: Saga, Circuit Breaker, Event Bus

### JavaScript/TypeScript
- **typescript-advanced-types**: Generics, conditional types, mapped types, template literals
- **modern-javascript-patterns**: ES6+, async/await, functional programming
- **javascript-testing-patterns**: Jest, Vitest, Testing Library, mocking, integration tests
- **nodejs-backend-patterns**: Express, Fastify, middleware, auth, database patterns

### Python
- **async-python-patterns**: asyncio, aiohttp, concurrent programming
- **python-packaging**: pyproject.toml, distribution, modern packaging
- **python-performance-optimization**: Profiling, caching, optimization techniques
- **python-testing-patterns**: pytest, fixtures, mocking, property-based testing
- **uv-package-manager**: Fast package management, virtual environments

### Frontend
- **nextjs-app-router-patterns**: Server Components, App Router, streaming
- **react-state-management**: Zustand, Jotai, React Query, Redux Toolkit
- **tailwind-design-system**: Design tokens, theming, component patterns
- **frontend-design**: Distinctive UI design, avoiding generic aesthetics

### Mobile
- **react-native-architecture**: New Architecture, Expo, cross-platform patterns

### Performance
- **memory-leak-detector**: Memory leak detection and remediation
- **bottleneck-detector**: Performance bottleneck identification
