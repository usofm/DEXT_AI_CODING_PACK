# Dext Framework — AI Coding Memory

> **Purpose:** High-signal, importable repository memory for AI coding agents working with `github.com/cesarliws/dext`.
>
> **Snapshot date:** 2026-08-12
>
> **Repository baseline:** `cesarliws/dext`, default branch `main`
>
> **Observed main HEAD:** `412ed29207d2d1dc5d4a259a7739a615aed0c626` (2026-08-11)
>
> **Recent-history audit window:** 2026-07-31 through 2026-08-11 (30 most recent commits reviewed)
>
> **Status at snapshot:** Dext Framework v1 Release Candidate (RC2)
>
> **Primary language:** Delphi / Object Pascal
>
> **Primary architectural inspiration:** ASP.NET Core + Entity Framework Core concepts adapted to native Delphi.
>
> **License:** Apache 2.0 (verify repository LICENSE if legal precision is needed).

---

## 0. How an AI Agent Must Use This Memory

This file is a **working memory**, not a replacement for the source tree.

When generating or modifying Dext code:

1. Treat the **source code under `Sources/` as the final authority**.
2. Treat `Docs/skills/` as the highest-value AI-oriented documentation.
3. Treat `Docs/Book/` as the human-oriented canonical guide.
4. Treat `Docs/Specs/` and roadmap/spec documents as design intent; distinguish implemented behavior from planned behavior.
5. Treat Cesar Romero's technical articles as architectural explanation and motivation, not as a substitute for current signatures.
6. Before inventing a utility, search `Dext.Core` and `Dext.Common`.
7. Before changing a subsystem, search its Dext skill file and implementation unit.
8. Prefer idiomatic Dext APIs over standard Delphi infrastructure when Dext already provides the abstraction.
9. If a code example conflicts with current source, current source wins.
10. When working against a newer commit than this memory, re-check changed public APIs.

### Priority of truth

Use this precedence:

`current source code`  
→ `current tests`  
→ `Docs/skills`  
→ `Docs/Book`  
→ `Docs/Features_Implemented_Index.md`  
→ `Docs/Specs`  
→ `Examples`  
→ `README`  
→ `articles / blog posts`  
→ `old snippets / external discussions`

---

# 1. Mental Model: What Dext Is

Dext is not merely a web framework and not merely an ORM.

It is an **integrated native Delphi application ecosystem** intended to provide modern enterprise patterns without forcing a migration from Object Pascal to .NET/Java/Go.

Its architectural pillars include:

- Dependency Injection
- Reflection and metadata caching
- Smart types and expression trees
- ORM / DbContext / DbSet
- Fluent Query
- Unit of Work and change tracking
- Web application hosting
- Minimal APIs
- Controllers
- Middleware pipeline
- Model binding
- Validation
- Database-as-API / zero-controller CRUD exposure
- JWT authentication and authorization
- Configuration + Options pattern
- Async/task abstraction
- REST client
- Resilience policies
- Structured logging
- Metrics / tracing / telemetry
- OpenAPI / Swagger
- WebSockets / Hubs / real-time
- Server-Sent Events
- HTTP/2 support
- native TLS/SSL infrastructure
- gRPC / Protobuf-oriented networking
- MessagePack support for real-time protocols
- MCP server integration for AI agents
- VCL-compatible EntityDataSet and design-time tooling
- desktop navigation / MVVM-oriented UI abstractions
- testing, mocks, fluent assertions, integration testing
- optimized collections and memory primitives
- high-performance zero-allocation hot paths

Dext intentionally attempts to bring the *developer experience* of modern ecosystems to Delphi while retaining native compilation, low startup overhead, and Delphi interoperability.

---

# 2. Repository Top-Level Architecture

Core source areas observed under `Sources/` include:

```text
Sources/
  AI/
  Common/
  Core/
  Dashboard/
  Data/
  Debug/
  Design/
  Events/
  Hosting/
  Hubs/
  Net/
  Performance/
  Server/
  Testing/
  UI/
  Web/
```

