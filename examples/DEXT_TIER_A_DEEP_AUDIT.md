# DEXT TIER A DEEP AUDIT

> Deep audit of the most architecture-relevant official Dext examples.
>
> Goal: distinguish stable application patterns from stale README text, demo-only shortcuts, and lower-level experiments.

## Trust Model

Use this order when an example's README and code disagree:

```text
current source code
> repository-wide critical rules
> finalized specs / current skills
> example README
```

A README is documentation evidence; the current `.pas` files are implementation evidence.

---

## 1. Web.FoodDelivery — Tier A / High Trust

### Why it is important

`Web.FoodDelivery` is a compact but broad composition example. Its Startup shows multiple Dext subsystems working together in one application.

Observed structure:

```text
DextFood.Domain.pas
DextFood.Services.pas
DextFood.DbSeeder.pas
DextFood.Startup.pas
Web.DextFood.dpr
DextFood.http
Test.Web.FoodDelivery.ps1
```

### Confirmed patterns

- `TStartup = class(TInterfacedObject, IStartup)`
- `ConfigureServices` as DI/persistence composition root
- `Configure` as HTTP pipeline / endpoint composition root
- typed `TDbContext`
- `IDbSet<T>` accessor implemented with `Entities<T>`
- explicit `Dext.Entity.Core` import for `IDbSet<T>`
- business services registered through DI
- Controllers and Minimal APIs can coexist
- typed endpoint DI
- Smart Property query via `Prototype.Entity<T>`
- rate limiting
- response caching
- CORS
- global JSON policy
- Data API mapping
- Swagger
- request-level `.http` / PowerShell verification

### Golden use

Use this example when the agent needs a compact reference for:

```text
Startup
DbContext
DI
Minimal API
Controllers
Smart Properties
Data API
middleware composition
Swagger
```

### Caution

Do not copy `AllowAnyOrigin` blindly into production. CORS must match the actual deployment threat model.

---

## 2. Web.HelpDesk — Tier A / Very High Trust for Layering

### Why it is important

`Web.HelpDesk` is one of the clearest architecture examples because its project structure explicitly separates:

```text
Server/
Domain/
Data/
Services/
Tests/
```

The README describes a real domain with:

```text
SLA rules
state transitions
role/access rules
metrics
JSON columns
```

### Confirmed architecture

```text
Server/
  Web.HelpDesk.dpr
  HelpDesk.Startup.pas
  HelpDesk.Endpoints.pas
Domain/
  Enums
  Entities
  Models/DTOs
Data/
  DbContext
  Seeder
Services/
  business services
Tests/
  entity tests
  service tests
```

### Dext capabilities demonstrated

- Minimal API
- Smart Properties
- JSON columns
- `TDbContext`
- `IDbSet<T>`
- `EnsureCreated`
- `[Required]`
- `[MaxLength]`
- `Mock<IUserService>`
- `Arg.Any<T>`
- non-owning entity collections (`OwnsObjects=False` semantics)

### Golden use

Prefer `Web.HelpDesk` when the agent needs guidance for:

```text
feature/layer separation
business rules outside endpoints
state-machine-like domain logic
DTO vs Entity separation
unit-testable services
JSON column usage
Minimal API with real domain rules
```

### Architectural lesson

A Dext application does not need to put all logic in endpoint lambdas. Use Minimal APIs as transport adapters and keep business behavior in services/domain code.

---

## 3. Web.DextStore — Tier A with Documentation Drift Warning

### Why it is useful

The project is a controller-oriented application with:

```text
Controllers
Services
Models
JWT
DI
Model Binding
integration scripts
```

### Important drift finding

The README still describes older attribute names such as:

```text
[DextController]
[DextGet]
[DextPost]
```

However, the current controller source uses the newer API:

```pascal
[ApiController('/api/auth')]
[HttpPost('/login')]
[AllowAnonymous]

[ApiController('/api/products')]
[HttpGet('')]
[HttpGet('/{id}')]
[FromRoute]
[FromServices]
[Authorize('Bearer')]
```

Therefore:

> Do not copy controller syntax from the DextStore README. Read `DextStore.Controllers.pas`.

### Startup patterns confirmed

