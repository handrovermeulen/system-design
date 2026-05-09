# System Design for Claude Code

Design complete systems before building them. Close the loop.

## The Problem

Claude builds parts, not wholes.
People create skills, automations, and workflows that never close the loop.
No feedback. No verification. No self-correction. Outputs nobody consumes. Things that grow unchecked until they break.

## The Solution

A skill chain that walks you through first-principles system design.
Maps what builds up, what moves, what self-corrects.
Verifies every loop is closed before you write a single skill.

## Quick Start

```bash
git clone https://github.com/handrovermeulen/system-design.git
cd system-design
./install.sh
```

Then in any Claude Code project:

```
/system:new-system
```

## Skill Chain

```
/system:new-system       What are you building? Who is involved? What matters?
     |
/system:map-system       What builds up? What moves? Where are the boundaries?
     |
/system:design-flows     How does each part connect? What triggers movement?
     |
/system:design-feedback  What self-corrects? What amplifies? What traps exist?
     |
/system:verify-closure   Is every loop closed? (5 tests)
     |
/system:build-plan       What skills and automations to build, in what order?
```

Each step produces artifacts in `.system/` and feeds the next step.

## What It Produces

The chain generates these files in `.system/`:

- `SYSTEM-MAP.md`. System purpose, actors, boundaries, current state, key decisions.
- `OUTCOMES.md`. Desired outcomes with measurability, current state, targets, priority.
- `MAP.md`. What builds up, what moves, where the boundaries are.
- `DESIGN.md`. Subsystem breakdown, dependencies, build order.
- `flows/{flow-name}.md`. Per-flow specs: trigger, data, transform, handoff, failure path.
- `feedback/{mechanism-name}.md`. Per-mechanism specs: detection, correction, delay.
- `CLOSURE-REPORT.md`. Results of five closure tests with pass/fail per item.
- `BUILD-PLAN.md`. Ordered component list with type, dependencies, and recommended patterns.

## The Five Closure Tests

1. **Output consumption.** Every output is consumed by at least one downstream process.
2. **Trigger sourcing.** Every trigger traces back to a concrete event or schedule.
3. **Self-correction.** Everything that accumulates has a way to detect drift and correct it.
4. **Failure paths.** Every flow has a documented failure case.
5. **Information access.** Every decision point has its data source specified.

A system passes verification only when all five tests clear.

## Powered By

The intellectual framework is Donella Meadows' systems thinking.
The operator sees plain language throughout. The framework runs under the surface.

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

## License

MIT
