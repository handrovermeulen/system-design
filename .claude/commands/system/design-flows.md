---
name: system:design-flows
description: Design flow connections between subsystems
allowed-tools:
  - Read
  - Write
  - Bash
  - Agent
  - AskUserQuestion
---

<objective>

Design the flow connections between subsystems. For every movement in the system, specify what triggers it, what data moves, what transforms, where it hands off, and what happens when it breaks.

Spawns the sys-flow-designer agent to question the operator on each flow.

**Reads:** `.system/MAP.md`, `.system/DESIGN.md`
**Creates:** `.system/flows/{flow-name}.md` (one per major flow)
**Updates:** `.system/DESIGN.md`, `.system/STATE.md`

**After this command:** Run `/system:design-feedback` to add self-correction mechanisms.

</objective>

<execution_context>

@.claude/agents/sys-flow-designer.md

</execution_context>

<process>

## Step 1: Validate State

```bash
[ ! -f .system/MAP.md ] && echo "ERROR: No system map found. Run /system:map-system first." && exit 1
```

Read:
- `.system/MAP.md`
- `.system/DESIGN.md`
- `.system/OUTCOMES.md`
- `.system/config.json`

Extract: all accumulations and their inflows/outflows from MAP.md, subsystem structure from DESIGN.md, config preferences.

## Step 2: Display Stage Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⇢  SYSTEM DESIGN >> DESIGNING FLOWS  ·  03/06
  How do parts connect? What triggers what?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Designing flow connections for [system name]...
Spawning sys-flow-designer agent.
```

## Step 3: Create Flows Directory

```bash
mkdir -p .system/flows
```

## Step 4: Spawn sys-flow-designer Agent

Build the agent prompt with full context.

```
Agent(prompt="First, read .claude/agents/sys-flow-designer.md for your role and instructions.

<system_context>

**System name:** [name]

**Accumulations (from MAP.md):**
[Full list of accumulations with their inflows and outflows]

**Subsystems (from DESIGN.md):**
[Subsystem names, purposes, and dependencies]

**Outcomes:**
[Outcome list from OUTCOMES.md]

**Config:**
Mode: [mode]
Depth: [depth]

</system_context>

<instructions>
Follow your agent process. Enumerate all flows, then specify each one with the operator.

Every flow needs 5 specs: trigger, data, transform, handoff, failure. Do not accept incomplete flows.

If mode is 'yolo': present your flow enumeration, ask one round of confirmation, specify each flow with minimal questioning, then write.
If mode is 'interactive': question the operator on each flow's 5 specs individually.

Depth controls detail level:
- quick: specify trigger type and failure path. Skip transform details if pass-through.
- standard: full 5-spec for each flow. Push for trigger specifics and failure paths.
- comprehensive: full 5-spec plus volume estimates, latency requirements, and alternative flow paths.

Write one file per major flow to .system/flows/{flow-name}.md.
Update DESIGN.md with flow specifications for each subsystem.
Return your structured result when complete.
</instructions>
", description="Design flow connections")
```

## Step 5: Handle Agent Return

Read the agent's structured return. Extract:
- Flow count
- Trigger type distribution (event, schedule, threshold, manual)
- Flow summary table

Verify flow files were written:
```bash
ls .system/flows/*.md 2>/dev/null | wc -l
```

Verify DESIGN.md was updated:
```bash
grep -c "Flows:" .system/DESIGN.md
```

## Step 6: Update STATE.md

Read `.system/STATE.md` and update:
- Stage: feedback
- Last completed: design-flows
- Next step: design-feedback
- Mark `design-flows` checkbox complete
- Add any decisions made during flow design

## Step 7: Present Results

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⇢  SYSTEM DESIGN >> FLOWS DESIGNED ✓  ·  03/06
  Every trigger sourced, every handoff specified.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Flows specified:** [count]
**Trigger types:** event: [N], schedule: [N], threshold: [N], manual: [N]

[Flow summary table from agent return]

| Artifact         | Location             |
|------------------|----------------------|
| Flow specs       | .system/flows/       |
| Design (updated) | .system/DESIGN.md    |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next: /system:design-feedback -- add self-correction mechanisms and check for trap patterns

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

</process>

<output>

- `.system/flows/{flow-name}.md` (one per major flow, created)
- `.system/DESIGN.md` (updated with flow specs)
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Abort triggered if `.system/MAP.md` missing
- [ ] sys-flow-designer agent spawned with full system context
- [ ] All flows from MAP.md enumerated
- [ ] Operator confirmed flow list is complete
- [ ] Each flow has all 5 specs: trigger, data, transform, handoff, failure
- [ ] Trigger types are specific (not vague)
- [ ] Failure paths documented for every flow
- [ ] One file per major flow in `.system/flows/`
- [ ] DESIGN.md updated with flow specifications
- [ ] STATE.md updated with correct stage and next step
- [ ] Operator knows next step is `/system:design-feedback`

</success_criteria>
