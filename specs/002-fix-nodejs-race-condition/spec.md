# Specification 002: Fix Node.js Race Condition Bug

## Overview
The Node.js order processor (`node/processor.js`) has a race condition where `discountConfig` is `null` for the first 2 orders because configuration only loads on the 3rd attempt.

**Priority:** HIGH  
**Independent:** Yes — can be completed without Spec 001

---

## Problem Statement

When running `node node/processor.js`:
- Output shows 9 successful orders, 6 failed
- First 2 orders ALWAYS fail regardless of their data validity
- Log file shows `discountConfig = null` and `configLoadAttempts = 1` or `2`
- Root cause: `loadDiscountConfig()` has a race condition — returns valid config only on attempt 3+

---

## Functional Requirements

### FR-1: Fix loadDiscountConfig() Race Condition
The configuration must be available from the first order.

**Acceptance Criteria:**
- [ ] Config loads synchronously or awaits before processing starts
- [ ] First order processes with valid config (not null)
- [ ] Minimal code change — only fix the specific race condition

### FR-2: Verify Processing Improvement
After the fix, valid orders should succeed from the start.

**Acceptance Criteria:**
- [ ] Running `node node/processor.js` shows improved success rate
- [ ] Log file shows `discountConfig` is NOT null for order 1
- [ ] Orders that previously failed due to race condition now succeed

---

## Success Criteria

| Metric | Before | After |
|--------|--------|-------|
| Successful Orders | 9 | 11+ |
| First Order Config | null | valid object |
| configLoadAttempts for Order 1 | 1 (fails) | 3+ (succeeds) OR config preloaded |

---

## Testing Requirements

The agent MUST verify ALL before outputting completion:

- [ ] `node node/processor.js` runs without crashing
- [ ] Output shows `Successful: 11` or higher
- [ ] `logs/node.log` shows valid config for first order
- [ ] Changes committed with descriptive message

---

## Completion Signal

**Only when ALL criteria pass, output:**
```
<promise>DONE</promise>
```

**If ANY check fails:** Fix the issue and retry. Do NOT output the magic phrase.

---

<!-- NR_OF_TRIES: 0 -->
