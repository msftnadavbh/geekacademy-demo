# Ralph Wiggum Build Prompt

Read the spec file and implement it completely.

---

## Your Task

1. Read `specs/001-fix-python-typeerror/spec.md`
2. Analyze the codebase to understand the bug
3. Implement the fix with minimal code changes
4. Run `python3 python/processor.py` to verify acceptance criteria
5. Confirm 13+ orders succeed and no TypeError in output

---

## Acceptance Criteria (from spec)

- [ ] Function returns a safe default value (0.0) for unknown categories
- [ ] No `TypeError` exceptions after fix
- [ ] Running `python3 python/processor.py` shows 13+ successful orders

---

## Completion Signal

**Only when ALL criteria are verified, output:**

```
<promise>DONE</promise>
```

**If ANY check fails:** Fix the issue and explain what went wrong. Do NOT output the magic phrase until truly complete.
