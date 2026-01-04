---
description: Context compiler - intake task, ask questions, create YAML capsule for handoff
argument-hint: <task-description>
---

# /phase0 - The Context Compiler

**Purpose**: Intake a task, understand it deeply, create a machine-readable capsule that other plugins can consume.

**Philosophy**: "Don't make me re-explain everything" - capsules persist context across sessions.

---

## Input

Task description: $ARGUMENTS

---

## Phase 1: Read Context (if exists)

```bash
# Check for existing context files
[ -f "patterns.yaml" ] && echo "patterns.yaml: found" || echo "patterns.yaml: not found"
[ -f "ARCHITECTURE.md" ] && echo "ARCHITECTURE.md: found" || echo "ARCHITECTURE.md: not found"
ls -la /.phase0/capsules/ 2>/dev/null | head -5 || echo "No existing capsules"
```

If patterns.yaml exists, read and summarize key constraints.
If ARCHITECTURE.md exists, note its age and compliance status.

---

## Phase 2: Restatement & Classification

Restate the task in Claude's words:

```
## My Understanding

[Restate what the user is asking for in 2-3 sentences]

**Goal**: [One sentence goal]
**Success looks like**: [Concrete outcome]
**This is NOT**: [What we're explicitly avoiding]

**Work Classification**:
- [ ] ML Work: [yes/no] - [brief description if yes]
- [ ] Dev Work: [yes/no] - [brief description if yes]
```

**ML/MLOps Detection** (→ ml-flow capsule):
- Model architecture (heads, layers, encoders, attention, embeddings)
- Training (trainers, loss functions, optimizers, schedulers, epochs, gradients)
- Inference (prediction pipelines, model serving, batching)
- Feature engineering (feature schemas, transformations, normalization)
- Tokenization, vocabularies, embeddings
- ML testing/validation (gauntlet, model tests, overfit tests)
- Experiment tracking (MLflow, W&B, TensorBoard)
- Data loading (datasets, dataloaders, samplers)
- Model registry, checkpoints, serialization
- ML pipelines, feature stores, data versioning
- Anything with tensors, gradients, backprop

**Dev Detection** (→ dev-flow capsule):
- APIs, frontend, backend, database, infrastructure
- Business logic, authentication, configuration
- Scripts, documentation, migrations
- **Everything else / default if unsure**

Wait for user confirmation before proceeding.

---

## Phase 3: Clarifying Questions

Use AskUserQuestion to gather essential details. Ask 2-4 questions max:

**Typical questions**:
1. Scope: Full-stack / API-only / Frontend-only / Other?
2. Testing: Unit only / Unit + Integration / Full coverage?
3. Integration: New feature / Extends existing / Replaces existing?
4. Priority: What's the most important aspect?

Store answers for capsule.

---

## Phase 4: Context Scanning (Internal Agents)

Launch scanning in background (internal, not exposed):

1. **File scan**: Find files related to task keywords
2. **Import trace**: Map dependencies in relevant area
3. **Pattern check**: Compare against patterns.yaml rules
4. **Boundary check**: Identify any layer violations

Synthesize findings into:
- Critical files to read
- Conventions to follow
- Risks identified
- Integration points

---

## Phase 4.5: Deep Online Research (Optional)

**MANDATORY**: After Phase 4 completes, you MUST ask the user:

```
Would you like me to orchestrate deep online research?

This will launch 3 parallel research agents to gather:
- BREADTH: Survey the topic landscape, find alternatives and sources
- DEPTH: Technical deep-dives, code examples, trade-offs
- PATTERNS: Best practices, anti-patterns, industry standards

[Yes / No]
```

### If User Says YES

**CRITICAL RULES:**
1. You MUST launch EXACTLY 3 agents in parallel (not 1, not 2, EXACTLY 3)
2. You MUST use the Task tool with `subagent_type: "phase0:deep-researcher"`
3. All 3 agents MUST be launched in a SINGLE message (parallel execution)
4. You MUST wait for ALL 3 to complete before proceeding

**Launch the 3 agents with these prompts:**

