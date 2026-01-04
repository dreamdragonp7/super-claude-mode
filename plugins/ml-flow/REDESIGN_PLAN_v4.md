# ML-Flow v4.0 Redesign Plan

**Created**: 2026-01-04
**Status**: HANDOFF TO NEW CHAT
**Previous Chat**: Extensive discussion about agent permissions and phase structure

---

## CRITICAL CONTEXT

We spent a long conversation figuring out:
1. Design phases (1-6) = READ-ONLY agents only
2. Implementation phases (7-11) = WRITE-ENABLED agents only
3. ML ≠ MLOps (different domains, different implementers)
4. ml-writer was a hollow shell with no knowledge - DELETE IT

---

## FINAL AGENT STRUCTURE (6 agents)

| Agent | Role | Tools | Domain |
|-------|------|-------|--------|
| ml-explorer | Explore codebase | **Read-only** | Discovery |
| **ml-architect** | Design model + training + infra strategy | **Read-only** | **ALL DESIGN** |
| data-scientist | Analysis, evaluation design, fact-check designs | **Read-only** | Data Science |
| ml-reviewer | Code review | **Read-only** | Review |
| **ml-engineer** | Implement ML code (model, training loop, losses) | **WRITE** | ML |
| **mlops-engineer** | Implement MLOps code (MLflow, pipelines, infra) | **WRITE** | MLOps |
| ~~ml-writer~~ | **DELETED** | - | - |

---

## THE NEW ml-architect AGENT

**CRITICAL**: ml-architect must be CREATED or heavily modified to include:
- Knowledge from ml-engineer (PyTorch, TBPTT, model architecture, training loops)
- Knowledge from mlops-engineer (MLflow, Kubeflow, pipelines, infrastructure)
- BUT written as a DESIGNER, not implementer
- Read-only tools only

This agent designs EVERYTHING:
- Model architecture (layers, attention, memory)
- Training strategy (loss, optimizer, schedule, TBPTT)
- Infrastructure strategy (which tools, what pipeline structure)

The IMPLEMENTATION is then done by:
- ml-engineer (ML code)
- mlops-engineer (MLOps code)

---

## FINAL 12 PHASES

| Phase | Name | Agents | Notes |
|-------|------|--------|-------|
| **1** | Problem Analysis | ml-explorer ×1-2 | Read-only |
| **2** | Data Architecture | ml-explorer ×2-3 (parallel) | Read-only |
| **3** | Risk Assessment | ml-explorer + data-scientist (parallel) | Read-only |
| **4** | Model Architecture | ml-architect ×3 (parallel) | Design model + training. Read-only |
| **5** | Infrastructure Design | ml-architect ×2 → data-scientist ×2 | **SEQUENTIAL**: architects design, then DS fact-checks |
| **6** | Design Approval | None | User must approve before implementation |
| **7** | Model Implementation | ml-engineer ×3 (parallel) | **WRITE-ENABLED** |
| **8** | Training/Infra Implementation | mlops-engineer ×3 (parallel) | **WRITE-ENABLED** |
| **9** | Integration | ml-engineer + mlops-engineer (parallel) | **WRITE-ENABLED** - each handles their domain |
| **10** | Quality Review | ml-reviewer ×3 (parallel) | Read-only |
| **11** | Fixes & Verification | ml-engineer + mlops-engineer (parallel) | **WRITE-ENABLED** - each fixes their domain |
| **12** | Summary | None | Orchestrator summarizes |

---

## PHASE 5 DETAIL (Important!)

Phase 5 is SEQUENTIAL, not parallel:

```
STEP 1: ml-architect ×2 (parallel)
  - Architect 1: Design experiment tracking strategy (MLflow vs W&B, etc.)
  - Architect 2: Design pipeline infrastructure (checkpointing, distributed, cloud)

STEP 2: data-scientist ×2 (parallel) - FACT CHECK
  - DS 1: Validate experiment tracking design makes sense statistically
  - DS 2: Validate evaluation strategy aligns with infrastructure
```

This ensures designs are reviewed before moving to approval.

---

## TODO FOR NEXT CHAT