Think of the layers roughly as follows.

## `Sources/Core`

Foundational primitives shared across nearly everything:

- reflection / RTTI caching
- DI
- activation
- JSON
- configuration
- options
- UUID / nullable / lazy types
- smart properties
- expression trees
- value conversion
- Span / memory utilities
- threading infrastructure
- common abstractions

**Agent rule:** Do not create local one-off infrastructure before checking Core.

## `Sources/Data`

Database / ORM stack:

- DbContext
- DbSet / entity sets
- mapping
- provider abstractions
- query expression translation
- change tracking
- transactions
- migrations
- relationships
- stored procedure / command abstractions
- database dialects/providers

## `Sources/Web`

Application-facing web framework:

- routing
- Minimal APIs
- controller conventions
- result types
- model binding
- middleware
- CORS
- auth hooks
- OpenAPI integration
- HTTP feature layers
- anti-forgery
- forwarded headers
- feature flags integration

## `Sources/Server`

HTTP server engine / low-level serving infrastructure.

## `Sources/Net`

Outbound networking and modern protocol support:

- REST client
- connection pooling
- TLS/security
- protocol utilities
- possibly HTTP parser and advanced transport features

## `Sources/Hubs`

Real-time abstractions resembling SignalR-style hubs.

## `Sources/Events`

In-process event bus / mediator-inspired messaging.

## `Sources/Testing`

Dext-native test framework, mocking, assertions, fixtures, integration helpers.

## `Sources/UI`

Desktop/UI architecture, navigation and binding abstractions.

## `Sources/Design`

Delphi IDE design-time integrations.

## `Sources/Dashboard`

Native developer / telemetry dashboard functionality.

## `Sources/AI`

AI integration, including MCP-oriented components.

## `Sources/Performance`

Performance-specific implementation/support/benchmark-oriented primitives.

---

# 3. Official AI-Specific Repository Guidance

Dext explicitly maintains AI-agent guidance.

Important files:

```text
Docs/CONTRIBUTING_AI.md
Docs/skills/README.md
Docs/skills/dext-app-structure.md
Docs/skills/dext-web.md
Docs/skills/dext-orm.md
Docs/skills/dext-orm-advanced.md
Docs/skills/dext-di.md
Docs/skills/dext-auth.md
Docs/skills/dext-testing.md
Docs/skills/dext-collections.md
Docs/skills/dext-json.md
Docs/skills/dext-api-features.md
Docs/skills/dext-validation.md
Docs/skills/dext-background.md
Docs/skills/dext-networking.md
Docs/skills/dext-logging.md
Docs/skills/dext-resilience.md
Docs/skills/dext-realtime.md
Docs/skills/dext-database-as-api.md
Docs/skills/dext-desktop-ui.md
Docs/skills/dext-server-adapters.md
Docs/skills/dext-mcp.md
Docs/skills/dext-symbols.md
```

### Agent behavior specified by Dext

When contributing:

- check existing Knowledge Items / specs first
- verify a utility does not already exist
- draft a plan
- use TDD first for framework changes
- update bilingual docs where applicable
- avoid local filesystem paths in code/commits
- update human docs (`Docs/Book`)
- update AI docs (`Docs/skills`)

### Forbidden / discouraged conventions from Dext AI guidance

- Do **not** use `L` prefix for local variables.
- Prefer modern inline local variables when supported rather than old-style giant `var` sections.
- Do not manually `Free` objects whose lifetime is controlled by DI/scope.
- Avoid duplication of Core/Common utilities.

---

# 4. Critical Global Dext Rules

These are high-impact rules an AI coding agent should remember.

## 4.1 Route syntax

Correct:

```pascal
'/users/{id}'
```

Not:

```pascal
'/users/:id'
```

Controller route templates that represent a sub-route should begin with `/`.

Correct:

```pascal
[HttpGet('/{id}')]
```

## 4.2 Controller method name conflict

Do **not** name a controller action `Create`.

