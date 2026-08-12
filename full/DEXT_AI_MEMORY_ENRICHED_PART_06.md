# 60E. `WriteJson` Fast Streaming Response API

Recent adapter work added consistent JSON response overloads to WebBroker and gRPC-provider-related HTTP response implementations.

Concepts include:

```pascal
Response.WriteJson(TValue)
Response.WriteJson(StatusCode, TValue)
Response.WriteJson(IDextFastQuery)
Response.WriteJson(StatusCode, IDextFastQuery)
Response.WriteJson(IDbSetFastStream)
Response.WriteJson(StatusCode, IDbSetFastStream)
Response.Status(Code, Message)
```

This lets high-level response handling detect fast-stream capable interfaces and avoid forcing them through ordinary JSON object serialization.

### Agent rule

If the value already implements a Dext fast-stream interface, do not unnecessarily convert it into a `TValue`, object list, JSON DOM or string first.

Let the response adapter stream directly when supported.

---

# 60F. Conditional Entity Integration — `DEXT_ENABLE_ENTITY`

Recent Web/adapter changes use:

```pascal
{$IFDEF DEXT_ENABLE_ENTITY}
```

to keep entity/ORM integration optional in parts of the Web stack.

Architectural implication:

- Web must not become hard-coupled to ORM everywhere.
- Build configurations may intentionally exclude Entity functionality.
- Infrastructure code should preserve modular compilation boundaries.

When modifying Web core code, do not introduce unconditional dependencies on Entity units if the surrounding code is designed to compile without them.

---

# 60G. PostgreSQL Benchmark and Provider Compatibility Learnings

Recent benchmark work explicitly added PostgreSQL/libpq coverage and fixed provider-specific behavior such as:

- 64-bit PostgreSQL client support
- identifier quoting
- FireDAC metadata scope handling
- concurrent DbContext/connection-pool benchmarking
- per-step query/serialization tracing

Agent implications:

1. Never assume SQL identifier quoting is portable.
2. Benchmark with the actual target DBMS where performance matters.
3. Provider metadata behavior can differ.
4. SQLite/in-memory performance is not a substitute for PostgreSQL/Firebird/SQL Server production profiling.
5. Separate database time from hydration/serialization time when diagnosing latency.

---

# 61. Common Anti-Patterns

## Anti-pattern: SQL in UI

```pascal
Form.Query.SQL.Text := ...
```

Replace with application/data service.

## Anti-pattern: Service locator everywhere

```pascal
ServiceProvider.GetService<T>
```

Prefer injection.

## Anti-pattern: HTTP client per request

Create/destroy expensive network clients repeatedly.

Prefer Dext RestClient pooling.

## Anti-pattern: `TObjectList<T>` as default ORM API

Prefer `IList<T>`.

## Anti-pattern: manual JSON concatenation

```pascal
'{"name":"' + Name + '"}'
```

Use TDextJson/builder.

## Anti-pattern: magic route strings repeated everywhere

Use controller prefixes/typed organization.

## Anti-pattern: long transaction across network call

Split workflow/outbox/compensation.

## Anti-pattern: `ProcessMessages` for responsiveness

Use async/task pipelines.

## Anti-pattern: trusting forwarded headers from the internet

Configure trusted proxy boundary.

## Anti-pattern: retrying non-idempotent writes blindly

Use idempotency strategy.

## Anti-pattern: premature micro-optimization in business code

Reserve Span/direct-memory complexity for measured hot paths.

---

# 62. Suggested Project Bootstrap

Use current Dext examples/skills for exact signatures, but an AI should conceptually generate:

```pascal
program MyApp;

{$APPTYPE CONSOLE}

uses
  Dext,
  Dext.Entity,
  Dext.Web,
  MyApp.Startup;

begin
  SetConsoleCharSet;

  var Builder := WebApplication.CreateBuilder;

  TStartup.ConfigureServices(Builder.Services, Builder.Configuration);

  var App := Builder.Build;

  TStartup.Configure(App);

  App.Run(8080);
end.
```

Exact bootstrap symbols can change; verify before compilation.

---

# 63. Suggested Service Registration Pattern

```pascal
class procedure TStartup.ConfigureServices(
  const Services: IServiceCollection;
  const Configuration: IConfiguration);
begin
  Services
    .AddScoped<IOrderRepository, TOrderRepository>
    .AddScoped<IOrderService, TOrderService>
    .AddSingleton<IClock, TSystemClock>;
end;
```

If DbContext registration is used for Web APIs, enable pooling where supported/currently recommended.

---

# 64. Suggested Endpoint Architecture

```text
HTTP request
 -> middleware
 -> model binding
 -> validation
 -> endpoint/controller
 -> application service
 -> domain
 -> repository/DbContext
 -> result DTO
 -> JSON serializer
 -> HTTP response
```

Every layer should have a clear reason to exist.

---

# 65. Suggested ORM Read Pattern

```pascal
function TProductService.Search(const Term: string): IList<TProduct>;
begin
  var P := Prototype.Entity<TProduct>;

  Result := FContext.Entities<TProduct>
    .AsNoTracking
    .Where(P.Name.Contains(Term))
    .OrderBy(P.Name.Asc)
    .Take(100)
    .ToList;
end;
```

If exposing externally, add pagination rather than arbitrary max limits when appropriate.

---

# 66. Suggested ORM Write Pattern

```pascal
procedure TOrderService.UpdateOrder(const Dto: TUpdateOrderDto);
begin
  var Order := FContext.Entities<TOrder>.Find(Dto.Id);

  if Order = nil then
    raise ENotFound.Create('Order not found');

  Order.ChangeQuantity(Dto.Quantity);

  FContext.SaveChanges;
end;
```

