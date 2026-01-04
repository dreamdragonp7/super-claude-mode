---
description: "4-phase PR review workflow with parallel agents and phase0 handoff"
argument-hint: "[review-aspects]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]
---

# PR-FLOW: 4-Phase PR Review Workflow

Run a comprehensive pull request review using multiple specialized agents across 4 phases, with parallel agent execution and phase0 handoff.

**Review Aspects (optional):** "$ARGUMENTS"

---

## MANDATORY ORCHESTRATION RULES

**READ THESE RULES BEFORE STARTING. VIOLATION IS NOT ALLOWED.**

1. **Orchestrator does NOT review code directly**
   - NO deep analysis via Grep/Read as orchestrator
   - Orchestrator's job: gather minimal context → launch subagents → merge results → present report
   - If you find yourself reading file contents to analyze code, STOP - launch an agent instead

2. **Every phase uses Task tool**
   - Subagent type format: `subagent_type: "pr-flow:<agent-name>"`
   - Example: `subagent_type: "pr-flow:code-reviewer"`

3. **Parallelism is MANDATORY where specified**
   - Phase 2: Launch 3 agents in ONE message (parallel)
   - Phase 3: Launch 2-3 agents in ONE message (parallel)
   - Use multiple Task tool calls in a single response

4. **Phase Announcements**
   - Start each phase with: **Phase X of 4: [Phase Name]**
   - Continue through ALL phases without stopping
   - No confirmation requests between phases

5. **Agent Results**
   - Wait for ALL agents in a phase to complete before proceeding
   - Aggregate findings, remove duplicates, categorize by severity

---

## Available Review Aspects

- **comments** - Analyze code comment accuracy and maintainability
- **tests** - Review test coverage quality and completeness
- **errors** - Check error handling for silent failures
- **types** - Analyze type design and invariants
- **code** - General code review for project guidelines
- **all** - Run all applicable reviews (default)

---

## Pre-Phase: patterns.yaml Check

**Before Phase 1, silently check for project context:**

1. Use Glob to check if `patterns.yaml` exists in the project root
2. **If found**: Read it, note boundaries, anti_patterns, source_of_truth
3. Check for `ARCHITECTURE.md` and read if exists
4. Briefly mention: "Using patterns.yaml for project conventions." or "No patterns.yaml found."

**Then proceed immediately to Phase 1.**

---

## Phase 1 of 4: PR Context Setup

> **Current**: Phase 1 - PR Context Setup
> **Goal**: Understand what we're reviewing

**Orchestrator Actions (NO code analysis here):**

1. Run `git diff --name-only` to get changed files
2. Run `git diff --stat` for change summary
3. Run `git status` for unstaged changes
4. Check for PR: `gh pr view` (if exists)
5. Categorize files by area:
   - Backend: `apps/api/`, `core/`, `infrastructure/`
   - Frontend: `apps/web/`, `apps/mobile/`
   - Tests: `tests/`, `**/test_*`, `**/*.test.*`
   - Config: `*.json`, `*.yaml`, `*.toml`
   - Docs: `*.md`, `docs/`
6. Generate risk hints based on paths:
   - "touches auth" if auth files changed
   - "touches migrations" if DB files changed
   - "touches API" if endpoint files changed
   - "touches ML" if model files changed

**Output:**
- Changed files list with categories
- Risk hints
- Review focus areas

**Then proceed to Phase 2.**

---

## Phase 2 of 4: Diff-Only Surface Scan

> **Current**: Phase 2 - Diff-Only Surface Scan
> **Goal**: Find possible issues in CHANGED code only

**Launch 3 agents IN PARALLEL using Task tool:**

| Agent | Lens | Prompt Focus |
|-------|------|--------------|
| `code-reviewer` | Bugs/Security/Correctness | Review diff for logic errors, security issues, CLAUDE.md violations |
| `type-design-analyzer` | Types/Contracts | Review diff for type safety, API shapes, invariant violations |
| `silent-failure-hunter` | Error Handling | Review diff for silent failures, swallowed errors, missing validation |

**Agent Prompt Template (include for each):**
```
## PHASE 2 INSTRUCTIONS

You are a FIRST-PASS reviewer. Your job is to FLAG possible issues, not to be perfect.

**Scope:** ONLY the changed code (git diff). Do NOT follow into unchanged files yet.

**Mindset:** Cast a wide net. If something looks off, flag it. Later phases will investigate deeper.

**Git diff to review:**
[Include git diff output here]

**Output Format:**
For each issue found:
- Severity: 🔴 [blocking] / 🟡 [important] / 🟢 [nit] / 💡 [suggestion]
- File:line reference
- Brief description
- Why it matters (1 sentence)

If no issues found, state "No issues found in [your focus area]."
```

**After all 3 agents return:**
- Aggregate findings
- Remove duplicates
- Group by file

**Then proceed to Phase 3.**

