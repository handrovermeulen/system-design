# Closure Test Reference

Five tests that verify a system design is complete. Every loop closed, every output consumed, every failure handled. This is the intellectual core of the `/system` skill chain.

## Test 1: Output Consumption

**What it checks:** Every output produced by every subsystem has a named consumer.

**How to check:** Read DESIGN.md and each file in flows/. For every output listed, confirm a consumer is named. If the consumer is outside the system boundary, confirm the handoff is specified.

**PASS:** Every output has a named consumer with a specified handoff.
**WARNING:** Output consumed only by an external actor with no handoff specification.
**FAIL:** Output with no consumer. Something is produced that nothing uses.

**Common causes:** Subsystem produces a report nobody reads. Data gets stored but never queried. A notification fires but nobody acts on it.

**Fix:** Re-run `/system:design-flows` to specify who consumes the orphan output, or remove the output if it is genuinely unnecessary.

## Test 2: Trigger Sourcing

**What it checks:** Every trigger that starts a flow has a specified source.

**How to check:** Read each file in flows/. For every trigger, confirm the source is named: an event, a schedule, a threshold, or a manual action by a named actor.

**PASS:** Every trigger has a named source.
**WARNING:** External trigger with no fallback if it fails to fire.
**FAIL:** Trigger with no source. Something starts but nothing kicks it off.

**Common causes:** "The daily brief runs every morning" but no scheduler is specified. "When a lead comes in" but the form or webhook is not identified.

**Fix:** Re-run `/system:design-flows` to specify the trigger source, or add a fallback mechanism.

## Test 3: Self-Correction

**What it checks:** Everything that builds up in the system has a way to detect when it drifts from target and correct it.

**How to check:** Read MAP.md for all accumulations. For each, check feedback/ for a corresponding mechanism with detection, correction, and delay.

**PASS:** Every accumulation has a documented detection mechanism, correction action, and delay estimate.
**WARNING:** Self-correction exists but delay is undocumented.
**FAIL:** Accumulation with no self-correction. It grows or shrinks with no check.

**Common causes:** Backlog grows indefinitely because nobody monitors it. Revenue drifts down but the team does not notice until quarterly review. Content quality erodes because there is no review mechanism.

**Fix:** Re-run `/system:design-feedback` to add detection and correction for the unregulated accumulation.

## Test 4: Failure Paths

**What it checks:** Every flow has a documented failure case.

**How to check:** Read each file in flows/. Confirm each flow specifies what happens when it fails: error handling, retry logic, escalation, or graceful degradation.

**PASS:** Every flow has a documented failure path with a recovery mechanism.
**WARNING:** Failure path ends at "a human handles it" with no escalation specification.
**FAIL:** Flow with no failure path. Nobody knows what happens when this breaks.

**Common causes:** Happy-path-only design. "The webhook fires and the CRM updates" but no specification for what happens when the webhook fails, times out, or sends malformed data.

**Fix:** Re-run `/system:design-flows` to add failure paths to the affected flows.

## Test 5: Information Availability

**What it checks:** Every decision point in the system has a specified information source. The person or process making the decision has the data it needs, when it needs it.

**How to check:** Read feedback/ for decision points. For each, confirm the information source is named and the timing is compatible (information is available before the decision must be made).

**PASS:** Every decision point has a named information source available in time.
**WARNING:** Information source exists but is delayed relative to when the decision must be made.
**FAIL:** Decision point with no information source. Deciding without the data to decide well.

**Common causes:** A manager approves campaigns based on gut feeling because performance data is not surfaced. A self-correction mechanism triggers based on a monthly report when the problem compounds daily.

**Fix:** Re-run `/system:design-feedback` to specify information sources and ensure timing alignment.

## Scoring

**Overall PASS:** All 5 tests pass (warnings acceptable).
**Overall GAPS FOUND:** Any test has at least one FAIL.

A system with warnings can proceed to `/system:build-plan`. A system with failures must address them first.
