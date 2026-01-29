# 🧸 Contoso Toyland - Log Debugging Demo

A demo showcasing **GitHub Copilot's log-based debugging capabilities** using a "toy store" order processing system with intentional bugs.

> 📖 **Presenting this demo?** See [Facilitator.md](Facilitator.md) for the full walkthrough.

## 🚀 Quick Start

```bash
# Run buggy Python processor
python3 python/processor.py

# Run buggy Node.js processor
node node/processor.js
```

Logs are saved to `logs/`.

Use **GitHub Copilot** to analyze the logs, identify bugs, and fix them!

## 🎯 The Scenario

It's the **Holiday Rush** at Contoso Toyland! The order processing system is failing:

| Processor | Result | Main Bug |
|-----------|--------|----------|
| Python | 0/15 succeed | `None` causing TypeError |
| Node.js | 9/15 succeed | Race condition on config load |

Use **GitHub Copilot** to analyze logs, find the bugs, and fix them.

## 📁 Files

| File | Description |
|------|-------------|
| `python/processor.py` | Buggy Python processor |
| `node/processor.js` | Buggy Node.js processor |
| `data/orders.csv` | Order data with edge cases |
| `logs/` | Generated log output |
