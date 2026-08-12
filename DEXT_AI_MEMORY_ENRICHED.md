# DEXT AI MEMORY — ENRICHED

> Architectural and behavioral memory for AI coding agents working with the Dext Delphi framework.
>
> Source repository: `cesarliws/dext`
> Audited branch: `main`
> Snapshot HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
> Snapshot date: `2026-08-12`

## 1. Framework Identity

Dext is a modern Delphi framework that combines concepts inspired by ASP.NET Core / EF-style development with native Object Pascal implementation.

Major areas include:

```text
Dependency Injection
ORM / Entity
Web pipeline
Minimal APIs
Controllers
OpenAPI / Swagger
Validation
Testing / mocking
Collections
Async / threading
REST client
Realtime / Hubs / WebSocket
Background services / persistent jobs
Logging / telemetry
MCP / AI integration
Desktop MVVM/MVU/Active Architecture
Performance / FastPath / direct UTF-8 streaming
```

Do not assume Dext is API-identical to .NET. It is inspired by those ecosystems but has Delphi-specific APIs, ownership rules, class-helper behavior and compiler constraints.

## 2. Source-of-Truth Priority

When information conflicts, use this precedence:

```text
1. current Dext source code
2. repository-wide Critical Rules / CONTRIBUTING_AI
3. finalized Specs
4. official Docs/skills
5. official Examples
6. Features_Implemented_Index
7. Book/articles
8. this memory
9. analogy to other frameworks
```

## 3. Critical Rules

Apply these unless current source clearly supersedes them:

1. Route parameters use `{id}`, not `:id`.
2. Controller route parameters start with `/`, e.g. `[HttpGet('/{id}')]`.
3. Never name a controller method `Create`; it conflicts with Delphi constructor semantics.
4. Prefer typed/generic endpoint injection; do not manually use `Ctx.RequestServices.GetService<T>` as the normal pattern.
5. ORM results use Dext `IList<T>`, not `TObjectList<T>`.
6. Repository-wide current rule prefers `[MaxLength(N)]` over stale `[StringLength]` examples.
7. Use `Nullable<T>` rather than legacy `NavType<T>`.
8. Web DbContexts should use `.WithPooling(True)` where applicable.
9. For detached entities, call `.Update(Entity)` before `SaveChanges`.
10. `Mock<T>` is a record; never `.Free` it.
11. `Dext.Entity.Core` may be required in `uses` for `IDbSet<T>` generic symbols.
12. Console/test/CLI projects use `SetConsoleCharSet`.
13. Preserve helper-sensitive uses order: `Dext` -> `Dext.Entity` -> `Dext.Web`.
14. Nullable Smart Property composition is `Prop<Nullable<T>>`, not `Nullable<Prop<T>>`.
15. Dext supports HTTP `QUERY`; use `MapQuery`, `TRestClient.Query`, `AcceptsQuery`, and `Accept-Query` metadata.

## 4. AI Contribution Rules

The repository includes `AI_GOVERNANCE.md`, `Docs/CONTRIBUTING_AI.md`, and agent-oriented `Docs/skills`.

Agent behavior should include:

```text
check specs / known issues first
avoid duplicate implementations
plan before coding
prefer tests first
update Book/skills when public behavior changes
preserve license/provenance
avoid copying incompatible third-party/copyleft code
avoid local absolute-path pollution
```

Human-directed/reviewed AI output remains the expected governance model.

## 5. Core Architecture

### Reflection

`TReflection` provides a shared RTTI context and metadata cache. Hot-path metadata lookup is designed to avoid repeated RTTI scanning.

Related concepts:

```text
TTypeMetadata
TPropertyHandler
attribute scanning
property path resolution
cached getter/setter metadata
```

### Activator / DI construction

`TActivator` performs RTTI-based construction, including:

```text
explicit arguments
greedy DI constructor selection
hybrid explicit + DI arguments
PTypeInfo-based creation
field/property injection
collection auto-instantiation
```

`[ServiceConstructor]` takes priority when explicitly selecting a constructor.

