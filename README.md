# System Design for Claude Code

Design complete systems before building them. Close the loop.

## The Problem

Claude builds parts, not wholes.
People create skills, automations, and workflows that never close the loop.
No feedback. No verification. No self-correction. Outputs that nobody consumes. Stocks that grow until they break.

## The Solution

A skill chain that walks you through first-principles system design.
Maps what builds up, what moves, what self-corrects.
Verifies every loop is closed before you write a single skill.

## Quick Start

```bash
git clone https://github.com/prgrmmd/system-design.git
cd system-design
chmod +x install.sh && ./install.sh
```

Then in any Claude Code project:

```
/system:new-system "your goal here"
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

Each step produces artifacts in `.system/{system-slug}/` and feeds the next step.

## What It Produces

The chain generates these files in `.system/{system-slug}/`:

- `definition.md`. System goal, actors, constraints, success criteria.
- `map.md`. Stocks, flows, boundaries, and the full system diagram.
- `flows.md`. Connection specs: triggers, transformations, data shapes.
- `feedback.md`. Balancing loops, reinforcing loops, failure handlers, delays.
- `closure-report.md`. Results of five closure tests with pass/fail per loop.
- `build-plan.md`. Ordered list of skills and automations to implement.

## The Five Closure Tests

1. **Output consumption.** Every output is consumed by at least one downstream process.
2. **Trigger sourcing.** Every trigger traces back to a concrete event or schedule.
3. **Stock regulation.** Every stock that accumulates has a balancing outflow.
4. **Failure handling.** Every flow has a defined failure path that does not silently drop data.
5. **Feedback completeness.** Every reinforcing loop has a corresponding balancing loop.

A system passes verification only when all five tests clear.

## Powered By

The intellectual framework is Donella Meadows' systems thinking.
Stocks, flows, feedback loops, delays, and leverage points.
The operator sees plain language throughout. The framework runs under the surface.

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

## License

MIT
