---
description: Guided 12-phase ML development with model architecture, training pipelines, experiment tracking, and evaluation
argument-hint: Optional ML task description or --capsule <slug>
---

# ML Development Workflow

You are helping a developer build a machine learning feature or model. Follow a systematic 12-phase approach across 4 meta-phases: Discovery, Design, Implementation, and Evaluation.

## Execution Rule

At the START of each phase, ALWAYS announce:

**Phase X of 12: [Phase Name]**
Next: Phase Y - [Next Phase Name]

Then proceed with the phase actions. This helps track progress through the workflow.

---

## Capsule Support

Check if `$ARGUMENTS` contains `--capsule`:

```
If --capsule <slug> provided:
  1. Read /.phase0/capsules/<slug>/capsule.yaml
  2. Extract: goal, constraints, key_files, risks
  3. Pre-fill Phase 1 context with capsule data
  4. Announce: "Loaded capsule: <slug>"

If no --capsule:
  1. Proceed normally with Phase 1 questions
  2. This is fine - capsules are optional
```

---

## Core Principles

- **Ask clarifying questions**: Identify ML-specific ambiguities early (data sources, metrics, deployment target).
- **Understand before acting**: Read and comprehend existing ML code patterns before proposing architecture.
- **Read files identified by agents**: Use agents to find important files, then read them to build context.
- **Simple and elegant**: Prioritize readable, maintainable, well-documented ML code.
- **Leave no stone unturned**: Address ALL ML design considerations (data leakage, distribution shift, bias).
- **Use TodoWrite**: Track all progress throughout.

---

## Phase 1 of 12: Problem Analysis

> **Current**: Phase 1 - Problem Analysis
> **Next**: Phase 2 - Data Architecture

**Goal**: Understand the ML problem, success metrics, and constraints

Initial request: $ARGUMENTS

**Actions**:

1. Create todo list with all 12 phases.

2. **Check for capsule** (if --capsule provided):
   - Read capsule.yaml and extract pre-filled context
   - Skip to step 4 with capsule data

3. **Get the ML task description** (if no capsule):

   **A) Arguments provided?** → Use `$ARGUMENTS` as the ML task request.

   **B) No arguments?** → Ask the user:
   - What ML problem are they solving? (classification, regression, forecasting, etc.)
   - What data do they have?
   - What are the success metrics?
   - Deployment target? (batch, real-time, edge)
   - Any constraints? (latency, memory, interpretability)

4. Launch `ml-explorer` agent to understand ML context:
   - "Explore existing ML code, models, and training pipelines to understand current patterns."

5. Summarize the ML requirements and confirm with user.

**When complete**: Proceed to Phase 2.

---

## Phase 2 of 12: Data Architecture

> **Current**: Phase 2 - Data Architecture
> **Next**: Phase 3 - Risk Assessment

**Goal**: Understand the data landscape, features, and pipelines

**Actions**:

1. Launch 2-3 `ml-explorer` agents in parallel. Each agent should:
   - Trace through data pipelines comprehensively
   - Target different aspects (data sources, feature engineering, preprocessing)
   - Return 5-10 key files to read

   **Example agent prompts**:
   - "Map the data sources and feature engineering pipeline for this ML task"
   - "Find existing preprocessing patterns and data validation in the codebase"
   - "Analyze the feature schema and understand how features are computed"

2. Once agents return, read all identified files to build deep understanding.
3. Present a summary of the data architecture:
   - Data sources and formats
   - Feature engineering patterns
   - Preprocessing pipelines
   - Data validation approaches

**When complete**: Proceed to Phase 3.

---

## Phase 3 of 12: Risk Assessment

> **Current**: Phase 3 - Risk Assessment
> **Next**: Phase 4 - Model Architecture

**Goal**: Identify ML-specific risks, data issues, and potential pitfalls

**Actions**:

1. Launch `ml-explorer` agent focused on ML risks:
   - "Identify data leakage risks, distribution shift concerns, and potential bias issues"
   - "Analyze temporal dependencies and lookahead bias in feature computation"
   - "Check for train/test contamination and proper data splitting"

2. Launch `data-scientist` agent for statistical analysis:
   - "Analyze data quality: missing values, outliers, class imbalance, feature correlations"

3. Review findings and compile risk list:
   - Data leakage risks
   - Distribution shift concerns
   - Bias and fairness issues
   - Reproducibility challenges
   - Scalability concerns

4. Present risks to user. Ask if any should block or modify the design.

**When complete**: Proceed to Phase 4.

---

## Phase 4 of 12: Model Architecture

> **Current**: Phase 4 - Model Architecture
> **Next**: Phase 5 - Training Pipeline

**Goal**: Design multiple model approaches with trade-offs

**Actions**:

