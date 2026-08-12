# Task Template — Create a Dext CRUD API

## Goal

Create a production-oriented CRUD API using current Dext conventions, typed DI and ORM patterns.

## Before coding

Load:

- `skills/dext-web/SKILL.md`
- `skills/dext-orm/SKILL.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

Inspect at least one focused example and one Tier A example.

## Required decisions

Determine explicitly:

1. Minimal API vs Controller
2. normal ORM entity flow vs `MapDataApi<T>`
3. whether business rules justify a service/application layer
4. whether DbContext pooling should be enabled for the web workload
5. validation strategy
6. auth requirements
7. pagination/filter/sort requirements
8. transaction boundaries

## Implementation contract

Use current route syntax:

```text
/users/{id}
```

Prefer typed/generic handler injection over service locator calls.

Use `IList<T>` for ORM results.

Keep meaningful business logic out of route lambdas/controllers.

For detached writes, call `Update(Entity)` before `SaveChanges`.

Check ownership of returned/class entities.

Use parameterized SQL only when raw SQL is genuinely needed.

## Deliverables

Produce:

- entity/model
- request/response DTOs where useful
- DbContext registration
- service/application layer if justified
- endpoint/controller unit
- validation
- auth/authorization metadata if required
- tests
- startup/DI wiring
- example requests (`.http` or PowerShell) where useful

## Verification checklist

Before finishing, verify:

- no `:id` routes
- no stale controller attributes
- no accidental `[StringLength]` if repository guidance requires `[MaxLength]`
- no `TObjectList<T>` for ORM results
- no request service locator when typed injection works
- no hard-coded secrets
- business errors map to appropriate HTTP results
- current source signatures were checked for uncertain APIs
