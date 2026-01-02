---
description: Full pre-flight exploration - reads patterns.yaml, asks questions, generates boilerplate, creates task capsule
argument-hint: [task-description]
---

# Phase 0: Smart Pre-Flight

Phase 0 is the required first step before any major work. It ensures you have deep context before diving into implementation. This is where the planning depth happens.

**The rifle metaphor: Phase 0 loads the chamber. /dev-flow fires.**

---

## What Phase 0 Does (v3.0)

1. Restate task in Claude's words
2. Read patterns.yaml (what SHOULD exist)
3. Read ARCHITECTURE.md (what DOES exist)
4. Ask clarifying questions (CLI-style with checkboxes)
5. Launch Haiku scanners for task-specific context
6. Launch Opus synthesizer for risk analysis
7. Generate boilerplate files using Hygen (if templates exist)
8. Update patterns.yaml if this is a new feature type
9. Create task capsule
10. Tell user to run /dev-flow or /bug-hunt

---

## Step 1: Task Restatement

Initial request: $ARGUMENTS

**Actions:**

1. Restate the task in your own words
2. Identify what is being requested
3. Identify what success looks like
4. Note any ambiguities or assumptions

```
Let me restate what I understand:

[Your restatement of the task]

This likely involves:
- [Aspect 1]
- [Aspect 2]
- [Aspect 3]

Is this accurate?
```

Wait for user confirmation before proceeding.

---

## Step 2: Read patterns.yaml

Check if patterns.yaml exists:

```bash
if [ -f "patterns.yaml" ]; then echo "found"; else echo "not found"; fi
```

**If found:**
- Parse patterns.yaml
- Identify relevant feature types for this task
- Extract required files for that feature type

```
Reading patterns.yaml...

For a '[feature-type]' feature, patterns.yaml requires:
├── [file1] in [location1]
├── [file2] in [location2]
├── [file3] in [location3]
└── Tests in [test-location]

This feature will need approximately X files.
```

**If NOT found:**
- Inform user: "No patterns.yaml found."
- Offer: "Run `/planning sync` to auto-generate from codebase?"
- If user declines, continue without pattern enforcement

---

## Step 3: Read ARCHITECTURE.md

Check if ARCHITECTURE.md exists:

```bash
if [ -f "ARCHITECTURE.md" ]; then echo "found"; else echo "not found"; fi
```

**If found:**
- Check age (should be < 24 hours for accuracy)
- Extract relevant context for this task

```
Reading ARCHITECTURE.md (last updated: X hours ago)...

Current codebase context:
├── Similar features exist: [list]
├── Tech stack: [detected patterns]
├── Existing related code: [if any]
├── Test coverage: [estimate]%
└── Recent changes: [if relevant]
```

**If NOT found or stale:**
- Inform user: "No ARCHITECTURE.md found (or stale). Consider running /audit first."
- Offer to continue anyway

---

## Step 4: Ask Clarifying Questions

Use AskUserQuestion tool to gather requirements. Ask 2-4 questions with checkboxes:

**Question categories:**

1. **Scope/Type**: What kind of feature is this?
   - Full-stack (backend + frontend)
   - API-only (backend only)
   - Frontend-only
   - Other (describe)

2. **Requirements**: What specific requirements?
   - (Task-specific options based on feature type)

3. **Integration**: Where does this integrate?
   - New standalone feature
   - Extends existing feature
   - Replaces existing feature

4. **Testing**: What testing approach?
   - Unit tests only
   - Unit + integration tests
   - Full coverage (unit + integration + e2e)

**Wait for user answers before proceeding.**

---

## Step 5: Context Scanning (Haiku Agents)

Launch 3 Haiku agents IN PARALLEL for cheap scanning:

**1. file-scanner agent:**
Prompt: "Search for files related to [task]. Focus on:
- Similar existing features
- Integration points
- Related utilities and helpers
Return a categorized list of relevant files."

**2. import-tracer agent:**
Prompt: "Trace dependencies for the area where [task] will be implemented.
- What modules will this new code need to import?
- What existing code might need to import this?
Return the dependency context."

**3. test-finder agent:**
Prompt: "Find tests related to [task area].
- Existing test patterns to follow
- Test utilities available
- Coverage gaps in related areas
Return test context."

Wait for all agents to return.

---

## Step 6: Context Synthesis (Opus Agent)

Once Haiku agents return, launch **context-synthesizer** agent (Opus):

Prompt: "Synthesize the scanner results for [task]. Provide:

1. **Critical Files** (must read before implementing)
2. **Architecture Patterns** (conventions to follow)
3. **Risks and Concerns** (what could go wrong)
4. **Integration Points** (where this connects)
5. **Recommendations** (how to approach this)

Use the patterns.yaml rules as your guide for what files should be created."

Read the key files identified by the synthesizer.

---

## Step 7: Generate Boilerplate (Hygen)