1. Launch 2-3 `ml-architect` agents in parallel with different focuses:
   - **Baseline approach**: Simple model, fast iteration, interpretable
   - **State-of-the-art approach**: Best performance, more complexity
   - **Pragmatic balance**: Performance + maintainability, practical trade-offs

   Each agent should return:
   - Model architecture design
   - Input/output specifications
   - Training strategy (loss, optimizer, schedule)
   - Inference considerations
   - Resource requirements

2. Review all approaches and form your recommendation.
3. Present to user:
   - Brief summary of each approach
   - Trade-offs comparison (performance vs. complexity vs. resources)
   - **Your recommendation with reasoning**
   - Ask user which approach they prefer

**When complete**: Proceed to Phase 5 (after user selects approach).

---

## Phase 5 of 12: Training Pipeline

> **Current**: Phase 5 - Training Pipeline
> **Next**: Phase 6 - Evaluation Strategy

**Goal**: Design the training infrastructure and experiment tracking

**Actions**:

1. Based on chosen architecture, launch `mlops-engineer` agent:
   - Design experiment tracking setup (MLflow, W&B, etc.)
   - Define training pipeline structure
   - Specify data loading and batching strategy
   - Plan distributed training if needed
   - Design checkpointing and model versioning

2. Agent should design:
   - Training loop structure
   - Experiment tracking configuration
   - Hyperparameter management
   - Resource allocation (GPU, memory)
   - Pipeline orchestration (if applicable)

3. Present training pipeline design to user for approval.

**When complete**: Proceed to Phase 6.

---

## Phase 6 of 12: Evaluation Strategy

> **Current**: Phase 6 - Evaluation Strategy
> **Next**: Phase 7 - Model Implementation

**Goal**: Plan comprehensive model evaluation before implementation

**Actions**:

1. Launch `data-scientist` agent:
   - "Design evaluation strategy for this ML model. Include offline metrics, validation approach, and production monitoring."

2. Agent should define:
   - Primary and secondary metrics
   - Validation strategy (holdout, cross-validation, walk-forward)
   - Statistical significance testing approach
   - Baseline comparisons
   - Production monitoring plan
   - A/B testing considerations

3. Present evaluation plan to user.

**IMPORTANT**: After Phase 6, wait for explicit user approval before proceeding to implementation.

**When complete**: Ask user to approve the full design (architecture + pipeline + evaluation) before proceeding.

---

## Phase 7 of 12: Model Implementation

> **Current**: Phase 7 - Model Implementation
> **Next**: Phase 8 - Training Infrastructure

**Goal**: Implement the model architecture and core ML code

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:

1. Wait for explicit user approval of the design from Phases 4-6.

2. Launch `ml-engineer` agent with model focus:
   - Provide: Approved architecture, target files, framework choice
   - Focus: Model class, forward pass, loss computation, metrics

3. Launch `ml-writer` agent to implement:
   - Create/modify model files
   - Follow project conventions
   - Implement proper typing and documentation
   - Add unit tests for model components

4. Review implementation and update todos.

**When complete**: Proceed to Phase 8.

---

## Phase 8 of 12: Training Infrastructure

> **Current**: Phase 8 - Training Infrastructure
> **Next**: Phase 9 - Integration

**Goal**: Implement training loop, experiment tracking, and pipelines

**Actions**:

1. Launch `mlops-engineer` agent with infrastructure focus:
   - Provide: Approved pipeline design, experiment tracking choice
   - Focus: Training loop, data loaders, logging, checkpointing

2. Launch `ml-writer` agent to implement:
   - Training script/module
   - Data loading pipeline
   - Experiment tracking integration
   - Configuration management
   - Reproducibility setup (seeds, versioning)

3. Review implementation and update todos.

**When complete**: Proceed to Phase 9.

---

## Phase 9 of 12: Integration

> **Current**: Phase 9 - Integration
> **Next**: Phase 10 - Quality Review

**Goal**: Connect model to application, finalize data flow

**Actions**:

1. Launch `ml-writer` agent with integration focus:
   - Provide: Model and training implementations
   - Focus: Inference pipeline, API integration, batch/streaming setup

2. Agent will:
   - Wire up model serving
   - Add configuration for different environments
   - Ensure data flows correctly end-to-end
   - Implement caching/optimization if needed

3. Run integration smoke tests.

**When complete**: Proceed to Phase 10.

---

## Phase 10 of 12: Quality Review

> **Current**: Phase 10 - Quality Review
> **Next**: Phase 11 - Evaluation Execution

**Goal**: Catch bugs, ML anti-patterns, and convention violations

**Actions**:

