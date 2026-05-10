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

Initialize a new system design through deep structured questioning. Map the operator's mental model into concrete system components before any design work begins.

**Creates:**
- `.system/SYSTEM-MAP.md` -- system purpose, actors, boundaries
- `.system/OUTCOMES.md` -- desired outcomes with measurability
- `.system/DESIGN.md` -- subsystem structure (skeleton)
- `.system/STATE.md` -- chain progress tracker
- `.system/config.json` -- workflow preferences

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

**Execute these checks before any operator interaction:**

1. **Abort if system exists:**
   ```bash
   [ -d .system ] && echo "ERROR: System already initialized. Use /system:map-system or check .system/STATE.md for current position." && exit 1
   ```

2. **Create system directory:**
   ```bash
   mkdir -p .system
   ```

You MUST run both checks via the Bash tool before proceeding.

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

Write `.system/config.json`:
```json
{
  "mode": "[chosen mode]",
  "depth": "[chosen depth]",
  "diagram": [true/false]
}
```

## Phase 4: Write System Files

Synthesize all questioning output into the system files using the templates.

**SYSTEM-MAP.md:** Use `templates/system-map.md`. Populate:
- System name and purpose (one paragraph)
- Actors table (from Phase 2 questioning)
- Boundaries (inside vs outside)
- Current state (existing system or greenfield)
- Key decisions (from questioning)

**OUTCOMES.md:** Use `templates/outcomes.md`. Populate:
- Desired outcomes with categories
- Each outcome has: measurability, current state, target, priority
- Out of scope items

**DESIGN.md:** Use `templates/design.md`. Populate:
- Overview (2-3 sentences)
- Subsystem skeletons (purpose, what builds up, flow placeholders)
- Build order (initial estimate)
- Progress table (all "Not started")

**STATE.md:** Use `templates/state.md`. Set:
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

| Artifact     | Location             |
|--------------|----------------------|
| System Map   | .system/SYSTEM-MAP.md |
| Outcomes     | .system/OUTCOMES.md   |
| Design       | .system/DESIGN.md     |
| State        | .system/STATE.md      |
| Config       | .system/config.json   |

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

- [ ] `.system/` directory created
- [ ] Abort triggered if `.system/` already existed
- [ ] Deep questioning completed (all 7 phases covered, threads followed, not rushed)
- [ ] Operator confirmed the system description before documentation
- [ ] Config preferences captured (mode, depth, diagram)
- [ ] SYSTEM-MAP.md captures system purpose, actors, boundaries, current state
- [ ] OUTCOMES.md captures measurable outcomes with priorities
- [ ] DESIGN.md has subsystem skeletons (not fully specified yet)
- [ ] STATE.md initialized with correct stage and next step
- [ ] Operator knows next step is `/system:map-system`

</success_criteria>
