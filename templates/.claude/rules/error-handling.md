# Error Handling Rules

## Exception Usage

1. Use exceptions for error conditions instead of `NULL` or `FALSE` returns.
2. Never catch `\Exception` - only catch exceptions you can handle.
3. Catch the narrowest exception possible (`RuntimeException` not `Exception`).
4. Don't catch just to log (unless error doesn't affect caller).
5. New exceptions should inherit from existing exception classes.

## Fail Fast

- Return early with clear error messages when preconditions aren't met.
- Handle errors at appropriate boundaries.
- Log sufficient context for debugging.
- Don't silently swallow errors.
