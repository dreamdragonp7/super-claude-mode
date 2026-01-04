---
description: Rip UI patterns from websites or pasted code into Hygen templates
argument-hint: [url]
---

# /rip - Extract UI Patterns into Hygen Templates

Rip UI components from websites and convert them into reusable Hygen templates stored in `~/.hygen-templates/`.

## Usage

- `/rip https://example.com` - Rip from URL (uses Playwright)
- `/rip` - Paste mode (manual HTML/CSS input)

---

## Mode Detection

**URL provided?**
- Yes → Playwright extraction mode
- No → Paste mode (prompt user for HTML/CSS)

---

## Phase 1: Extraction

### If URL Mode:

1. Navigate to URL:
   ```
   Use mcp__playwright__browser_navigate with the URL
   ```

2. Wait for content:
   ```
   Use mcp__playwright__browser_wait_for with time=3000
   ```

3. Take snapshot:
   ```
   Use mcp__playwright__browser_snapshot to show element refs
   ```

4. Ask user which component to rip:
   ```
   "Which component do you want to rip? Provide:
   - A CSS selector (e.g., .hero-card, #pricing-table)
   - OR click on an element ref from the snapshot above"
   ```

5. Extract using browser_evaluate with this script:
   ```javascript
   async (page) => {
     const selector = 'USER_SELECTOR';
     const el = document.querySelector(selector);
     if (!el) return { error: 'Element not found' };

     // Get HTML
     const html = el.outerHTML;

     // Detect framework
     const classes = [];
     el.querySelectorAll('*').forEach(e => classes.push(...e.classList));
     classes.push(...el.classList);
     const tailwind = /^(flex|grid|p-|m-|text-|bg-|border-|rounded-|shadow-|w-|h-|gap-)/.test(classes.join(' '));

     // Get computed styles recursively
     function getStyles(e) {
       const computed = getComputedStyle(e);
       const props = ['display','flex-direction','justify-content','align-items','gap','padding','margin','background','color','font-size','border','border-radius','box-shadow'];
       const styles = {};
       props.forEach(p => {
         const v = computed.getPropertyValue(p);
         if (v && v !== 'none' && v !== 'normal') styles[p] = v;
       });
       return styles;
     }

     const elements = [];
     function traverse(e, path='') {
       elements.push({ path, tag: e.tagName.toLowerCase(), classes: [...e.classList], styles: getStyles(e) });
       [...e.children].forEach((c,i) => traverse(c, path+'>'+c.tagName.toLowerCase()+':nth-child('+(i+1)+')'));
     }
     traverse(el);

     return { html, framework: tailwind ? 'tailwind' : 'vanilla', elements };
   }
   ```

### If Paste Mode:

1. Prompt user:
   ```
   "Paste your HTML code below (I'll extract CSS from inline styles and class names):"
   ```

2. After paste, ask:
   ```
   "Now paste any associated CSS (or type 'skip' if styles are inline/Tailwind):"
   ```

---

## Phase 2: Classification

Launch **extractor** agent (Haiku) with the extracted data:

Prompt: "Classify this component:
- HTML: [extracted html]
- Framework: [tailwind/vanilla]
- Elements: [element tree]

Return:
- componentType: button|card|form|nav|modal|input|list|table|tabs|accordion|toast|badge|avatar|skeleton|tooltip|dropdown|drawer|other
- suggestedName: kebab-case name based on content
- variables: what should be parameterized (names, content, booleans)"

---

## Phase 3: Template Generation

Launch **templater** agent (Opus) with classification results:

Prompt: "Generate a Hygen template for this ripped component.

Component Type: [type]
Suggested Name: [name]
HTML: [html]
Framework: [framework]
Variables to parameterize: [variables]

Create these files in ~/.hygen-templates/component/ripped/[name]/:

1. prompt.js - Enquirer prompts for variables (use 'select' not 'list')
2. component.ejs.t - Main component template with EJS variables
3. index.ejs.t - Export barrel if needed

Follow Hygen best practices:
- Use <%= name %> for identifiers
- Use <% if (condition) { -%> for conditionals (note the -)
- Use h.changeCase.pascal(name) for PascalCase
- Numeric prefixes for ordering: 01_, 02_

Also update ~/.hygen-templates/.hygen-index.json with:
- origin: 'ripped'
- sourceUrl: [url if provided]
- rippedDate: [today]
- tags: [component type, framework]"

---

## Output

```
✅ Component ripped successfully!

Template: ~/.hygen-templates/component/ripped/[name]/
Files created:
  - prompt.js
  - component.ejs.t
  - index.ejs.t

Origin: ripped
Source: [url or 'pasted']

To use: hygen component ripped [name]
```
