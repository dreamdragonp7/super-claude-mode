# ML-Flow Plugin v2.0

Comprehensive 12-phase ML development workflow with specialized agents for model architecture, training pipelines, experiment tracking, and evaluation. Now with enhanced cloud MLOps (AWS/Azure/GCP), production infrastructure, and business analytics.

## What's New in v2.0

- **Enhanced mlops-engineer**: Full cloud-specific sections (AWS SageMaker, Azure ML, GCP Vertex AI), Kubernetes orchestration, Infrastructure as Code, Security & Compliance
- **Enhanced data-scientist**: Business analytics domains (Financial, Marketing, Operations), experimental design, advanced analytics
- **Enhanced ml-engineer**: Production ML infrastructure, edge deployment, data management, MLOps CI/CD integration

## Installation

```bash
# Install from super-claude-mode marketplace
/plugin install ml-flow@super-claude-mode
```

## Usage

```bash
# Start ML development workflow
/ml-flow Build a 63-day trajectory forecasting model using TBPTT

# With phase0 capsule pre-filled context
/ml-flow --capsule trajectory-model

# Just run the command to be prompted for details
/ml-flow
```

## The 12 Phases

| Phase | Name | Focus |
|-------|------|-------|
| 1 | Problem Analysis | Understand ML problem, metrics, constraints |
| 2 | Data Architecture | Map data sources, features, pipelines |
| 3 | Risk Assessment | Data leakage, distribution shift, bias |
| 4 | Model Architecture | Design multiple approaches with trade-offs |
| 5 | Training Pipeline | Experiment tracking, pipeline design |
| 6 | Evaluation Strategy | Metrics, validation, monitoring plan |
| 7 | Model Implementation | PyTorch/TF code, TBPTT, distributed |
| 8 | Training Infrastructure | MLflow, cloud training setup |
| 9 | Integration | Connect model to application |
| 10 | Quality Review | ML-specific code review |
| 11 | Evaluation Execution | Run evaluations, analyze results |
| 12 | Summary | Document model card, next steps |

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| **ml-explorer** | opus | Trace ML code, data pipelines, feature engineering |
| **ml-architect** | opus | Design model architectures with trade-offs |
| **ml-engineer** | opus | PyTorch 2.x, TBPTT, distributed training |
| **mlops-engineer** | opus | MLflow, Kubeflow, experiment tracking |
| **data-scientist** | opus | Time series, model evaluation, statistics |
| **ml-reviewer** | opus | ML-specific code review, data leakage detection |
| **ml-writer** | opus | Implement approved ML designs |

## Skills (27 Total)

### Core ML
| Skill | Purpose |
|-------|---------|
| aeon-time-series | Time series classification, forecasting, anomaly detection, DTW |
| pytorch-patterns | PyTorch 2.x best practices, torch.compile, FSDP |
| pytorch-lightning | Structured PyTorch training with Lightning |
| tbptt-training | TBPTT patterns for memory-based models |
| scikit-learn | Classical ML algorithms, preprocessing, model selection |
| statsmodels | Statistical modeling, time series, hypothesis testing |
| transformers | Hugging Face models, NLP, embeddings |
| shap | Model interpretability, feature importance |
| stable-baselines3 | Reinforcement learning algorithms |
| torch_geometric | Graph neural networks, graph ML |

### Data Processing
| Skill | Purpose |
|-------|---------|
| dask | Parallel computing, distributed dataframes |
| polars | Fast dataframes, data wrangling |
| vaex | Out-of-core dataframes for big data |
| zarr-python | Chunked arrays for large datasets |
| networkx | Graph analysis, network algorithms |

### Statistics & Analysis
| Skill | Purpose |
|-------|---------|
| statistical-analysis | Hypothesis testing, confidence intervals |
| exploratory-data-analysis | EDA patterns, data profiling |
| hypothesis-generation | Scientific hypothesis formulation |
| pymc | Bayesian modeling, probabilistic programming |
| pymoo | Multi-objective optimization |
| umap-learn | Dimensionality reduction, visualization |

### Visualization
| Skill | Purpose |
|-------|---------|
| matplotlib | Static plotting, publication-quality figures |
| seaborn | Statistical visualization |
| plotly | Interactive plots, dashboards |

### Utilities
| Skill | Purpose |
|-------|---------|
| sympy | Symbolic mathematics |
| simpy | Discrete event simulation |
| global-templates | Hygen templates for ML scaffolding |

## Phase0 Integration

ML-Flow supports capsules from `/phase0`:

```bash
# First, compile context with phase0
/phase0 Build trajectory forecasting model for stock predictions

# Then use the capsule with ml-flow
/ml-flow --capsule trajectory-model
```

The capsule provides:
- Pre-filled goal and constraints
- Key files already identified
- Risks documented
- Questions already answered

## Hooks

ML-Flow includes hooks for phase enforcement:

- **UserPromptSubmit**: Injects phase reminder before each response
- **Stop**: Validates phase completion (placeholder for future enhancement)

## Example Workflow

```
User: /ml-flow Build a time series forecasting model

Claude: **Phase 1 of 12: Problem Analysis**
Next: Phase 2 - Data Architecture

Let me understand the ML problem...

[Proceeds through all 12 phases with explicit announcements]
```

## Requirements

- Claude Code with plugin support
- Opus model access (all agents use Opus)

## License

MIT
