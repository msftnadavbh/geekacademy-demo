# 🧸 404 Toys - Log Debugging Demo

A demo showcasing **GitHub Copilot's log-based debugging capabilities** using a "toy store" order processing system with intentional bugs.

## 🚀 Quick Start

```bash
# Run buggy Python processor
python3 python/processor.py
```

Logs are saved to `logs/`.

Use **GitHub Copilot** to analyze the logs, identify bugs, and fix them!

## 🎯 The Scenario

It's the **Holiday Rush** at 404 Toys! The order processing system is failing:

| Processor | Result | Main Bug |
|-----------|--------|----------|
| Python | 0/15 succeed | `None` causing TypeError |

Use **GitHub Copilot** to analyze logs, find the bugs, and fix them.

## 📁 Files

| File | Description |
|------|-------------|
| `python/processor.py` | Buggy Python processor |
| `data/orders.csv` | Order data with edge cases |
| `logs/` | Generated log output |
| `.github/copilot-instructions.md` | Python coding conventions for Copilot |
| `.github/copilot/agents/` | Custom Copilot agents (Ralph Wiggum) |
| `.github/copilot/prompts/` | Reusable Copilot prompts |