- `AddSingleton<IJwtTokenHandler, TJwtTokenHandler>` with factory
- `AddTransient<IClaimsBuilder, TClaimsBuilder>`
- service registration through DI
- `AddControllers`
- `UseCors`
- `UseJwtAuthentication`
- health Minimal API
- `App.MapControllers`

### Golden use

Use current source from `Web.DextStore` for:

```text
Controller DI
JWT registration
[Authorize]
[AllowAnonymous]
[FromRoute]
[FromServices]
Model binding
Controller/service separation
```

### Caution

The example contains demo JWT secrets and in-memory persistence decisions. Never treat these as production security/storage defaults.

---

## 4. Web.SalesSystem — Tier A / Minimal API Architecture Reference

### Structure observed

```text
Data/
Domain/
Server/
Tests/
Test.Web.SalesSystem.ps1
```

Server contains:

```text
Sales.Auth.pas
Sales.Endpoints.pas
Sales.Startup.pas
Web.SalesSystem.Minimal.dpr
```

### Architectural significance

This is a stronger Minimal API reference than a tiny route demo because endpoint registration, auth, startup, domain and data concerns are separated into distinct units.

### Golden use

Use it when the agent needs:

```text
Minimal API at application scale
separate endpoint-registration unit
separate auth unit
Domain/Data/Server separation
API integration tests
```

### Pattern

```text
DPR
  -> Startup
      -> DI/persistence
      -> pipeline
      -> endpoint registration unit
```

This scales better than placing dozens of route declarations directly in the DPR or Startup.

---

## 5. Web.TicketSales — Tier A / Controller + Domain Rules Reference

### Why it is important

The README explicitly identifies this as a complete Controller-pattern API and documents non-trivial business rules.

Project structure:

```text
Server/
Domain/
Data/
Services/
Tests/
```

### Confirmed framework usage

- `[ApiController]`
- `[Route]`
- `TDbContext`
- entities
- scoped services
- JWT protection
- business-rule validation
- `Dext.Testing`

### Domain rules represented

```text
stock validation
customer discount eligibility
event availability
maximum tickets per order
order state flow
stock return on cancellation
```

### Golden use

Prefer this example for:

```text
Controller-based business APIs
Domain + Services layering
state transitions
stock/capacity rules
JWT-protected operations
unit tests around business rules
```

### Important operational pattern

The README explicitly advises against manual absolute source-path edits and describes a standardized build/environment workflow. This aligns with Dext's repository rule against local path pollution.

---

# Tier A Selection Matrix

| Need | Best Tier A Reference |
|---|---|
| Compact all-in-one composition | `Web.FoodDelivery` |
| Layered Minimal API | `Web.HelpDesk` |
| Controller + JWT | `Web.DextStore` current source |
| Large Minimal API organization | `Web.SalesSystem` |
| Controller + real domain rules | `Web.TicketSales` |

---

# New Golden Rules Derived From Deep Audit

## Rule A — Source beats README

Example documentation can lag API evolution. Before copying syntax:

```text
README -> identify intent
source  -> verify exact API
```

## Rule B — Separate endpoint registration as APIs grow

For larger Minimal API projects, prefer a dedicated endpoints unit rather than allowing Startup to become a giant route file.

## Rule C — Business rules belong outside transport code

Tier A examples repeatedly separate Domain/Services from Server/Controllers/Endpoints.

## Rule D — Tests are part of architecture evidence

Tier A examples commonly include both unit tests and request-level PowerShell verification. A pattern with tests carries more evidentiary weight than an isolated snippet.

## Rule E — Demo security values are never production defaults

Hard-coded JWT secrets, `AllowAnyOrigin`, and in-memory stores are demonstration conveniences. Do not generalize them to production.

## Rule F — Layering is flexible, not ceremonial

Small example:

```text
Domain + Services + Startup
```

Larger example:

```text
Domain + Data + Services + Server + Tests
```

Choose the smallest separation that keeps business logic reusable and testable.

---

# Recommended Agent Workflow for Tier A Examples

```text
Need architecture pattern
  -> DEXT_DECISION_TREE.md
  -> DEXT_EXAMPLE_CROSS_REFERENCE.md
  -> choose Tier A project
  -> inspect README for intent
  -> inspect actual .pas source for syntax
  -> verify current Dext skill/source
  -> generate code
```

Never generate exact Dext API syntax from README prose alone.