Based on the selected feature type from Step 4 and patterns.yaml:

**Check for Hygen templates:**
```bash
ls _templates/
```

**If templates exist for this feature type:**

1. Determine the Hygen command from patterns.yaml's `hygen_mappings`
2. Present what will be generated:

```
Generating boilerplate files...

Based on '[feature-type]' pattern, will generate:

Running: npx hygen [generator] [action] --name [name]
├── [file1]
├── [file2]
├── [file3]
└── [file4]

Proceed? [Yes] [No] [Skip boilerplate]
```

3. If user approves, run Hygen commands:
```bash
npx hygen [generator] [action] --name [name]
```

4. Report generated files

**If no templates:**
- Note: "No Hygen templates for this feature type. Files will be created during /dev-flow."

---

## Step 8: Update patterns.yaml (If Needed)

If this is a NEW feature type not in patterns.yaml:

```
This appears to be a new feature type: '[type-name]'

Would you like to add it to patterns.yaml?
[Yes, add it] [No, proceed without]
```

If yes:
- Use AskUserQuestion to gather pattern details
- Add new feature type to patterns.yaml
- Confirm: "Added '[type-name]' feature type to patterns.yaml"

---

## Step 9: Create Task Capsule

Create a task capsule at `docs/taskcaps/YYYY-MM-DD-<slug>.md`:

```markdown
# Task: [Title]

## Goal
[What we're trying to achieve - from Step 1]

## Non-Goals
[What we're explicitly NOT doing - from clarifying questions]

## Feature Type
[From patterns.yaml or user selection]

## Relevant Files

### Generated (by /phase0)
[List files generated by Hygen, if any]

### Reference Files (read these first)
[From context-synthesizer - critical files to understand]

### Integration Points
[Where this connects to existing code]

## Plan
1. [ ] [Step from synthesis]
2. [ ] [Step from synthesis]
3. [ ] [Step from synthesis]
4. [ ] Run tests
5. [ ] Code review

## Risks
| Risk | Severity | Mitigation |
|------|----------|------------|
| [Risk 1] | [High/Medium/Low] | [How to mitigate] |
| [Risk 2] | [severity] | [mitigation] |

## Definition of Done
- [ ] All required files created per patterns.yaml
- [ ] Unit tests passing
- [ ] Integration tests passing (if applicable)
- [ ] No regressions in existing tests
- [ ] Code follows project conventions
- [ ] [Task-specific criteria]

## Progress
- [x] Task capsule created
- [x] Boilerplate generated (if applicable)
- [ ] Implementation started

## Blockers
None currently

## Notes
Created: [date]
Feature type: [type from patterns.yaml]
Patterns.yaml compliant: [yes/no]
```

Ensure `docs/taskcaps/` directory exists:
```bash
mkdir -p docs/taskcaps
```

---

## Step 10: Handoff

Present the task capsule summary and handoff:

```
📋 Task Capsule Created
───────────────────────────────────────

docs/taskcaps/[date]-[slug].md

SUMMARY
├── Goal: [brief goal]
├── Feature type: [type]
├── Files generated: [count or "none"]
├── Reference files: [count]
├── Plan steps: [count]
├── Risks identified: [count]
└── DoD criteria: [count]

PATTERNS.YAML STATUS
├── Feature type: [exists/new/none]
├── Required files: [count]
└── Templates available: [yes/no]

READY FOR IMPLEMENTATION.

Next:
• Run /dev-flow to start building
• Or /bug-hunt if this is a fix
───────────────────────────────────────
```

---

## Agent Reference

| Agent | Model | Purpose | Cost |
|-------|-------|---------|------|
| file-scanner | Haiku | CHEAP file finding | ~$0.005 |
| import-tracer | Haiku | CHEAP dependency tracing | ~$0.005 |
| test-finder | Haiku | CHEAP test discovery | ~$0.005 |
| context-synthesizer | Opus | Smart analysis of scan results | ~$0.05 |

**Total Phase 0 cost: ~$0.07**

---

## Skills Available

- **patterns-yaml**: Knowledge about patterns.yaml structure
- **phase0-guide**: This workflow guidance
- **task-capsules**: Capsule format and lifecycle
- **repo-atlas**: Documentation system knowledge
- **ultra-scientist**: Maximum enthusiasm mode

---

## Integration with Other Plugins

- **/dev-flow**: Reads task capsule, follows patterns.yaml
- **/bug-hunt**: Reads task capsule for bug context
- **/pr-review**: Checks code against patterns.yaml
- **/audit**: Verifies pattern compliance after work

---

## Why Phase 0 Exists

1. **Context doesn't persist** across sessions - capsules survive
2. **Diving in without mapping** leads to mistakes
3. **Cheap scanning (Haiku)** saves tokens for smart work (Opus)
4. **Patterns.yaml** ensures consistency across features
5. **Boilerplate generation** is FREE (Hygen) vs expensive (LLM)