#### Agent 1: BREADTH (Discovery)
```
Focus Area: BREADTH

Research topic: [task from Phase 2]
Context from Phase 3 answers: [relevant answers]
Codebase context from Phase 4: [relevant findings]

Your job: Survey the entire landscape of this topic.
- Find all relevant approaches and alternatives
- Identify diverse sources (docs, blogs, repos, forums)
- Map the ecosystem of solutions
- Return structured YAML findings
```

#### Agent 2: DEPTH (Technical)
```
Focus Area: DEPTH

Research topic: [task from Phase 2]
Context from Phase 3 answers: [relevant answers]
Codebase context from Phase 4: [relevant findings]

Your job: Deep dive into technical implementation.
- Find code examples and tutorials
- Analyze architectural patterns
- Document trade-offs and constraints
- Return structured YAML findings
```

#### Agent 3: PATTERNS (Best Practices)
```
Focus Area: PATTERNS

Research topic: [task from Phase 2]
Context from Phase 3 answers: [relevant answers]
Codebase context from Phase 4: [relevant findings]

Your job: Research best practices and patterns.
- Find design patterns applicable to this task
- Identify anti-patterns to avoid
- Document industry standards
- Return structured YAML findings
```

### Synthesis After All 3 Complete

Once all 3 agents return, synthesize their outputs into:

```yaml
research:
  breadth:
    sources_found: [count]
    key_alternatives:
      - "[alternative 1]"
      - "[alternative 2]"
    landscape_summary: "[2-3 sentences]"

  depth:
    code_examples_found: [count]
    key_patterns:
      - pattern: "[pattern name]"
        applicability: "[how it applies]"
    trade_offs:
      - "[trade-off 1]"
      - "[trade-off 2]"

  patterns:
    best_practices:
      - "[practice 1]"
      - "[practice 2]"
    anti_patterns:
      - "[anti-pattern to avoid]"
    industry_standards:
      - "[standard]"

  confidence: "[high|medium|low]"
  gaps:
    - "[area needing more research]"
```

Add this `research` section to the capsule(s) in Phase 5.

### If User Says NO

Skip directly to Phase 5: Create Capsule(s).

---

## Phase 5: Create Capsule(s)

Based on Phase 2 classification, create **up to 2 capsules**:

### If ML Work Detected → Create ML Capsule

Create `/.phase0/capsules/<slug>-ml/capsule.yaml`:

```yaml
# Auto-generated by /phase0 - DO NOT EDIT MANUALLY
version: "1.0"
created: "YYYY-MM-DDTHH:MM:SSZ"
slug: "<task-slug>-ml"
type: "ml"

goal: |
  [ONLY the ML-related portions of the task]

non_goals:
  - [Non-ML work - handled in dev capsule]
  - [Explicit ML scope boundaries]

constraints:
  - [ML-specific constraints]
  - [From patterns.yaml if applicable]

success_criteria:
  - tests_pass: true
  - gauntlet_pass: true  # ML-specific
  - files_created:
      - [model files]
      - [training files]
  - no_regressions: true

context:
  patterns_path: "patterns.yaml"
  architecture_path: "ARCHITECTURE.md"
  key_files:
    - path: "[model file]"
      reason: "[why it matters]"

questions:
  decisions_made:
    - question: "[ML-related question]"
      answer: "[answer]"
  open_questions: []

handoff:
  recommended_command: "/ml-flow"
  args: "--capsule <slug>-ml"
  reasoning: "Contains ML/MLOps work"
  counterpart_capsule: "<slug>-dev"  # or null if no dev work

risks:
  - severity: "high|medium|low"
    description: "[ML-specific risk]"
    mitigation: "[how to handle]"

# Only included if Phase 4.5 was run
research:
  breadth:
    sources_found: [count]
    key_alternatives: ["[alt1]", "[alt2]"]
    landscape_summary: "[summary]"
  depth:
    code_examples_found: [count]
    key_patterns: [{pattern: "[name]", applicability: "[how]"}]
    trade_offs: ["[tradeoff1]"]
  patterns:
    best_practices: ["[practice1]"]
    anti_patterns: ["[antipattern1]"]
    industry_standards: ["[standard1]"]
  confidence: "[high|medium|low]"
```

