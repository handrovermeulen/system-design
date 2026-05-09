# System Design

## Overview

[2-3 sentences: what this system does, how many subsystems, key dependency chain.]

## Subsystems

### [Subsystem Name]

**Purpose:** [What this part does]

**What builds up here:** [What accumulates in this subsystem]

**Flows:**
- In: [What enters, triggered by what]
- Out: [What leaves, goes where]

**Self-correction:** [How drift gets detected and fixed]

**Dependencies:** [What other subsystems this needs]

**Outcomes served:** [OUT-IDs this subsystem supports]

---

### [Next Subsystem]

**Purpose:** [What this part does]

**What builds up here:** [What accumulates]

**Flows:**
- In: [What enters]
- Out: [What leaves]

**Self-correction:** [Detection and correction mechanism]

**Dependencies:** [Dependencies]

**Outcomes served:** [OUT-IDs]

## Build Order

| Order | Subsystem | Reason |
|-------|-----------|--------|
| 1 | [Name] | [No dependencies / Foundation] |
| 2 | [Name] | [Depends on subsystem 1] |
| 3 | [Name] | [Depends on subsystem 1 and 2] |

## Progress

| Subsystem | Design Status | Build Status |
|-----------|---------------|--------------|
| [Name] | [Complete / In progress / Not started] | [Not started] |

---
*Last updated: [date]*
