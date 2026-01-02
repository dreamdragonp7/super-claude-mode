---
description: List everything in the codebase - components, endpoints, hooks, stores, tests
argument-hint: [path]
---

# Inventory: Codebase Census

You are helping a developer understand what exists in their codebase. This command provides a structured inventory of all components, organized by type.

## Why Inventory Exists

- Large codebases are hard to navigate
- Developers forget what already exists
- Prevents reinventing existing functionality
- Helps with onboarding and documentation

---

## Input

Path to inventory: $ARGUMENTS (default: entire project)

---

## Step 1: Detect Project Type

Scan for configuration files to understand the project structure:
- `pnpm-workspace.yaml` or `lerna.json` → Monorepo
- `package.json` with workspaces → Monorepo
- `pyproject.toml` or `setup.py` → Python project
- `next.config.js` → Next.js app
- `app.json` (Expo) → React Native app

Report detected project type.

---

## Step 2: Launch Inventory Scanners (PARALLEL)

Launch 3 **pattern-checker** agents (Haiku) IN PARALLEL:

1. **Frontend inventory**:
   - "List all React/React Native components in [path]"
   - Count: pages, components, hooks, stores
   - Group by directory

2. **Backend inventory**:
   - "List all API endpoints, services, and database models in [path]"
   - Count: routers, schemas, services, repositories
   - Group by module

3. **Test inventory**:
   - "List all test files and their coverage areas in [path]"
   - Count: unit tests, integration tests, e2e tests
   - Calculate rough coverage

Wait for all agents to complete.

---

## Step 3: Compile Inventory Report

Present findings in structured format:

```
┌─────────────────────────────────────────────────────────────┐
│ INVENTORY: [path]                                           │
│ Generated: [timestamp]                                      │
│ Project Type: [detected-type]                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ FRONTEND                                                    │
│ ─────────                                                   │
│ Pages:        [N] (apps/web/src/app/)                       │
│ Components:   [N] (apps/web/src/components/)                │
│ Hooks:        [N] (apps/web/src/hooks/)                     │
│ Stores:       [N] (packages/shared/src/stores/)             │
│                                                             │
│ Component Breakdown:                                        │
│   primitives/     [N] components                            │
│   feed/           [N] components                            │
│   ticker-detail/  [N] components                            │
│   trajectory/     [N] components                            │
│   ...                                                       │
│                                                             │
│ BACKEND                                                     │
│ ─────────                                                   │
│ Routers:      [N] (apps/api/routers/)                       │
│ Schemas:      [N] (apps/api/schemas/)                       │
│ Services:     [N] (core/**/services/)                       │
│ Protocols:    [N] (core/**/protocols.py)                    │
│ Providers:    [N] (infrastructure/data_providers/)          │
│                                                             │
│ Router Breakdown:                                           │
│   prediction.py    [endpoints: GET /predict, POST /predict] │
│   ssp.py           [endpoints: GET /feed, GET /ticker/...]  │
│   trajectory.py    [endpoints: POST /trajectory, ...]       │
│   ...                                                       │
│                                                             │
│ ML/MODEL                                                    │
│ ─────────                                                   │
│ TRM Modules:  [N] (lantern/trm/)                            │
│ Features:     83 (core/features/schema.py)                  │
│ Heads:        [N] (lantern/trm/heads/)                      │
│ Memory:       [N] (lantern/trm/memory/)                     │
│                                                             │
│ TESTS                                                       │
│ ─────────                                                   │
│ Unit:         [N] tests (tests/unit/)                       │
│ API:          [N] tests (tests/api/)                        │
│ Gauntlet:     [N] tests (tests/gauntlet/)                   │
│ SSP Gauntlet: [N] tests (tests/ssp_gauntlet/)               │
│                                                             │
│ Coverage Estimate: ~[N]%                                    │
│                                                             │
│ CONFIGURATION                                               │
│ ─────────────                                               │
│ Python:       pyproject.toml, ruff, mypy                    │
│ TypeScript:   tsconfig.json, eslint                         │
│ Build:        turbo.json, pnpm-workspace.yaml               │
│ CI/CD:        .github/workflows/                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Step 4: Highlight Key Files

List the "Source of Truth" files that define critical contracts:

```
KEY FILES (Source of Truth)
───────────────────────────
• core/features/schema.py     - 83 Lantern features
• lantern/interface.py        - LanternModel Protocol
• config/settings.py          - Centralized config
• packages/shared/src/types.ts - TypeScript types
```

---

## Step 5: Suggest Actions

Based on inventory, suggest:
- "Missing tests for [N] components - run `/audit` for details"
- "Large directory [X] has [N] files - consider splitting"
- "No README in [directory] - add documentation"

---

## Agent Reference

| Agent | Model | Purpose |
|-------|-------|---------|
| pattern-checker | Haiku | CHEAP file/component discovery |

---

## Cost Optimization

All scanning uses Haiku (~$0.02 total). Fast, cheap, comprehensive census.
