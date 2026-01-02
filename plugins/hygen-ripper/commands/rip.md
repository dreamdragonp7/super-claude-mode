---
description: Extract UI patterns from URLs or generate from gaps.json - writes to STAGING only
argument-hint: <url> | --from-gaps
---

# /hygen-rip - Extract to Staging

**Purpose**: Extract UI components from websites OR generate missing files from gaps.json. Always writes to STAGING first (atomic safety).

**Key Safety**: NEVER writes directly to `_templates/`. Use `/hygen-promote` to finalize.

---

## Input Modes

- `/hygen-rip <url>` - Extract from website using Playwright
- `/hygen-rip --from-gaps` - Generate missing files from `/.phase0/reports/gaps.json`

---

## Mode A: Extract from URL

### Phase 1: Navigate and Snapshot

```javascript
// Use Playwright MCP tools
mcp__playwright__browser_navigate({ url: "<url>" })
mcp__playwright__browser_wait_for({ time: 3000 })
mcp__playwright__browser_snapshot()
```

### Phase 2: Ask User to Select Component

Show snapshot and ask:
```
Which component do you want to rip?

Provide a CSS selector (e.g., .hero-card, #pricing-table)
OR click an element ref from the snapshot above.
```

### Phase 3: Extract DOM

Use browser_evaluate to extract:
- HTML structure
- Classes (detect Tailwind vs vanilla)
- Computed styles
- Element tree

### Phase 4: Classify (Extractor Agent - Haiku)

Internal agent classifies:
- componentType: button|card|form|nav|modal|etc
- framework: tailwind|vanilla|css-modules
- suggestedName: kebab-case
- variables: what to parameterize

### Phase 5: Generate Template (Templater Agent - Opus)

Internal agent generates Hygen template:
- prompt.js (Enquirer prompts)
- component.ejs.t (main template)
- index.ejs.t (barrel export)
- _origin.json (metadata)

### Phase 6: Write to Staging

```bash
# Create staging directory
STAGING_ID="$(date +%Y%m%d-%H%M%S)-${SITE_SLUG}"
mkdir -p "/.ripper/staging/${STAGING_ID}"

# Write template files there
```

**Output**:
```
Ripped: [component-name] from [url]

Staged at: /.ripper/staging/[staging-id]/
Files:
├── prompt.js
├── component.ejs.t
├── index.ejs.t
└── _origin.json

To finalize: /hygen-promote [staging-id]
To preview: cat /.ripper/staging/[staging-id]/component.ejs.t
```

---

## Mode B: From Gaps

### Phase 1: Read Gaps

```bash
if [ ! -f "/.phase0/reports/gaps.json" ]; then
  echo "ERROR: No gaps.json found. Run /phase0:audit first."
  exit 1
fi
```

Parse gaps.json and filter to actionable gaps:
- type: "missing_file" (can generate)
- has fix_template (knows which template)

### Phase 2: Match Templates

For each gap, find matching template:
```
Gap: Button missing test file
Pattern: react_component
Template: component/test or ~/.hygen-templates/test/component
```

### Phase 3: Generate Files

For each gap with matching template:
1. Read the template
2. Apply gap context (component name, path)
3. Generate file content

### Phase 4: Write to Staging

```bash
STAGING_ID="gaps-$(date +%Y%m%d-%H%M%S)"
mkdir -p "/.ripper/staging/${STAGING_ID}"

# Write each generated file
# Keep original target paths in manifest
```

Create manifest:
```yaml
# /.ripper/staging/[id]/manifest.yaml
type: "from-gaps"
generated: "2025-01-02T12:00:00Z"
source: "/.phase0/reports/gaps.json"
files:
  - staged: "Button.test.tsx"
    target: "src/components/Button/Button.test.tsx"
    template: "component/test"
  - staged: "index.ts"
    target: "src/components/Card/index.ts"
    template: "component/index"
```

**Output**:
```
Generated from gaps.json

Staged at: /.ripper/staging/[staging-id]/
Files to create:
├── Button.test.tsx → src/components/Button/Button.test.tsx
└── index.ts → src/components/Card/index.ts

Gaps addressed: 2/5 (3 require manual intervention)

To finalize: /hygen-promote [staging-id]
To review: ls /.ripper/staging/[staging-id]/
```

---

## Cross-Plugin Integration

If capsule exists, read context:
```yaml
# Can read from /.phase0/capsules/*/capsule.yaml
context:
  patterns_path: "patterns.yaml"
  key_files: [...]
```

This helps understand project conventions.

---

## Writes (ONLY staging)

- `/.ripper/staging/<id>/*` (templates and manifests)

**NEVER writes to**: `_templates/`, `~/.hygen-templates/`, source code

---

## Cost

| Phase | Model | Cost |
|-------|-------|------|
| Extractor | Haiku | ~$0.01 |
| Templater | Opus | ~$0.03 |
| **Total** | | **~$0.04** |
