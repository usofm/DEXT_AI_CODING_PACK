# Task Template — Create a Dext CRUD API

## Goal

Create a production-oriented CRUD API using current Dext conventions, typed DI and Dext-native ORM patterns.

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
2. normal Dext Entity flow vs `MapDataApi<T>`
3. whether business rules justify a service/application layer
4. whether native `TDbContext` + `IDbSet<T>` fully express persistence
5. whether a custom Repository/provider adapter is genuinely required, and why
6. whether DbContext pooling should be enabled for the web workload
7. validation strategy
8. auth requirements
9. pagination/filter/sort requirements
10. transaction boundaries

## Dext-native default

For normal business CRUD, prefer:

```text
Endpoint / Controller
  -> Application Service / Manager
      -> TAppDbContext
          -> IDbSet<TEntity>
              -> Dext Entity ORM
```

Do not automatically generate:

```text
IRepository
  -> TFDQuery / TUniQuery
      -> ConnectionFactory
```

when Dext Entity already provides the required CRUD/query semantics.

A provider-specific repository is an exception that requires an explicit reason such as specialized SQL, stored procedures, external persistence, unusual bulk behavior or another real integration boundary.

## Implementation contract

Use current route syntax:

```text
/users/{id}
```

Prefer typed/generic handler injection over service locator calls.

For standard Dext application composition, prefer the official `IStartup` + `App.UseStartup(...)` pattern when appropriate.

Register persistence through Dext:

```text
AddDbContext<TContext>
UsePostgreSQL / UseFirebird / UseConnectionDef / matching native provider helper
WithPooling(True) for appropriate Web workloads
```

Use `IList<T>` for ORM results.

Use Smart Properties / `Prototype.Entity<T>` or Specifications for typed queries when appropriate.

Keep meaningful business logic out of route lambdas/controllers.

For detached/update flows, call `Update(Entity)` before `SaveChanges`.

Check ownership of returned/class entities.

Use parameterized SQL only when raw SQL is genuinely needed.

For JWT/auth, prefer native Dext facilities (`IJwtTokenHandler`, `TJwtTokenHandler`, `TClaimsBuilder`, `UseJwtAuthentication`, `RequireAuthorization`) before inventing a wrapper.

## Deliverables

Produce:

- Dext entity/model
- request/response DTOs where useful
- `TDbContext` / `IDbSet<T>` definition
- `AddDbContext<TContext>` registration
- service/application layer if justified
- endpoint/controller unit
- validation
- auth/authorization metadata if required
- tests
- startup/DI wiring
- example requests (`.http` or PowerShell) where useful

Only add a custom Repository/connection factory when the required-decisions section documents why Dext Entity is insufficient for that boundary.

## Verification checklist

Before finishing, verify:

- no `:id` routes
- no stale controller attributes
- no accidental `[StringLength]` if repository guidance requires `[MaxLength]`
- no `TObjectList<T>` for ORM results
- no request service locator when typed injection works
- no manually invented `TFDQuery`/`TUniQuery` Repository layer for ordinary CRUD
- no custom JWT wrapper when native Dext auth types suffice
- DbContext is scoped/registered through Dext
- Web pooling is considered explicitly
- updates use `.Update(Entity)` where required
- no hard-coded secrets
- business errors map to appropriate HTTP results
- current source signatures were checked for uncertain APIs
