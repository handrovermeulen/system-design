---
name: system:help
description: Show available /system commands and usage
allowed-tools:
  - Read
---

<objective>

Display the /system command reference.

</objective>

<process>

Display this reference:

```
/system Skill Chain

Design complete systems before building them. Close the loop.

Commands (run in order):

  /system:new-system       Initialize a new system design
  /system:map-system       Map what builds up, what moves, boundaries
  /system:design-flows     Design flow connections between parts
  /system:design-feedback  Design self-correction mechanisms
  /system:verify-closure   Run 5 closure tests
  /system:build-plan       Generate the build plan

Utilities:

  /system:progress         Show current design state
  /system:help             This reference

State directory: .system/ in the current project
Each command produces artifacts consumed by the next.

The five closure tests:
  1. Output Consumption    Every output has a named consumer
  2. Trigger Sourcing      Every trigger has a specified source
  3. Self-Correction       Every accumulation has detection and correction
  4. Failure Paths         Every flow has a documented failure case
  5. Information Access    Every decision has its data source

Start: /system:new-system "your goal"
```

</process>
