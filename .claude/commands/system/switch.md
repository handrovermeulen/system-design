---
name: system:switch
description: Switch the active system design
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

<objective>

Switch which system design is currently active. All subsequent chain commands will operate on the selected system.

**Reads:** `.system/ACTIVE`, `.system/*/STATE.md`
**Updates:** `.system/ACTIVE`

</objective>

<process>

## Step 1: List Available Systems

```bash
SYSTEMS=$(ls -d .system/*/ 2>/dev/null | grep -v -E '^\.' | sed 's|.system/||' | sed 's|/$||' | grep -v '^$')
ACTIVE=$(cat .system/ACTIVE 2>/dev/null)
echo "Active: $ACTIVE"
echo "Available systems:"
echo "$SYSTEMS"
```

If no systems found (`.system/` is empty or missing), tell the operator to run `/system:new-system [name]` first and stop.

## Step 2: Show System List

For each system found, read its `STATE.md` to show the current stage. Present:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ◆  SYSTEM DESIGN >> SWITCH ACTIVE SYSTEM
  Select the system to work on.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Systems found:

  [active marker] [system-name]  Stage: [current stage from STATE.md]
  [ ]             [system-name]  Stage: [current stage from STATE.md]
  ...
```

Mark the currently active system with `[*]`, others with `[ ]`.

## Step 3: Select System

If the operator provided a name as a command argument and that name exists, use it directly. Skip the question.

Otherwise use AskUserQuestion:
- header: "Switch Active System"
- question: "Which system do you want to activate?"
- options: one option per system name found, plus "Cancel"

If "Cancel": stop without making changes.

## Step 4: Switch

```bash
echo "{selected-system-name}" > .system/ACTIVE
cat .system/ACTIVE
```

Confirm:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Active system: {selected-system-name}
Working directory: .system/{selected-system-name}/

Next: /system:progress to see where this system is in the chain.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

</process>

<success_criteria>

- [ ] Available systems listed with stage status
- [ ] Currently active system clearly marked
- [ ] Operator confirms selection before switching
- [ ] `.system/ACTIVE` updated with new system name
- [ ] Operator knows next step after switch

</success_criteria>
