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

This will:
1. Read `PROMPT.md` (which references the spec)
2. Run Copilot CLI in non-interactive mode
3. Iterate until `<promise>DONE</promise>` is detected
4. Exit with success when criteria are met

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

## Learn More

Ralph Wiggum methodology: `https://github.com/fstandhartinger/ralph-wiggum`
Copilot CLI version: `https://github.com/notoriousmic/github-copilot-workshop`
