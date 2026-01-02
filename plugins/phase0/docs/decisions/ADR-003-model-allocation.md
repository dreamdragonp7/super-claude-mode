# ADR-003: Model Allocation (Haiku vs Opus)

## Status
Accepted

## Context
Different tasks require different intelligence levels:
- File scanning is mechanical (grep/glob)
- Synthesis requires understanding
- Implementation needs the smart model

Using Opus for everything wastes money on simple tasks.

## Decision
Two-tier model allocation:

| Task Type | Model | Reasoning |
|-----------|-------|-----------|
| File scanning | **Haiku** | Pattern matching, no intelligence needed |
| Import tracing | **Haiku** | Following chains is mechanical |
| Test finding | **Haiku** | Just file discovery |
| Context synthesis | **Opus** | Needs understanding |
| Architecture design | **Opus** | Needs intelligence |
| Implementation | **Opus** | Needs the big brain |

**No Sonnet.** Either it's cheap work (Haiku) or smart work (Opus).

## Consequences

### Good
- 10x cost savings on exploration (~$0.02 vs $0.20)
- Phase 0 costs ~$0.07 instead of ~$0.50
- Haiku is fast (lower latency for scanning)

### Bad
- Haiku may miss nuanced patterns
- Need to clearly separate mechanical vs smart tasks
- Some edge cases may need Opus for scanning

## Cost Estimate
| Phase 0 Step | Model | Est. Cost |
|--------------|-------|-----------|
| 3x Haiku scanners | Haiku | ~$0.015 |
| Context synthesis | Opus | ~$0.05 |
| **Total** | | **~$0.07** |

Without optimization: ~$0.50+ (all Opus)