For detached DTO-to-entity updates, use explicit update/attach semantics.

---

# 67. Suggested Domain + Transaction Pattern

```pascal
procedure TPaymentService.Capture(OrderId: Integer);
begin
  FContext.BeginTransaction;
  try
    var Order := FOrders.GetForUpdate(OrderId);
    Order.MarkPaid;

    FOutbox.Add(TOrderPaidEvent.Create(Order.Id));

    FContext.SaveChanges;
    FContext.Commit;
  except
    FContext.Rollback;
    raise;
  end;
end;
```

Use an outbox for durable external events where needed.

---

# 68. Suggested Outbound REST Pattern

```pascal
function TCustomerApi.GetCustomer(Id: Integer): TCustomerDto;
begin
  Result := RestClient(FBaseUrl)
    .BearerToken(FAccessToken)
    .Timeout(5000)
    .Get<TCustomerDto>('/customers/' + Id.ToString)
    .Await;
end;
```

Add resilience only if failure semantics are understood.

---

# 69. Suggested Async UI Pattern

```pascal
TAsyncTask.Run<TReport>(
  function: TReport
  begin
    Result := FReportService.Build;
  end)
  .OnComplete(
    procedure(Report: TReport)
    begin
      RenderReport(Report);
    end)
  .OnException(
    procedure(E: Exception)
    begin
      ShowMessage(E.Message);
    end)
  .Start;
```

Do not mutate VCL controls from worker threads unless Dext guarantees completion callback synchronization for that API.

---

# 70. Suggested MCP Architecture

```text
MCP transport
 -> authentication
 -> tool registry
 -> tool input validation
 -> application service
 -> domain/data
 -> structured result
 -> audit log
```

MCP tool classes should be thin adapters.

Do not put business rules in attribute-decorated MCP transport classes.

---

# 71. Dext Documentation Map for Agents

Before writing code in a domain, load the matching skill:

| Task | Skill |
|---|---|
| New project / Startup | `dext-app-structure.md` |
| HTTP / Controller / Minimal API | `dext-web.md` |
| Core ORM | `dext-orm.md` |
| Relations / migrations / multi-tenancy | `dext-orm-advanced.md` |
| Dependency injection | `dext-di.md` |
| JWT / auth | `dext-auth.md` |
| Unit/integration tests | `dext-testing.md` |
| IList / collections | `dext-collections.md` |
| JSON | `dext-json.md` |
| CORS/rate-limit/OpenAPI/etc | `dext-api-features.md` |
| Validation | `dext-validation.md` |
| Background services / config / async | `dext-background.md` |
| REST/gRPC/protobuf | `dext-networking.md` |
| Logging / OTEL | `dext-logging.md` |
| Retry/circuit breaker | `dext-resilience.md` |
| Hubs/WebSocket | `dext-realtime.md` |
| DataApi | `dext-database-as-api.md` |
| VCL/MVVM/navigation | `dext-desktop-ui.md` |
| Hosting/TLS/adapters | `dext-server-adapters.md` |
| MCP | `dext-mcp.md` |
| Locate source symbols | `dext-symbols.md` |

---

# 72. Cesar Romero Article Map and Architectural Takeaways

The article collection provides design rationale for several Dext features.

## Zero-Alloc Pipeline

Key ideas:

- heap allocation can be a major throughput limiter
- routing/middleware/ORM/JSON hot paths should minimize allocations
- spans provide type-safe views over raw memory
- direct UTF-8 processing reduces transient objects
- request data should be exposed as lightweight/lazy views where possible

## Modern Delphi: RAD to Decoupling

Key ideas:

- dependency inversion
- repository/service abstractions
- business code should request capabilities rather than construct infrastructure
- retain Delphi productivity while eliminating form/database coupling

## Design-Time Revolution

Key ideas:

- modern architecture should not destroy Object Inspector / design-time productivity
- entity metadata can power IDE design experiences
- EntityDataSet bridges ORM to RAD workflows

## Documentation / Swagger / dext doc

Key ideas:

- documentation should derive from code
- OpenAPI for API consumers
- code documentation generator for maintainers

## Continuous Evolution / Architecture

Key ideas:

- lock-free reflection cache fast paths
- AST-driven template engine
- EntityDataSet design-time experience
- event bus integration
- observability
- lazy loading/migrations
- architecture maturity over isolated features

## Fluent Query

Key ideas:

- query strings are fragile
- typed expression trees improve refactor safety
- compiler assistance reduces runtime schema-name mistakes
- tests/mocks should allow query/application behavior to be verified outside production DB

## REST Client

Key ideas:

- code-first request composition
- connection pooling
- async pipelines
- `.http` files as source-of-truth
- testability without DataModules/components

## Enterprise Patterns / CQRS

Key ideas:

- read side can use expressive specifications
- write side benefits from rich domain behavior
- testability is a primary architectural goal
- CQRS is a design separation, not automatically a distributed system

## Native TLS / S43

Key ideas:

- TLS can terminate in the Delphi process
- OpenSSL/Schannel abstractions
- WSS / compression / binary messaging
- reverse proxies remain useful but are not mandatory for every deployment

---

# 73. Current Snapshot Notes (2026-08-12)

Observed repository state immediately before this memory was generated:

- repository: `cesarliws/dext`
- branch: `main`
- latest observed merge commit: `412ed292...`
- commit date: 2026-08-11
- recent features include:
  - feature flags
  - forwarded headers
  - anti-forgery CSRF
  - WebApplicationFactory integration testing
  - TBcd / ftFMTBcd first-class support
  - dynamic docs TOC work
- README reports RC2

Because Dext is moving quickly, **verify new APIs against source when using this memory after the snapshot date**.

---
