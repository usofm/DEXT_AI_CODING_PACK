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

## 2. Entity Modeling

```text
Need ORM entity model?
├─ existing/legacy/native Delphi POCO
│  └─ Classic entity + TEntityType<T> for typed query metadata
├─ new Dext-first model
│  └─ Smart Property entity + Prototype.Entity<T>
└─ exact high-precision decimal field
   └─ TBcd / BcdType / FmtBcdType
```

Do not force Smart Properties into every legacy/domain model.

## 3. Database Read

```text
Need data?
├─ domain/entity object required -> IDbSet<T>
├─ reusable named business predicate -> TSpecification<T>
├─ eager relations -> Include(...)
├─ typed SQL join -> JoinInner/Left/Right/Full/Cross
├─ raw SQL but entity hydration acceptable -> FromSql
├─ raw projection / no entity hydration -> TDbContext.UseSql / IDextFastQuery
└─ direct JSON streaming -> IDextFastQuery / IDbSetFastStream
```

Push filters/aggregates to the database when translatable; do not materialize large lists just to filter them in Delphi.

## 4. Database Write

```text
Need write?
├─ normal tracked aggregate -> Add/Update/Remove + SaveChanges
├─ detached entity -> Update(Entity) before SaveChanges
├─ bulk operation -> check IsBulkInsertSafe/IsBulkUpdateSafe/IsBulkDeleteSafe
├─ stored procedure -> [StoredProcedure] / [DbParam]
└─ generic low-risk maintenance CRUD -> Data API may fit
```

Do not expose state-machine/payment/accounting/inventory commands as generic CRUD.

## 5. Multi-Tenancy

```text
Need tenant isolation?
├─ shared DB + tenant column -> tenant middleware + verified tenant context + filtered writes/reads
├─ schema per tenant -> verify provider/current Dext support
└─ DB per tenant -> resolve connection/context per authorized tenant
```

Tenant identity is a security boundary. A raw header alone is not authorization.

## 6. Numeric Type

```text
Need decimal?
├─ exact >4 decimals -> TBcd / FmtBcdType / BcdType
├─ fixed 4 decimals sufficient -> CurrencyType
└─ approximate scientific/measurement -> FloatType/Double
```

For Firebird 5 financial schemas, exact columns such as `NUMERIC(28,10)` are valid when the domain requires them.

## 7. Collections

```text
Need collection?
├─ normal list -> IList<T>
├─ ordered dictionary -> IOrderedDictionary<K,V>
├─ immutable concurrent reads -> IFrozenList<T> / IFrozenDictionary<K,V>
├─ producer/consumer -> bounded IChannel<T>
└─ expensive reusable objects -> TDextPool<T> + scoped lease
```

## 8. Eventing

```text
Need internal server-side decoupling?
├─ handlers share HTTP request scope / DbContext -> AddScopedEventBus
├─ independent event scope -> AddEventBus
├─ publisher only needs one event capability -> IEventPublisher<T>
├─ fire-and-forget semantics appropriate -> PublishBackground<T>
└─ test publication -> TEventBusTracker
```

Event Bus is not a client realtime transport.

## 9. Real-Time

```text
Need client realtime?
├─ server -> client only -> SSE
├─ bidirectional raw protocol -> WebSocket
├─ methods/groups/broadcasts -> THub / IHubContext<T>
└─ server-side telemetry producer -> Hubs + hosted/background producer
```

Use the highest-level abstraction that satisfies the requirement.

## 10. Background Work

```text
Need background execution?
├─ process-lifetime worker -> IHostedService
├─ delayed/persistent/restart-safe work -> TDextJobs
├─ short async operation -> TAsyncTask
├─ producer/consumer backpressure -> IChannel<T>
└─ retryable external I/O -> Resilience Pipeline
```

All long-running producers need cancellation/shutdown semantics.

## 11. Web UI

```text
Need browser UI?
├─ JSON API + independent SPA genuinely required -> API + chosen frontend
├─ server-rendered templates -> Dext View Engine / WebStencils
├─ dynamic server-driven fragments -> HTMX / Starter.Admin pattern
└─ realtime dashboard -> static/server UI + Hubs/SSE
```

Do not default to a Node/SPA toolchain when server-driven HTML satisfies the product requirements.

## 12. Desktop UI

```text
Need desktop architecture?
├─ business CRUD + navigation/binding -> MVVM/Controller + feature folders
├─ immutable deterministic state -> MVU
├─ explicit Domain/Infra/Presentation layers -> Active Architecture
├─ TDataSet / DB-aware compatibility -> EntityDataSet adapter
└─ navigation -> INavigator + adapters/middleware
```

Forms are presentation objects, not Service Locators or domain services.

## 13. Validation

```text
Need validation?
├─ simple declarative rules -> current supported attributes
├─ complex/business/conditional rules -> TAbstractValidator<T>
├─ strongly typed property rules -> Prototype.Entity<T> + RuleFor
└─ reusable localized regex -> TValidationPatterns
```

Repository-wide current guidance prefers `[MaxLength(N)]`; do not copy stale `[StringLength]` examples blindly.

## 14. Authentication / Authorization

```text
Need auth?
├─ token-based API -> JWT
├─ simple constrained integration -> Basic Auth may fit, always under TLS
└─ protected operation -> authentication + authorization/domain permission checks
```

A valid token establishes identity; it does not automatically authorize every business operation.

## 15. Security / Proxy

```text
Behind reverse proxy?
├─ client IP/scheme/host -> ForwardedHeaders (trusted proxies only)
├─ sub-path deployment -> UsePathBase
├─ browser state-changing requests -> Antiforgery where applicable
├─ browser hardening -> SecurityHeaders + strict CORS
└─ production errors -> sanitized RFC 9457 Problem Details
```

## 16. Caching / Rate Limit

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

## 17. File Upload / Download

```text
Need file handling?
├─ multipart input -> IFormFile / Request.Files
├─ multiple uploads -> file collection
├─ direct download -> stream response + MIME/Content-Disposition
└─ inline media -> streamed response
```

Always validate size, type policy, authorization, safe server-side filename/path, quota and path traversal.

## 18. External HTTP / AI

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

## 19. MCP

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

## 20. Logging / Observability

```text
Need logging?
├─ normal structured logs -> ILogger
├─ correlated operation -> BeginScope
├─ high throughput -> AddAsync / async RingBuffer path
├─ centralized logs -> AddSeq
└─ observability platform -> AddOpenTelemetry
```

Never log secrets/tokens/private payloads.

## 21. Configuration

```text
Need config?
├─ dynamic/bootstrap tree -> IConfiguration
├─ stable typed feature settings -> IOptions<T>
├─ reload-aware settings -> IOptionsMonitor<T>
└─ deployment override -> layered providers / environment variables
```

Later configuration providers override earlier ones.

## 22. Testing

```text
Need test?
├─ unit test -> Dext.Testing
├─ dependency mock -> Mock<T>
├─ event publication -> TEventBusTracker
├─ complex output regression -> MatchSnapshot
├─ web integration -> WebApplicationFactory / request scripts
└─ protocol feature -> protocol-level .http/integration tests
```

## 23. Performance

```text
Need more throughput?
├─ first -> benchmark normal architecture
├─ DB hydration dominates -> raw projection / UseSql
├─ serialization dominates -> direct UTF-8 streaming
├─ object construction dominates -> pool where lifecycle is safe
└─ endpoint pipeline dominates -> MapFast on measured hot route
```

Prefer `AcquireScoped` RAII leases when available in the current pool API.

## 24. AI Agent Reference Routing

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
