---
name: system:build-plan
description: Generate a concrete build plan from the verified system design
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
  - Glob
  - Agent
  - WebSearch
  - WebFetch
---

<objective>

Transform the verified system design into a concrete, ordered build plan. Classify each component as skill, automation, data structure, or SOP. Recommend Claude Code patterns. Identify reusable existing skills.

**Requires:** `.system/CLOSURE-REPORT.md` must exist with overall PASS status.

**Produces:**
- `.system/BUILD-PLAN.md`
- `.system/BUILD-PLAN.html`

**After this command:** Start building with `/new-skill {first-component}` or the recommended build method.

</objective>

<execution_context>

@.claude/system-design/templates/build-plan.md

</execution_context>

<process>

## Step 1: Resolve Active System and Check Prerequisites

```bash
ACTIVE=$(cat .system/ACTIVE 2>/dev/null)
[ -z "$ACTIVE" ] && echo "ERROR: No active system. Run /system:new-system [name] first." && exit 1
[ ! -f ".system/$ACTIVE/CLOSURE-REPORT.md" ] && echo "ERROR: Run /system:verify-closure first" && exit 1
echo "Active system: $ACTIVE | Working directory: .system/$ACTIVE/"
```

Read `.system/{active-system}/CLOSURE-REPORT.md` and check overall status. If any test has FAIL status, stop:
"The system design has unresolved failures. Address them and re-run `/system:verify-closure` first."

Warnings are acceptable. Proceed if all tests show PASS or WARNING.

From this point, all file paths use `.system/{active-system}/` as the root.

## Step 2: Display Stage Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ▤  SYSTEM DESIGN >> BUILDING PLAN  ·  06/06
  Classify. Order. Identify reuse. Ship.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Step 3: Load Design Artifacts

Read all design files from `.system/{active-system}/`:
- `.system/{active-system}/SYSTEM-MAP.md`
- `.system/{active-system}/MAP.md`
- `.system/{active-system}/OUTCOMES.md`
- `.system/{active-system}/DESIGN.md`
- All files in `.system/{active-system}/flows/`
- All files in `.system/{active-system}/feedback/`
- `.system/{active-system}/CLOSURE-REPORT.md`

## Step 3: Spawn Build Planner

Spawn sys-build-planner agent with full context:

```
Agent(prompt="
Read your agent definition first:
@.claude/agents/sys-build-planner.md

<system_artifacts>
[Include content of all .system/ files]
</system_artifacts>

<vault_context>
[Include ls of .claude/skills/ and .claude/commands/ if they exist]
</vault_context>

<instructions>
1. Classify each component (skill / automation / data structure / SOP)
2. Query Context7 for current Claude Code capabilities
3. Check for reusable vault skills
4. Derive build order from dependencies
5. Write .system/BUILD-PLAN.md using the template
6. Return BUILD PLAN READY with summary
</instructions>
", subagent_type="general-purpose", description="Build planning")
```

## Step 4: Generate HTML Build Plan

After the agent writes BUILD-PLAN.md, generate a self-contained interactive HTML report using the PRGRMMD report pattern. Do not use the triage-board pattern.

Brand spec (white theme — mandatory):
```css
:root {
  --bg: #ffffff; --bg-secondary: #f8f8fb; --text: #0f0f0f; --text-muted: #6b7280;
  --accent: #7c6af7; --accent-light: #ede9fe;
  --success: #22c55e; --success-bg: #f0fdf4;
  --error: #ef4444; --error-bg: #fef2f2;
  --warning: #f59e0b; --warning-bg: #fffbeb;
  --border: #e5e7eb; --code-bg: #f3f4f6;
  --max-width: 1100px;
  --font: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

### HTML structure

**Header:**
```html
<div class="report-header">
  <div class="report-meta">[System name] · [date]</div>
  <h1>Build Plan</h1>
  <div class="badge-row">
    <span class="badge badge-neutral">[N] components</span>
    <span class="badge badge-neutral">[N] stages</span>
    <span class="badge badge-neutral">[N] reusable</span>
  </div>
</div>
```

**Left ToC + main layout** (sticky sidebar navigation):
```html
<div class="layout">
  <nav class="toc">
    <div class="toc-title">Contents</div>
    <a href="#summary">Summary</a>
    <a href="#stage-1">Stage 1</a>
    <!-- one link per stage -->
    <a href="#claude-patterns">Claude Code Patterns</a>
  </nav>
  <main>...</main>
