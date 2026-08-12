# CURSOR_RULES.md — Dext Cursor Guidance

Use this file as the source for Cursor project rules when working on Dext Delphi code.

## Required Context

Always include:
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

Prefer on-demand retrieval for:
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_CODE_RECIPES.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
- matching deep-audit file
- relevant `full/` parts only when necessary

## Cursor Behavioral Rules

1. Search before generating.
2. Prefer current Dext `.pas` source over stale README syntax.
3. Do not infer Dext signatures from ASP.NET Core.
4. Use typed/generic endpoint DI rather than service-locator patterns.
5. Preserve repository helper ordering where relevant: `Dext`, `Dext.Entity`, `Dext.Web`.
6. Use `{id}` route syntax and slash-prefixed controller action routes.
7. Use `IList<T>` for ORM results.
8. Prefer `Prop<Nullable<T>>` for nullable smart properties.
9. Prefer `[MaxLength(N)]` over stale `[StringLength]` samples.
10. Use `FmtBcdType`/`TBcd` for exact high-precision financial values.
11. Use `.WithPooling(True)` for Web DbContexts where applicable.
12. For detached updates, call `.Update(Entity)` before `SaveChanges`.
13. Check `IsBulk*Safe` before bulk mutation paths.
14. Prefer `AcquireScoped` when pool RAII is available.
15. Use `MapFast` only for measured hot paths.
16. Never copy demo secrets, permissive CORS, mock auth, or demo credentials into production code.
17. Treat Tier C examples as internals/performance references, not normal app architecture.

## Search Order

```text
Decision Tree
  -> Compact Symbol Index
  -> Example Cross Reference
  -> Drift Register
  -> current example source
  -> current Dext skill/source
  -> Full Memory/Symbol part if needed
```

## Architecture Preference

For non-trivial applications:

```text
Feature Endpoint/Controller
  -> Application Service / Manager
      -> Domain
          -> Data/Integration
```

For large Minimal API projects, split route registration by feature.

## Precision Rule

If the domain is financial/accounting/FX/gold/crypto and requires more than 4 decimal places, do not use `Double` or `Currency` as the default storage/application type. Prefer exact TBcd-based mapping.
