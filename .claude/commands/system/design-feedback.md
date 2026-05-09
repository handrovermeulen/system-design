---
name: system:design-feedback
description: Design self-correction mechanisms and detect system trap patterns
allowed-tools:
  - Read
  - Write
  - Bash
  - Agent
  - AskUserQuestion
---

<objective>

Design the self-correction mechanisms that keep the system on target. For everything that builds up, specify how drift gets detected and corrected. Check the design against 7 common trap patterns that cause systems to fail over time.

Optionally generates a system diagram showing what builds up, what moves, and what self-corrects.

Spawns the sys-feedback-designer agent.

**Reads:** `.system/MAP.md`, `.system/flows/`, `.system/OUTCOMES.md`
**Creates:** `.system/feedback/{mechanism-name}.md`, optionally `.system/system-diagram.excalidraw`
**Updates:** `.system/STATE.md`

**After this command:** Run `/system:verify-closure` to test whether every loop is closed.

</objective>

<execution_context>

@.claude/agents/sys-feedback-designer.md
@.claude/system-design/references/system-traps.md

</execution_context>

<process>

## Step 1: Validate State

```bash
[ ! -d .system/flows ] && echo "ERROR: No flows designed. Run /system:design-flows first." && exit 1
ls .system/flows/*.md 2>/dev/null | wc -l | grep -q "^0$" && echo "ERROR: No flow files found. Run /system:design-flows first." && exit 1
```

Read:
- `.system/MAP.md`
- `.system/OUTCOMES.md`
- `.system/DESIGN.md`
- `.system/config.json`
- All files in `.system/flows/`

Extract: all accumulations from MAP.md, all flows, all outcomes, config preferences.

## Step 2: Display Stage Banner

```
----------------------------------------------------
 SYSTEM DESIGN >> DESIGNING FEEDBACK
----------------------------------------------------

Designing self-correction mechanisms for [system name]...
Spawning sys-feedback-designer agent.
```

## Step 3: Create Feedback Directory

```bash
mkdir -p .system/feedback
```

## Step 4: Spawn sys-feedback-designer Agent

Build the agent prompt with full context.

```
Agent(prompt="First, read .claude/agents/sys-feedback-designer.md for your role and instructions.
Then read .claude/system-design/references/system-traps.md for the 7 trap patterns to check.

<system_context>

**System name:** [name]

**Accumulations (from MAP.md):**
[Full list of accumulations with current levels, targets, and boundaries]

**Flows:**
[Summary of all flows from flows/ directory: name, from, to, trigger type]

**Outcomes:**
[Outcome list from OUTCOMES.md]

**Config:**
Mode: [mode]
Depth: [depth]

</system_context>

<instructions>
Follow your agent process:
1. Design self-correction for each accumulation
2. Identify amplifiers (self-reinforcing cycles)
3. Check all 7 trap patterns against the design
4. Write feedback files
5. Flag unregulated accumulations

If mode is 'yolo': present your proposed mechanisms, ask one round of confirmation, then write.
If mode is 'interactive': question the operator on each accumulation's detection, correction, and delay.

Depth controls detail level:
- quick: detection method and correction action only. Skip delay analysis unless obvious risk.
- standard: full detection, correction, and delay for each accumulation. Check all 7 traps.
- comprehensive: everything in standard plus amplifier chain analysis, second-order trap interactions, and delay sensitivity assessment.

Write one file per mechanism to .system/feedback/{mechanism-name}.md.
Return your structured result when complete. Include trap warnings prominently.
</instructions>
", description="Design self-correction mechanisms")
```

## Step 5: Handle Agent Return

Read the agent's structured return. Extract:
- Mechanism count
- Amplifier count
- Trap warning count
- Unregulated accumulation count
- Mechanism summary table
- Trap warnings list

Verify feedback files were written:
```bash
ls .system/feedback/*.md 2>/dev/null | wc -l
```

## Step 6: Diagram Generation (Conditional)

Read `.system/config.json`. If `diagram` is `true`:

```
----------------------------------------------------
 SYSTEM DESIGN >> GENERATING DIAGRAM
----------------------------------------------------
```

Generate an Excalidraw diagram showing the full system:
- Accumulations as rectangles (labeled with name and target level)
- Flows as arrows between accumulations (labeled with trigger type)
- Feedback mechanisms as curved arrows returning to their monitored accumulation
- Boundary line separating inside from outside the system
- Trap warnings as annotation callouts near affected components

Use the `/excalidraw-diagram` skill if available. If not available, write the Excalidraw JSON directly to `.system/system-diagram.excalidraw`.

The diagram should be readable at a glance. Keep labels short. Use color to distinguish:
- Accumulations: light blue fill
- Flows: dark arrows
- Feedback loops: green arrows
- Trap warnings: red callouts
- Boundary: dashed gray line

## Step 7: Update STATE.md

Read `.system/STATE.md` and update:
- Stage: verification
- Last completed: design-feedback
- Next step: verify-closure
- Mark `design-feedback` checkbox complete
- Add any decisions made during feedback design

## Step 8: Present Results

```
----------------------------------------------------
 SYSTEM DESIGN >> FEEDBACK DESIGNED
----------------------------------------------------

**Mechanisms:** [count]
**Amplifiers identified:** [count]
**Trap warnings:** [count]
**Unregulated accumulations:** [count]

[Mechanism summary table from agent return]
```

If trap warnings exist, present them prominently:

```
## Trap Warnings

[For each trap warning:]
- **[Trap name]:** [Where detected in this system]. Fix: [suggested structural fix].
```

If unregulated accumulations exist:

```
## Unregulated (must address before verification)

[For each unregulated accumulation:]
- **[Name]:** No self-correction mechanism. It will drift unchecked.
```

If diagram was generated:

```
**Diagram:** .system/system-diagram.excalidraw
```

```
| Artifact         | Location                             |
|------------------|--------------------------------------|
| Feedback specs   | .system/feedback/                    |
| Diagram          | .system/system-diagram.excalidraw    |

----------------------------------------------------

Next: /system:verify-closure -- run five closure tests to verify the design is complete

----------------------------------------------------
```

</process>

<output>

- `.system/feedback/{mechanism-name}.md` (one per mechanism, created)
- `.system/system-diagram.excalidraw` (if diagram enabled)
- `.system/STATE.md` (updated)

</output>

<success_criteria>

- [ ] Abort triggered if `.system/flows/` missing or empty
- [ ] sys-feedback-designer agent spawned with full system context
- [ ] Every accumulation from MAP.md has a self-correction mechanism or is explicitly flagged
- [ ] Each mechanism has: detection, correction, delay
- [ ] Amplifiers identified and assessed (beneficial vs dangerous)
- [ ] All 7 trap patterns checked against the design
- [ ] Trap warnings presented with plain-language explanation and fix
- [ ] One file per mechanism in `.system/feedback/`
- [ ] Unregulated accumulations flagged prominently
- [ ] Diagram generated if config.diagram is true
- [ ] STATE.md updated with correct stage and next step
- [ ] Operator knows next step is `/system:verify-closure`

</success_criteria>
