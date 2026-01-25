# 🧸 Contoso Toyland - Log Debugging Demo

A demo showcasing **GitHub Copilot's log-based debugging capabilities** using a "toy store" order processing system with intentional bugs.

## 📁 Project Structure

```
contoso-toyland/
├── data/
│   └── orders.csv              # Order data with "poison" records
├── python/
│   ├── processor.py            # Buggy Python processor (demo)
│   └── processor_fixed.py      # Fixed Python processor
├── node/
│   ├── processor.js            # Buggy Node.js processor (demo)
│   └── processor_fixed.js      # Fixed Node.js processor
├── logs/                       # Generated log files
├── run-demo.sh                 # Run both processors
└── README.md
```

## 🚀 Quick Start

```bash
# Run buggy Python processor (0/14 orders succeed)
python3 python/processor.py

# Run buggy Node.js processor (8/14 orders succeed)
node node/processor.js

# Run fixed versions (12/14 orders succeed)
python3 python/processor_fixed.py
node node/processor_fixed.js

# Run all processors
./run-demo.sh
```

Logs are generated in the `logs/` directory with verbose debug output.

---

## 🎯 Demo Scenario

**The Situation:** It's the **Holiday Rush** at Contoso Toyland! The order processing system is failing. Use **GitHub Copilot** to analyze logs, find bugs, and fix them.

### Bugs Overview

| Type | Python | Node.js |
|------|--------|---------|
| **Code bugs** | `None` return causing TypeError | Race condition, array OOB, off-by-one |
| **Data bugs** | Invalid price, negative qty | Malformed product IDs |
| **Results** | 0/14 succeed | 8/14 succeed |

---

## 📋 Demo Prompts

### 🔍 1. Analyze Logs

**Setup:** Run `python3 python/processor.py`, open `logs/python.log`, select all (Ctrl+A)

**Prompt:**
```
Analyze this log file. Summarize the errors and their root causes.
```

**Expected:** Copilot identifies `TypeError: unsupported operand type(s) for +: 'float' and 'NoneType'`

---

### 🐛 2. Debug TypeError

**Setup:** In logs, find and select the TypeError block

**Prompt:**
```
@workspace This TypeError is crashing all orders. Find the line causing this and explain why.
```

**Expected:** Points to `discount_rate = base_rate + tier_discount` where `tier_discount` is `None`

---

### 🔧 3. Fix the Bug

**Setup:** Open `python/processor.py`, go to `get_discount_tier()` function

**Prompt:**
```
Fix get_discount_tier to return a default value instead of None
```

**Expected:** Suggests `return tiers.get(category, 0.0)`

---

### 💥 4. Debug Node.js Null Reference

**Setup:** Run `node node/processor.js`, check `logs/node.log` for first 2 orders

**Prompt:**
```
@workspace Why do the first 2 orders always fail but later orders succeed?
```

**Expected:** Identifies `discountConfig = null` race condition (loads on 3rd attempt)

---

### 🎯 5. Find All Bugs

**Setup:** Open `node/processor.js`, select `applyHolidayDiscount` function

**Prompt:**
```
Review this function for bugs. List every potential issue.
```

**Expected:** Identifies: null config, array OOB in `getBonusRate`, off-by-one in `getLoyaltyBonus`, no discount cap

---

## 🐛 Bug Reference (Facilitator Notes)

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
| CT-1012 | Empty product ID | `` |

---

## 💡 Presenter Tips

1. **Show the noise first** - Let the audience see those verbose logs before Copilot filters them
2. **Use `@workspace`** - This connects logs to source code
3. **Start broad, then specific** - "What's wrong?" then "Fix line 67"
4. **Verify the fix** - Run `processor_fixed.py` to show 12/14 succeed
5. **Highlight the debug logs** - Show how `tier_discount = None` makes the bug obvious

---

## 🎓 Key Takeaways

- Copilot can parse verbose logs and extract actionable insights
- `@workspace` lets Copilot search your entire codebase
- Debug logs with `varName = value` format help Copilot (and humans) trace issues
- Copilot distinguishes code bugs from data validation errors
- Natural language prompts work - no special syntax needed

---

*Demo for GitHub Copilot debugging capabilities - January 2026*
