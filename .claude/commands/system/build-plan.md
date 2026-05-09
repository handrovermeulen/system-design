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

## Step 2: Load Design Artifacts

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

## Step 4: Present Build Plan

Read the BUILD-PLAN.md written by the agent and present it:

```
System Design: Build Plan Ready

Components: [count]
  Skills: [N] | Automations: [N] | Data Structures: [N] | SOPs: [N]

Build Order:
  Stage 1: [component names]
  Stage 2: [component names]
  ...

Reusable existing skills: [count]

Claude Code patterns:
  [pattern]: [which components]

Start building: /new-skill [first-component-name]
```

## Step 5: Update State

Read `.system/STATE.md` and update:
- Current Position: complete
- Last completed: build-plan
- Mark build-plan checkbox

Write updated STATE.md.

</process>

<output>

- `.system/BUILD-PLAN.md`
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
- [ ] Claude Code patterns recommended
- [ ] STATE.md updated
- [ ] Operator knows how to start building

</success_criteria>
