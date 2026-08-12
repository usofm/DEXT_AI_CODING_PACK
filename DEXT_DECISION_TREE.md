# DEXT DECISION TREE

> Fast architecture and API selection guide for AI coding agents working with Dext.

## 1. HTTP Endpoint

```text
Need HTTP endpoint?
├─ compact business endpoint
│  └─ typed Minimal API (generic handler injection)
├─ large Minimal API feature
│  └─ feature endpoint module + typed DI
├─ grouped/attribute/filter-heavy surface
│  └─ Controller
├─ Minimal API + Controllers together
│  └─ hybrid routing (see TaskFlow/FoodDelivery)
├─ metadata-driven low-risk CRUD
│  └─ Data API
├─ ultra-high-throughput measured hot path
│  └─ MapFast
└─ server-rendered HTML
   └─ View Engine / WebStencils / HTMX pattern
```

Prefer typed handler injection over request Service Locator patterns.

For standard application composition, prefer `IStartup` + `App.UseStartup(...)` when it matches the project structure.

## 2. Entity Modeling

```text
Need ORM entity model?
├─ existing/legacy/native Delphi POCO
│  └─ Classic entity + TEntityType<T> for typed query metadata
├─ new Dext-first model
│  └─ Smart Property entity + Prototype.Entity<T>
└─ exact high-precision decimal field
   └─ TBcd / BcdType / FmtBcdType + Precision(P,S)
```

Do not force Smart Properties into every legacy/domain model.

## 3. Persistence Boundary

```text
Need database-backed business CRUD?
├─ Can Dext Entity express it cleanly?
│  ├─ yes -> scoped TDbContext + IDbSet<T> (default)
│  └─ no  -> identify the missing capability explicitly
│            ├─ specialized vendor SQL -> infrastructure adapter/repository
│            ├─ stored-procedure contract -> explicit integration boundary
│            ├─ bulk/import pipeline -> specialized persistence component
│            └─ external/non-Dext store -> repository/port may fit
└─ metadata-only low-risk CRUD -> Data API may fit
```

Do not insert `IRepository -> TFDQuery/TUniQuery -> ConnectionFactory` between the service and Dext Entity for ordinary CRUD just because the pattern is familiar.

A Repository is optional. Use it only when it adds a meaningful domain/integration boundary.

## 4. Database Read

```text
Need data?
├─ domain/entity object required -> IDbSet<T>
├─ reusable named business predicate -> TSpecification<T>
├─ eager relations -> Include(...)
├─ typed SQL join -> JoinInner/Left/Right/Full/Cross
├─ typed filter/order -> Smart Properties / Prototype.Entity<T>
├─ raw SQL but entity hydration acceptable -> FromSql
├─ raw projection / no entity hydration -> TDbContext.UseSql / IDextFastQuery
└─ direct JSON streaming -> IDextFastQuery / IDbSetFastStream
```

Push filters/aggregates to the database when translatable; do not materialize large lists just to filter them in Delphi.

## 5. Database Write

```text
Need write?
├─ normal tracked aggregate -> Add/Update/Remove + SaveChanges
├─ detached entity -> Update(Entity) before SaveChanges
├─ bulk operation -> check IsBulkInsertSafe/IsBulkUpdateSafe/IsBulkDeleteSafe
├─ stored procedure -> [StoredProcedure] / [DbParam]
└─ generic low-risk maintenance CRUD -> Data API may fit
```

Do not expose state-machine/payment/accounting/inventory commands as generic CRUD.

## 6. DbContext Registration / Provider

```text
Need database provider?
├─ PostgreSQL -> AddDbContext<T> + UsePostgreSQL(...)
├─ Firebird -> AddDbContext<T> + UseFirebird(...)
├─ SQL Server -> AddDbContext<T> + UseSQLServer(...)
├─ existing FireDAC connection definition -> UseConnectionDef(...)
└─ direct provider object needed for specialized operation -> isolate at infrastructure boundary
```