### 1. DELETE ml-writer
```bash
rm ~/.claude/plugins/marketplaces/super-claude-mode/plugins/ml-flow/agents/ml-writer.md
```
Update plugin.json to remove ml-writer from agents list.

### 2. RESTORE ml-engineer WRITE CAPABILITY
Current state: We accidentally made it read-only with "advisory" language.
Fix: Give it back write tools and restore implementation language.

```yaml
# ml-engineer.md frontmatter should be:
tools:
  - Glob
  - Grep
  - Read
  - Edit
  - Write
  - Bash
  - TodoWrite
```

### 3. RESTORE mlops-engineer WRITE CAPABILITY
Current state: We accidentally made it read-only with "design" language.
Fix: Give it back write tools and restore implementation language.

```yaml
# mlops-engineer.md frontmatter should be:
tools:
  - Glob
  - Grep
  - Read
  - Edit
  - Write
  - Bash
  - TodoWrite
```

### 4. UPDATE ml-architect
Current state: Only has model design knowledge.
Fix: Expand to include training strategy + infrastructure strategy knowledge.
Keep it READ-ONLY (design agent).

The new ml-architect should know:
- Model architecture design (already has this)
- Training strategy design (loss, optimizer, TBPTT, schedules)
- Infrastructure strategy design (which experiment tracker, pipeline structure)
- But DOES NOT implement - just designs

### 5. CHECK data-scientist CAPABILITIES
Verify data-scientist agent has appropriate knowledge for:
- Fact-checking ML designs
- Evaluation strategy design
- Statistical validation
- Should remain READ-ONLY

### 6. UPDATE ml-flow.md COMMAND
Rewrite the 12 phases with:
- Correct agent assignments per phase
- Phase 5 sequential structure (architects → fact-checkers)
- Correct tool permissions noted

### 7. UPDATE plugin.json
- Remove ml-writer from agents list
- Bump version to 4.0.0

### 8. CLEAR CACHE
```bash
rm -rf ~/.claude/plugins/cache/super-claude-mode/ml-flow/
```

---

## ALL SKILLS (Assign to ALL agents)

Per user request, ALL agents should have access to ALL skills:

```
aeon-time-series, pytorch-patterns, pytorch-lightning, tbptt-training,
scikit-learn, statsmodels, transformers, shap, stable-baselines3,
torch_geometric, dask, polars, vaex, zarr-python, networkx,
statistical-analysis, exploratory-data-analysis, hypothesis-generation,
pymc, pymoo, umap-learn, matplotlib, seaborn, plotly, sympy, simpy,
global-templates
```

---

## VISUAL SUMMARY

```
PHASES 1-6: DESIGN (all read-only)
├── ml-explorer (discovery)
├── ml-architect (ML + MLOps design)
├── data-scientist (analysis + fact-check)
└── NO WRITE TOOLS

PHASE 6: ⛔ USER APPROVAL CHECKPOINT

PHASES 7-11: IMPLEMENTATION (write-enabled)
├── ml-engineer (implements ML code)
├── mlops-engineer (implements MLOps code)
├── ml-reviewer (reviews, read-only)
└── WRITE TOOLS for engineer agents

PHASE 12: SUMMARY (orchestrator only)
```

---

## MISTAKES WE MADE (Don't repeat!)

1. Created ml-writer as a "generic implementer" with no domain knowledge
2. Neutered ml-engineer and mlops-engineer to be "advisors"
3. Put write-enabled agents in design phases
4. Confused ML (model/training logic) with MLOps (infrastructure/tooling)
5. Didn't separate design agents from implementation agents cleanly

---

## FILES TO MODIFY

1. `agents/ml-architect.md` - Expand knowledge, keep read-only
2. `agents/ml-engineer.md` - Restore write tools, implementation language
3. `agents/mlops-engineer.md` - Restore write tools, implementation language
4. `agents/ml-writer.md` - DELETE THIS FILE
5. `commands/ml-flow.md` - Rewrite all 12 phases
6. `.claude-plugin/plugin.json` - Remove ml-writer, bump version

---

## VERSION

After all changes: **ml-flow v4.0.0**
