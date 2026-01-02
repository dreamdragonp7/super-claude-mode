---
name: patterns-yaml
description: Complete reference for patterns.yaml structure and usage. Use when creating, editing, or explaining patterns.yaml.
---

# patterns.yaml Reference

## What Is patterns.yaml?

`patterns.yaml` is the **single source of truth** for how your codebase SHOULD look. It defines:
- Layer boundaries (what can import what)
- Component patterns (required files for each type)
- Anti-patterns (code smells to detect)
- Feature types (what files each feature needs)
- Hygen mappings (auto-fix templates)

## Full Schema

```yaml
# ============================================================
# patterns.yaml - THE IDEAL
# This file defines what your codebase SHOULD look like.
# /audit generates ARCHITECTURE.md showing THE REALITY.
# The gap between them is your work.
# ============================================================

version: "3.0"
project: "your-project-name"

# ────────────────────────────────────────────────────────────
# SOURCE OF TRUTH FILES
# Files that define project contracts. Always read these first.
# ────────────────────────────────────────────────────────────
source_of_truth:
  - path: "core/features/schema.py"
    purpose: "Feature vector definition"
  - path: "lantern/interface.py"
    purpose: "ML model protocol"
  - path: "packages/shared/src/types.ts"
    purpose: "Shared TypeScript types"

# ────────────────────────────────────────────────────────────
# LAYER BOUNDARIES
# Dependency rules enforced by /audit and boundary-validator
# ────────────────────────────────────────────────────────────
boundaries:
  python:
    # Core layer - pure business logic, no external deps
    core:
      allow_from: []
      deny_from: [apps, infrastructure, lantern]
      description: "Business logic, no framework dependencies"

    # Lantern layer - ML code
    lantern:
      allow_from: [core]
      deny_from: [apps, infrastructure]
      description: "ML model code, can use core"

    # Infrastructure layer - external services
    infrastructure:
      allow_from: [core]
      deny_from: [apps, lantern]
      description: "Database, APIs, external services"

    # Apps layer - delivery mechanisms
    apps:
      allow_from: [core, infrastructure, lantern]
      deny_from: []
      description: "FastAPI, CLI, can import everything"

  typescript:
    packages:
      - name: "@project/web"
        path: "apps/web"
        allow_from: ["@project/shared"]
        deny_from: ["@project/mobile"]

      - name: "@project/mobile"
        path: "apps/mobile"
        allow_from: ["@project/shared"]
        deny_from: ["@project/web"]

      - name: "@project/shared"
        path: "packages/shared"
        allow_from: []
        deny_from: ["@project/web", "@project/mobile"]

# ────────────────────────────────────────────────────────────
# COMPONENT PATTERNS
# What files each component type requires
# ────────────────────────────────────────────────────────────
component_patterns:
  react_component:
    description: "React component with tests and exports"
    location: "apps/web/src/components/**/"
    required_files:
      - "*.tsx"           # The component itself
      - "index.ts"        # Re-export for clean imports
      - "*.test.tsx"      # Unit tests
    optional_files:
      - "*.stories.tsx"   # Storybook stories
      - "*.module.css"    # CSS modules
    hygen_template: "component/new"  # Run when missing

  react_hook:
    description: "Custom React hook"
    location: "apps/web/src/hooks/"
    required_files:
      - "use*.ts"
      - "use*.test.ts"
    hygen_template: "hook/new"

  api_endpoint:
    description: "FastAPI router with schema"
    location: "apps/api/routers/"
    required_files:
      - "*.py"                    # Router
      - "../schemas/*.py"         # Pydantic schema
    hygen_template: "api/endpoint"

  python_service:
    description: "Business logic service"
    location: "core/**/services/"
    required_files:
      - "*.py"
      - "../../tests/unit/test_*.py"
    hygen_template: "service/new"

# ────────────────────────────────────────────────────────────
# ANTI-PATTERNS
# Code smells to detect and report
# ────────────────────────────────────────────────────────────
anti_patterns:
  console-log:
    pattern: "console\\.log"
    severity: warning
    message: "Remove console.log before committing"
    exclude: ["*.test.*", "*.spec.*"]

  any-type:
    pattern: ": any(?![a-zA-Z])"
    severity: warning
    message: "Avoid 'any' type, use proper typing"
    include: ["*.ts", "*.tsx"]

  relative-import:
    pattern: "from \\.\\."
    severity: error
    message: "Use absolute imports"
    include: ["*.py"]

  hardcoded-secret:
    pattern: "(sk-|api_key|password)\\s*=\\s*['\"][^'\"]+['\"]"
    severity: error
    message: "Possible hardcoded secret"

  todo-without-ticket:
    pattern: "TODO(?!\\s*\\[)"
    severity: info
    message: "TODO without ticket reference"

# ────────────────────────────────────────────────────────────
# FEATURE TYPES
# What files a complete feature needs
# ────────────────────────────────────────────────────────────
feature_types:
  full_stack:
    description: "Feature with API + Frontend + Tests"
    layers:
      - api: "apps/api/routers/{name}.py"
      - schema: "apps/api/schemas/{name}.py"
      - component: "apps/web/src/components/{name}/"
      - hook: "apps/web/src/hooks/use{Name}.ts"
      - unit_tests: "tests/unit/test_{name}.py"
      - api_tests: "tests/api/test_{name}_api.py"

  api_only:
    description: "Backend-only feature"
    layers:
      - api: "apps/api/routers/{name}.py"
      - schema: "apps/api/schemas/{name}.py"
      - service: "core/{domain}/services/{name}_service.py"
      - unit_tests: "tests/unit/test_{name}.py"

  frontend_only:
    description: "Frontend-only feature"
    layers:
      - component: "apps/web/src/components/{name}/"
      - hook: "apps/web/src/hooks/use{Name}.ts"
      - tests: "apps/web/src/components/{name}/*.test.tsx"

# ────────────────────────────────────────────────────────────
# HYGEN MAPPINGS
# Which template to run for each pattern
# ────────────────────────────────────────────────────────────
hygen:
  templates_dir: "_templates"
  mappings:
    react_component: "component/new"
    react_hook: "hook/new"
    api_endpoint: "api/endpoint"
    python_service: "service/new"
    test_file: "test/unit"

# ────────────────────────────────────────────────────────────
# REAL TOOL CONFIGS
# /audit uses these when installed
# ────────────────────────────────────────────────────────────
tools:
  python:
    import_linter:
      config: ".importlinter"
      enabled: true
  typescript:
    eslint_boundaries:
      config: "eslint.config.js"
      enabled: true
```

