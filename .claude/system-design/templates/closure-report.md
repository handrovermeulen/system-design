# Closure Report

**System:** [System name]
**Date:** [date]
**Overall:** [X/5 tests passed] | [PASS / GAPS FOUND]

## Test Results

### 1. Output Consumption

**Status:** [PASS / FAIL / WARNING]
**Items checked:** [count]

| Output | Producer | Consumer | Status |
|--------|----------|----------|--------|
| [Output name] | [Subsystem] | [Consumer] | [PASS / FAIL] |

### 2. Trigger Sourcing

**Status:** [PASS / FAIL / WARNING]
**Items checked:** [count]

| Trigger | Flow | Source | Status |
|---------|------|--------|--------|
| [Trigger name] | [Flow name] | [Source] | [PASS / FAIL] |

### 3. Self-Correction

**Status:** [PASS / FAIL / WARNING]
**Items checked:** [count]

| Accumulation | Detection | Correction | Delay | Status |
|--------------|-----------|------------|-------|--------|
| [What builds up] | [How detected] | [How corrected] | [Time] | [PASS / FAIL] |

### 4. Failure Paths

**Status:** [PASS / FAIL / WARNING]
**Items checked:** [count]

| Flow | Failure Case | Recovery | Status |
|------|-------------|----------|--------|
| [Flow name] | [What happens] | [How recovered] | [PASS / FAIL] |

### 5. Information Availability

**Status:** [PASS / FAIL / WARNING]
**Items checked:** [count]

| Decision Point | Info Needed | Info Source | Available When Needed | Status |
|----------------|-------------|------------|----------------------|--------|
| [Decision] | [Data needed] | [Source] | [Yes / No / Delayed] | [PASS / FAIL] |

## Recommended Fixes

| Issue | Severity | Fix | Re-run |
|-------|----------|-----|--------|
| [Issue description] | [FAIL / WARNING] | [What to address] | [/system:design-flows or /system:design-feedback] |