### Mapping

Dext includes `Dext.Mapper` with `TMapper` and fluent mapping configuration. Before writing repetitive DTO/entity copy code, check whether `TMapper` can express it.

## 6. Dependency Injection

Core service registration includes:

```pascal
AddSingleton<T>
AddTransient<T>
AddScoped<T>
AddSingletonInstance<T>
AddSingletonFactory<T>
```

Scopes are represented through `IServiceScope` / child service providers. Scoped objects should be resolved inside the correct scope, especially in long-lived background services.

## 7. Configuration / Options

Dext configuration supports multiple providers with last-provider-wins precedence:

```text
JSON
YAML
Environment Variables
Command Line
In-Memory
```

Options patterns include:

```text
IOptions<T>
IOptionsSnapshot<T>
IOptionsMonitor<T>
IChangeToken
OnReload
AddSectionValidator
```

Do not create custom polling for settings when the built-in reload/options model fits.

## 8. UUID / Nullable / Lazy

### `TUUID`

RFC-style UUID support includes V4 and time-ordered V7 generation with `TGUID`/string interop.

### `Nullable<T>`

Use for nullable scalar values and compose Smart Properties as `Prop<Nullable<T>>`.

### `Lazy<T>`

Dext provides lazy wrappers/interfaces for thread-safe delayed initialization and navigation scenarios. Ownership can be explicit.

## 9. Smart Properties

`Prop<T>` is a dual-mode generic record:

```text
Runtime mode -> stores value T
Query mode   -> builds expression AST
```

Common aliases include:

```pascal
StringType
IntType
Int64Type
BoolType
FloatType
CurrencyType
DateTimeType
DateType
TimeType
BcdType
FmtBcdType
```

String/query operations include `Like`, `StartsWith`, `EndsWith`, `Contains`, `In`, `NotIn`, `Between`, `IsNull`, `IsNotNull`, `Asc`, and `Desc`.

`Prototype.Entity<T>` creates a typed query prototype/ghost entity.

`TEntityType<T>` is important when a clean POCO/domain entity should not embed `Prop<T>` fields merely to support typed querying.

## 10. High-Precision Financial Decimal Support

Dext now has first-class `TBcd` / `ftFMTBcd` support.

Exact Smart Property aliases:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

Today these aliases are technically the same underlying type; the distinction is semantic naming.

Converter support includes:

```text
TBcd <-> Currency
TBcd <-> Double / Single / Extended
TBcd <-> string using invariant formatting
TBcd <-> Integer / Int64
Variant <-> TBcd
```

FireDAC handling preserves `ftBCD` / `ftFMTBcd` through `Field.AsBcd`, `TValue.From<TBcd>`, and `Param.AsFMTBCD`.

For exact financial fields, do not silently replace TBcd with Double or Currency. Currency is limited to 4 fractional decimal digits; binary floating point is approximate.

Firebird 5 can support exact schemas such as:

```sql
NUMERIC(28,10)
DECIMAL(28,10)
```

when the domain needs that precision. For such domains, preserve precision/scale end-to-end.

Typical exact fields:

```text
Amount
Rate
Quantity
Debit
Credit
Balance
GoldWeight
CryptoAmount
UnitCost
```

## 11. Value Conversion

`TValueConverterRegistry` performs exact type-pair lookup, kind-based lookup, and Variant fallback. It is Smart Property and Nullable aware.

Avoid ad-hoc conversion layers until checking the registry and ORM type converter mechanisms.

## 12. Span / Memory / Lifetime

Dext includes:

```text
TSpan<T>
TReadOnlySpan<T>
TByteSpan
TVector<T>
ILifetime<T>
TLifetime<T>
IDeferred
TDeferredAction
```

`TByteSpan` is optimized for byte-oriented/UTF-8/network paths and can use SIMD-aware operations.

`ILifetime<T>` and deferred actions are useful for scoped resource cleanup, but they are tools rather than a mandate to replace all explicit ownership.

## 13. Collections

Prefer Dext collection interfaces/factories in Dext code:

```text
IList<T>
IDictionary<K,V>
IOrderedDictionary<K,V>
IFrozenList<T>
IFrozenDictionary<K,V>
IChannel<T>
```

Use cases:

```text
normal list                -> IList<T>
insertion order required   -> IOrderedDictionary<K,V>
immutable concurrent read  -> Frozen collection
producer/consumer          -> bounded IChannel<T>
```

For ORM-managed child collections, use non-owning collections when DbContext controls entity lifetime. Avoid double ownership.

## 14. Generic Object Pooling

`TDextPool<T>` supports high-concurrency reuse of expensive objects.

Important concepts:

```text
TDextPoolConfig
MinSize
MaxSize
AcquireTimeoutMs
Acquire
AcquireScoped
IPooledObject<T>
Release
Use
```

Prefer RAII/scoped leases when available. Pool exhaustion is backpressure; returning HTTP 503 for a FastPath pool timeout can be correct behavior.

## 15. Threading / Async

`TAsyncTask` supports asynchronous execution, chaining, completion/error callbacks, cancellation and awaiting.

Windows processor-group support exists for systems with more than 64 logical CPUs. Do not size high-core-count Windows worker pools using a single processor group assumption.

## 16. JSON

`TDextJson` provides typed serialization/deserialization with configurable casing, enum and date formats.

Dext supports both:

```text
DOM-oriented JSON for normal application work
direct UTF-8 streaming/codecs for high-volume paths
```

Direct-codec infrastructure shares field plans across JSON, ORM hydration, protobuf and related serializers.

## 17. ORM Core

Core concepts:

```text
TDbContext
IDbSet<T>
TModelBuilder
Entities<T>
Add / AddRange
Update
Remove
SaveChanges
Find
Where
ToList
AsNoTracking
```

For detached objects, attach/update explicitly before `SaveChanges`.

For Web APIs, DbContext pooling is a standard performance/lifetime pattern.

## 18. Bulk Safety

`IDbSet<T>` exposes:

```text
IsBulkInsertSafe
IsBulkUpdateSafe
IsBulkDeleteSafe
```

Do not replace tracked ORM semantics with bulk SQL merely for speed; first check whether hooks/concurrency/relationship semantics make the operation unsafe.

## 19. Fast Query / Direct UTF-8 Streaming

Fast query APIs include `TDbContext.UseSql`, `IDextFastQuery`, `IDbSetFastStream`, `ExecuteToUtf8Proc`, and `ExecuteToUtf8Stream`.

The goal is a path like:

```text
DB cursor
 -> UTF-8 writer
 -> HTTP/output stream
```

without mandatory entity hydration, `IList<T>`, DOM construction or intermediate Unicode strings.

Use this when the endpoint is projection/read-oriented and no domain object is required.

## 20. Relationships / Joins / Inheritance

ORM relationship support includes:

```text
[ForeignKey]
[BelongsTo]
[InverseProperty]
[HasMany]
[ManyToMany]
Include
LinkManyToMany
UnlinkManyToMany
SyncManyToMany
```

Typed joins include inner/left/right/full/cross variants.

Inheritance supports TPH and TPT using inheritance/discriminator metadata.

## 21. Specifications

`TSpecification<T>` encapsulates reusable, composable read predicates. This aligns well with separating read concerns from write/domain models.

Use specifications when a query represents reusable business selection logic rather than an incidental one-off filter.

## 22. Raw SQL / Stored Procedures / Concurrency

`FromSql` supports raw SQL that can still participate in Dext query/materialization behavior. Parameterize all untrusted values.

Stored procedure support includes input/output/input-output/return-value parameter directions and multiple result-set scenarios.

Concurrency options include:

```text
optimistic concurrency -> [Version]
pessimistic locking     -> TLockMode
```

## 23. Shadow Properties / Custom ORM Converters

Shadow properties allow persistence/infrastructure metadata without putting every field on the Delphi domain class.

Custom type conversion is supported through converter attributes/base classes and a global registry.

## 24. Migrations

