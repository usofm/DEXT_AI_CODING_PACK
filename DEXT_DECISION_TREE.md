# DEXT DECISION TREE

> Fast architecture and API selection guide for AI coding agents working with Dext.

## 1. HTTP Endpoint

```text
Need HTTP endpoint?
├─ Normal business endpoint
│  ├─ simple function-style endpoint -> Minimal API (MapGet/MapPost/...)
│  └─ grouped/attribute-driven endpoint -> Controller
├─ Metadata-driven CRUD -> MapDataApi<T>
├─ Ultra-high-throughput hot path -> MapFast
└─ One-way event stream -> SSE
```

## 2. Database Read

```text
Need data?
├─ Domain/entity object required -> IDbSet<T>
├─ Reusable business predicate -> Specification
├─ Eager relations -> Include(...)
├─ Typed SQL join -> JoinInner/Left/Right/Full/Cross
├─ Raw SQL but entity hydration acceptable -> FromSql
├─ Raw projection / no entity hydration -> TDbContext.UseSql / IDextFastQuery
└─ Direct JSON streaming -> IDextFastQuery / IDbSetFastStream
```

## 3. Database Write

```text
Need write?
├─ Normal tracked aggregate -> Add/Update/Remove + SaveChanges
├─ Detached entity -> Update(Entity) before SaveChanges
├─ Bulk operation -> check IsBulkInsertSafe/IsBulkUpdateSafe/IsBulkDeleteSafe
└─ Stored procedure -> [StoredProcedure] / [DbParam]
```

## 4. Numeric Type

```text
Need decimal?
├─ exact >4 decimals -> TBcd / FmtBcdType / BcdType
├─ fixed 4 decimals sufficient -> CurrencyType
└─ approximate scientific/measurement -> FloatType/Double
```

For Firebird 5 financial schemas prefer exact fixed-point mappings such as `NUMERIC(28,10)` when the domain requires them.

## 5. Collections

```text
Need collection?
├─ normal list -> IList<T>
├─ ordered dictionary -> IOrderedDictionary<K,V>
├─ immutable concurrent reads -> IFrozenList<T> / IFrozenDictionary<K,V>
├─ producer/consumer -> IChannel<T>
└─ expensive reusable objects -> TDextPool<T>
```

## 6. Background Work

```text
Need background execution?
├─ process-lifetime worker -> IHostedService
├─ delayed/persistent/restart-safe work -> TDextJobs
├─ short async operation -> TAsyncTask
└─ retryable I/O -> Resilience Pipeline
```

## 7. Validation

```text
Need validation?
├─ simple declarative rules -> attributes
├─ complex/business/conditional rules -> TAbstractValidator<T>
├─ strongly typed property rules -> Prototype.Entity<T> + RuleFor
└─ reusable localized regex -> TValidationPatterns
```

## 8. Real-Time

```text
Need real-time?
├─ server -> client only -> SSE
├─ bidirectional raw socket -> WebSocket
└─ higher-level groups/broadcasts -> THub / IHubContext<T>
```

## 9. Security

```text
Behind reverse proxy?
├─ client IP/scheme/host -> ForwardedHeaders (trusted proxies only)
├─ sub-path deployment -> UsePathBase
├─ browser state-changing requests -> Antiforgery
├─ auth -> JWT / [Authorize]
└─ browser hardening -> SecurityHeaders + strict CORS
```

## 10. Logging / Observability

```text
Need logging?
├─ normal structured logs -> ILogger
├─ high throughput -> AddAsync
├─ centralized logs -> AddSeq
└─ observability platform -> AddOpenTelemetry
```

## 11. Testing

```text
Need test?
├─ unit test -> Dext.Testing
├─ dependency mock -> Mock<T> from Dext.Mocks
├─ complex output regression -> MatchSnapshot
├─ web integration -> WebApplicationFactory
└─ IDE/external runner integration -> DUnit/DUnitX/DUnit2/TestInsight adapters
```

## 12. AI Agent Routing

```text
Unsure about exact API?
1. search DEXT_API_SYMBOL_INDEX.md
2. load matching Docs/skills/dext-*.md
3. inspect current source
4. inspect official example
5. only then generate code
```
