# 16B. Base Path Hosting and Reverse-Proxy Prefixes

Dext supports hosting an application beneath a URL prefix.

Core concepts include:

```pascal
UsePathBase('/myapp')
Request.PathBase
Request.SetPath(...)
Request.SetPathBase(...)
Request.ToAppUrl('/route')
TDextPathBaseMiddleware
```

On the HTTP.sys engine, Dext can also bind the kernel URL prefix with the PathBase.

Example conceptual deployment:

```text
https://example.com/erp/api
                    ^^^^ PathBase
```

Application routes can remain:

```text
/orders
/customers
```

while generated application URLs use:

```pascal
Request.ToAppUrl('/orders');
```

rather than manually concatenating prefixes.

### Segment-boundary rule

PathBase stripping is expected to honor path segment boundaries.

A base:

```text
/app
```

must not accidentally match:

```text
/application
```

### Agent rule

When an app is deployed behind IIS/nginx/Cloudflare or below a sub-path, prefer Dext's PathBase abstraction over embedding the deployment prefix into every route.

---

# 17. Authentication / Authorization

Dext supports JWT-oriented auth patterns.

Expected concepts:

```pascal
[Authorize]
[AllowAnonymous]
TClaimsBuilder
```

Typical architecture:

```text
Login endpoint
  -> validate credentials
  -> build claims
  -> issue JWT

Request
  -> authentication middleware
  -> principal/claims
  -> authorization rule
  -> endpoint
```

Never embed signing secrets directly in source.

Load secrets from secure configuration/environment/secret management.

---

# 18. Validation

Dext supports attribute-based and strongly typed fluent validation.

Attributes include concepts such as:

```pascal
[Required]
[MaxLength(100)]
[Range(...)]
```

For complex business validation use Dext's typed validator abstraction rather than stuffing rules into controllers.

Conceptual style:

```pascal
TCreateOrderValidator = class(TAbstractValidator<TCreateOrderDto>)
public
  constructor Create;
end;
```

Strongly typed validation can use entity prototypes / smart properties, reducing magic-string property naming.

Distinguish:

- input validation
- domain invariants
- database constraints

All three may be necessary.

---

# 19. ORM: Core Mental Model

Dext's ORM is strongly influenced by EF Core-style thinking.

Main concepts:

```text
Entity
DbContext
DbSet / IDbSet<T>
Change Tracking
Unit of Work
Query AST
Provider/Dialect
Migrations
Relationships
Specifications
Raw SQL escape hatch
Stored procedure command objects
```

### DbContext responsibilities

A DbContext generally owns:

- database session/connection abstraction
- sets/entities
- transaction/unit-of-work boundary
- change tracking
- SQL execution coordination

Avoid creating a new context for every individual repository method if the operation is part of one unit of work.

---

# 20. Entity Mapping

Dext supports Convention over Configuration plus attributes/fluent mapping.

Typical attributes/concepts:

```pascal
[Table]
[PK]
[AutoInc]
[Required]
[MaxLength(...)]
[ForeignKey(...)]
[InverseProperty(...)]
[ManyToMany(...)]
```

Example:

```pascal
[Table]
TOrder = class
private
  FId: IntType;
  FStatus: Prop<TOrderStatus>;
  FTotal: Prop<Nullable<Currency>>;
public
  [PK, AutoInc]
  property Id: IntType read FId write FId;

  property Status: Prop<TOrderStatus> read FStatus write FStatus;

  property Total: Prop<Nullable<Currency>> read FTotal write FTotal;
end;
```

Do not infer exact database types from Pascal type alone when precision/scale matters.

---

# 21. High-Precision Decimal / TBcd

As of the snapshot, recent repository work added first-class `TBcd` and `ftFMTBcd` handling.

This is important for:

- finance
- accounting
- currency exchange
- high-precision quantities
- `NUMERIC(p,s)` / `DECIMAL(p,s)`

Observed goals include:

