---
description: Guided bug hunting with codebase exploration, root cause analysis, and fix validation
argument-hint: Optional bug description
---

# Bug Hunting

You are helping a developer find and fix a bug. Follow a systematic approach: understand the bug report, explore the codebase, find the root cause, design a fix, implement it, and validate.

## Execution Rule

At the START of each phase, ALWAYS announce:

**Phase X of 7: [Phase Name]**
Next: Phase Y - [Next Phase Name]

Then proceed with the phase actions. This helps track progress through the workflow.

---

## Core Principles

- **Ask clarifying questions**: Identify ambiguities in the bug report. Ask for steps to reproduce, expected vs. actual behavior, and any relevant logs or error messages.
- **Understand before acting**: Read and comprehend existing code before attempting a fix.
- **Read files identified by agents**: Use agents to find important files, then read them to build context.
- **Simple and safe fixes**: Prioritize fixes that are easy to understand and have minimal side effects.
- **Leave no stone unturned**: Address ALL confirmed issues regardless of complexity. Never defer or skip issues because they seem difficult, risky, or time-consuming. Every issue gets fixed.
- **Use TodoWrite**: Track all progress throughout.
- **Follow patterns.yaml**: Respect project boundaries and conventions when fixing.

---

## Pre-Phase: patterns.yaml Check

**Before Phase 1, silently check for patterns.yaml**:

1. Use Glob to check if `patterns.yaml` exists in the project root.

2. **If found**:
   - Read it to understand project structure
   - Note `boundaries` for understanding import rules
   - Note `anti_patterns` that might be relevant to the bug
   - Note `source_of_truth` files for key contracts
   - Briefly mention: "Using patterns.yaml for project conventions."

3. **If not found**:
   - Continue without it
   - Briefly mention: "No patterns.yaml found."

4. Check if ARCHITECTURE.md exists - read for current reality snapshot.

**Then proceed immediately to Phase 1.**

---

## Phase 1 of 7: Bug Report Analysis

> **Current**: Phase 1 - Bug Report Analysis
> **Next**: Phase 2 - Codebase Exploration

**Goal**: Understand WHAT the bug is (not WHERE in the code - that's Phase 2)

**IMPORTANT**: This phase is about understanding the bug DESCRIPTION only. Do NOT read files, do NOT explore code, do NOT launch agents. Just gather information about what needs to be fixed.

Initial request: $ARGUMENTS

**Actions**:

1. Create a todo list with all phases.

2. **Get the bug description** (check in this order):

   **A) Arguments provided?** → Use `$ARGUMENTS` as the bug report.

   **B) No arguments?** → Check the conversation history above for issues.

   The conversation may contain:
   - Issue lists from pr-review (Critical, Important, Suggestions)
   - File:line references to problems
   - Error messages or stack traces
   - Any structured list of problems

   If you find issues above → Extract them as your bug list, announce what you found, proceed.
   Example: "I found 3 issues from the review above: [list them]. Proceeding."

   **C) No arguments AND nothing useful above?** → Ask the user:
   - What's the bug?
   - Steps to reproduce?
   - Expected vs actual behavior?
   - Any error messages?

3. Summarize the bug(s) you'll be hunting. Confirm with user.

