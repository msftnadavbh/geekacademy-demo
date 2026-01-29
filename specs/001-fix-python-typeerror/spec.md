# Specification 001: Fix Python TypeError Bug

## Overview
The Python order processor (`python/processor.py`) fails with a `TypeError` when processing orders with unknown product categories. This causes 0/15 orders to succeed.

**Priority:** HIGH
**Independent:** Yes — can be completed without Spec 002

---

## Problem Statement

When running `python3 python/processor.py`:
- Output shows 0 successful orders, 15 failed
- Log file contains `TypeError: unsupported operand type(s) for +: 'float' and 'NoneType'`
- Root cause: `get_discount_tier()` returns `None` for unknown categories

---

## Functional Requirements

### FR-1: Fix get_discount_tier() Function
The function must never return `None`.

**Acceptance Criteria:**
- [ ] Function returns a safe default value (0.0) for unknown categories
- [ ] No `TypeError` exceptions in logs after fix
- [ ] Minimal code change — only fix the specific bug

### FR-2: Verify Processing Success
After the fix, orders with valid data must process successfully.

**Acceptance Criteria:**
- [ ] Running `python3 python/processor.py` completes without exceptions
- [ ] Output shows 13+ successful orders (some will still fail due to bad CSV data)
- [ ] Log file shows successful processing for valid orders

---

## Success Criteria

| Metric | Before | After |
|--------|--------|-------|
| Successful Orders | 0 | 13+ |
| TypeError in Logs | Yes | No |

---

## Testing Requirements

The agent MUST verify ALL before outputting completion:

- [ ] `python3 python/processor.py` runs without crashing
- [ ] Output shows `Successful: 13` or higher
- [ ] `logs/python.log` contains no `TypeError` exceptions
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
