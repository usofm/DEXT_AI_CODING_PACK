# DEXT 03-DATA DEEP AUDIT

> Source group: `cesarliws/dext/Examples/03-Data`
> Snapshot: 2026-08-12

## Scope

Audited examples:

- `Dext.Examples.ComplexQuerying`
- `Dext.Examples.MultiTenancy`
- `Orm.EntityDemo`
- `Orm.EntityStyles`
- `Orm.Specification`
- `Web.DatabaseAsApi`
- `Web.FastPath.OrmPool`
- `Web.SmartPropsDemo`

## 1. Entity Styles: two legitimate models

`Orm.EntityStyles` explicitly demonstrates two supported approaches.

### Classic entity

```pascal
[Table('ClassicPeople')]
TClassicPerson = class
  property Id: Integer read FId write FId;
  property Name: string read FName write FName;
  property Age: Integer read FAge write FAge;
end;
```

Best fit:

- legacy/migrated Delphi models
- native Delphi property types
- explicit metadata/query type layer

Typed queries use a separate `TEntityType<T>`-based type system.

### Smart entity

```pascal
[Table('SmartPeople')]
TSmartPerson = class
  property Id: IntType read FId write FId;
  property Name: StringType read FName write FName;
  property Age: IntType read FAge write FAge;
end;
```

Best fit:

- new Dext-first code
- less query boilerplate
- `Prototype.Entity<T>` query expressions

### Golden rule

Do not force Smart Properties into an existing domain model merely to make queries typed. `TEntityType<T>` exists specifically so classic POCO-style models can remain clean.

---

## 2. Specification Pattern

`Orm.Specification` demonstrates reusable, composable criteria with `TSpecification<T>`.

Representative concepts:

```text
TSpecification<T>
Where(...)
And(...)
Or(...)
GetExpression
SQL generation
parameterized criteria
```

### Golden rule

Use Specifications when a query expresses a named reusable business concept, for example:

```text
ActiveCustomers
OverdueInvoices
OpenOrdersForTenant
AvailableProducts
```

Do not create a Specification class for every trivial one-off filter.

### Drift note

The example README contains `Prop('Price')` string-style expressions. Current Dext also supports stronger typed Smart Property / Prototype approaches. Prefer the strongest currently-supported typed syntax when writing new code.

---

## 3. Complex Querying

`Dext.Examples.ComplexQuerying` combines:

- Smart Properties
- JSON-oriented fields
- dynamic search criteria
- date-range filtering
- aggregations/reporting
- typed DbContext
- `IList<T>` service results

Representative context pattern:

```pascal
TQueryDbContext = class(TDbContext)
private
  function GetOrders: IDbSet<TOrder>;
public
  property Orders: IDbSet<TOrder> read GetOrders;
end;
```

### Important lesson

The example performs some post-query filtering by materializing a list and iterating it. An AI agent must not generalize this into "filter in memory" when the condition can be translated to SQL. Push filters/aggregates to the database when possible.

### Reporting rule

For reporting/read models:

```text
simple entity read -> IDbSet<T>
reusable domain criteria -> Specification
complex typed query -> fluent query/join API
raw optimized projection -> FromSql / UseSql
very hot JSON read -> IDextFastQuery/direct UTF-8 streaming
```

---

## 4. Multi-Tenancy

`Dext.Examples.MultiTenancy` demonstrates a SaaS-style shared-database tenant-column strategy.

Observed concepts:

```text
X-Tenant-Id request header
Tenant Resolution Middleware
ITenantAware
automatic TenantId population
per-tenant product filtering
shared DB + tenant_id column
```

Other isolation strategies are described but not implemented in this demo:

```text
separate database per tenant
schema per tenant
```

### Security rule

Tenant identity is a security boundary. Never trust a raw tenant header merely because it exists. In a production application tenant resolution must be tied to authenticated identity, trusted gateway metadata, membership/authorization, or another verified source.

### Query rule

All tenant-scoped reads and writes must preserve tenant isolation. A missing tenant predicate is a data-leak bug, not a normal query bug.

---

## 5. Database as API

`Web.DatabaseAsApi` demonstrates automatic CRUD exposure through `TDataApiHandler<T>.Map` and options such as:

```text
UseSnakeCase
UseSwagger
Tag(...)
```