`Create` is semantically reserved for Delphi constructors and causes ambiguity / bad style.

Prefer:

```pascal
CreateUser
CreateOrder
RegisterCustomer
AddProduct
```

## 4.3 Dependency injection

Do not service-locate from request context when typed injection is available.

Avoid:

```pascal
Ctx.RequestServices.GetService<IMyService>
```

Prefer constructor injection, endpoint generic injection, or supported Dext DI binding.

## 4.4 ORM collections

Do not default to `TObjectList<T>` for Dext ORM result APIs.

Prefer Dext collections:

```pascal
IList<T>
```

## 4.5 Length validation

Prefer:

```pascal
[MaxLength(100)]
```

Do not assume `[StringLength]` is the Dext idiom.

## 4.6 Nullable types

Use:

```pascal
Nullable<T>
```

For entity smart-property nullable columns, current guidance prefers composition in the form:

```pascal
Prop<Nullable<T>>
```

rather than the legacy inverted form:

```pascal
Nullable<Prop<T>>
```

or aliases that create the same legacy structure.

## 4.7 DbContext pooling

For Web API workloads, prefer pooled DbContext configuration:

```pascal
.WithPooling(True)
```

unless a concrete reason requires otherwise.

## 4.8 Detached entity update

Before saving a detached entity, explicitly attach/update according to Dext semantics:

```pascal
Context.Update(Entity);
Context.SaveChanges;
```

Do not assume EF-style implicit tracking of a detached object.

## 4.9 Mocks

`Mock<T>` is a record in Dext's mocking approach.

Do not call:

```pascal
Mock.Free;
```

## 4.10 Required ORM unit

If `IDbSet<T>` generics are unresolved, verify:

```pascal
Dext.Entity.Core
```

is in the `uses` list.

## 4.11 Console projects

Dext guidance requires `SetConsoleCharSet` in console/test/CLI applications where relevant for proper character handling.

## 4.12 Uses-clause ordering

Because Delphi permits only one active class helper for a type, helper visibility can depend on unit order.

Dext AI guidance says the important order is:

```pascal
Dext,
Dext.Entity,
Dext.Web
```

The last applicable helper wins, keeping Web extension methods visible.

Do not casually reorder these units.

## 4.13 HTTP QUERY method

Dext supports the standardized HTTP `QUERY` method.

Relevant APIs include concepts such as:

```pascal
MapQuery
TRestClient.Query
AcceptsQuery
```

When documenting/querying OPTIONS behavior, account for `Accept-Query`.

---

# 5. Core Type System and Smart Properties

One of the most important ideas in Dext is that entities and queries can be strongly typed without manually constructing SQL strings.

## 5.1 Smart property aliases

Prefer semantic aliases such as:

```pascal
IntType
Int64Type
StringType
BoolType
FloatType
CurrencyType
DateTimeType
DateType
TimeType
```

These are conceptually based on `Prop<T>`.

Example:

```pascal
type
  [Table]
  TProduct = class
  private
    FId: IntType;
    FName: StringType;
    FPrice: CurrencyType;
  public
    [PK, AutoInc]
    property Id: IntType read FId write FId;

    [Required, MaxLength(150)]
    property Name: StringType read FName write FName;

    property Price: CurrencyType read FPrice write FPrice;
  end;
```

## 5.2 Dual-mode expression behavior

`Prop<T>` is central to Fluent Query.

Conceptually it can work in:

1. runtime/value mode
2. query/expression mode

Operators such as:

```pascal
=
<>
>
>=
<
<=
+
-
*
/
and
or
not
```

can build an AST instead of immediately computing a regular Pascal value.

This enables expressions like:

```pascal
var P := Prototype.Entity<TProduct>;

var Items := Context.Entities<TProduct>
  .Where((P.Price > 100) and P.Name.Contains('Pro'))
  .OrderBy(P.Name.Asc)
  .Take(50)
  .ToList;
```

The AI must understand that `P.Price > 100` is *not ordinary business logic* in this context; it is building a database query expression.

---
