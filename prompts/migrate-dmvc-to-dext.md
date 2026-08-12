# Task Template — Migrate DelphiMVCFramework Code to Dext

## Goal

Migrate an existing DMVC application to current Dext patterns without doing a mechanical attribute rename.

## Load first

- `skills/dext-web/SKILL.md`
- `skills/dext-orm/SKILL.md` when persistence is involved
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

Inspect `Examples/07-UseCases/Web.OrderAPI`, but treat README syntax as migration intent only; verify current `.pas` source and current Dext attributes before generating code.

## Migration sequence

1. inventory controllers/routes/middleware
2. identify service/repository/business logic boundaries
3. map composition/bootstrap into Dext Startup/host pattern
4. migrate DI registrations
5. migrate routes/controllers using current Dext attributes
6. migrate responses/results
7. migrate auth and middleware semantics
8. migrate ORM/data access separately
9. add tests before removing old implementation

## Rules

Do not preserve framework-specific coupling unnecessarily.

Prefer:

```text
transport/controller
  -> application/service
  -> domain/data
```

Do not translate old DMVC attributes by name from stale documentation. Resolve the current Dext API from source.

Use `{id}` route syntax.

Prefer constructor/typed injection.

## Deliverables

Produce:

- migration mapping table
- target Dext structure
- migrated startup/DI
- migrated controllers/endpoints
- migrated middleware/auth
- data layer migration notes
- compatibility risks
- test plan

## Verification checklist

- current Dext controller attributes verified
- route semantics preserved
- status codes/content types preserved where intentional
- service lifetimes mapped correctly
- auth behavior not weakened
- no old DMVC infrastructure leaked into domain/business services without reason
