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

## Step 1: Check Prerequisites

```bash
[ ! -f .system/CLOSURE-REPORT.md ] && echo "ERROR: Run /system:verify-closure first" && exit 1
```

Read CLOSURE-REPORT.md and check overall status. If any test has FAIL status, stop:
"The system design has unresolved failures. Address them and re-run `/system:verify-closure` first."

Warnings are acceptable. Proceed if all tests show PASS or WARNING.

## Step 2: Display Stage Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ▤  SYSTEM DESIGN >> BUILDING PLAN  ·  06/06
  Classify. Order. Identify reuse. Ship.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Step 3: Load Design Artifacts

Read all design files:
- `.system/SYSTEM-MAP.md`
- `.system/MAP.md`
- `.system/OUTCOMES.md`
- `.system/DESIGN.md`
- All files in `.system/flows/`
- All files in `.system/feedback/`
- `.system/CLOSURE-REPORT.md`

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

After the agent writes BUILD-PLAN.md, generate a self-contained interactive HTML triage board.

Use the triage-board pattern from `.claude/skills/html-templates/triage-board.md` (read that file before generating HTML).

Brand spec (white theme):
```css
--bg: #ffffff; --bg-secondary: #f8f8fb; --text: #0f0f0f; --text-muted: #6b7280;
--accent: #7c6af7; --accent-light: #ede9fe;
--success: #22c55e; --success-bg: #f0fdf4;
--border: #e5e7eb; --max-width: 1100px;
--font: system-ui, -apple-system, sans-serif;
```

HTML structure:
- **Header**: system name, component count, build stages count, date
- **Filter bar**: filter by component type (skill, automation, data structure, SOP)
- **Triage board columns**: one column per build stage (Stage 1, Stage 2, Stage 3...)
- **Component cards**: each card shows component name, type badge, and whether it reuses an existing skill
  - Skill = purple badge (`badge-purple`)
  - Automation = blue badge (`badge-blue`)
  - Data structure = teal badge (`badge-teal`)
  - SOP = grey badge (`badge-grey`)
  - Reusable existing skill = green "Reuse" badge alongside type badge
- **Footer controls**: Reset (restores original stage assignments), Copy as markdown (exports current column arrangement as the build sequence)

The operator can drag components between stages to reprioritise, then Copy as markdown to export the revised build order.

Interactivity (all self-contained JS): drag-drop, tag filter by type, Reset, Copy as markdown.

Save to `.system/BUILD-PLAN.html`.

Add this as the first line of BUILD-PLAN.md (after any frontmatter):
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

Read `.system/STATE.md` and update:
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
- [ ] HTML triage board generated using triage-board pattern from html-templates/triage-board.md
- [ ] HTML has columns per build stage, typed component cards, Reuse badges, drag-drop, Copy as markdown
- [ ] BUILD-PLAN.html saved alongside markdown
- [ ] [Open Visual Build Plan] link added to top of BUILD-PLAN.md
- [ ] Claude Code patterns recommended
- [ ] STATE.md updated
- [ ] Operator knows how to start building

</success_criteria>
