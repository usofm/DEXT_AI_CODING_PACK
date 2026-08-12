# DEXT EXAMPLE GOLDEN PATTERNS

> Canonical composition patterns distilled from the official examples. These are guidance, not frozen signatures.

## Golden Pattern 01 — Application Composition

```text
DPR
  -> WebApplication/host bootstrap
  -> TStartup
      -> ConfigureServices
      -> Configure
```

Use Startup as the composition root. Keep feature/business logic out of the bootstrap.

## Golden Pattern 02 — Web Uses Ordering

Where helpers depend on Delphi's single class-helper resolution, preserve the repository-wide order:

```pascal
Dext,
Dext.Entity,
Dext.Web
```

Add specialized units around that order without hiding the facade helpers you need.

## Golden Pattern 03 — Typed DbContext

```pascal
type
  TAppDbContext = class(TDbContext)
  private
    function GetOrders: IDbSet<TOrder>;
  public
    property Orders: IDbSet<TOrder> read GetOrders;
  end;
```

For Web workloads, configure pooling where supported/appropriate.

## Golden Pattern 04 — Thin Endpoint, Business Service Behind It

```text
HTTP endpoint/controller
  -> typed DI service
      -> application/domain logic
          -> DbContext/repository/integration
```

Do not bury significant business rules in route lambdas merely because Minimal APIs make it easy.

## Golden Pattern 05 — Typed Queries

```pascal
var E := Prototype.Entity<TEntity>;

var Rows := Db.Entities
  .Where(E.Active = True)
  .OrderBy(E.Name.Asc)
  .ToList;
```

Prefer typed expressions over magic-string query construction.

## Golden Pattern 06 — Exact Decimal Finance

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

For exact values with scale beyond Currency's 4 decimal places, keep TBcd precision through ORM read, parameter binding and serialization. Firebird 5 schemas may legitimately use `NUMERIC(28,10)` / `DECIMAL(28,10)` where the domain requires it.

## Golden Pattern 07 — Normal Pipeline First, FastPath Selectively

```text
normal endpoint
  -> DI scope
  -> middleware
  -> model binding/validation
  -> ORM/domain objects
```

Use `MapFast`, `UseSql`, `IDextFastQuery`, direct UTF-8 streaming or specialized pooling only after identifying a hot path where those bypasses are justified.

## Golden Pattern 08 — Middleware as a Deliberate Pipeline

A production API typically composes concerns such as:

```text
exception handling
HTTP logging
forwarded headers / PathBase when proxied
security headers
CORS
rate limiting
compression/cache as appropriate
authentication/authorization
endpoints/controllers
Swagger in the intended environment
```

Order by semantics, not by copying one demo blindly.

## Golden Pattern 09 — Data API for Appropriate CRUD

Use metadata-driven Data API when the operation is genuinely CRUD-like.

Do not expose core accounting, payment, inventory reservation, authorization-sensitive or state-machine business operations as generic CRUD merely for convenience.

## Golden Pattern 10 — Verification Lives With the Example

For API examples, keep one or more of:

```text
.http request file
PowerShell integration script
Dext unit/integration tests
snapshot tests
WebApplicationFactory tests
```

A sample that compiles but is not exercised is weaker evidence for an AI agent.

## Golden Pattern 11 — Collections Match Ownership

```text
ORM results                -> IList<T>
DbContext-owned children   -> non-owning collection
immutable shared lookup    -> Frozen collection
producer/consumer          -> bounded IChannel<T>
expensive reusable object  -> TDextPool<T> + scoped lease
```

Ownership is part of the architecture, not an afterthought.

## Golden Pattern 12 — Realtime by Abstraction Level

```text
SSE         -> one-way server push
WebSocket   -> raw bidirectional protocol
Hubs        -> groups/broadcast/application realtime
```

Select the highest-level abstraction that satisfies the requirement.

## Golden Pattern 13 — Tiered Example Trust

```text
Tier A use-case     -> architecture/composition reference
Tier B feature demo -> API usage reference
Tier C low-level    -> internals/performance/protocol reference
```

When a Tier C example conflicts with normal application style, do not generalize the Tier C pattern.

## Golden Pattern 14 — Provider Isolation

Keep FireDAC/UniDAC/provider-specific code at driver/infrastructure boundaries. Do not contaminate Dext Core or domain/application layers with a provider dependency without a clear reason.

## Golden Pattern 15 — Source Verification Before Generation

Before emitting code with an exact attribute/overload/configuration method:

```text
1. locate symbol in pack index
2. read the matching official skill
3. inspect the current source signature
4. inspect nearest official example
5. generate code
```

This rule is especially important because Dext evolves rapidly.

## Golden Pattern 16 — Example Source Beats Example README

Official example README files can lag API evolution. Use README prose to understand intent, but use the current `.pas` source for exact syntax.

Observed case: `Web.DextStore/README.md` still names older controller attributes, while `DextStore.Controllers.pas` uses current `[ApiController]`, `[HttpGet]`, `[HttpPost]`, `[FromRoute]` and `[FromServices]` forms.

Agent rule:

```text
README -> intent
source  -> exact syntax
```

## Golden Pattern 17 — Scale Minimal APIs With Endpoint Modules

Small projects can map routes directly in Startup. Larger Minimal API projects should move route registration into focused endpoint units, as demonstrated by `Web.HelpDesk` and `Web.SalesSystem`.

```text
DPR
  -> Startup
      -> ConfigureServices
      -> Configure pipeline
      -> Register feature endpoints
```

This prevents Startup from becoming a monolithic route file and keeps transport code organized by feature.

## Golden Pattern 18 — Domain Rules Outside Transport

Tier A examples repeatedly separate business behavior from HTTP concerns:

```text
Server / Controllers / Endpoints
          ↓
       Services
          ↓
     Domain + Data
```

State transitions, SLA rules, stock/capacity validation, pricing/discount logic and similar domain behavior should remain testable without the web server.

## Golden Pattern 19 — Demo Security Is Not Production Security

Never generalize demonstration convenience into production defaults:

```text
hard-coded JWT secrets
AllowAnyOrigin
in-memory persistence
mock login tokens
```

Treat examples as API/composition references; apply production security configuration separately.
