# System Design for Claude Code

A skill chain that makes you think before you build. 

## The Problem

You tell Claude to build a system. It builds parts. Good parts, even. Skills that fire. Automations that trigger. Workflows that flow.

Then you zoom out and realise: the daily brief writes to a channel nobody reads. The escalation fires but nobody handles it. The backlog grows forever because nothing trims it. The webhook has no failure path, so when it breaks (it will break), the whole thing goes silent.

Claude builds fast. It does not ask "who consumes this?" or "what happens when this fails?" or "what stops this from growing until it kills the server?"

You are supposed to catch that. You do not catch that because you are already building the next thing.

## The Solution

Six commands. Run them in order. They walk you through first-principles system design before a single skill gets written.

You define the goal. The chain maps what builds up, what moves, what self-corrects, and what breaks. Then it runs five closure tests that verify every loop is closed. If something fails, you fix the design, not the production system at 2am.

## Quick Start

```bash
git clone https://github.com/handrovermeulen/system-design.git
cd system-design && ./install.sh
```

Then in any Claude Code project:

```
/system:new-system
```

The chain will ask you what you are building. Answer honestly. It gets easier from there.

## The Chain

```
/system:new-system           What are you building? Who cares? What matters?
       |
/system:map-system           What builds up? What moves? Where are the edges?
       |
/system:design-flows         How do parts connect? What triggers what?
       |
/system:design-feedback      What self-corrects? What amplifies? What traps exist?
       |
/system:verify-closure       Five closure tests. Pass or fix.
       |
/system:build-plan           What to build, in what order, with what patterns.
```

Each step produces artifacts in `.system/` that feed the next. Two utility commands round it out: `/system:progress` shows where you are, `/system:help` shows the reference.

## The Five Closure Tests

This is the part that actually matters.

A system passes verification only when all five tests clear. Warnings are acceptable. Failures are not. You fix the design or you do not proceed.

**1. Output Consumption.** Every output is consumed by at least one downstream process. If you produce a report and nobody reads it, the report is not useful. It is noise with a cron job.

**2. Trigger Sourcing.** Every trigger traces back to a concrete event or schedule. "The daily brief runs every morning" is not a trigger. A trigger names the scheduler, the webhook, the threshold. Something specific that actually fires.

**3. Self-Correction.** Everything that accumulates has a way to detect drift and correct it. Backlogs, queues, caches, token counts. If it grows, something must watch it. If nothing watches it, it will grow until it becomes your problem on a Sunday.

**4. Failure Paths.** Every flow has a documented failure case. Happy-path-only design is not design. It is optimism with a flowchart.

**5. Information Access.** Every decision point has its data source specified, available before the decision must be made. A self-correction loop that triggers from a monthly report when the problem compounds daily is not self-correction. It is a delayed autopsy.

## What It Produces

The chain generates these files in `.system/`:

| File | Contains |
|------|----------|
| `SYSTEM-MAP.md` | Purpose, actors, boundaries, current state, key decisions |
| `OUTCOMES.md` | Desired outcomes with measurability, targets, priority |
| `MAP.md` | What builds up, what moves, where the boundaries are |
| `DESIGN.md` | Subsystem breakdown, dependencies, build order |
| `flows/*.md` | Per-flow specs: trigger, data, transform, handoff, failure path |
| `feedback/*.md` | Per-mechanism specs: detection, correction, delay |
| `CLOSURE-REPORT.md` | Five closure tests with pass/fail per item |
| `BUILD-PLAN.md` | Ordered component list with type, dependencies, patterns |

## Who This Is For

People who build automations, skill chains, and AI workflows in Claude Code. You know how to build. You just skip the part where you think about whether the thing you are building will actually hold together as a system.

This is the part you skip.

## Powered By

The intellectual framework underneath is Donella Meadows' systems thinking. Stocks, flows, feedback loops, delays, leverage points. Her book *Thinking in Systems* is one of those rare works that changes how you see everything after you read it.

You do not need to have read it. The chain translates the concepts into plain language. No academic jargon in any output.

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)

## License

MIT