For Web workloads, enable `.WithPooling(True)` when appropriate. Do not hand-build a provider connection factory merely to reproduce what Dext DbContext registration already provides.

## 7. Multi-Tenancy

```text
Need tenant isolation?
├─ shared DB + tenant column -> tenant middleware + verified tenant context + filtered writes/reads
├─ schema per tenant -> verify provider/current Dext support
└─ DB per tenant -> resolve connection/context per authorized tenant
```

Tenant identity is a security boundary. A raw header alone is not authorization.

## 8. Numeric Type

```text
Need decimal?
├─ exact >4 decimals -> TBcd / FmtBcdType / BcdType
├─ fixed 4 decimals sufficient -> CurrencyType
└─ approximate scientific/measurement -> FloatType/Double
```

For financial schemas, exact columns such as `NUMERIC(28,10)` are valid when the domain requires them.

## 9. Collections

```text
Need collection?
├─ normal ORM list -> IList<T>
├─ ordered dictionary -> IOrderedDictionary<K,V>
├─ immutable concurrent reads -> IFrozenList<T> / IFrozenDictionary<K,V>
├─ producer/consumer -> bounded IChannel<T>
└─ expensive reusable objects -> TDextPool<T> + scoped lease
```

## 10. Authentication / Authorization

```text
Need auth?
├─ JWT token API -> IJwtTokenHandler / TJwtTokenHandler + TClaimsBuilder
├─ middleware -> UseJwtAuthentication(JwtOptions(...))
├─ authenticated route -> RequireAuthorization
├─ role route -> RequireAuthorization('Role')
└─ simple constrained integration -> Basic Auth may fit, always under TLS
```

Do not create a custom JWT wrapper unless native Dext auth cannot satisfy a verified requirement.

A valid token establishes identity; it does not automatically authorize every business operation.

## 11. Eventing

```text
Need internal server-side decoupling?
├─ handlers share HTTP request scope / DbContext -> AddScopedEventBus
├─ independent event scope -> AddEventBus
├─ publisher only needs one event capability -> IEventPublisher<T>
├─ fire-and-forget semantics appropriate -> PublishBackground<T>
└─ test publication -> TEventBusTracker
```

Event Bus is not a client realtime transport.

## 12. Real-Time

```text
Need client realtime?
├─ server -> client only -> SSE
├─ bidirectional raw protocol -> WebSocket
├─ methods/groups/broadcasts -> THub / IHubContext<T>
└─ server-side telemetry producer -> Hubs + hosted/background producer
```

Use the highest-level abstraction that satisfies the requirement.

## 13. Background Work

```text
Need background execution?
├─ process-lifetime worker -> IHostedService
├─ delayed/persistent/restart-safe work -> TDextJobs
├─ short async operation -> TAsyncTask
├─ producer/consumer backpressure -> IChannel<T>
└─ retryable external I/O -> Resilience Pipeline
```

All long-running producers need cancellation/shutdown semantics.

## 14. Web UI

```text
Need browser UI?
├─ JSON API + independent SPA genuinely required -> API + chosen frontend
├─ server-rendered templates -> Dext View Engine / WebStencils
├─ dynamic server-driven fragments -> HTMX / Starter.Admin pattern
└─ realtime dashboard -> static/server UI + Hubs/SSE
```

Do not default to a Node/SPA toolchain when server-driven HTML satisfies the product requirements.

## 15. Desktop UI

```text
Need desktop architecture?
├─ business CRUD + navigation/binding -> MVVM/Controller + feature folders
├─ immutable deterministic state -> MVU
├─ explicit Domain/Infra/Presentation layers -> Active Architecture
├─ TDataSet / DB-aware compatibility -> EntityDataSet adapter
└─ navigation -> INavigator + adapters/middleware
```

Forms are presentation objects, not Service Locators or domain services.

## 16. Validation

```text
Need validation?
├─ simple declarative rules -> current supported attributes
├─ complex/business/conditional rules -> TAbstractValidator<T>
├─ strongly typed property rules -> Prototype.Entity<T> + RuleFor
└─ reusable localized regex -> TValidationPatterns
```

