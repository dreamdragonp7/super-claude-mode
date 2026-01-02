---
description: Promote staging templates to _templates (atomic finalization)
argument-hint: <staging-id>
---

# /hygen-promote - Finalize Templates

**Purpose**: Move validated templates from staging to final location. This is the ONLY command that can write to `_templates/`.

**Safety**: Two-phase commit - rip stages, promote finalizes.

---

## Input

Staging ID: $ARGUMENTS

If not provided, list available staging directories.

---

## Phase 1: List Staging (if no ID)

```bash
echo "Available staging:"
ls -la /.ripper/staging/ 2>/dev/null || echo "No staging directories found"
```

Ask user to select:
```
Which staging to promote?

1. 20250102-143022-stripe (ripped from stripe.com)
2. gaps-20250102-150000 (generated from gaps.json)
3. [Cancel]
```

---

## Phase 2: Validate Staging

```bash
STAGING_DIR="/.ripper/staging/${STAGING_ID}"

if [ ! -d "$STAGING_DIR" ]; then
  echo "ERROR: Staging not found: $STAGING_DIR"
  exit 1
fi
```

Check for required files:
- For ripped templates: prompt.js, *.ejs.t
- For gap-generated: manifest.yaml

### Validation Checks

1. **EJS syntax**: Parse .ejs.t files, check for errors
2. **prompt.js validity**: Check Enquirer syntax
3. **No duplicates**: Won't overwrite existing templates (unless --force)

---

## Phase 3: Determine Destination

### For Ripped Templates
```
Source: /.ripper/staging/20250102-stripe/
Destination: _templates/component/ripped/stripe-btn/

Or global: ~/.hygen-templates/component/ripped/stripe-btn/
```

Ask user:
```
Where to promote?

[Project _templates/] - Local to this project
[Global ~/.hygen-templates/] - Available everywhere
```

### For Gap-Generated Files
```
Source: /.ripper/staging/gaps-xxx/Button.test.tsx
Destination: src/components/Button/Button.test.tsx (from manifest)
```

---

## Phase 4: Preview Changes

Show what will be created:

```
## Promotion Preview

Staging: /.ripper/staging/[id]/

FILES TO CREATE:
├── _templates/component/ripped/stripe-btn/prompt.js
├── _templates/component/ripped/stripe-btn/component.ejs.t
└── _templates/component/ripped/stripe-btn/index.ejs.t

INDEX UPDATE:
└── Add entry to .hygen-index.json

Proceed? [Yes] [No] [Show file contents]
```

---

## Phase 5: Execute Promotion

### For Templates

```bash
# Create destination
mkdir -p "_templates/component/ripped/${NAME}"

# Copy files
cp -r "/.ripper/staging/${STAGING_ID}/"* "_templates/component/ripped/${NAME}/"

# Update index
# (handled by indexer agent)
```

### For Gap-Generated Files

```bash
# Read manifest
# For each file in manifest:
#   mkdir -p $(dirname $target)
#   cp staged target
```

---

## Phase 6: Update Index

If promoting templates, update `.hygen-index.json`:

```json
{
  "component/ripped/stripe-btn": {
    "origin": "ripped",
    "sourceUrl": "https://stripe.com",
    "rippedDate": "2025-01-02",
    "tags": ["button", "payment", "tailwind"],
    "promoted": "2025-01-02T15:00:00Z"
  }
}
```

---

## Phase 7: Cleanup

After successful promotion:

```bash
# Remove staging directory
rm -rf "/.ripper/staging/${STAGING_ID}"

echo "Staging cleaned up"
```

---

## Output

```
/hygen-promote COMPLETE
════════════════════════════════════════════

Promoted: [staging-id]
Type: [ripped|from-gaps]

CREATED:
├── _templates/component/ripped/stripe-btn/prompt.js
├── _templates/component/ripped/stripe-btn/component.ejs.t
└── _templates/component/ripped/stripe-btn/index.ejs.t

INDEX:
└── Updated .hygen-index.json

USAGE:
└── hygen component ripped stripe-btn

Staging cleaned: /.ripper/staging/[id]/ removed

════════════════════════════════════════════
```

---

## Writes (ONLY these locations)

- `_templates/**` (or `~/.hygen-templates/**`)
- `.hygen-index.json`
- Source code (only for gap-generated files)
- Deletes: `/.ripper/staging/<id>/` after success

---

## Safety Features

1. **Validation before write**: Checks syntax, duplicates
2. **Preview before execute**: User must confirm
3. **Atomic**: Either all files promote or none
4. **Cleanup**: Staging removed only after success
