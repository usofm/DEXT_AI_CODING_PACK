# DEXT ANTI-PATTERNS

> High-signal list of things an AI coding agent should not do in Dext projects.

## Routing

Wrong: `[HttpGet(':id')]`

Correct: `[HttpGet('/{id}')]`

Wrong: `App.MapGet('/users/:id', ...)`

Correct: `App.MapGet('/users/{id}', ...)`

Do not copy colon-style route examples from stale README files such as older Streaming docs.

## Controller naming

Never name a controller action `Create`; use a domain-specific name such as `CreateUser`.

## Endpoint DI

Avoid request Service Locator patterns such as manual `Context.Services.GetService(...)` when Dext endpoint/controller injection can express the dependency directly.

Prefer typed/generic handler injection, as demonstrated by current TaskFlow/Tier-A examples.

## Example trust

Do not assume an official README is exact-current syntax. Use:

```text
README -> intent
current example .pas -> example syntax
current Dext source/Critical Rules -> final authority
```

Always check `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md` before copying a focused demo literally.

## ORM collections

Use `IList<T>` rather than `TObjectList<T>` for ORM results.

For DbContext-owned child entities, prefer non-owning collections when the DbContext controls lifetime.

## Entity modeling

Do not force Smart Properties into every existing POCO/domain entity. Use `TEntityType<T>` when typed query metadata should remain separate from a classic model.

## Nullable Smart Properties

Prefer `Prop<Nullable<T>>`; avoid legacy `Nullable<Prop<T>>` composition.

## High precision decimals

For exact high-precision columns such as `NUMERIC(28,10)`, do not default to `DoubleType` or `CurrencyType`.

Use:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

## Detached update

For detached objects, call `.Update(Entity)` before `SaveChanges`.

## Web DbContext

For Web workloads, prefer `.WithPooling(True)` when using Dext DbContext registration.

Do not share one mutable DbContext as a singleton across unrelated requests.

## Pool lifecycle

Prefer scoped/RAII leases such as `AcquireScoped` when available.

Do not copy an older manual `Acquire/Release` example without checking whether the target Dext revision provides scoped leases.

A pooled DbContext must be reset/clean before reuse.

## Multi-tenancy

Do not trust `X-Tenant-Id`, route tenant IDs, or other tenant hints as authorization by themselves.

A missing tenant predicate or tenant write constraint is a potential cross-tenant data leak.

## Mock lifetime

`Mock<T>` is a record. Never call `.Free` on it.

## Validation

Repository-wide Critical Rules take precedence over stale examples. Current guidance prefers `[MaxLength(N)]` over `[StringLength]`.

## Raw SQL

Never concatenate untrusted values into SQL. Use parameters with `FromSql` / `UseSql`.

## Query execution

Do not materialize a huge `IList<T>` and then filter/aggregate in Delphi when the operation can be translated efficiently to SQL.

## Bulk writes

Do not replace tracked writes with bulk operations merely for speed. Check `IsBulkInsertSafe`, `IsBulkUpdateSafe`, and `IsBulkDeleteSafe` first.

## Data API

Do not expose invariant-heavy commands as generic CRUD merely because `MapDataApi<T>` is convenient.

Avoid generic CRUD for:

```text
payments
accounting posting
stock reservation
settlement
permission changes
state-machine transitions
```

## FastPath

Do not use `MapFast` everywhere. Use the normal pipeline by default and reserve FastPath for measured hot routes.

Do not infer normal application architecture from Tier C protocol/performance examples.

## Event Bus

Do not use Event Bus just to make a direct dependency harder to see.

Do not assume a publish is transactional without verifying the DbContext/transaction boundary.

Do not inject full `IEventBus` if a narrow `IEventPublisher<T>` is sufficient.

## Event Bus vs realtime

Do not confuse:

```text
Event Bus = in-process server decoupling
Hubs      = client/server realtime abstraction
```

Also do not confuse the business example `Web.EventHub` with Dext realtime Hubs.

## Background work

Do not start immortal unmanaged threads in web startup without cancellation/shutdown behavior.

Prefer `IHostedService`, persistent jobs, channels, or another Dext lifecycle abstraction when appropriate.

## Forwarded headers

Never trust `X-Forwarded-*` from arbitrary clients. Configure trusted proxies.

## Caching

Never cache private/authenticated/session responses accidentally.

Do not cache tenant/user-varying output unless those dimensions are safely represented in cache semantics/keying.

## Rate limiting

Do not document old `X-RateLimit-*` names as current merely because an older example does. Verify current RFC 9333-style middleware behavior.

Do not use only a global IP limiter when the real abuse boundary is user, tenant, API key or expensive operation.

## CORS

Do not combine `AllowAnyOrigin` with credentials.

Do not copy broad demo CORS settings to production without an explicit origin policy.

## Exceptions

Do not expose raw internal exception messages for production HTTP 500 responses.

Use the framework's production-safe Problem Details behavior.

## WebSocket / Hubs

Do not leave receive size unbounded; honor `MaximumReceiveMessageSize`.

Do not implement groups/broadcast/method invocation manually over raw WebSocket when Hubs provides the needed abstraction.

## File uploads

Never use a client-supplied filename directly as a server filesystem path.

Validate size, type policy, safe storage name/path, authorization, quotas and traversal.

## Web UI architecture

Do not default to a heavy JavaScript SPA when server-rendered WebStencils/HTMX can satisfy the requirement with less operational complexity.

Do not mix server-rendered partial semantics and SPA client-state ownership accidentally.

## Desktop UI

Do not put database access, business rules and navigation orchestration directly into VCL button event handlers.

Do not turn forms into Service Locators.

Do not mix MVVM mutable ViewModel state with MVU immutable state in the same feature without an explicit architecture boundary.

## AI / external providers

Do not spread provider-specific Gemini/OpenAI/etc. DTOs throughout domain/application code.

Do not commit real API keys.

Do not expose raw provider errors automatically to clients.

Do not use MCP just because an LLM API is involved; MCP is for tool/resource/prompt interoperability.

## MCP tools

Do not expose unrestricted raw SQL, filesystem or privileged business operations through MCP without authentication, authorization, validation and narrow capabilities.

## WebApplication lifecycle

Do not `Start -> Stop -> Start` the same stopped instance. Stop, discard, then create a new `WebApplication` instance.

## Provider isolation

Do not pull provider-specific dependencies such as UniDAC into Dext Core. Keep third-party drivers isolated.

## Ownership

Do not call `.Free` by habit when DI/interface/scope owns the object, and do not assume ownership is automatic when it is undocumented.

## API hallucination

Dext is ASP.NET-Core-inspired, not API-identical. Never invent attributes, helpers, overloads, or middleware options without checking current Dext source.
