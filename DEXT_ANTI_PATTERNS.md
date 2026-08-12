# DEXT ANTI-PATTERNS

> High-signal list of things an AI coding agent should not do in Dext projects.

## Routing

Wrong: `[HttpGet(':id')]`

Correct: `[HttpGet('/{id}')]`

Wrong: `App.MapGet('/users/:id', ...)`

Correct: `App.MapGet('/users/{id}', ...)`

## Controller naming

Never name a controller action `Create`; use a domain-specific name such as `CreateUser`.

## Endpoint DI

Avoid `Ctx.RequestServices.GetService<IMyService>` when Dext endpoint/controller injection can express the dependency directly.

## ORM collections

Use `IList<T>` rather than `TObjectList<T>` for ORM results.

For DbContext-owned child entities, prefer non-owning lists such as `TCollections.CreateList<TChild>(False)` when the DbContext controls lifetime.

## Nullable Smart Properties

Prefer `Prop<Nullable<T>>`; avoid legacy `Nullable<Prop<T>>` composition.

## High precision decimals

For exact high-precision columns such as `NUMERIC(28,10)`, do not use `DoubleType` or `CurrencyType` by default.

Use:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

## Detached update

For detached objects, call `.Update(Entity)` before `SaveChanges`.

## Web DbContext

For Web workloads, prefer `.WithPooling(True)` when using Dext DbContext registration.

## Mock lifetime

`Mock<T>` is a record. Never call `.Free` on it.

## Validation

Repository-wide critical rules take precedence over stale examples. Current critical guidance prefers `[MaxLength(N)]` over `[StringLength]`.

## Raw SQL

Never concatenate untrusted values into SQL. Use parameters with `FromSql` / `UseSql`.

## Bulk writes

Do not replace tracked writes with bulk operations merely for speed. Check `IsBulkInsertSafe`, `IsBulkUpdateSafe`, and `IsBulkDeleteSafe` first.

## FastPath

Do not use `MapFast` everywhere. Use the normal pipeline by default and reserve FastPath for measured hot routes.

## Pooling

Prefer scoped/RAII leases such as `AcquireScoped` when available.

## Forwarded headers

Never trust `X-Forwarded-*` from arbitrary clients. Configure trusted proxies.

## Caching

Never cache private/authenticated/session responses accidentally.

## CORS

Do not combine `AllowAnyOrigin` with credentials.

## Exceptions

Do not expose raw internal exception messages for production HTTP 500 responses.

## WebSocket

Do not leave receive size unbounded; honor `MaximumReceiveMessageSize`.

## WebApplication lifecycle

Do not `Start -> Stop -> Start` the same stopped instance. Stop, discard, then create a new `WebApplication` instance.

## Provider isolation

Do not pull provider-specific dependencies such as UniDAC into Dext Core. Keep third-party drivers isolated.

## Ownership

Do not call `.Free` by habit when DI/interface/scope owns the object, and do not assume ownership is automatic when it is undocumented.

## API hallucination

Dext is ASP.NET-Core-inspired, not API-identical. Never invent attributes, helpers, overloads, or middleware options without checking current Dext source.
