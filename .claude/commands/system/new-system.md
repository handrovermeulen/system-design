---
name: system:new-system
description: Initialize a new system design through structured questioning
allowed-tools:
  - Read
  - Bash
  - Write
  - Agent
  - AskUserQuestion
---

<objective>

Initialize a new named system design through deep structured questioning. Map the operator's mental model into concrete system components before any design work begins.

Each system lives in its own folder: `.system/{name}/`. Multiple systems can coexist. One is active at a time.

**Creates:**
- `.system/{name}/SYSTEM-MAP.md` -- system purpose, actors, boundaries
- `.system/{name}/OUTCOMES.md` -- desired outcomes with measurability
- `.system/{name}/DESIGN.md` -- subsystem structure (skeleton)
- `.system/{name}/STATE.md` -- chain progress tracker
- `.system/{name}/config.json` -- workflow preferences
- `.system/ACTIVE` -- pointer to the currently active system

**After this command:** Run `/system:map-system` to inventory what builds up and what moves.

</objective>

<execution_context>

@.claude/system-design/references/questioning-guide.md
@.claude/system-design/templates/system-map.md
@.claude/system-design/templates/outcomes.md
@.claude/system-design/templates/design.md
@.claude/system-design/templates/state.md
@.claude/system-design/templates/config.json

</execution_context>

<process>

## Phase 1: Setup

**Execute these steps before any operator interaction:**

1. **Extract the system name from the command argument.** If the operator typed `/system:new-system my-system-name`, use `my-system-name`. If no argument was provided, ask inline (not AskUserQuestion): "What will you call this system? Use lowercase letters and hyphens, no spaces (e.g. `telegram-router`, `content-pipeline`)." Wait for the answer.

2. **Validate the name:**
   ```bash
   NAME="{extracted-name}"
   echo "$NAME" | grep -qE '^[a-z0-9][a-z0-9-]*$' || echo "ERROR: Name must be lowercase letters, numbers, and hyphens only." && exit 1
   echo "System name: $NAME"
   ```

3. **Abort if this system already exists:**
   ```bash
   [ -d ".system/$NAME" ] && echo "ERROR: System '$NAME' already exists. Use /system:switch $NAME to activate it, or choose a different name." && exit 1
   ```

4. **Create the system directory and set as active:**
   ```bash
   mkdir -p ".system/$NAME"
   echo "$NAME" > .system/ACTIVE
   echo "Created .system/$NAME/ | Set as active system."
   ```

You MUST run all four steps via the Bash tool before proceeding. Use `$NAME` as the working directory prefix for all file paths throughout this command.

## Phase 2: Deep Questioning

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◆  SYSTEM DESIGN >> QUESTIONING  ·  01/06
  Define the goal before building anything.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Open the conversation:**

Ask inline (freeform, NOT AskUserQuestion):

"What system do you want to design?"

Wait. Let the operator dump their mental model. Do not interrupt. Do not redirect.
Their first answer reveals what they think the system is. That framing is data.

**Follow the thread:**

Work through the 7 phases from questioning-guide.md. Do not announce phase transitions. Weave questions naturally based on what the operator shares.

Phase order: Open, Purpose and Boundaries, What Builds Up, What Moves, Self-Correction, Failure, Leverage.

For each phase, follow the probing rules from the guide:
- Push vague language to specifics
- Surface missing actors
- Probe missing failure paths
- Name circular references

**When to move on:** The operator has given specific, concrete answers. Probing yields repetition, not new information. You can name the key elements.

**Decision gate:**

When you can describe the system back to the operator in 3-4 sentences and they confirm it, use AskUserQuestion:

- header: "Ready to Document"
- question: "I think I have a clear picture. Ready to create the system files?"
- options:
  - "Create system files" -- Proceed to documentation
  - "Keep exploring" -- I want to share more or ask me more

If "Keep exploring": ask what they want to add, or identify gaps and probe. Loop until "Create system files" selected.

## Phase 3: Workflow Preferences