- conversion among TBcd, Currency, Double, String, Variant, Integer/Int64
- invariant formatting
- provider-level parameter binding via `AsFMTBCD`
- dynamic precision/scale resolution in SQL dialects
- entity aliases such as `BcdType` / `FmtBcdType`
- explicit conversion errors on overflow/incompatibility

### Agent rule

For high-precision financial database columns:

- do not automatically downgrade to `Double`
- do not use floating-point arithmetic if exact decimal semantics are required
- preserve DB precision/scale
- prefer TBcd/FMTBCD paths when supported end-to-end

---

# 22. Fluent Query

This is a flagship Dext feature.

Instead of:

```pascal
Query.SQL.Text :=
  'select * from USERS where AGE >= :AGE order by NAME';
```

use typed expression building.

Conceptual:

```pascal
var U := Prototype.Entity<TUser>;

var Users := Context.Entities<TUser>
  .AsNoTracking
  .Where(U.Age >= 18)
  .OrderBy(U.Name.Asc)
  .Take(50)
  .ToList;
```

Benefits:

- compile-time refactoring safety
- IDE completion
- parameterized query generation
- reduced magic strings
- expressive intent
- provider translation through AST

### Query methods/concepts

Expect concepts such as:

```text
Where
OrderBy
Take
Skip
AsNoTracking
Include
Find
ToList
First
FirstOrDefault
Any
Count
Update/Execute
Delete/Execute
```

Verify exact signatures per current source.

---

# 23. Tracking vs No-Tracking

Use tracking when entities will be modified in the current unit of work.

Use no-tracking for:

- read-only dashboards
- list endpoints
- reports
- high-throughput query paths
- data that will not be updated

Conceptually:

```pascal
Context.Entities<TProduct>
  .AsNoTracking
  .Where(...)
  .ToList;
```

Do not overuse tracking; it adds memory and bookkeeping.

---

# 24. Bulk Operations

Dext supports database-side operations that avoid hydrating every row.

Conceptual:

```pascal
Context.Products
  .Where(P.Category = 'Outdated')
  .Update
  .Execute;
```

Prefer set-based operations for mass updates/deletes when:

- business rules permit it
- per-entity domain hooks are not required
- optimistic concurrency semantics are understood

Do not load 100,000 rows only to update one field if a safe set-based operation exists.

---

# 25. Relationships and Loading

Dext supports relationship mapping and loading concepts.

Likely patterns:

- one-to-one
- one-to-many
- many-to-many
- eager loading
- lazy loading
- explicit loading

Eager load with `Include` when the API needs related data.

Example concept:

```pascal
Context.Orders
  .Include('Customer')
  .Include('Items')
  .Where(...)
  .ToList;
```

Where possible, use typed relationship APIs if current Dext version provides them; avoid inventing magic-string conventions without checking the current skill/source.

### N+1 rule

Do not use lazy loading across a list when it causes one query per row.

Use eager loading/projection/batching when appropriate.

---

# 26. Specifications and Enterprise Domain Patterns

Dext uses specifications to make query intent reusable and testable.

Architecture encouraged in Cesar Romero's enterprise articles:

```text
Read side:
  Fluent Query / Specifications

Write side:
  Domain Model / business behavior

Quality:
  tests outside the physical database where possible
```

This aligns well with CQRS-like separation without requiring a distributed CQRS architecture.

### Agent guideline

For complex systems:

- keep entity persistence concerns separate from domain behavior when useful
- use specifications for reusable query predicates
- keep controllers thin
- keep domain/application logic testable
- do not introduce CQRS ceremony where simple CRUD is enough

---

# 27. Stored Procedures as Typed Commands

Dext includes patterns to map stored procedures to strongly typed command objects.

Conceptual:

```pascal
[StoredProcedure('ProcessFiscalNotes')]
TProcessNotesCommand = class
private
  FStartDate: TDateTime;
  FProcessedCount: Integer;
public
  [DbParam('StartDate')]
  property StartDate: TDateTime read FStartDate write FStartDate;

  [DbParam('ProcessedCount', pdOutput)]
  property ProcessedCount: Integer
    read FProcessedCount write FProcessedCount;
end;
```

The point is to eliminate repeated manual parameter binding and magic strings at call sites.

---

# 28. Database as API / DataApi

Dext can expose CRUD REST endpoints directly from entity definitions.

Conceptual entity:

```pascal
[Table]
[DataApi('/api/products')]
TProduct = class
...
end;
```

Security/config can be layered through DataApi options.

Conceptual:

```pascal
App.MapDataApis.Configure<TProduct>(
  DataApiOptions
    .RequireAuth
    .RequireWriteRole(['admin'])
);
```

### Appropriate uses

- admin CRUD
- internal tools
- prototypes
- simple master-data APIs
- controlled enterprise CRUD

### Inappropriate uses

Do not use raw DataApi exposure when write operations require:

- complex domain invariants
- workflows
- multi-aggregate transactions
- approvals
- side effects
- external integrations
- custom authorization per business state

In those cases, use application/domain services behind explicit endpoints.

---

# 29. OpenAPI / Swagger and Documentation Philosophy

Cesar Romero's documentation philosophy is:

> documentation should be generated from the code as much as possible.

Dext supports OpenAPI/Swagger so API documentation stays coupled to routes, DTOs, metadata, parameters, and annotations.

Also, `dext doc` generates developer-oriented documentation from source.

### Agent rule

When adding a public API:

- add route metadata
- use meaningful DTO types
- annotate/document response behavior where supported
- keep OpenAPI output accurate
- update docs and skills for framework-level features

Do not create a separate static API document that immediately diverges from the code.

---

# 30. REST Client

`Dext.Net.RestClient` is a code-first fluent HTTP client.

Conceptual usage:

```pascal
var Users := RestClient('https://api.example.com')
  .BearerToken(Token)
  .Timeout(5000)
  .Get<TList<TUser>>('/users?role=admin')
  .Await;
```

Architectural principles:

- lightweight fluent facade
- underlying connection/client pooling
- thread-safe connection reuse
- typed deserialization
- sync or async usage
- integration with Dext.Threading
- testability without form-bound REST components

### Agent rule

Do not create/destroy an expensive `TNetHTTPClient` for every outbound request in high-throughput code if Dext pooling is available.

---

# 31. `.http` Files

Dext supports IDE-style `.http` request files.

Example:

```http
@baseUrl = https://api.example.com
@authToken = abc123

### Create Order
POST {{baseUrl}}/orders
Authorization: Bearer {{authToken}}
Content-Type: application/json

{
  "productId": 10,
  "qty": 2
}
```

They can act as:

- developer documentation
- manual API test scenarios
- dashboard request definitions
- integration-test fixtures
- repository-owned source of truth

Prefer keeping these files with the code rather than duplicating requests into opaque external Postman collections only.

---

# 32. Async / Threading

Dext provides a fluent task abstraction over Delphi concurrency primitives.

Conceptual:

```pascal
TAsyncTask.Run<TData>(
  function: TData
  begin
    Result := LoadData;
  end)
  .Then<TReport>(
    function(Data: TData): TReport
    begin
      Result := BuildReport(Data);
    end
  )
  .OnComplete(
    procedure(Report: TReport)
    begin
      ShowReport(Report);
    end
  )
  .OnException(
    procedure(E: Exception)
    begin
      ShowError(E.Message);
    end
  )
  .Start;
```

Core concepts:

- task pipeline
- futures/results
- continuation
- centralized exception handling
- cancellation
- thread pool
- UI-safe completion callback semantics where supported
- work stealing

### Cancellation

Use cooperative cancellation for long I/O / loops.

Do not forcibly terminate threads.

### UI rule

Do not use `Application.ProcessMessages` as an async architecture.

---
