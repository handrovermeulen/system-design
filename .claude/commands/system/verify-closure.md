---
name: system:verify-closure
description: Run five closure tests to verify the system design is complete
allowed-tools:
  - Read
  - Bash
  - Grep
  - Glob
  - Write
  - Agent
---

<objective>

Run five closure tests against the system design. Verify every output is consumed, every trigger is sourced, every accumulation is regulated, every failure is handled, and every decision has data.

This is the intellectual core of the /system skill chain. A system that passes all five tests has every loop closed.

**Requires:** `.system/MAP.md`, `.system/flows/`, `.system/feedback/` must exist.

**Produces:**
- `.system/CLOSURE-REPORT.md`
- `.system/CLOSURE-REPORT.html`

**After this command:** Run `/system:build-plan` to generate the build plan.

</objective>

<execution_context>

@.claude/system-design/references/closure-test.md
@.claude/system-design/templates/closure-report.md

</execution_context>

<process>

## Step 1: Check Prerequisites

```bash
[ ! -f .system/MAP.md ] && echo "ERROR: Run /system:map-system first" && exit 1
[ ! -d .system/flows ] && echo "ERROR: Run /system:design-flows first" && exit 1
[ ! -d .system/feedback ] && echo "ERROR: Run /system:design-feedback first" && exit 1
```

Count flow files and feedback files:
```bash
FLOW_COUNT=$(ls .system/flows/*.md 2>/dev/null | wc -l)
FEEDBACK_COUNT=$(ls .system/feedback/*.md 2>/dev/null | wc -l)
echo "Flows: $FLOW_COUNT | Feedback mechanisms: $FEEDBACK_COUNT"
```

If either count is zero, tell the operator which skill to run.

## Step 2: Load Context

Read all design artifacts:
- `.system/SYSTEM-MAP.md`
- `.system/MAP.md`
- `.system/OUTCOMES.md`
- `.system/DESIGN.md`
- All files in `.system/flows/`
- All files in `.system/feedback/`

## Step 3: Spawn Closure Verifier

Spawn sys-closure-verifier agent with full context:

```
Agent(prompt="
Read your agent definition first:
@.claude/agents/sys-closure-verifier.md

<system_artifacts>
[Include content of all .system/ files]
</system_artifacts>

<instructions>
Run all 5 closure tests against the system design.
Write .system/CLOSURE-REPORT.md using the template.
Return CLOSURE VERIFIED or CLOSURE GAPS FOUND with results.
</instructions>
", subagent_type="general-purpose", description="Closure verification")
```

## Step 4: Generate HTML Closure Report

After the agent writes CLOSURE-REPORT.md, generate a self-contained interactive HTML report.

Use the report pattern from `.claude/skills/html-templates/report.md` (read that file before generating HTML).

Brand spec (white theme):
```css
--bg: #ffffff; --bg-secondary: #f8f8fb; --text: #0f0f0f; --text-muted: #6b7280;
--accent: #7c6af7; --accent-light: #ede9fe;
--success: #22c55e; --success-bg: #f0fdf4;
--error: #ef4444; --error-bg: #fef2f2;
--warning: #f59e0b; --warning-bg: #fffbeb;
--border: #e5e7eb; --max-width: 1100px;
--font: system-ui, -apple-system, sans-serif;
```

HTML structure:
- **Header**: system name, overall score (e.g. "4/5 PASS"), date
- **Score grid**: 5 check cards — PASS = green badge, FAIL = red badge, WARNING = amber badge
- **Accordion sections**: one per closure test, auto-expanded if FAIL status
- **Failures section** (if any): each failure with plain-language explanation and recommended fix
- **Action items table** (if failures): Priority, Item, Recommended Fix columns

Interactivity (all self-contained JS):
- Accordion toggle on each test section
- Auto-open any FAIL sections on page load
- ToC scroll highlighting

Save to `.system/CLOSURE-REPORT.html`.

Add this as the first line of CLOSURE-REPORT.md (after any frontmatter):
```
[Open Visual Report](CLOSURE-REPORT.html)
```

## Step 5: Handle Results

**If `## CLOSURE VERIFIED`:**

Present the score and test summary.

```
System Design: Closure Verified

Score: 5/5 tests passed
Items checked: [total]
Warnings: [count]

[Test result table from agent return]

Artifacts:
  .system/CLOSURE-REPORT.md
  .system/CLOSURE-REPORT.html

Next: /system:build-plan
```

**If `## CLOSURE GAPS FOUND`:**

Present failures with fix recommendations.

```
System Design: Closure Gaps Found

Score: [X]/5 tests passed
Failures: [count]

[Failure table with recommended fixes]

Fix the gaps, then re-run /system:verify-closure.
```

## Step 6: Update State

Read `.system/STATE.md` and update:
- Current Position: verification
- Last completed: verify-closure (if passed)
- Mark verify-closure checkbox

Write updated STATE.md.

</process>

<output>

- `.system/CLOSURE-REPORT.md`
- `.system/CLOSURE-REPORT.html`
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Prerequisites checked (MAP.md, flows/, feedback/ exist)
- [ ] All design artifacts loaded
- [ ] sys-closure-verifier agent spawned with full context
- [ ] All 5 tests run with per-item results
- [ ] CLOSURE-REPORT.md written
- [ ] HTML report generated using report pattern from html-templates/report.md
- [ ] HTML has score header, 5 check cards, accordion detail sections, action items table
- [ ] FAIL sections auto-expand on page load
- [ ] CLOSURE-REPORT.html saved alongside markdown
- [ ] [Open Visual Report] link added to top of CLOSURE-REPORT.md
- [ ] Results presented clearly (pass or gaps)
- [ ] Failures paired with specific fix recommendations
- [ ] STATE.md updated
- [ ] Operator knows next step

</success_criteria>
