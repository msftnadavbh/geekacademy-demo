# 🎤 Facilitator Guide: Contoso Toyland Demo

A step-by-step guide for presenting the GitHub Copilot log debugging demo in VS Code.

---

## 📋 Pre-Demo Checklist

### Environment Setup
- [ ] VS Code installed with **GitHub Copilot** and **GitHub Copilot Chat** extensions
- [ ] Python 3.x installed (`python3 --version`)
- [ ] Terminal accessible in VS Code (`` Ctrl+` ``)

### Files Ready
- [ ] Clone/copy the demo folder to a clean location
- [ ] Close all other VS Code windows (avoid distractions)
- [ ] Hide any sensitive bookmarks or recent files

### Ralph Wiggum Setup (Part 7)
- [ ] GitHub Copilot CLI installed (`copilot --version`)
- [ ] Spec file ready: `specs/001-fix-python-typeerror/spec.md`
- [ ] Prompt file ready: `PROMPT.md`
- [ ] Script executable: `chmod +x ./scripts/ralph.sh`
- [ ] Copilot customizations in `.github/copilot/` (agents + prompts)

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
   📁 .github/copilot/     ← Custom agents & prompts
   📁 data/orders.csv
   📁 python/processor.py
   📁 specs/               ← Bug specifications
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
  Total Orders: 15
  Successful:   0
  Failed:       15
```

---

### Part 3: The Messy Log File (2 min)

**Action:**
1. Open `logs/python.log` in the editor
2. Scroll through quickly to show the "noise"
3. Point out it's hard to find errors manually

**Say:**
> "This is a typical production log - lots of debug messages, timestamps, and buried somewhere in here are our errors. Imagine hunting through this manually..."

---

### Part 4: One Prompt Investigation (5 min) 🎯

**Say:**
> "Instead of asking multiple questions, let's give Copilot one comprehensive prompt and watch it do the full detective work."

**Action:**
1. Select all text in the log (`Ctrl+A`)
2. Open Copilot Chat (`Ctrl+Alt+I`)
3. Type this single prompt:

```
@workspace Analyze this log, find the root cause of the failures in the codebase, and explain how to fix it
```

**Say:**
> "Notice `@workspace` - this tells Copilot to search my entire codebase, not just the log file. One prompt, full investigation."

**Expected Response:** Copilot should:
1. **Summarize** the log errors (15 failures, all TypeErrors)
2. **Locate** the bug in `processor.py` (without us pointing to it!)
3. **Trace** the root cause: `get_discount_tier()` returns `None` for unknown categories
4. **Explain** the fix: add a default value

**Action:** Click the file link in Copilot's response to jump to the code.

**Say:**
> "From a messy log to pinpointing the exact function — one prompt. Copilot traced the error through the call stack and found the root cause."

---

### Part 5: Verify the Finding (3 min) 🔍

**Say:**
> "Before we fix anything, let's verify Copilot's analysis. Good developers don't blindly trust — they validate."

**Action:**
1. You're now in `processor.py` (from clicking the link)
2. Scroll to the `get_discount_tier()` function
3. Select it and ask:

```
Walk me through this function. What happens when I pass a category that isn't in the dictionary?
```

**Expected Response:** Copilot explains that `dict.get()` returns `None` for missing keys, and this `None` propagates to cause the TypeError.

**Action:**
4. Now select the `apply_holiday_discount()` function
5. Ask:

```
Show me the data flow - how does a None from get_discount_tier cause the TypeError here?
```

**Say:**
> "See how we're building understanding, not just getting answers. Copilot is our pair programmer explaining the code path."

**Expected Response:** Copilot traces: `get_discount_tier()` returns `None` → passed to `apply_holiday_discount()` → line `discount_amount = base_price * discount + ...` fails because you can't multiply `None`.

---

### Part 6: What Else Could Break? (3 min) 🔮

**Say:**
> "We found one bug. But as senior developers, we don't stop there — we ask: what else could go wrong?"

**Action:**
1. Still in `processor.py`, ask:

```
@workspace What other edge cases or potential bugs exist in this order processing code?
```

**Expected Response:** Copilot proactively identifies:
- Negative quantities (what if quantity is -5?)
- Non-numeric prices (the CSV has `string_error` in one row)
- Missing required fields
- Zero price edge cases
- Large quantities (potential overflow or fraud)

**Say:**
> "See how Copilot shifts from reactive debugging to proactive code review. We're not just fixing today's fire — we're preventing tomorrow's."

**Action:**
2. Point to one of the issues (e.g., negative quantity):

```
Show me where in the code this would cause a problem
```

**Expected Response:** Copilot traces the negative quantity path — it would result in a negative total, which might pass silently but corrupt business data.

**Say:**
> "This is the zero-to-hero journey: from 'fix this error' to 'harden this system'. Copilot grows with you."

---

### Part 7: Autonomous Fix with Ralph Wiggum (3 min)

**Say:**
> "Now here's where it gets interesting. Instead of guiding Copilot step by step, we'll use the Ralph Wiggum methodology — an autonomous loop that reads specs, implements fixes, and verifies acceptance criteria without hand-holding."

**Action:**
1. Show the spec file: open `specs/001-fix-python-typeerror/spec.md`
2. Highlight the key sections:
   - Acceptance criteria (13+ successful orders, no TypeError)
   - The `<promise>DONE</promise>` completion signal

**Say:**
> "This spec defines WHAT success looks like — not HOW to fix it. The AI figures out the solution and only signals 'done' when ALL criteria pass."

**Action:**
3. Show `PROMPT.md` — this tells the loop what to do
4. Run the Ralph Wiggum loop in terminal:

```bash
./scripts/ralph.sh --plan 3
```

**Say:**
> "The `--plan` flag asks Copilot to analyze the spec and create an implementation plan first, then saves it to `plan.md` before proceeding to fix. This keeps the terminal clean while preserving the plan for review. This mimics how senior engineers think before they code. Watch — it reads the spec, analyzes the code, saves the plan, implements the fix, verifies the criteria, and outputs the completion signal."

**Expected Behavior:** The loop:
1. Reads `PROMPT.md` which points to the spec
2. Copilot CLI analyzes `python/processor.py`
3. Creates an implementation plan and saves it to `plan.md`
4. Identifies `get_discount_tier()` returns `None` for unknown categories
5. Applies the fix (adds default value `0.0`)
6. Verifies acceptance criteria are met
7. Outputs `<promise>DONE</promise>`
8. Loop detects the signal and exits with "SPEC COMPLETE!"

**Say:**
> "Notice it figured out the fix from the acceptance criteria alone. We didn't say 'add a default value' — the spec just said 'no TypeError, 13+ orders succeed'. This is spec-driven autonomous development."

**Fallback (if Copilot CLI not installed):**
Show the spec file and PROMPT.md, explain the loop pattern, then use Copilot Chat manually with: `@workspace Implement this spec [paste spec content]`

---

### Part 8: Verify Acceptance Criteria (2 min)

**Action:** Run the processor again:

```bash
python3 python/processor.py
```

**Say:**
> "Now we verify that the acceptance criteria are met — remember, we asked for 13+ successful orders..."

**Expected Output:**
```
Processing complete!
  Total Orders: 15
  Successful:   13
  Failed:       2
```

**Say:**
> "13 successes — acceptance criteria passed! This is the Ralph Wiggum loop: define spec, let AI fix, verify criteria, done. The remaining two failures are data issues, not code bugs — which is exactly what our spec allowed for."

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

### Part 10: VS Code Copilot Chat Integration (Optional, 2 min)

**Say:**
> "For those who prefer VS Code's native Copilot Chat over the CLI, we've also set up custom agents and prompts following the awesome-copilot conventions."

**Action:**
1. Open Copilot Chat (`Ctrl+Alt+I`)
2. Show the custom agent: type `@ralph-wiggum` and explain it's the spec-driven methodology agent
3. Show the custom prompt: type `/fix-spec` and explain it runs the fix workflow

**Say:**
> "These customizations live in `.github/copilot/` and are automatically discovered by VS Code. The `copilot-instructions.md` file also sets Python coding conventions for all interactions."

---

## 🎯 Key Talking Points

| When | Say |
|------|-----|
| After single prompt analysis | "One prompt: log analysis, code location, root cause, and fix — all in one response" |
| After verification deep-dive | "We verified the finding by tracing the data flow. Copilot is a pair programmer, not a magic box" |
| After edge case hunt | "From reactive debugging to proactive hardening — this is the zero-to-hero journey" |
| After Ralph Wiggum fix | "We defined WHAT success looks like, not HOW to fix it — Copilot figured out the solution autonomously" |
| After --plan flag | "Planning before implementation — the plan is saved to plan.md for review, keeping the terminal clean" |
| After verify | "Acceptance criteria passed! This is spec-driven development: define done, let AI iterate" |
| After suspicious order | "Copilot isn't just for code — it spots business logic and data anomalies too" |
| After VS Code integration | "Custom agents and prompts follow awesome-copilot conventions — easy to share and extend" |

---

## 💬 Suggested Prompts (Copy-Paste Ready)

### Full Investigation (The One-Liner)
```
@workspace Analyze this log, find the root cause of the failures in the codebase, and explain how to fix it
```

### Verify the Finding (Function Walkthrough)
```
Walk me through this function. What happens when I pass a category that isn't in the dictionary?
```

### Trace the Data Flow
```
Show me the data flow - how does a None from get_discount_tier cause the TypeError here?
```

### Edge Case Hunt (Proactive Review)
```
@workspace What other edge cases or potential bugs exist in this order processing code?
```

### Deep Dive on Edge Case
```
Show me where in the code this would cause a problem
```

### Fix Request (Ralph Wiggum Style)
```
Implement this spec:

**Bug:** TypeError when processing orders with unknown product categories
**Acceptance Criteria:** 
- Orders with valid data process without TypeError
- Unknown categories get a safe default discount (0%)
- Running processor.py results in 13+ successful orders

Fix the code to meet this spec. Output <promise>DONE</promise> when complete.
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
| Ralph loop not starting | Ensure Copilot CLI installed: `copilot --version` |
| Ralph loop permission error | Run `chmod +x ./scripts/ralph.sh` |

---

## 🔄 Reset for Next Demo

```bash
# Quick reset - regenerate logs and restore code
./run-demo.sh --reset

# Or manually:
python3 python/processor.py

# To fully reset (undo code fixes):
git checkout -- python/processor.py
```

---

## 📊 Demo Metrics to Mention

- **Log file size:** ~350 lines of mixed debug/info/error
- **Hidden bugs:** 6 code bugs + 6 data issues
- **Time to debug manually:** 30-60 minutes (estimated)
- **Time with Copilot:** 5-10 minutes

---

## 🎬 Closing Statement

> "GitHub Copilot isn't just for writing code - it's a debugging partner that can analyze logs, trace errors to source code, explain root causes, and fix bugs autonomously when given clear acceptance criteria. Using spec-driven approaches like Ralph Wiggum, you can define WHAT success looks like and let AI figure out HOW to get there. It turns hours of investigation into minutes."

**Resource:** For teams wanting to scale autonomous AI development, check out the Ralph Wiggum methodology: `https://github.com/fstandhartinger/ralph-wiggum`

---

## ⏱️ Timing Guide

| Part | Duration | Skippable? |
|------|----------|------------|
| Parts 1-8 (Core Demo) | 20 min | No |
| Part 9 (Suspicious Order) | 2 min | No - it's fun! |
| Part 10 (VS Code Integration) | 2 min | Yes - if short on time |
| **Buffer for next presenter** | 3-5 min | - |

**Target:** Finish at 20-22 min to leave buffer before the next session.

---

## 🚨 Fallback Plan

If Copilot is slow or unresponsive:
1. Have screenshots of expected responses ready
2. Say: "Copilot is thinking... while it works, let me show you what it typically returns"
3. Show the screenshot and continue the narrative

---

*Questions? Open Copilot Chat and ask!*
