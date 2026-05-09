# System Design for Claude Code

A skill chain for designing complete business systems before building them.
You define the goal. The chain maps what builds up, what moves, what self-corrects, and what breaks.
Every system exits the chain verified: every output consumed, every trigger sourced, every accumulation regulated, every failure handled.

## Core Principle

Close the loop.
No orphaned outputs. No unregulated stocks. No missing feedback. No silent failures.
If a system produces something nobody consumes, the design is incomplete.
If a stock grows without a balancing flow, the design will break under load.

## Intellectual Framework

Donella Meadows' systems thinking powers the engine.
Stocks, flows, feedback loops, delays, and leverage points.
The operator sees plain language throughout. No academic jargon in any output.

## Skill Chain

Run in order. Each step feeds the next.

1. `/system:new-system`. Define the goal, actors, and constraints.
2. `/system:map-system`. Identify stocks, flows, and system boundaries.
3. `/system:design-flows`. Connect components. Define triggers and transformations.
4. `/system:design-feedback`. Add balancing loops, reinforcing loops, and failure handlers.
5. `/system:verify-closure`. Run five closure tests. Flag open loops.
6. `/system:build-plan`. Sequence the skills and automations to build.

## State Directory

Each system creates a `.system/{system-slug}/` directory.
State files accumulate as the chain progresses.
The verify step reads the full state to run closure tests.

## File Structure

```
.claude/commands/system/     Skill chain commands
.claude/agents/sys-*.md      System design agents
.claude/system-design/
  references/                Meadows framework, closure test specs
  templates/                 Output templates for each chain step
```

## Rules

- Skills under 300 lines.
- Agents under 250 lines.
- Plain language in all operator-facing output.
- No academic jargon. Translate concepts into concrete business terms.
- One sentence per line in prose output.
- ATX-style headers in all markdown.
- No emoji in any output.