---

## Phase 3 of 4: Rabbit-Hole Investigation

> **Current**: Phase 3 - Rabbit-Hole Investigation
> **Goal**: Follow implications into UNCHANGED code

**Inputs to agents:**
- The diff from Phase 1
- Phase 2 aggregated findings
- patterns.yaml (if exists)
- ARCHITECTURE.md (if exists)

**Launch 2-3 agents IN PARALLEL using Task tool:**

| Agent | Lens | Prompt Focus |
|-------|------|--------------|
| `root-cause-analyzer` | Impact Tracing | Trace what this change AFFECTS downstream. Call graph, dependencies. |
| `pr-test-analyzer` | Test Implications | What tests should run? What's missing? Coverage gaps. |
| `fix-validator` (optional) | Contract Verification | If we merge this, what else needs verification? |

**Agent Prompt Template (include for each):**
```
## PHASE 3 INSTRUCTIONS

You are a DEEP investigator. Phase 2 flagged possible issues. Your job is to FOLLOW THE RABBIT HOLE.

**Scope:** You CAN traverse into unchanged code that is AFFECTED by the changes.

**Phase 2 Findings:**
[Include aggregated Phase 2 findings here]

**Focus Areas:**
1. Ripple effects: What downstream code breaks?
2. Contract mismatches: Types, API shapes, DB assumptions
3. Hidden failure modes: Race conditions, silent fails
4. "If this changes, these areas must be re-verified" list

**Output Format:**
For each finding:
- Severity: 🔴 [critical] / 🟡 [high] / 🟢 [medium]
- Location: file:line (can be in unchanged code)
- Issue: What's wrong
- Evidence: Why you believe this
- Recommendation: What to check/fix
```

**After all agents return:**
- Synthesize findings
- Map ripple effects
- Identify verification needs

**Then proceed to Phase 4.**

---

## Phase 4 of 4: Phase0 Handoff

> **Current**: Phase 4 - Phase0 Handoff
> **Goal**: Create summary and recommend phase0 for fix capsule

**Orchestrator Actions:**

1. Compile Phase 2 + Phase 3 findings
2. Prioritize by severity (🔴 → 🟡 → 🟢)
3. Group by file/area
4. Present final report

**Output Format:**

```markdown
# PR Review Complete

## Summary
- **Files Changed:** X files across Y areas
- **Risk Level:** High/Medium/Low
- **Review Focus:** [areas reviewed]

## Critical Issues (🔴)
| # | File:Line | Issue | Suggested Fix |
|---|-----------|-------|---------------|
| 1 | | | |

## Important Issues (🟡)
| # | File:Line | Issue | Suggested Fix |
|---|-----------|-------|---------------|
| 1 | | | |

## Suggestions (🟢💡)
| # | File:Line | Issue | Suggested Fix |
|---|-----------|-------|---------------|
| 1 | | | |

## Ripple Effects
- **Affected Modules:** [list]
- **Verification Needed:** [areas to re-test]

## Test Notes
- **Run These Tests:** [list]
- **Missing Tests:** [suggested additions]

## Positive Observations
[What's well-done in this PR]

---

**Ready to create fixes?**

Run: `/phase0 Fix PR issues: [brief summary of issues]`

This creates a capsule for handoff to `/dev-flow` or `/bug-hunt:bug-hunt`.
```

---

## Agent Reference (9 READ-ONLY Agents)

| Agent | Focus | Skills |
|-------|-------|--------|
| code-reviewer | Bugs, security, CLAUDE.md compliance | code-review-excellence, debugging-strategies |
| comment-analyzer | Comment accuracy, technical debt | code-review-excellence |
| silent-failure-hunter | Error handling, silent failures | error-handling-patterns, debugging-strategies |
| type-design-analyzer | Type design, invariants | code-review-excellence |
| pr-test-analyzer | Test coverage, gaps | e2e-testing-patterns, code-review-excellence |
| bug-explorer | Code tracing, architecture mapping | debugging-strategies, git-advanced-workflows |
| root-cause-analyzer | Impact tracing, hypothesis testing | debugging-strategies, error-handling-patterns |
| bug-fixer | Fix proposals (proposal-only) | code-review-excellence, error-handling-patterns |
| fix-validator | Regression checking, validation | code-review-excellence, debugging-strategies |

**All agents are READ-ONLY. No agent can modify code.**

---

## Usage Examples

**Full review (default):**
```
/pr-flow:pr-flow
```

**Specific aspects:**
```
/pr-flow:pr-flow tests errors
/pr-flow:pr-flow comments
```

---

## Tips

- **Run early**: Before creating PR, not after
- **Focus on changes**: Agents analyze git diff by default
- **Address critical first**: Fix high-priority issues before lower priority
- **Re-run after fixes**: Verify issues are resolved
- **Use phase0 for fixes**: Creates a capsule for structured fix implementation