Dext migrations use `TMigration`, `TTableBuilder`, and `[Migration]` metadata.

CLI families include:

```text
dext migrate:up
dext migrate:down
dext migrate:list
dext migrate:generate
```

## 25. Web Application Model

Dext Web supports Minimal APIs and Controllers in the same application.

A common composition model is:

```text
DPR
 -> host/WebApplication
 -> TStartup
    -> ConfigureServices
    -> Configure
```

Important lifecycle behavior: after a `WebApplication` instance is stopped, treat it as non-restartable. Stop, discard, and instantiate a new application.

## 26. Minimal APIs / Controllers

Use Minimal APIs for compact, function-style endpoints. Use Controllers for larger grouped/attribute-driven surfaces.

Do not call controller actions `Create`.

Typed dependency injection in endpoint signatures is preferred over manual service-provider lookup.

## 27. FastPath Routing

`MapFast` bypasses parts of the normal DI/RTTI/request pipeline for very hot routes.

Use it selectively. Normal business endpoints should remain on the standard pipeline unless profiling demonstrates that bypassing framework work matters.

FastPath + direct SQL + UTF-8 streaming is especially suitable for simple high-volume read projections.

## 28. Production Middleware Hardening

Recent middleware work includes:

```text
HTTP logging with sensitive-header redaction
RFC 9457 Problem Details
production exception sanitization
strict CORS preflight handling
RateLimit headers
response-cache privacy protections
compression
security headers
PathBase
forwarded headers
antiforgery
feature flags
```

Never cache private/authenticated responses accidentally.

Never trust forwarded headers from arbitrary clients; configure trusted proxies.

Do not combine `AllowAnyOrigin` with credentials.

## 29. PathBase / Reverse Proxy

Dext supports application path bases and HTTP.sys prefix binding.

Use PathBase-aware APIs instead of hardcoding a deployment prefix into every route/URL.

A reverse proxy can still add meaningful WAF, L7 routing, certificate, load-balancing and edge-security capabilities even when Dext has native server/TLS support.

## 30. Authentication / Authorization

Dext supports JWT, authorization attributes, claims/roles/policies and Basic-auth examples.

Use the current `dext-auth` skill and example for exact setup because security APIs can evolve.

## 31. HTTP QUERY

Dext supports the `QUERY` HTTP method with `MapQuery`, REST client support and `Accept-Query` discovery metadata.

## 32. OpenAPI / Swagger / Documentation CLI

Dext can derive OpenAPI/Swagger information from Minimal APIs and Controllers.

`dext doc` generates documentation; recent work improved dynamic TOC behavior and file-friendly navigation.

## 33. WebSocket / Hubs / Realtime

Dext includes RFC 6455 WebSocket handling, permessage-deflate support, message-size limits and platform-specific server paths.

Use abstraction by need:

```text
SSE        -> one-way server push
WebSocket  -> raw bidirectional protocol
Hubs       -> groups/broadcast/application realtime
```

Always bound receive sizes for untrusted clients.

## 34. Server / TLS

Dext contains multiple server and transport strategies including HTTP.sys and Linux epoll-oriented paths.

TLS work includes OpenSSL 3.x memory-BIO approaches, Windows native capabilities, HTTPS/WSS and certificate tooling strategies.

Low-level server internals must preserve wire ordering and partial-write correctness.

## 35. REST Client / gRPC / Protobuf

`TRestClient` provides fluent outbound HTTP with connection reuse/pooling and async/typed response capabilities.

Dext also includes gRPC/protobuf/direct-codec infrastructure and code-first proto export concepts.

## 36. Resilience

Dext resilience follows familiar policy concepts:

```text
Retry
Circuit Breaker
Fallback
Timeout
```

Use around transient I/O boundaries rather than swallowing programming/domain errors.

## 37. Logging / Telemetry

Structured logging includes Console/File plus APM sinks such as Seq and OpenTelemetry. High-throughput logging can use asynchronous buffering.

`TBatchOptions` controls network sink batching.

Never log secrets, auth tokens, cookies, credentials or sensitive full payloads.