**Phase 1 Output** (pass to Phase 2):
- Clear list of bug(s) to investigate
- Any file:line hints from the bug report (but don't read them yet)
- Severity if known

**When complete**: Proceed to Phase 2 with your bug list.

---

## Phase 2 of 7: Codebase Exploration

> **Current**: Phase 2 - Codebase Exploration
> **Next**: Phase 3 - Root Cause Analysis

**Goal**: Understand the relevant parts of the code

**Actions**:
1. Launch 2-3 `code-explorer` agents in parallel. Each agent should:
   - Trace through the code related to the bug report.
   - Target different aspects (e.g., the specific feature, error handling, data flow).
   - Return a list of 5-10 key files to read.

   **Example agent prompts**:
   - "Explore the code related to [feature with bug] to understand its implementation."
   - "Analyze the error handling and logging in the area of [bug location]."
   - "Trace the data flow for [action that causes bug]."

2. Once the agents return, read all identified files to build a deep understanding.
3. Present a summary of your findings.

**When complete**: Proceed to Phase 3.

---

## Phase 3 of 7: Root Cause Analysis

> **Current**: Phase 3 - Root Cause Analysis
> **Next**: Phase 4 - Solution Design

**Goal**: Pinpoint the exact cause of the bug

**Actions**:
1. Launch 2-3 `root-cause-analyzer` agents in parallel. Each agent should:
   - Form a hypothesis about the bug's cause.
   - Dig through the code, logs, and your understanding to prove or disprove the hypothesis.
   - Provide a clear explanation of the root cause with evidence (file paths, line numbers).

   **Example agent prompts**:
   - "Hypothesis: The bug is caused by a race condition in [file.js]. Investigate the async operations."
   - "Hypothesis: A null check is missing in [function]. Analyze the function's inputs and call sites."
   - "Hypothesis: The configuration for [module] is incorrect. Examine the config files and how they are used."

2. Review the analyses and identify the most likely root cause.
3. Present the root cause to the user and get their confirmation.

**When complete**: Proceed to Phase 4.

---

## Phase 4 of 7: Solution Design

> **Current**: Phase 4 - Solution Design
> **Next**: Phase 5 - Implementation

**Goal**: Propose a clean and effective fix

**Actions**:
1. Launch 1-2 `bug-fixer` agents. Each agent should:
   - Propose a specific, minimal code change to fix the root cause.
   - Explain why the fix works and consider potential side effects.
   - Provide the exact code to be changed.

2. Review the proposed fixes.
3. Present the best fix to the user, explaining the change and its implications.
4. **Ask the user for approval before implementing.**

**IMPORTANT**: Design fixes for ALL confirmed issues from Phase 3. Do NOT propose to defer, skip, or de-prioritize any issues due to complexity, risk, or effort. Every confirmed issue gets a fix proposal.

**When complete**: Proceed to Phase 5 (only after user approval).

---

## Phase 5 of 7: Implementation

> **Current**: Phase 5 - Implementation
> **Next**: Phase 6 - Validation

**Goal**: Apply the fix to the code

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:
1. Wait for explicit user approval.
2. Organize the approved fix by target files.
3. Launch 1-3 `bug-implementer` agents in parallel. Each agent should:
   - Receive the specific files it's responsible for
   - Receive the approved fix details for those files
   - Receive the root cause context
   - Implement the fix following codebase conventions
   - Run tests after editing (if tests exist in the project)
   - Return structured output with files modified, changes made, and test results

   **Example agent prompts**:
   - "Implement the fix in `src/auth/session.ts`: Add `await` before `validateToken()` on line 47. Root cause: race condition. Run tests after editing if available."
   - "Implement the fix in `src/api/handlers.ts` and `src/api/middleware.ts`: Add null check before accessing `user.id`. Root cause: undefined user object. Run tests after editing if available."

4. Review agent outputs and present results to user.
5. Update todos as agents complete.

**IMPORTANT**: Implement fixes for ALL approved issues. Do not selectively implement only the "easy" ones while skipping complex fixes.

**When complete**: Proceed to Phase 6.

---

## Phase 6 of 7: Validation

> **Current**: Phase 6 - Validation
> **Next**: Phase 7 - Summary

**Goal**: Ensure the fix works and doesn't introduce new bugs

**Actions**:
1. Launch 2-3 `fix-validator` agents in parallel with different focuses:
   - "Does the fix actually resolve the original bug? Try to find edge cases where it might fail."
   - "Does the fix introduce any regressions or new bugs in related areas?"
   - "Does the fix adhere to project conventions and good practices?"
2. Recommend writing a test case that reproduces the original bug and confirms the fix.
3. Consolidate findings and present them to the user.

**When complete**: Proceed to Phase 7.

---

## Phase 7 of 7: Summary

> **Current**: Phase 7 - Summary
> **Next**: Done!

**Goal**: Document what was accomplished

**Actions**:
1. Mark all todos complete.
2. Summarize:
   - The bug and its root cause.
   - The fix that was implemented.
   - Files modified.
   - Suggested next steps (e.g., deployment, further testing).

**When complete**: Bug hunt finished!

---
