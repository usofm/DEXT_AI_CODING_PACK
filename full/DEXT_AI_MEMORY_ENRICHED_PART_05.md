# 52A. WebApplication Lifecycle Semantics

Recent lifecycle fixes clarify important runtime rules.

## Teardown is single-run

Application teardown is guarded so that competing shutdown paths cannot tear down the same host/services twice.

This matters for:

- VCL applications hosting Dext on a worker thread
- Windows Services
- GUI applications
- concurrent `Stop`/run-loop shutdown

## Stop must be race-safe

The active host is retained in a local interface reference during stop so another thread cannot nil/release the field between check and invocation.

## A stopped `WebApplication` instance is not restartable

After a Dext `WebApplication` has been stopped, do not attempt:

```pascal
App.Start;
```

again on the same instance.

Create a fresh instance:

```pascal
App := WebApplication;
```

This behavior intentionally prevents access to services/configuration already released during teardown.

### Agent rule

When generating Windows Service or VCL host lifecycle code:

```text
Create app instance
 -> Start/Run
 -> Stop once
 -> discard instance
```

If restart is required, construct a new WebApplication object.

---

# 53. Legacy Modernization Strategy

A core Dext value proposition is **incremental modernization**.

Do not rewrite a 20-year Delphi ERP merely to adopt Dext.

A safer progression:

```text
Step 1: isolate business logic from forms
Step 2: introduce DI
Step 3: introduce application services/repositories
Step 4: adopt DbContext/ORM for new modules
Step 5: expose new APIs through Dext Web
Step 6: move old screens to EntityDataSet/adapters
Step 7: add async/networking/telemetry
Step 8: gradually replace legacy infrastructure
```

Dext should coexist with legacy VCL/FMX/DataSnap/ISAPI-era code during transition.

---

# 54. Clean Architecture Guidance

A reasonable Dext enterprise structure:

```text
src/
  Domain/
    Entities/
    ValueObjects/
    Specifications/
    Events/

  Application/
    DTOs/
    Interfaces/
    Services/
    Commands/
    Queries/
    Validators/

  Infrastructure/
    Persistence/
      Context/
      Mappings/
      Migrations/
      Repositories/
    External/
      RestClients/
      Messaging/
      AI/

  Web/
    Controllers/
    Endpoints/
    Middleware/

  Desktop/
    Views/
    ViewModels/
    Controllers/

tests/
  Unit/
  Integration/
```

Do not over-layer small apps.

The architecture must match complexity, not ideology.

---

# 55. CQRS Guidance

Use pragmatic CQRS.

You do not need separate databases or message buses merely because the system has Commands and Queries.

A good default:

```text
Queries:
  read models / projections / no tracking

Commands:
  application service + domain invariants + transaction
```

Escalate to distributed CQRS/event sourcing only when justified by scale/domain/audit/replay requirements.

---

# 56. Domain Model Guidance

For important write workflows, put behavior where it can be tested.

Bad:

```pascal
procedure TOrderController.Pay(...);
begin
  if Query.FieldByName('STATUS').AsString = 'OPEN' then
  begin
    Query.Edit;
    Query.FieldByName('STATUS').AsString := 'PAID';
    Query.Post;
  end;
end;
```

Better mental model:

```pascal
Order.Pay(PaymentInfo);
Repository.Save(Order);
```

The actual Dext implementation may vary, but business invariants should not depend on a form/control/query component.

---

# 57. Data Ownership and Memory Management

Delphi memory ownership must remain explicit even in modern abstractions.

With Dext:

- interfaces often manage lifetime
- DI scopes may own service objects
- managed records may own/release internal resources
- `IList<T>` may manage collection lifetime
- Lazy wrappers may have ownership flags
- detached class instances may still require clear ownership

Never add `.Free` mechanically.

First determine:

```text
Who owns this object?
Is it interface managed?
Is it DI scoped?
Does the collection own elements?
Does Lazy own the value?
Is it returned to a pool?
```

---

# 58. Thread Safety

Do not assume a class is thread-safe because it is used in server code.

Check:

- mutable fields
- singleton lifetime
- caches
- connection/session ownership
- object pools
- request context
- shared JSON buffers
- logging queues
- hub connection registries

Dext intentionally uses lock-free fast paths where possible, but initialization and mutation may still require synchronization.

---

# 59. Database Connections and Pooling

A web server should not bind one permanent DB connection to each app thread manually if Dext/provider pooling is available.

Prefer:

```text
request scope
 -> DbContext
 -> pooled physical connection lease
 -> execute
 -> return connection
```

Do not keep a transaction open while:

- calling remote APIs
- waiting for user input
- performing long CPU work
- streaming unrelated network data

Keep database transactions short.

---

# 60. Performance Rules for AI-Generated Dext Code

Before optimizing, preserve correctness.

Then prefer:

- typed queries
- `AsNoTracking` for read-only
- server-side filtering
- pagination
- projection
- bulk operations
- connection pooling
- pooled DbContext
- cached metadata
- direct codecs on hot paths
- spans for parsing
- structured async
- avoid repeated allocations
- avoid repeated reflection
- avoid unnecessary object graphs
- avoid `string` building in protocol parsers
- avoid loading entire datasets

Never claim "zero allocation" unless the hot path is actually verified.

---

# 60A. FastPath Routing — `MapFast`

Recent Dext development introduced an explicit **FastPath** for extremely hot HTTP endpoints.

The important distinction is architectural:

```text
Normal Dext route
  -> request pipeline
  -> DI scope
  -> typed activation/model binding
  -> application endpoint

FastPath route
  -> minimal routing path
  -> direct request/response interfaces
  -> optional pooled DbContext
  -> direct UTF-8 output
```

