---
name: system:progress
description: Show current system design state
allowed-tools:
  - Read
  - Bash
---

<objective>

Show the current state of the system design. Which stages are complete, what to run next.

</objective>

<process>

## Step 1: Check System Exists

```bash
[ ! -d .system ] && echo "No system design found. Run /system:new-system to start." && exit 1
```

## Step 2: Load State

Read `.system/STATE.md` if it exists.
Read `.system/config.json` if it exists.

## Step 3: Check Artifacts

Detect which stages are complete by checking for artifacts:

```bash
echo "=== Artifact Check ==="
[ -f .system/SYSTEM-MAP.md ] && echo "SYSTEM-MAP.md: exists" || echo "SYSTEM-MAP.md: missing"
[ -f .system/MAP.md ] && echo "MAP.md: exists" || echo "MAP.md: missing"
FLOW_COUNT=$(ls .system/flows/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Flow files: $FLOW_COUNT"
FEEDBACK_COUNT=$(ls .system/feedback/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Feedback files: $FEEDBACK_COUNT"
[ -f .system/CLOSURE-REPORT.md ] && echo "CLOSURE-REPORT.md: exists" || echo "CLOSURE-REPORT.md: missing"
[ -f .system/BUILD-PLAN.md ] && echo "BUILD-PLAN.md: exists" || echo "BUILD-PLAN.md: missing"
```

## Step 4: Determine Completion

Map artifacts to stages:
- SYSTEM-MAP.md exists -> new-system complete
- MAP.md exists -> map-system complete
- flows/ has files -> design-flows complete
- feedback/ has files -> design-feedback complete
- CLOSURE-REPORT.md exists -> verify-closure complete
- BUILD-PLAN.md exists -> build-plan complete

## Step 5: Present Status

Read the system name from SYSTEM-MAP.md (first heading).

Present:

```
System Design: [System Name]

[x] new-system        System mapped, outcomes defined
[x] map-system        Accumulations and boundaries inventoried
[x] design-flows      [N] flow connections specified
[ ] design-feedback   Self-correction mechanisms
[ ] verify-closure    Closure test (5 tests)
[ ] build-plan        Build plan

Config: mode=[mode] | depth=[depth] | diagram=[on/off]

Next: /system:design-feedback
```

Mark stages with [x] if complete, [ ] if not.
Identify the first incomplete stage as "Next."

If all stages complete:
```
All stages complete. System design is ready to build.
Review: .system/BUILD-PLAN.md
```

</process>

<success_criteria>

- [ ] System existence checked
- [ ] All artifacts checked
- [ ] Stages mapped to completion status
- [ ] Clear visual showing what is done and what is next
- [ ] Next step identified

</success_criteria>