## 38. Background Services / Persistent Jobs

Use `IHostedService` for process-lifetime workers.

Use persistent background jobs (`TDextJobs`, `IJobClient`, SQLite/InMemory storage) when work should survive restart/crash or execute after a delay.

Long-lived workers should create DI scopes when they need scoped services such as DbContext.

## 39. Testing

Dext testing includes:

```text
fixtures / setup / teardown / test cases
Mock<T>
fluent Should assertions
classic Assert APIs
snapshot testing
DUnit/DUnit2/DUnitX/TestInsight integration
history/regression data
telemetry
IDE Test Explorer / coverage support
WebApplicationFactory integration testing
```

`Mock<T>` is a record and is not manually freed.

Console runners should use `SetConsoleCharSet` and the documented runner configuration.

## 40. MCP / AI

Dext includes MCP examples and skills for tools, resources, prompts and database/function-calling integration.

Use `MCP.FullDemo` as the full reference and `MCP.VclDbDemo` for VCL/database integration.

## 41. Desktop UI

Official examples demonstrate multiple UI architectures:

```text
MVVM
MVU
Active Architecture
EntityDataSet integration
```

Choose one deliberately rather than mixing patterns accidentally.

## 42. Database as API

Dext can expose CRUD endpoints from ORM metadata with Data API handlers/options.

Use this for truly CRUD-like admin/internal/rapid development surfaces. Do not bypass critical domain workflows merely because generic CRUD is convenient.

## 43. Examples as Architecture Evidence

Official Examples are important because they show composition, ownership, uses ordering, DI, Startup, testing and integration behavior that isolated API docs cannot fully convey.

This pack classifies examples as:

```text
Tier A -> architecture/use-case reference
Tier B -> focused feature reference
Tier C -> low-level/performance/protocol reference
```

Tier C examples such as FastPath, native server or parser demos must not be generalized into default application architecture.

See:

```text
examples/DEXT_EXAMPLES_INDEX.md
examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
examples/DEXT_EXAMPLE_PATTERNS.md
examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md
```

## 44. Recent Commit-Derived Agent Rules

1. Normal routes first; FastPath selectively.
2. Use direct UTF-8 streaming when domain/entity materialization is unnecessary.
3. Prefer `AcquireScoped` / RAII pooled objects.
4. Treat pool exhaustion as backpressure.
5. Check `IsBulk*Safe` before bulk substitutions.
6. Preserve `DEXT_ENABLE_ENTITY` modularity where relevant.
7. Preserve TBcd precision/scale end-to-end.
8. Prefer PathBase APIs over hardcoded prefixes.
9. Trust forwarded headers only from known proxies.
10. Use RFC 9457 Problem Details and sanitize production errors.
11. Never cache authenticated/private/session responses accidentally.
12. Enforce strict CORS semantics.
13. Bound WebSocket receive sizes.
14. Stop/discard/recreate WebApplication instances rather than restarting stopped instances.
15. Keep third-party DB drivers outside Core.
16. Benchmark on the actual database/OS/compiler before making performance claims.
17. Preserve source/license provenance for AI-generated contributions.
18. Consider both Windows and Linux server engines when modifying low-level networking.
19. Update docs/skills when public agent-facing behavior changes.

## 45. Recommended AI Loading Strategy

Always-small context:

```text
DEXT_DECISION_TREE.md
DEXT_ANTI_PATTERNS.md
```

Load on demand:

```text
DEXT_API_SYMBOL_INDEX.md
DEXT_CODE_RECIPES.md
relevant example cross-reference/pattern file
relevant official Dext skill
current source file
```

Use this full memory for architecture/design sessions, not necessarily on every coding prompt.

## 46. Freshness Rule

Dext is moving quickly. Before emitting exact code for a recently changed area, verify current `main` source and the matching skill/example.

Snapshot identity:

```text
Repository: cesarliws/dext
Branch:     main
HEAD:       412ed29207d2d1dc5d4a259a7739a615aed0c626
Date:       2026-08-12
```
