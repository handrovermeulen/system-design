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

## Step 4: Handle Results

**If `## CLOSURE VERIFIED`:**

Present the score and test summary.

```
System Design: Closure Verified

Score: 5/5 tests passed
Items checked: [total]
Warnings: [count]

[Test result table from agent return]

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

## Step 5: Update State

Read `.system/STATE.md` and update:
- Current Position: verification
- Last completed: verify-closure (if passed)
- Mark verify-closure checkbox

Write updated STATE.md.

</process>

<output>

- `.system/CLOSURE-REPORT.md`
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Prerequisites checked (MAP.md, flows/, feedback/ exist)
- [ ] All design artifacts loaded
- [ ] sys-closure-verifier agent spawned with full context
- [ ] All 5 tests run with per-item results
- [ ] CLOSURE-REPORT.md written
- [ ] Results presented clearly (pass or gaps)
- [ ] Failures paired with specific fix recommendations
- [ ] STATE.md updated
- [ ] Operator knows next step

</success_criteria>