1. Launch 3 `ml-reviewer` agents in parallel with different focuses:
   - **Code Quality**: Clean code, DRY, proper abstractions
   - **ML Best Practices**: Data leakage, reproducibility, proper validation
   - **Performance/Scalability**: Memory efficiency, batching, distributed training readiness

   Each agent should:
   - Use confidence scoring (0-100)
   - Only report issues with confidence >= 80
   - Provide specific file:line references
   - Flag ML-specific anti-patterns

2. Consolidate findings and identify highest severity issues.
3. Present findings to user and ask what they want to fix.
4. If fixes needed, use `ml-writer` to address them.

**When complete**: Proceed to Phase 11.

---

## Phase 11 of 12: Evaluation Execution

> **Current**: Phase 11 - Evaluation Execution
> **Next**: Phase 12 - Summary

**Goal**: Run evaluations and validate model performance

**Actions**:

1. Launch `data-scientist` agent:
   - "Execute evaluation suite for the model. Validate metrics meet requirements."

2. Run all relevant evaluations:
   - Unit tests for model components
   - Integration tests for training pipeline
   - Offline evaluation metrics
   - Sanity checks (overfit small batch, gradient flow)

3. Report results. If failures:
   - Use `ml-writer` to fix issues
   - Re-run evaluations until passing

4. Compare against baselines and document results.

**When complete**: Proceed to Phase 12.

---

## Phase 12 of 12: Summary

> **Current**: Phase 12 - Summary
> **Next**: Done!

**Goal**: Document what was accomplished

**Actions**:

1. Mark all todos complete.
2. Summarize:
   - What was built (model architecture, training pipeline)
   - Key design decisions and trade-offs
   - Files created/modified
   - Evaluation metrics achieved
   - Model card information (if applicable)
   - Suggested next steps:
     - Hyperparameter tuning
     - Production deployment
     - Monitoring setup
     - A/B testing plan

**When complete**: ML development finished!

---

## Agent Reference

**ml-explorer** (opus):
- Traces ML code, data pipelines, feature engineering
- Maps model architectures and training patterns
- Returns key files to read
- Used in: Phases 1-3

**ml-architect** (opus):
- Designs model architectures
- Makes confident ML design decisions
- Considers trade-offs (performance vs. complexity)
- Used in: Phase 4

**ml-engineer** (opus):
- PyTorch 2.x, TensorFlow, JAX expertise
- TBPTT, distributed training, model optimization
- Production ML systems
- Used in: Phase 7

**mlops-engineer** (opus):
- MLflow, Kubeflow, experiment tracking
- Training pipelines, cloud ML services
- Infrastructure as code for ML
- Used in: Phases 5, 8

**data-scientist** (opus):
- Statistical analysis, model evaluation
- Time series, hypothesis testing
- Feature engineering, data quality
- Used in: Phases 3, 6, 11

**ml-reviewer** (opus):
- ML-specific code review
- Data leakage detection, reproducibility checks
- Confidence >= 80 filter
- Used in: Phase 10

**ml-writer** (opus):
- Implements approved ML designs
- Has Edit/Write tools
- Follows ML best practices
- Used in: Phases 7-10

---

## Skills Available (27 Skills)

### Core ML Skills
- **aeon-time-series**: Time series classification, forecasting, anomaly detection, DTW
- **pytorch-patterns**: PyTorch best practices, TBPTT, distributed training
- **pytorch-lightning**: Structured PyTorch training with Lightning
- **tbptt-training**: Truncated backpropagation, memory gradients, training loops
- **scikit-learn**: Classical ML algorithms, preprocessing, model selection
- **statsmodels**: Statistical modeling, time series analysis, hypothesis testing
- **transformers**: Hugging Face models, NLP, embeddings
- **shap**: Model interpretability, feature importance, explanations
- **stable-baselines3**: Reinforcement learning algorithms
- **torch_geometric**: Graph neural networks, graph ML

### Data Processing Skills
- **dask**: Parallel computing, distributed dataframes
- **polars**: Fast dataframes, data wrangling
- **vaex**: Out-of-core dataframes for big data
- **zarr-python**: Chunked, compressed arrays for large datasets
- **networkx**: Graph analysis, network algorithms

### Statistics & Analysis Skills
- **statistical-analysis**: Hypothesis testing, confidence intervals, power analysis
- **exploratory-data-analysis**: EDA patterns, data profiling
- **hypothesis-generation**: Scientific hypothesis formulation
- **pymc**: Bayesian modeling, probabilistic programming
- **pymoo**: Multi-objective optimization, hyperparameter tuning
- **umap-learn**: Dimensionality reduction, visualization

### Visualization Skills
- **matplotlib**: Static plotting, publication-quality figures
- **seaborn**: Statistical visualization, distribution plots
- **plotly**: Interactive plots, dashboards

### Utilities
- **sympy**: Symbolic mathematics, equations
- **simpy**: Discrete event simulation
- **global-templates**: Hygen templates for ML scaffolding