### If Dev Work Detected → Create Dev Capsule

Create `/.phase0/capsules/<slug>-dev/capsule.yaml`:

```yaml
# Auto-generated by /phase0 - DO NOT EDIT MANUALLY
version: "1.0"
created: "YYYY-MM-DDTHH:MM:SSZ"
slug: "<task-slug>-dev"
type: "dev"

goal: |
  [ONLY the non-ML portions of the task]

non_goals:
  - [ML work - handled in ml capsule]
  - [Explicit dev scope boundaries]

constraints:
  - [Dev-specific constraints]
  - [From patterns.yaml if applicable]

success_criteria:
  - tests_pass: true
  - files_created:
      - [API files]
      - [frontend files]
  - no_regressions: true

context:
  patterns_path: "patterns.yaml"
  architecture_path: "ARCHITECTURE.md"
  key_files:
    - path: "[API/frontend file]"
      reason: "[why it matters]"

questions:
  decisions_made:
    - question: "[dev-related question]"
      answer: "[answer]"
  open_questions: []

handoff:
  recommended_command: "/dev-flow"
  args: "--capsule <slug>-dev"
  reasoning: "Contains API/frontend/infrastructure work"
  counterpart_capsule: "<slug>-ml"  # or null if no ML work

risks:
  - severity: "high|medium|low"
    description: "[dev-specific risk]"
    mitigation: "[how to handle]"
```

### Single Capsule Cases

- **ML only**: Create only `<slug>-ml/capsule.yaml`, set `counterpart_capsule: null`
- **Dev only**: Create only `<slug>-dev/capsule.yaml`, set `counterpart_capsule: null`
- **Unsure**: Default to dev capsule

Ensure directories exist:
```bash
mkdir -p /.phase0/capsules/<slug>-ml 2>/dev/null
mkdir -p /.phase0/capsules/<slug>-dev 2>/dev/null
```

---

## Phase 6: Handoff

Present capsule summary and recommend next steps:

```
## Capsule(s) Created

┌─────────────────────────────────────────────────────────┐
│ ML CAPSULE (if created)                                 │
│ /.phase0/capsules/<slug>-ml/capsule.yaml                │
│ ├── Goal: [ML-specific goal summary]                    │
│ ├── Success criteria: [count] items                     │
│ ├── Key files: [count] identified                       │
│ ├── Risks: [count] ([high count] high)                  │
│ └── Run: /ml-flow --capsule <slug>-ml                   │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ DEV CAPSULE (if created)                                │
│ /.phase0/capsules/<slug>-dev/capsule.yaml               │
│ ├── Goal: [Dev-specific goal summary]                   │
│ ├── Success criteria: [count] items                     │
│ ├── Key files: [count] identified                       │
│ ├── Risks: [count] ([high count] high)                  │
│ └── Run: /dev-flow --capsule <slug>-dev                 │
└─────────────────────────────────────────────────────────┘

EXECUTION ORDER (if both capsules exist):
1. /ml-flow --capsule <slug>-ml   ← ML work first (model must exist)
2. /dev-flow --capsule <slug>-dev ← Then integrate with API/frontend

[Or ask questions if anything is unclear]
```

**Single Capsule Output**: If only one capsule was created, show only that box.

---

## Writes (ONLY these locations)

- `/.phase0/capsules/<slug>-ml/capsule.yaml` (ML capsule, if ML work)
- `/.phase0/capsules/<slug>-ml/notes.md` (optional)
- `/.phase0/capsules/<slug>-dev/capsule.yaml` (Dev capsule, if dev work)
- `/.phase0/capsules/<slug>-dev/notes.md` (optional)

**NEVER writes to**: `_templates/`, `patterns.yaml`, `ARCHITECTURE.md`, source code

---

## Cost

| Phase | Model | Estimated Cost |
|-------|-------|----------------|
| Scanning (Phase 4) | Haiku×4 | ~$0.02 |
| Deep Research (Phase 4.5) | Haiku×3 | ~$0.03 (optional) |
| Synthesis | Opus | ~$0.03 |
| **Total (without research)** | | **~$0.05** |
| **Total (with research)** | | **~$0.08** |
