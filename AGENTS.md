# Agent Instructions

This project uses the **Ralph Wiggum methodology** for spec-driven AI development.

**Key concept:** Define WHAT success looks like, not HOW to fix it.

---

## Specs Folder

The `specs/` folder contains bug specifications with:
- Problem statement
- Acceptance criteria (testable conditions for "done")
- Completion signal: `<promise>DONE</promise>`

---

## How to Use with GitHub Copilot CLI

Run the autonomous loop:

```bash
./scripts/ralph.sh 5
```

Or with a **planning phase** first (recommended):

```bash
./scripts/ralph.sh --plan 5
```

This will:
1. **(If --plan)** Ask Copilot to analyze the spec and create an implementation plan
2. Read `PROMPT.md` (which references the spec)
3. Run Copilot CLI in non-interactive mode
4. Iterate until `<promise>DONE</promise>` is detected
5. Exit with success when criteria are met

---

## Manual Alternative (Copilot Chat)

1. Open a spec file (e.g., `specs/001-fix-python-typeerror/spec.md`)
2. Select all and paste into Copilot Chat with:
   ```
   @workspace Implement this spec. Analyze the codebase, find the bug, 
   fix it, and verify acceptance criteria. Output <promise>DONE</promise> 
   only when ALL criteria pass.
   ```

---

## VS Code Copilot Chat Integration

This project includes standardized Copilot customizations in `.github/copilot/`:

| File | Type | Usage |
|------|------|-------|
| `.github/copilot-instructions.md` | Instructions | Auto-loaded for all Copilot interactions |
| `.github/copilot/agents/ralph-wiggum.agent.md` | Agent | Use with `@ralph-wiggum` in Copilot Chat |
| `.github/copilot/prompts/fix-spec.prompt.md` | Prompt | Use with `/fix-spec` slash command |

These follow the [awesome-copilot](https://github.com/github/awesome-copilot) conventions.

---

## Learn More

Ralph Wiggum methodology: `https://github.com/fstandhartinger/ralph-wiggum`
Copilot CLI version: `https://github.com/notoriousmic/github-copilot-workshop`
