# Copilot Instructions

Project-level instructions for GitHub Copilot. These rules apply to all Copilot interactions in this workspace.

---

## Project Context

This is a **demo project** for showcasing GitHub Copilot's debugging capabilities using the **Ralph Wiggum methodology** — spec-driven autonomous AI development.

**Key principle:** Define WHAT success looks like, not HOW to fix it.

---

## Python Coding Conventions

When generating or modifying Python code, follow these guidelines:

### Naming Conventions
- Use `snake_case` for functions, methods, and variables
- Use `PascalCase` for class names
- Use `SCREAMING_SNAKE_CASE` for constants
- Prefix private methods/attributes with single underscore (`_private_method`)

### Type Hints
- Always include type hints for function parameters and return types
- Use `Optional[T]` for values that can be `None`
- Use `list[T]`, `dict[K, V]` syntax (Python 3.9+)

```python
# Good
def calculate_discount(price: float, tier: str | None) -> float:
    ...

# Avoid
def calculate_discount(price, tier):
    ...
```

### Error Handling
- Handle `None` values explicitly — never assume data is valid
- Use specific exception types, not bare `except:`
- Provide meaningful error messages with context
- Use early returns to reduce nesting

```python
# Good
def get_discount(category: str) -> float:
    discount = DISCOUNTS.get(category)
    if discount is None:
        return 0.0  # Safe default
    return discount

# Avoid
def get_discount(category: str) -> float:
    return DISCOUNTS.get(category)  # May return None!
```

### Documentation
- Add docstrings to functions with complex logic
- Use inline comments sparingly — prefer self-documenting code
- Document WHY, not WHAT

### Code Style
- Maximum line length: 100 characters
- Use f-strings for string formatting
- Prefer `pathlib.Path` over `os.path`
- Use context managers (`with`) for file operations

---

## Spec-Driven Development

When working with specs in `specs/` folder:

1. **Read the full spec** before making changes
2. **Verify acceptance criteria** are testable
3. **Make minimal changes** — don't over-engineer
4. **Test after each change** — run the verification command
5. **Output `<promise>DONE</promise>`** only when ALL criteria pass

---

## Debugging Workflow

When analyzing logs or debugging:

1. **Identify the error type** (TypeError, ValueError, etc.)
2. **Trace the call stack** to find the root cause
3. **Check for `None` propagation** — common bug pattern
4. **Verify the fix** doesn't break other functionality
5. **Consider edge cases** — what else could go wrong?
