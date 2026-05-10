---
name: system:map-system
description: Identify what builds up, what moves, and where the boundaries are
allowed-tools:
  - Read
  - Write
  - Bash
  - Agent
  - AskUserQuestion
---

<objective>

Build a detailed structural inventory of the system. Map every accumulation (what builds up), every movement (what fills and drains it), and every boundary (inside vs outside the system).

Spawns the sys-mapper agent to walk the operator through the inventory.

**Reads:** `.system/SYSTEM-MAP.md`, `.system/OUTCOMES.md`
**Creates:** `.system/MAP.md`
**Updates:** `.system/STATE.md`

**After this command:** Run `/system:design-flows` to design how things move between parts.

</objective>

<execution_context>

@.claude/agents/sys-mapper.md

</execution_context>

<process>

## Step 1: Validate State

```bash
[ ! -f .system/SYSTEM-MAP.md ] && echo "ERROR: No system initialized. Run /system:new-system first." && exit 1
```

Read:
- `.system/SYSTEM-MAP.md`
- `.system/OUTCOMES.md`
- `.system/DESIGN.md`
- `.system/config.json`

Extract: system name, purpose, actors, boundaries, subsystems, outcomes, config preferences.

## Step 2: Display Stage Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◎  SYSTEM DESIGN >> MAPPING  ·  02/06
  What builds up, what moves, where are the edges.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mapping [system name]...
Spawning sys-mapper agent.
```

## Step 3: Spawn sys-mapper Agent

Build the agent prompt with full context from the files read in Step 1.

```
Agent(prompt="First, read .claude/agents/sys-mapper.md for your role and instructions.

<system_context>

**System name:** [name]
**Purpose:** [purpose from SYSTEM-MAP.md]

**Actors:**
[actors table from SYSTEM-MAP.md]

**Boundaries:**
Inside: [list]
Outside: [list]

**Subsystems identified so far:**
[subsystem names and purposes from DESIGN.md]

**Outcomes:**
[outcome list from OUTCOMES.md]

**Config:**
Mode: [mode]
Depth: [depth]

</system_context>

<instructions>
Follow your agent process. Walk the operator through the inventory. Write MAP.md when complete.

If mode is 'yolo': present your initial inventory, ask one round of confirmation, then write.
If mode is 'interactive': probe thoroughly for each accumulation before writing.

Depth controls detail level:
- quick: name accumulations and their primary in/out flows. Skip intangibles unless obvious.
- standard: full inventory with levels, targets, and boundary classification.
- comprehensive: everything in standard plus second-order accumulations, intangible stocks, and external dependency impact analysis.

Return your structured result when complete.
</instructions>
", description="Map system structure")
```

## Step 4: Handle Agent Return

Read the agent's structured return. Extract:
- Accumulation count
- Flow count
- Boundary crossing count
- Inventory summary table

Verify MAP.md was written:
```bash
[ ! -f .system/MAP.md ] && echo "WARNING: MAP.md not written. Check agent output."
```

## Step 5: Update STATE.md

Read `.system/STATE.md` and update:
- Stage: flows
- Last completed: map-system
- Next step: design-flows
- Mark `map-system` checkbox complete
- Add any decisions made during mapping

## Step 6: Present Results

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◎  SYSTEM DESIGN >> MAPPING COMPLETE ✓  ·  02/06
  Accumulations, flows, and boundaries defined.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Accumulations:** [count]
**Flows identified:** [count]
**Boundary crossings:** [count]

[Inventory summary table from agent return]

| Artifact   | Location        |
|------------|-----------------|
| System Map | .system/MAP.md  |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next: /system:design-flows -- design flow connections between subsystems

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

</process>

<output>

- `.system/MAP.md` (created)
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Abort triggered if `.system/SYSTEM-MAP.md` missing
- [ ] sys-mapper agent spawned with full system context
- [ ] Agent walked operator through accumulation inventory
- [ ] All accumulations from SYSTEM-MAP.md captured with specifics
- [ ] Operator probed for missed accumulations (intangibles, secondary effects)
- [ ] Each accumulation has: location, inflows, outflows, current level, target level
- [ ] Boundaries mapped: inside vs outside
- [ ] External dependencies documented with impact if they change
- [ ] MAP.md written with structured inventory
- [ ] STATE.md updated with correct stage and next step
- [ ] Operator knows next step is `/system:design-flows`

</success_criteria>