</div>
```

**Summary section** — component type breakdown cards:
- One card per type (Skill, Automation, Data Structure, SOP)
- Each card: type name, count, colour-coded (skill = purple, automation = blue, data structure = teal, SOP = grey)

**Per-stage sections** — one accordion per build stage:
- Accordion header: "Stage N — [N components]" with a neutral badge
- Accordion body: table of components in that stage
  - Columns: Component | Type | Reuse | Notes
  - Type badge: skill (purple), automation (blue), data structure (teal), SOP (grey)
  - Reuse badge: green "Reuse" if an existing vault skill covers it, empty otherwise
  - Notes: one-line description of what the component does

**Claude Code Patterns section** — table mapping pattern to which components use it:
- Columns: Pattern | Components

**All HTML must be fully self-contained.** All CSS in a `<style>` block, all JS in a `<script>` at end of `<body>`. No CDN links.

**Interactivity (mandatory):**
- Accordion open/close on each stage section
- ToC links highlight the active section on scroll (IntersectionObserver)
- Type filter buttons above the stage sections: All / Skill / Automation / Data Structure / SOP — clicking filters which component rows are visible across all stages
- Copy as markdown button in the header — exports the full stage-by-stage build order as a markdown checklist

**Badge CSS classes to use:**
- `badge-skill` → `background: var(--accent-light); color: var(--accent)`
- `badge-automation` → `background: #dbeafe; color: #2563eb`
- `badge-data` → `background: #ccfbf1; color: #0d9488`
- `badge-sop` → `background: var(--bg-secondary); color: var(--text-muted); border: 1px solid var(--border)`
- `badge-reuse` → `background: var(--success-bg); color: var(--success)`
- `badge-neutral` → `background: var(--bg-secondary); color: var(--text-muted); border: 1px solid var(--border)`

Save to `.system/{active-system}/BUILD-PLAN.html`.

Add this as the first line of `.system/{active-system}/BUILD-PLAN.md` (after any frontmatter):
```
[Open Visual Build Plan](BUILD-PLAN.html)
```

## Step 5: Present Build Plan

Read the BUILD-PLAN.md written by the agent and present it:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ▤  SYSTEM DESIGN >> BUILD PLAN READY ✓  ·  06/06
  Classified. Ordered. Ready to build.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Components: [count]
  Skills: [N] | Automations: [N] | Data Structures: [N] | SOPs: [N]

Build Order:
  Stage 1: [component names]
  Stage 2: [component names]
  ...

Reusable existing skills: [count]

Claude Code patterns:
  [pattern]: [which components]

| Artifact         | Location               |
|------------------|------------------------|
| Build plan       | .system/BUILD-PLAN.md  |
| Visual board     | .system/BUILD-PLAN.html|

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Start building: /new-skill [first-component-name]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Step 6: Update State

Read `.system/{active-system}/STATE.md` and update:
- Current Position: complete
- Last completed: build-plan
- Mark build-plan checkbox

Write updated STATE.md.

</process>

<output>

- `.system/BUILD-PLAN.md`
- `.system/BUILD-PLAN.html`
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Closure report verified as PASS
- [ ] All design artifacts loaded
- [ ] sys-build-planner agent spawned with full context
- [ ] Every component classified
- [ ] Context7 queried for current capabilities
- [ ] Existing vault skills checked for reuse
- [ ] Build order derived from dependencies
- [ ] BUILD-PLAN.md written
- [ ] HTML report generated using PRGRMMD report pattern (white theme, sticky ToC, accordions)
- [ ] Header has component count, stage count, reuse count badges
- [ ] Summary section has type breakdown cards (Skill/Automation/Data Structure/SOP)
- [ ] One accordion section per build stage with component table (name, type badge, reuse badge, notes)
- [ ] Claude Code Patterns section present
- [ ] Type filter buttons work across all stage sections
- [ ] Copy as markdown exports build order as checklist
- [ ] ToC scroll highlighting active section
- [ ] HTML is fully self-contained (no CDN, no external fonts)
- [ ] BUILD-PLAN.html saved alongside markdown
- [ ] [Open Visual Build Plan] link added to top of BUILD-PLAN.md
- [ ] Claude Code patterns recommended
- [ ] STATE.md updated
- [ ] Operator knows how to start building

</success_criteria>
