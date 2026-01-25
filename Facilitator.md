# 🎤 Facilitator Guide: Contoso Toyland Demo

A step-by-step guide for presenting the GitHub Copilot log debugging demo in VS Code.

---

## 📋 Pre-Demo Checklist

### Environment Setup
- [ ] VS Code installed with **GitHub Copilot** and **GitHub Copilot Chat** extensions
- [ ] Python 3.x installed (`python3 --version`)
- [ ] Node.js installed (`node --version`)
- [ ] Terminal accessible in VS Code (`` Ctrl+` ``)

### Files Ready
- [ ] Clone/copy the demo folder to a clean location
- [ ] Close all other VS Code windows (avoid distractions)
- [ ] Hide any sensitive bookmarks or recent files

### Copilot Settings
- [ ] Ensure Copilot is signed in and active (check status bar icon)
- [ ] Open Copilot Chat panel (`Ctrl+Alt+I` or View → Chat)

---

## 🚀 Demo Flow (20-25 minutes)

### Part 1: Set the Scene (2 min)

**Say:**
> "Welcome to Contoso Toyland! It's the holiday rush, and our order processing system is failing. Customers are complaining, and we need to find the bugs fast. Let's see how GitHub Copilot can help us analyze logs and fix code."

**Action:**
1. Open VS Code in the demo folder
2. Show the folder structure in Explorer:
   ```
   📁 data/orders.csv
   📁 python/processor.py
   📁 node/processor.js
   ```

---

### Part 2: Generate the Problem (2 min)

**Action:** Open integrated terminal and run:

```bash
python3 python/processor.py
```

**Say:**
> "Yikes! Zero successful orders. Something is very wrong. Let's check the logs."

**Show the output:**
```
Processing complete!
  Total Orders: 12
  Successful:   0
  Failed:       12
```

---

### Part 3: The Messy Log File (3 min)

**Action:**
1. Open `logs/python.log` in the editor
2. Scroll through quickly to show the "noise"
3. Point out it's hard to find errors manually

**Say:**
> "This is a typical production log - lots of debug messages, timestamps, and buried somewhere in here are our errors. Let's ask Copilot to help."

**Action:**
1. Select all text (`Ctrl+A`)
2. Open Copilot Chat (`Ctrl+Alt+I`)
3. Type the prompt:

```
Analyze this log file. What errors are occurring and how many orders failed?
```

**Expected Response:** Copilot summarizes the errors, identifies `TypeError` as the main culprit.

---

### Part 4: Find the Bug (4 min)

**Action:**
1. In the log file, find and select a `TypeError` error block:
   ```
   TypeError: unsupported operand type(s) for +: 'float' and 'NoneType'
   ```
2. With the text selected, type in Chat:

```
@workspace Find the code that causes this error and explain why it happens
```

**Say:**
> "Notice I used `@workspace` - this tells Copilot to search my entire codebase, not just the current file."

**Expected Response:** Copilot points to `processor.py`, specifically the `apply_holiday_discount()` function where `None` is added to a float.

**Action:** Click the file link in Copilot's response to jump to the code.

---

### Part 5: Understand the Root Cause (2 min)

**Action:**
1. Now in `processor.py`, select the `get_discount_tier()` function
2. Ask:

```
Why does this function return None and how does that cause the TypeError?
```

**Say:**
> "Copilot traces the bug back to its source - the dictionary lookup returns None when the product category isn't recognized."

---

### Part 6: Fix the Bug (3 min)

**Action:**
1. Keep cursor in the `get_discount_tier()` function
2. Ask:

```
Fix this function to never return None. Use a safe default value.
```

**Expected Response:** Copilot suggests changing:
```python
return tiers.get(category)  # Bug
```
to:
```python
return tiers.get(category, 0.0)  # Fixed
```

**Action:**
1. Accept the fix (click "Apply" or copy-paste)
2. Copilot may also suggest fixing `apply_holiday_discount()` - accept that too

---

### Part 7: Verify the Fix (2 min)

**Action:** Run the processor again:

```bash
python3 python/processor.py
```

**Say:**
> "Let's see if our fix worked..."

**Expected Output:**
```
Processing complete!
  Total Orders: 12
  Successful:   10
  Failed:       2
```

**Say:**
> "We went from zero successful orders to ten! The remaining two failures are data issues, not code bugs."

---

### Part 8: Node.js Speed Round (3 min) ⏱️ *Skip if short on time*

**Action:**
1. Run the Node.js processor:

```bash
node node/processor.js
```

**Show the output:**
```
Processing complete!
  Total Orders: 15
  Successful:   8
  Failed:       7
```

**Say:**
> "Interesting - different failure pattern! Python had zero successes, Node.js has eight. Let's ask Copilot why."

**Action:**
1. Open `logs/node.log`
2. Select all (`Ctrl+A`)
3. Ask:

```
Why do the first 2 orders always fail but later orders succeed?
```

**Expected Response:** Copilot identifies the race condition - `discountConfig` is `null` for the first 2 orders because it only loads on the 3rd attempt.

**Say:**
> "Same technique, different language, different bug. Copilot adapts to whatever codebase you're working in."

---

### Part 9: The Suspicious Order (2 min) 🎭

**Action:**
1. Open `data/orders.csv`
2. Scroll to the last row (Barry Broke)
3. Select that row and ask:

```
Anything suspicious about this order?
```

**Expected Response:** Copilot flags the order - 9999 items at $999.99 each = ~$10 million order, likely fraud or data entry error.

**Say:**
> "Copilot isn't just for code bugs - it can spot business logic issues too. This is the kind of order that would get flagged by a fraud detection system."

---

### Part 10: Data Bug Wrap-up (2 min) ⏱️ *Skip if short on time*

**Action:**
1. Remind audience of the Python results: 10/14 succeeded after the fix
2. Ask:

```
Why are 2 orders still failing after the code fix?
```

**Expected Response:** Copilot identifies CSV data issues - CT-1004 has `string_error` as price, CT-1008 has negative quantity.

**Say:**
> "Copilot distinguishes between code bugs and bad data. The code is fixed - these are upstream data quality issues."

---

## 🎯 Key Talking Points

| When | Say |
|------|-----|
| After log analysis | "Copilot understood the log format without any configuration" |
| After @workspace | "The @workspace feature connects errors to source code across your entire project" |
| After fix | "Copilot didn't just find the bug - it explained WHY it happened" |
| At the end | "This took us 5 minutes. Manually, this could have taken hours" |

---

## 💬 Suggested Prompts (Copy-Paste Ready)

### Log Analysis
```
Analyze this log file. What errors are occurring and how many orders failed?
```

### Find Bug from Error
```
@workspace Find the code that causes this error and explain why it happens
```

### Fix Request
```
Fix this function to never return None. Use a safe default value.
```

### Code Review
```
Review this function for bugs including null references, edge cases, and race conditions
```

### Root Cause Report
```
Generate a bug report for the engineering team with severity, root cause, and fix recommendations
```

---

## 🐛 Bug Reference

### Code Bugs

| File | Function | Bug | Log Indicator |
|------|----------|-----|---------------|
| `processor.py` | `get_discount_tier()` | Returns `None` for unknown categories | `tier_discount = None` |
| `processor.py` | `apply_holiday_discount()` | No division-by-zero guard | `total = 0, order_id in cache = True` |
| `processor.py` | `apply_holiday_discount()` | No discount cap | `discount_rate = 1.2` (>100%) |
| `processor.js` | `loadDiscountConfig()` | Race condition - null on attempts 1-2 | `discountConfig = null`, `configLoadAttempts = 1` |
| `processor.js` | `getBonusRate()` | No bounds check on `parts[1]` | `parts = ["MALFORMED"]` |
| `processor.js` | `getLoyaltyBonus()` | Off-by-one: accesses `length` not `length-1` | `accessing index = 5` (undefined) |

### Data Issues (orders.csv)

| Order ID | Issue | Field Value |
|----------|-------|-------------|
| CT-1004 | Non-numeric price | `string_error` |
| CT-1006 | Zero quantity | `0` |
| CT-1008 | Negative quantity | `-1` |
| CT-1011 | Malformed product ID | `MALFORMED` |
| CT-1012 | Empty product ID | (empty) |
| CT-1015 | Suspicious quantity | `9999` (Barry Broke) |

---

## ⚠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| Copilot not responding | Check internet connection; re-authenticate via status bar |
| @workspace not finding code | Ensure the folder is open as a workspace, not individual files |
| Python not found | Use `python` instead of `python3` on Windows |
| Logs not generated | Run processor first; check `logs/` folder exists |
| Too many errors | This is intentional! Shows Copilot can handle noise |

---

## 🔄 Reset for Next Demo

```bash
# Quick reset - regenerate logs and restore code
./run-demo.sh --reset

# Or manually:
python3 python/processor.py
node node/processor.js

# To fully reset (undo code fixes):
git checkout -- python/processor.py node/processor.js
```

---

## 📊 Demo Metrics to Mention

- **Log file size:** ~200 lines of mixed debug/info/error
- **Hidden bugs:** 5 code bugs + 5 data issues
- **Time to debug manually:** 30-60 minutes (estimated)
- **Time with Copilot:** 5-10 minutes

---

## 🎬 Closing Statement

> "GitHub Copilot isn't just for writing code - it's a debugging partner that can analyze logs, trace errors to source code, explain root causes, and suggest fixes. It turns hours of investigation into minutes."

---

## ⏱️ Timing Guide

| Part | Duration | Skippable? |
|------|----------|------------|
| Parts 1-7 (Core Demo) | 15 min | No |
| Part 8 (Node.js) | 3 min | Yes |
| Part 9 (Suspicious Order) | 2 min | No - it's fun! |
| Part 10 (Data Bugs) | 2 min | Yes |
| **Buffer for next presenter** | 3-5 min | - |

**Target:** Finish at 20 min to leave buffer before the next session.

---

## 🚨 Fallback Plan

If Copilot is slow or unresponsive:
1. Have screenshots of expected responses ready
2. Say: "Copilot is thinking... while it works, let me show you what it typically returns"
3. Show the screenshot and continue the narrative

---

*Questions? Open Copilot Chat and ask!*
