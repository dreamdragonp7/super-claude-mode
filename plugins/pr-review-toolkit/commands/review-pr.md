---
description: "Comprehensive PR review using specialized agents"
argument-hint: "[review-aspects]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]
---

# Comprehensive PR Review

Run a comprehensive pull request review using multiple specialized agents, each focusing on a different aspect of code quality.

**Review Aspects (optional):** "$ARGUMENTS"

## Execution Rule

At the START of each phase, ALWAYS announce:

**Phase X of 7: [Phase Name]**
Next: Phase Y - [Next Phase Name]

Then proceed with the phase actions. This helps track progress through the workflow.

---

## Available Review Aspects

- **comments** - Analyze code comment accuracy and maintainability
- **tests** - Review test coverage quality and completeness
- **errors** - Check error handling for silent failures
- **types** - Analyze type design and invariants (if new types added)
- **code** - General code review for project guidelines
- **simplify** - Simplify code for clarity and maintainability
- **all** - Run all applicable reviews (default)

---

## Phase 1 of 7: Scope Analysis

> **Current**: Phase 1 - Scope Analysis
> **Next**: Phase 2 - Agent Selection

**Goal**: Understand what to review

**Actions**:
1. Parse arguments to see if user requested specific review aspects
2. Run `git diff --name-only` to see modified files
3. Run `git status` to check for unstaged changes
4. Check if PR already exists: `gh pr view`
5. Identify file types in the changes

**When complete**: Proceed to Phase 2.

---

## Phase 2 of 7: Agent Selection

> **Current**: Phase 2 - Agent Selection
> **Next**: Phase 3 - Launch Agents

**Goal**: Determine which agents apply based on changes

**Actions**:
1. Review the changed files from Phase 1
2. Select applicable agents:
   - **Always**: `code-reviewer` (general quality)
   - **If test files changed**: `pr-test-analyzer`
   - **If comments/docs added**: `comment-analyzer`
   - **If error handling changed**: `silent-failure-hunter`
   - **If types added/modified**: `type-design-analyzer`
   - **If user requested simplify**: `code-simplifier`
3. Check if user requested specific aspects (override auto-detection)
4. Check if user requested parallel execution
5. Present the agents that will run and confirm with user

**When complete**: Proceed to Phase 3.

---

## Phase 3 of 7: Launch Agents

> **Current**: Phase 3 - Launch Agents
> **Next**: Phase 4 - Aggregate Results

**Goal**: Run the selected review agents

**Actions**:
1. Launch agents based on user preference:

   **Sequential approach** (default):
   - Launch one agent at a time
   - Wait for completion before next
   - Good for interactive review

   **Parallel approach** (if user requested):
   - Launch all agents simultaneously
   - Faster for comprehensive review

2. Each agent receives:
   - The git diff or changed files
   - The scope of review
   - Project context (CLAUDE.md if exists)

3. Wait for all agents to complete

**When complete**: Proceed to Phase 4.

---

## Phase 4 of 7: Aggregate Results

> **Current**: Phase 4 - Aggregate Results
> **Next**: Phase 5 - Action Plan

**Goal**: Collect and organize findings from all agents

**Actions**:
1. Gather reports from all completed agents
2. Categorize findings by severity:
   - **Critical Issues** (must fix before merge)
   - **Important Issues** (should fix)
   - **Suggestions** (nice to have)
   - **Positive Observations** (what's good)
3. De-duplicate any overlapping findings
4. Note which agent found each issue

**When complete**: Proceed to Phase 5.

---

## Phase 5 of 7: Action Plan

> **Current**: Phase 5 - Action Plan
> **Next**: Phase 6 - User Decision

**Goal**: Present prioritized issues to user

**Actions**:
1. Present the organized findings:
   ```
   # PR Review Summary

   ## Critical Issues (X found)
   - [agent-name]: Issue description [file:line]

   ## Important Issues (X found)
   - [agent-name]: Issue description [file:line]

   ## Suggestions (X found)
   - [agent-name]: Suggestion [file:line]

   ## Strengths
   - What's well-done in this PR
   ```

2. Highlight the most important issues to address first
3. Provide specific file:line references for each issue

**When complete**: Proceed to Phase 6.

---

## Phase 6 of 7: User Decision

> **Current**: Phase 6 - User Decision
> **Next**: Phase 7 - Summary

**Goal**: Determine next steps with user

**Actions**:
1. Ask the user how they want to proceed:
   - **Fix manually**: User will fix issues themselves
   - **Get help**: Use bug-hunt or other tools to fix specific issues
   - **Re-run specific review**: Run targeted review on specific aspect
   - **Run code-simplifier**: Polish code after fixing issues
   - **Done**: No more changes needed

2. If user wants to re-run after fixes:
   - Go back to Phase 1 with updated scope
   - Focus only on previously identified issues

**When complete**: Proceed to Phase 7.

---

## Phase 7 of 7: Summary

> **Current**: Phase 7 - Summary
> **Next**: Done!

**Goal**: Document review completion

**Actions**:
1. Summarize what was reviewed
2. List agents that ran
3. Recap issues found and their status
4. Note any remaining issues
5. Recommend next steps (create PR, run more reviews, etc.)

**When complete**: PR review finished!

---

## Agent Reference

**code-reviewer**:
- Checks CLAUDE.md compliance
- Detects bugs and issues
- Reviews general code quality
- Confidence threshold: 80+

**comment-analyzer**:
- Verifies comment accuracy vs code
- Identifies comment rot
- Checks documentation completeness

**silent-failure-hunter**:
- Finds silent failures
- Reviews catch blocks
- Checks error logging
- Severity: CRITICAL/HIGH/MEDIUM

**type-design-analyzer**:
- Analyzes type encapsulation
- Reviews invariant expression
- Rates type design quality (1-10 scales)

**pr-test-analyzer**:
- Reviews behavioral test coverage
- Identifies critical gaps
- Rates criticality 1-10

**code-simplifier**:
- Simplifies complex code
- Improves clarity and readability
- Applies project standards
- **NOTE**: This agent can WRITE/EDIT code

---

## Usage Examples

**Full review (default):**
```
/pr-review-toolkit:review-pr
```

**Specific aspects:**
```
/pr-review-toolkit:review-pr tests errors
/pr-review-toolkit:review-pr comments
/pr-review-toolkit:review-pr simplify
```

**Parallel review:**
```
/pr-review-toolkit:review-pr all parallel
```

---

## Tips

- **Run early**: Before creating PR, not after
- **Focus on changes**: Agents analyze git diff by default
- **Address critical first**: Fix high-priority issues before lower priority
- **Re-run after fixes**: Verify issues are resolved
- **Use specific reviews**: Target specific aspects when you know the concern
