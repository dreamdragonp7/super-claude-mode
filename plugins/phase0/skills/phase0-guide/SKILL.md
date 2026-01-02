---
name: phase0-guide
description: Complete guide to the Phase 0 workflow. Use when explaining how phase0 works or why it exists.
---

# Phase 0 Guide

## What Is Phase 0?

Phase 0 is a **pre-flight exploration** step that runs before /dev-flow or /bug-hunt. It ensures context is mapped and captured before diving into implementation.

## Why Phase 0 Exists

### The Problems It Solves

| Problem | How Phase 0 Helps |
|---------|-------------------|
| Context drift | Task capsules persist across sessions |
| Skipped phases | Hooks enforce running phase0 first |
| Token waste | Haiku scanners are cheap ($0.02 vs $0.50) |
| Wrong assumptions | Scanning finds what exists before building |
| Lost decisions | Capsules document the plan and risks |

### The Philosophy

"Don't make the model remember the repo—make the repo tell the model."

## The Workflow

```
User Request
     │
     ▼
┌─────────────────┐
│    /phase0      │ ← REQUIRED FIRST STEP
│                 │
│ 1. Restate task │
│ 2. Ask questions│
│ 3. Haiku scan   │  (cheap)
│ 4. Opus synth   │  (smart)
│ 5. Create capsule│
│ 6. Get approval │
└─────────────────┘
     │
     ▼ (approved)
     │
┌─────────────────┐
│  /dev-flow OR   │ ← NOW HAS CONTEXT
│  /bug-hunt      │
└─────────────────┘
```

## Cost Optimization

| Agent | Model | Cost | Purpose |
|-------|-------|------|---------|
| file-scanner | Haiku | ~$0.005 | File finding |
| import-tracer | Haiku | ~$0.005 | Dependency chains |
| test-finder | Haiku | ~$0.005 | Test discovery |
| context-synthesizer | Opus | ~$0.05 | Smart analysis |

**Total Phase 0 cost**: ~$0.07
**Without optimization**: ~$0.50+

Haiku does mechanical work. Opus does thinking.

## Commands

| Command | Purpose |
|---------|---------|
| `/phase0 [task]` | Full pre-flight with capsule creation |
| `/focus [topic]` | Quick context mapping without capsule |
| `/atlas` | Generate/update repo documentation |
| `/scaffold [template] [name]` | Deterministic code generation |

## Integration with Existing Workflows

Phase 0 is the **entry point** to:
- `/dev-flow` - 12-phase feature development
- `/bug-hunt` - 7-phase debugging

The hook system suggests running phase0 if no recent capsule exists.

## When to Skip Phase 0

You can skip phase0 for:
- Trivial changes (typos, one-line fixes)
- Continuing work with existing capsule
- Pure research/exploration

But for any significant work: **run phase0 first**.
