# Task Template — Review Dext Code

## Goal

Review Dext code for correctness, current API usage, architecture quality, lifetime/ownership safety, security and drift from current framework conventions.

## Load first

- `DEXT_ANTI_PATTERNS.md`
- `DEXT_API_SYMBOL_INDEX.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
- relevant domain skill from `skills/`

## Review order

1. compile/runtime correctness risks
2. stale or invented Dext API usage
3. ownership/lifetime bugs
4. DI/service lifetime problems
5. route/controller/model-binding issues
6. ORM/query/write correctness
7. financial precision when relevant
8. security and middleware ordering
9. performance misuse such as unnecessary FastPath
10. test coverage gaps

## Mandatory checks

Look specifically for:

- `:id` routes instead of `{id}`
- stale controller attributes
- `[StringLength]` drift where current rules prefer `[MaxLength]`
- manual service locator usage
- `TObjectList<T>` used as ORM result container
- detached entities saved without `Update`
- missing web DbContext pooling where appropriate
- manual pool `Acquire/Release` where scoped lease is current
- `Mock<T>.Free`
- exact financial fields routed through `Double`
- unparameterized raw SQL
- unsafe CORS/cache/forwarded-header behavior
- hard-coded secrets
- unbounded WebSocket receive
- assuming example README syntax is current

## Output format

Return findings in severity order:

```text
Critical
High
Medium
Low / Cleanup
```

For every actionable finding include:

- location/symbol
- why it is a problem
- current Dext pattern
- concrete fix

Do not invent replacement APIs. If exact syntax is uncertain, mark it for source verification.
