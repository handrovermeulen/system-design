---
name: system:progress
description: Show current system design state across all systems
allowed-tools:
  - Read
  - Bash
---

<objective>

Show the current state of all system designs. Which system is active, which stages are complete, what to run next.

</objective>

<process>

## Step 1: Check Systems Exist

```bash
SYSTEMS=$(ls -d .system/*/ 2>/dev/null | sed 's|.system/||' | sed 's|/$||' | grep -v '^$')
ACTIVE=$(cat .system/ACTIVE 2>/dev/null)
echo "Active: ${ACTIVE:-none}"
echo "Systems: ${SYSTEMS:-none}"
```

If no systems found: "No system designs found. Run `/system:new-system [name]` to start." Stop.

## Step 2: For Each System, Check Artifacts

For each system in the list, run:

```bash
SYSDIR=".system/{system-name}"
echo "=== {system-name} ==="
[ -f "$SYSDIR/SYSTEM-MAP.md" ] && echo "SYSTEM-MAP.md: exists" || echo "SYSTEM-MAP.md: missing"
[ -f "$SYSDIR/MAP.md" ] && echo "MAP.md: exists" || echo "MAP.md: missing"
FLOW_COUNT=$(ls "$SYSDIR/flows/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Flow files: $FLOW_COUNT"
FEEDBACK_COUNT=$(ls "$SYSDIR/feedback/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Feedback files: $FEEDBACK_COUNT"
[ -f "$SYSDIR/CLOSURE-REPORT.md" ] && echo "CLOSURE-REPORT.md: exists" || echo "CLOSURE-REPORT.md: missing"
[ -f "$SYSDIR/BUILD-PLAN.md" ] && echo "BUILD-PLAN.md: exists" || echo "BUILD-PLAN.md: missing"
```

## Step 3: Determine Completion Per System

Map artifacts to stages:
- SYSTEM-MAP.md exists -> new-system complete
- MAP.md exists -> map-system complete
- flows/ has files -> design-flows complete
- feedback/ has files -> design-feedback complete
- CLOSURE-REPORT.md exists -> verify-closure complete
- BUILD-PLAN.md exists -> build-plan complete

## Step 4: Present Status

For each system, read its name from SYSTEM-MAP.md (first heading) and the config from config.json.

Present all systems, with the active one first and marked:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◆  SYSTEM DESIGN >> PROGRESS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[*] {active-system-name}                         ← ACTIVE

  [x] ◆  01  new-system        System mapped, outcomes defined
  [x] ◎  02  map-system        Accumulations and boundaries inventoried
  [x] ⇢  03  design-flows      [N] flow connections specified
  [ ] ↺  04  design-feedback   Self-correction mechanisms
  [ ] ◉  05  verify-closure    Closure test (5 tests)
  [ ] ▤  06  build-plan        Build plan

  Config: mode=[mode] | depth=[depth] | diagram=[on/off]
  Next: /system:design-feedback

[ ] {other-system-name}

  [x] ◆  01  new-system        System mapped, outcomes defined
  [ ] ◎  02  map-system        Accumulations and boundaries inventoried
  ...

  Next: /system:map-system

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To switch: /system:switch [name]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Mark stages with [x] if complete, [ ] if not.
Identify the first incomplete stage as "Next" for each system.

If all stages complete for active system:
```
All stages complete. System design is ready to build.
Review: .system/{active-system-name}/BUILD-PLAN.md
```

</process>

<success_criteria>

- [ ] All systems listed, active system marked
- [ ] Each system shows full stage completion status
- [ ] Next step identified per system
- [ ] Switch command surfaced at the bottom

</success_criteria>