Representative API concepts from the current implementation include:

```pascal
App.MapFast('GET', '/fastping',
  procedure(const Req: IHttpRequest; const Res: IHttpResponse)
  begin
    Res.SendJsonUtf8('{"message":"pong"}');
  end);
```

For database-backed endpoints, Dext also supports a pooled DbContext form:

```pascal
App.MapFast<TAppDbContext>('/api/users/fast',
  procedure(Ctx: TAppDbContext; Req: IHttpRequest; Res: IHttpResponse)
  begin
    Ctx.DataSet(TypeInfo(TUser))
      .ExecuteToUtf8Stream(Res.BodyStream);
  end);
```

Exact overload signatures must still be verified against the current source.

## When FastPath is appropriate

Use it for:

- extremely high-frequency read endpoints
- benchmark-sensitive APIs
- large JSON streams
- simple health/ping endpoints
- read-only direct database projections
- cases where DI activation and object hydration are measurable bottlenecks

Do **not** use FastPath as the default application architecture.

Normal typed routes remain preferable when an endpoint needs:

- application services
- domain behavior
- validation
- authorization policies
- rich model binding
- multiple injected dependencies
- normal business maintainability

### FastPath Agent Rule

An AI agent must not "optimize" every endpoint by converting it to `MapFast`.

First identify that the endpoint is truly latency/throughput sensitive and simple enough that bypassing normal abstractions is beneficial.

---

# 60B. Direct UTF-8 Database Streaming

Dext's recent FastPath ORM work adds a direct path from database cursor to response output.

Core concepts include:

```text
IDextFastQuery
TDbContext.UseSql(...)
ExecuteToUtf8Proc(...)
ExecuteToUtf8Stream(...)
IHttpResponse.SendJsonUtf8(...)
IHttpResponse.GetOutputStream / BodyStream
IDbSetFastStream
```

Conceptually:

```pascal
Ctx.UseSql(
  'SELECT Id, Name, Email, Age FROM BenchmarkUsers'
)
.ExecuteToUtf8Stream(Res.GetOutputStream);
```

This bypasses:

```text
database rows
 -> entity allocation
 -> IList<T>
 -> RTTI object hydration
 -> JSON DOM/object tree
 -> Unicode string
 -> UTF-8 conversion
```

and moves toward:

```text
database cursor
 -> TUtf8JsonWriter
 -> output stream/socket
```

## Architectural implication

Use typed Fluent Query/entity hydration when you need domain/entity behavior.

Use direct FastQuery/streaming when the endpoint is essentially a high-throughput database projection and materializing objects provides no business value.

## Safety rule

`UseSql` is a raw-SQL escape hatch.

- parameterize dynamic values
- never concatenate untrusted input
- keep DB/provider-specific SQL isolated
- do not bypass authorization/tenant filters accidentally
- do not expose arbitrary query execution to callers

---

# 60C. Generic Object Pooling — `TDextPool<T>`

Dext now has a first-class generic object pool intended for expensive reusable objects such as:

- DbContexts
- REST clients
- UTF-8 writers
- reusable framework infrastructure

Important types/concepts:

```pascal
TDextPool<T>
IDextPool<T>
TDextPoolConfig
IPoolable
IPooledObject<T>
Acquire
AcquireScoped
Release
Use
```

Representative configuration:

```pascal
var Config := TDextPoolConfig.Default;
Config.MinSize := 5;
Config.MaxSize := 50;
Config.AcquireTimeoutMs := 2000;
```

### RAII / ARC scoped acquisition

Recent Dext changes added:

```pascal
IPooledObject<T>
AcquireScoped(...)
```

The returned interface acts as an ARC-managed lease. When the interface leaves scope, the pooled object is returned automatically.

Prefer this pattern when possible because it remains exception-safe:

```pascal
var Lease := Pool.AcquireScoped;

if Lease <> nil then
  Lease.Item.PerformQuery;
```

Another supported style is conceptually:

```pascal
Pool.Use(
  procedure(Item: TMyContext)
  begin
    Item.PerformQuery;
  end
);
```

### Pool concurrency semantics

The current implementation explicitly addresses:

- `TSpinLock` synchronization
- manual-reset event broadcast to waiters
- atomic waiter tracking
- monotonic deadline-based acquisition timeout
- shutdown/disposal state
- drain-before-free behavior
- prevention of use-after-free during pool destruction

### Pool exhaustion

For pooled `MapFast<TDbContext>` routes, Dext now returns:

```text
HTTP 503 Service Unavailable
```

when no context can be acquired within the configured pool acquisition behavior.

### Agent rule

Do not replace the Dext pool with an ad-hoc `TObjectQueue<T>` + lock.

Do not manually return an item from multiple exception paths if `AcquireScoped` or `Use` can express the same lifecycle safely.

---

# 60D. DbSet Bulk-Safety Introspection

`IDbSet<T>` now exposes explicit safety checks for set/batch operations:

```pascal
IsBulkInsertSafe
IsBulkUpdateSafe
IsBulkDeleteSafe
```

The presence of these methods is a strong architectural signal:

> Bulk operations are not automatically semantically safe merely because the database can execute them efficiently.

An AI should evaluate bulk safety before substituting a normal tracked operation with a batch operation.

Potential reasons bulk execution may be unsafe include:

- entity lifecycle behavior
- relationship implications
- provider/dialect restrictions
- concurrency requirements
- generated/computed values
- domain hooks that require hydration

Never transform application logic into bulk UPDATE/DELETE solely for performance without checking semantics.

---