It also demonstrates entity mapping attributes such as:

```text
[PK]
[AutoInc]
[NotMapped]
```

### Golden rule

Use Database-as-API for genuinely generic CRUD surfaces:

- admin/reference data
- internal utilities
- prototypes
- low-risk maintenance screens

Do not use it as a shortcut for:

- payments
- accounting posting
- inventory reservations
- permission-changing operations
- state machines
- settlement workflows
- any command with important invariants

### Drift rule

The README may show an older `TDataApiHandler<T>.Map` overload. Verify current source/example code before emitting the exact call signature.

---

## 6. FastPath ORM Pool

`Web.FastPath.OrmPool` demonstrates the specialized high-throughput path:

```text
TDextPool<TAppDbContext>
TDextPoolConfig
MapFast
TDbContext.UseSql
IHttpResponse.WriteJson
DbContext.ResetState
```

The example uses:

```pascal
DbPool.Acquire(Ctx)
try
  ...
finally
  DbPool.Release(Ctx);
end;
```

### Important version note

Newer Dext pool APIs introduced `IPooledObject<T>` / `AcquireScoped` RAII leasing. Therefore:

```text
example Acquire/Release -> valid historical/example evidence
current preferred pattern -> AcquireScoped when available
```

### FastPath decision rule

Use FastPath only when profiling shows normal pipeline overhead matters.

Normal default:

```text
middleware + DI + typed endpoint/controller + ORM/domain model
```

Specialized path:

```text
MapFast + pooled context + raw projection/direct streaming
```

### Pool reset rule

A pooled DbContext must be returned to a clean state. The example explicitly calls `ResetState` to clear tracking/transactions before reuse.

---

## 7. Smart Properties

`Web.SmartPropsDemo` plus `Orm.EntityStyles` establish Smart Properties as both:

```text
runtime values
query expression builders
```

Recommended new-code pattern:

```pascal
var E := Prototype.Entity<TEntity>;
var Rows := Db.Entities<TEntity>
  .Where(E.Active = True)
  .ToList;
```

For exact decimal fields:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

---

## 8. ORM Ownership Rules

Across production-like examples and docs:

```text
ORM query result -> IList<T>
DbContext-managed entity children -> non-owning collection
Mock<T> -> record, no Free
DbContext pooling -> explicit/reset-aware lifecycle
```

Avoid accidental dual ownership between an owning Delphi object list and DbContext tracking.

---

## 9. Recommended ORM Learning Order for Agents

```text
Orm.EntityStyles
  -> choose entity model style

Orm.EntityDemo
  -> CRUD, relationships, navigation, tracking

Orm.Specification
  -> reusable domain queries

Web.SmartPropsDemo
  -> strongly typed expression style

Dext.Examples.ComplexQuerying
  -> reporting/search composition

Dext.Examples.MultiTenancy
  -> tenant boundary concerns

Web.DatabaseAsApi
  -> metadata-driven CRUD

Web.FastPath.OrmPool
  -> specialized performance path
```

---

## 10. ORM Golden Decision Tree

```text
Need data access?
├─ normal aggregate/entity CRUD
│  └─ IDbSet<T> + SaveChanges
├─ legacy/native entity + typed query
│  └─ TEntityType<T>
├─ Dext-first Smart Entity query
│  └─ Prototype.Entity<T>
├─ reusable business criteria
│  └─ TSpecification<T>
├─ relation graph
│  └─ Include / typed joins
├─ raw SQL with entity materialization
│  └─ FromSql
├─ projection without entity materialization
│  └─ UseSql / IDextFastQuery
├─ generic low-risk CRUD
│  └─ Data API
└─ measured ultra-hot read path
   └─ MapFast + pool + direct UTF-8 streaming
```

---

## 11. Agent Anti-Patterns Found/Prevented by This Audit

Do not:

```text
force Smart Properties into every legacy model
filter large query results in memory when SQL can filter them
trust tenant ID headers without authorization
expose business commands as generic Data API CRUD
use MapFast as normal application architecture
copy old manual Acquire/Release if current AcquireScoped exists
copy exact signatures from README without checking source
```

---

## 12. Source Priority for Data Examples

```text
current Dext source
> current example .pas source
> repository-wide AI critical rules
> official ORM skills/specs
> example README
> this audit
```
