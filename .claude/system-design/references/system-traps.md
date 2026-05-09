# System Traps

Seven common patterns that cause systems to fail. These get checked during `/system:design-feedback`. Each trap has a structural cause and a structural fix. Naming the trap during design prevents it from appearing in production.

## 1. Band-Aid Dependency

**What it looks like:** A quick fix becomes permanent. The real fix never happens because the band-aid "works." Over time, the system becomes dependent on the workaround.

**Example:** A founder manually approves every campaign because the approval criteria were never codified. The manual step "works" so nobody builds the automated approval logic. The founder becomes a permanent bottleneck.

**How to detect during design:** Look for flows where a human is performing a step that could be automated or rule-based. Ask: "If this person disappeared tomorrow, would the system stop?" If yes, the system depends on the band-aid.

**Prevention:** Design the structural fix first. If a manual step is needed temporarily, document the criteria it applies and set a deadline for automation.

## 2. Drifting Standards

**What it looks like:** The target slowly drops because "close enough" keeps getting redefined downward. Nobody notices because each individual adjustment is small.

**Example:** Response time target starts at 4 hours, then becomes "same day," then becomes "within 48 hours," then becomes "when we get to it." Each step feels reasonable. The cumulative drift is catastrophic.

**How to detect during design:** Check every self-correction mechanism for a fixed, measurable target. If the target is vague ("fast," "good," "timely"), it will drift.

**Prevention:** Set numeric targets with no ambiguity. Build the detection mechanism to alert against the original target, not the current performance.

## 3. Winner Takes All

**What it looks like:** Early advantage compounds. The thing that is already winning gets more resources, starving alternatives. Diversity disappears.

**Example:** One content channel performs well early, so all effort shifts to it. Other channels get no investment, never get the chance to prove themselves. The business becomes dependent on a single channel.

**How to detect during design:** Look for resource allocation flows that are driven by current performance only. Ask: "Does the best performer always get more? What protects underperforming alternatives from starvation?"

**Prevention:** Reserve a fixed portion of resources for exploration. Build allocation rules that balance exploitation (scaling what works) with exploration (testing what might work).

## 4. Blame the Wrong Thing

**What it looks like:** People optimise for the metric, not the goal. The metric improves while the actual problem gets worse.

**Example:** Support team is measured on tickets closed per day. They start closing tickets faster by giving shallow answers. Ticket count drops. Customer satisfaction drops. The metric looks great. The system is failing.

**How to detect during design:** For every measurability criterion in OUTCOMES.md, ask: "Can someone hit this metric without achieving the actual goal? What would gaming this look like?"

**Prevention:** Use multiple metrics that cross-validate. Pair activity metrics (tickets closed) with outcome metrics (customer satisfaction). Design the self-correction mechanism to monitor the outcome, not just the activity.

## 5. Overreaction Spiral

**What it looks like:** Each correction overshoots, triggering a correction in the opposite direction, which also overshoots. Small problems become large oscillations.

**Example:** Ad spend goes up because leads are low. Leads spike. Ad spend gets cut. Leads crash. Ad spend goes back up. The system oscillates instead of finding equilibrium.

**How to detect during design:** Look for self-correction mechanisms with no damping. Ask: "When you correct, do you correct by a fixed amount, or proportional to the gap? What prevents overcorrection?"

**Prevention:** Add damping to corrections. Adjust gradually, not all at once. Build in delay awareness: if the system takes 2 weeks to respond to a change, do not make another change after 3 days.

## 6. Delayed Consequences

**What it looks like:** The fix works short-term but makes the original problem worse long-term. By the time the long-term effect is visible, the cause is forgotten.

**Example:** Discounting to hit quarterly revenue targets works immediately. But it trains customers to wait for discounts, reducing full-price purchases over time. Next quarter requires deeper discounts.

**How to detect during design:** For every correction action, ask: "What is the second-order effect? Does this fix create a new problem 3, 6, or 12 months from now?"

**Prevention:** Design monitoring that tracks both the immediate effect and the delayed consequence. Set review triggers at the expected delay interval.

## 7. Resource Depletion

**What it looks like:** A shared resource gets overused because nobody owns the cost of depletion. Each user acts rationally. The collective outcome is irrational.

**Example:** Every team creates tasks for the same ops person. Each request is reasonable. The total is impossible. The ops person burns out. Nobody caused it. Everyone caused it.

**How to detect during design:** Look for shared resources (people, attention, budget, tool capacity) that multiple subsystems draw from. Ask: "Who monitors the total load? What happens when demand exceeds capacity?"

**Prevention:** Make the cost of usage visible to each consumer. Set capacity limits with explicit overflow rules. Assign an owner to monitor aggregate demand.