Use AskUserQuestion for each setting:

**Question 1: Mode**
- header: "Mode"
- question: "How do you want to work through the design chain?"
- options:
  - "Interactive" -- Confirm at each step (Recommended for first use)
  - "YOLO" -- Auto-approve, just execute

**Question 2: Depth**
- header: "Depth"
- question: "How thorough should the design be?"
- options:
  - "Quick" -- High-level flows, minimal detail
  - "Standard" -- Balanced detail and speed (Recommended)
  - "Comprehensive" -- Full specification of every flow and mechanism

**Question 3: Diagrams**
- header: "Diagrams"
- question: "Generate system diagrams during design?"
- options:
  - "Yes" -- Create visual diagrams at key stages (Recommended)
  - "No" -- Text only

Write `.system/{name}/config.json`:
```json
{
  "mode": "[chosen mode]",
  "depth": "[chosen depth]",
  "diagram": [true/false]
}
```

## Phase 4: Write System Files

Synthesize all questioning output into the system files using the templates.

Write all files into `.system/{name}/`. Use `{name}` resolved from Phase 1.

**`.system/{name}/SYSTEM-MAP.md`:** Use `templates/system-map.md`. Populate:
- System name and purpose (one paragraph)
- Actors table (from Phase 2 questioning)
- Boundaries (inside vs outside)
- Current state (existing system or greenfield)
- Key decisions (from questioning)

**`.system/{name}/OUTCOMES.md`:** Use `templates/outcomes.md`. Populate:
- Desired outcomes with categories
- Each outcome has: measurability, current state, target, priority
- Out of scope items

**`.system/{name}/DESIGN.md`:** Use `templates/design.md`. Populate:
- Overview (2-3 sentences)
- Subsystem skeletons (purpose, what builds up, flow placeholders)
- Build order (initial estimate)
- Progress table (all "Not started")

**`.system/{name}/STATE.md`:** Use `templates/state.md`. Set:
- Stage: mapping
- Last completed: new-system
- Next step: map-system
- Mark `new-system` checkbox complete

Do not compress. Capture everything gathered.

## Phase 5: Present and Confirm

Present the system back to the operator:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◆  SYSTEM DESIGN >> INITIALIZED ✓  ·  01/06
  Foundation set. Ready for mapping.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**[System Name]**

[2-3 sentence description from SYSTEM-MAP.md]

| Artifact     | Location                              |
|--------------|---------------------------------------|
| System Map   | .system/{name}/SYSTEM-MAP.md          |
| Outcomes     | .system/{name}/OUTCOMES.md            |
| Design       | .system/{name}/DESIGN.md              |
| State        | .system/{name}/STATE.md               |
| Config       | .system/{name}/config.json            |
| Active       | .system/ACTIVE                        |

**[N] outcomes** | **[M] subsystems identified** | Ready for mapping

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next: /system:map-system -- inventory what builds up, what moves, where the boundaries are

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

</process>

<output>

- `.system/SYSTEM-MAP.md`
- `.system/OUTCOMES.md`
- `.system/DESIGN.md`
- `.system/STATE.md`
- `.system/config.json`

</output>

<success_criteria>

- [ ] System name extracted from argument or asked inline
- [ ] Name validated (lowercase, hyphens, no spaces)
- [ ] Abort triggered if `.system/{name}/` already existed
- [ ] `.system/{name}/` directory created
- [ ] `.system/ACTIVE` written with the system name
- [ ] Deep questioning completed (all 7 phases covered, threads followed, not rushed)
- [ ] Operator confirmed the system description before documentation
- [ ] Config preferences captured (mode, depth, diagram)
- [ ] SYSTEM-MAP.md captures system purpose, actors, boundaries, current state
- [ ] OUTCOMES.md captures measurable outcomes with priorities
- [ ] DESIGN.md has subsystem skeletons (not fully specified yet)
- [ ] STATE.md initialized with correct stage and next step
- [ ] Operator knows next step is `/system:map-system`

</success_criteria>