## Sections Explained

### source_of_truth

Files that define project contracts. Phase0 and other plugins read these first to understand the project.

### boundaries

Layer rules that `/audit` and `boundary-validator` enforce:
- `allow_from`: Packages this layer CAN import
- `deny_from`: Packages this layer CANNOT import

### component_patterns

What files each component type needs:
- `location`: Glob pattern for where to find them
- `required_files`: Files that MUST exist
- `optional_files`: Nice-to-have files
- `hygen_template`: Template to run when missing

### anti_patterns

Code smells to detect:
- `pattern`: Regex to search for
- `severity`: error | warning | info
- `include`/`exclude`: File patterns to filter

### feature_types

Complete feature definitions showing all layers needed.

### hygen

Mappings from pattern names to Hygen templates for auto-fixing.

## Commands That Use patterns.yaml

| Command | How It Uses patterns.yaml |
|---------|---------------------------|
| `/phase0` | Reads to understand project structure |
| `/planning` | Views and manages patterns.yaml |
| `/planning sync` | Discovers patterns and updates file |
| `/audit` | Checks reality against patterns |
| `/audit fix` | Runs Hygen templates for gaps |
| `/focus` | Checks for topic-related patterns |
| `/atlas` | Shows pattern compliance in docs |
| `/dev-flow` | Reads patterns before building |
| `/bug-hunt` | Checks compliance during debugging |
| `/pr-review` | Enforces patterns in reviews |

## Creating Your First patterns.yaml

1. Run `/planning` to check if one exists
2. If not, copy from templates/patterns-template.yaml
3. Customize for your project
4. Run `/audit` to see current compliance
5. Run `/audit fix` to auto-fix gaps