Repository-wide current guidance prefers `[MaxLength(N)]`; do not copy stale `[StringLength]` examples blindly.

## 17. Security / Proxy

```text
Behind reverse proxy?
├─ client IP/scheme/host -> ForwardedHeaders (trusted proxies only)
├─ sub-path deployment -> UsePathBase
├─ browser state-changing requests -> Antiforgery where applicable
├─ browser hardening -> SecurityHeaders + strict CORS
└─ production errors -> sanitized RFC 9457 Problem Details
```

## 18. Caching / Rate Limit

```text
Need read acceleration?
├─ public/cache-safe response -> Response Cache
└─ private/auth/session-dependent -> normally no shared response cache

Need abuse control?
├─ anonymous public -> IP/route partition may fit
├─ authenticated SaaS -> user/tenant/API-key/service partition
└─ expensive operation -> stricter operation-specific partition
```

Verify current RFC 9333 rate-limit header behavior.

## 19. File Upload / Download

```text
Need file handling?
├─ multipart input -> IFormFile / Request.Files
├─ multiple uploads -> file collection
├─ direct download -> stream response + MIME/Content-Disposition
└─ inline media -> streamed response
```

Always validate size, type policy, authorization, safe server-side filename/path, quota and path traversal.

## 20. External HTTP / AI

```text
Need external API?
├─ simple/typed HTTP -> Dext.Net.RestClient
├─ complex request composition -> TRestRequest builder
├─ cancelable async -> WithCancellation
└─ transient failures -> Resilience Pipeline where semantics allow

Need AI?
├─ direct provider API -> application/provider adapter + RestClient
└─ agent/tool interoperability -> MCP
```

MCP and direct LLM provider APIs solve different problems.

## 21. MCP

```text
Need MCP?
├─ tools -> [MCPTool] / [MCPParam]
├─ resources -> [MCPResource]
├─ prompts -> [MCPPrompt] / [MCPPromptArg]
├─ HTTP Streamable -> /mcp + session semantics
├─ legacy compatibility -> SSE if required
└─ desktop-managed process -> stdio
```

Keep authorization and domain invariants behind MCP tools.

## 22. Logging / Observability

```text
Need logging?
├─ normal structured logs -> ILogger
├─ correlated operation -> BeginScope
├─ high throughput -> AddAsync / async RingBuffer path
├─ centralized logs -> AddSeq
└─ observability platform -> AddOpenTelemetry
```

Never log secrets/tokens/private payloads.

## 23. Configuration

```text
Need config?
├─ dynamic/bootstrap tree -> IConfiguration
├─ stable typed feature settings -> IOptions<T>
├─ reload-aware settings -> IOptionsMonitor<T>
└─ deployment override -> layered providers / environment variables
```

Later configuration providers override earlier ones.

## 24. Testing

```text
Need test?
├─ unit test -> Dext.Testing
├─ dependency mock -> Mock<T>
├─ event publication -> TEventBusTracker
├─ complex output regression -> MatchSnapshot
├─ web integration -> WebApplicationFactory / request scripts
└─ protocol feature -> protocol-level .http/integration tests
```

## 25. Performance

```text
Need more throughput?
├─ first -> benchmark normal architecture
├─ DB hydration dominates -> raw projection / UseSql
├─ serialization dominates -> direct UTF-8 streaming
├─ object construction dominates -> pool where lifecycle is safe
└─ endpoint pipeline dominates -> MapFast on measured hot route
```

Prefer `AcquireScoped` RAII leases when available in the current pool API.

## 26. AI Agent Reference Routing

```text
Unsure about implementation?
1. DEXT_DECISION_TREE.md
2. DEXT_API_SYMBOL_INDEX.md
3. examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
4. examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md
5. examples/DEXT_EXAMPLE_DRIFT_REGISTER.md
6. relevant deep-audit file
7. current official example .pas
8. current Dext skill/source
9. generate code
```
