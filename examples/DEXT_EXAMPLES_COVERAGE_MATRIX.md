# DEXT EXAMPLES COVERAGE MATRIX

> Official source: `cesarliws/dext/Examples`
> Snapshot: 2026-08-12
> Purpose: tell an AI agent which example to inspect, how much to trust it, and which audit file explains it.

## Coverage Summary

The current official `Examples/` tree contains 8 top-level example groups audited by this pack:

```text
01-Basics
02-Web
03-Data
04-Advanced
05-UI
07-UseCases
08-AI
09-ActiveArchitecture
```

Directory-level examples catalogued: **50**.

Trust levels used here:

```text
A  = architecture/reference application; useful for composition and boundaries
B  = focused feature/integration reference; useful for API usage
C  = low-level/protocol/performance/internal reference; do not generalize to normal apps
```

Audit confidence:

```text
Deep       = source/README or key units inspected and patterns extracted
Group      = inspected as part of a group audit; enough for routing/classification
Catalogued = indexed/classified, but exact API syntax must be re-opened before generation
```

---

# 01-Basics

| Example | Tier | Coverage | Primary Use | Audit |
|---|---:|---|---|---|
| `Core.LoggingDemo` | B | Deep | async logging, scopes, RingBuffer, multi-thread producers | `DEXT_01_BASICS_DEEP_AUDIT.md` |
| `Core.TestConfig` | B | Deep | configuration providers, hierarchy, precedence, environment variables | `DEXT_01_BASICS_DEEP_AUDIT.md` |

---

# 02-Web

| Example | Tier | Coverage | Primary Use | Drift / Caution |
|---|---:|---|---|---|
| `Web.BasicAuthDemo` | B | Deep | Basic Auth + `RequireAuthorization` | demo credentials only |
| `Web.CachingDemo` | B | Deep | response caching, vary-by-query | supplement with current auth/private cache hardening |
| `Web.ControllerExample` | B | Deep | controllers, binding, DI, filters, serialization | contains `[StringLength]`; current critical rule prefers `[MaxLength]` |
| `Web.Http2Framing` | C | Group | HTTP/2 framing/protocol internals | never use as normal endpoint architecture |
| `Web.JwtAuthDemo` | B | Deep | JWT, claims, RBAC | demo secrets/credentials only |
| `Web.MinimalAPI` | B | Deep | request/response mechanics, basic routing | manual request service resolution is legacy vs current typed injection guidance |
| `Web.NativeServer` | B/C | Deep | selecting native server engine | host concern, not business-layer pattern |
| `Web.RateLimitDemo` | B | Deep | fixed-window rate limiting | README uses older `X-RateLimit-*`; current middleware uses newer `RateLimit-*` semantics |
| `Web.SslDemo` | B | Deep | http.sys/SChannel vs socket/OpenSSL TLS | engine-specific deployment details |
| `Web.SwaggerControllerExample` | B | Group | Controller OpenAPI/Swagger | verify exact current attributes |
| `Web.SwaggerExample` | B | Deep | Minimal API OpenAPI fluent metadata | verify exact current fluent overloads |
| `Web.TUUIDBindingExample` | B | Deep | typed TUUID route/body binding | strong web identifier reference |
| `Web.UUIDExample` | B | Group | UUID/TGUID general usage | use TUUIDBinding example for web binding questions |

Primary audit: `DEXT_02_WEB_DEEP_AUDIT.md`.

---

# 03-Data

| Example | Tier | Coverage | Primary Use | Caution |
|---|---:|---|---|---|
| `Dext.Examples.ComplexQuerying` | B | Deep | advanced search/report/query composition | don't generalize in-memory filtering when SQL can do it |
| `Dext.Examples.MultiTenancy` | A/B | Deep | tenant-column isolation, tenant middleware | tenant identity is a security boundary |
| `Orm.EntityDemo` | B | Group | CRUD, navigation, relationships, tracking | use current source for exact APIs |
| `Orm.EntityStyles` | A/B | Deep | Classic entity vs Smart Entity design | both styles are legitimate |
| `Orm.Specification` | B | Deep | reusable composable query criteria | README may use weaker string-style expressions |
| `Web.DatabaseAsApi` | B | Deep | metadata-driven CRUD | not for invariant-heavy domain commands; overload drift possible |
| `Web.FastPath.OrmPool` | C | Deep | DbContext pool + MapFast + direct streaming | manual Acquire/Release lags newer `AcquireScoped` API |
| `Web.SmartPropsDemo` | B | Group/Deep | Smart Property typed queries | combine with EntityStyles audit |

Primary audit: `DEXT_03_DATA_DEEP_AUDIT.md`.

---

# 04-Advanced

| Example | Tier | Coverage | Primary Use | Caution |
|---|---:|---|---|---|
| `Core.TestHttpParser` | C | Group | HTTP parser internals/testing | framework-internal reference only |
| `Grpc.EntityDataSet.Demo` | B/C | Group | gRPC + dataset bridge | integration-specific |
| `Hubs` | B | Deep | realtime Hubs, methods, groups, broadcast | use over raw WebSocket for app-level hub semantics |
| `MCP.FullDemo` | B/A | Deep | MCP Tools, Resources, Prompts, transports | primary MCP feature reference |
| `MCP.VclDbDemo` | B/C | Group | MCP + VCL/database integration | security boundary required |
| `Net.RestClient.Demo` | B | Deep | fluent REST client, records, async/cancel | TRestClient is record/interface wrapper; no manual Free |
| `WebStencilsDemo` | B | Deep | server-rendered views/templates + ORM | preserve conditional feature define |

Primary audit: `DEXT_04_ADVANCED_DEEP_AUDIT.md`.

---

# 05-UI

| Example | Tier | Coverage | Primary Use | Caution |
|---|---:|---|---|---|
| `Desktop.MVU.Counter` | B | Deep | immutable Model-View-Update state flow | don't casually mix with mutable MVVM state |
| `Desktop.MVU.CounterFrame` | B | Group | component/frame-scoped MVU | useful for localized state architecture |
| `Desktop.MVVM.CustomerCRUD` | A | Deep | business VCL app, feature folders, ViewModel/Controller, Navigator, binding | strongest business desktop reference |
| `VCLMemoLog` | B | Group | VCL logging sink/control integration | not a whole-app architecture reference |

Primary audit: `DEXT_05_UI_DEEP_AUDIT.md`.

---

# 07-UseCases

| Example | Tier | Coverage | Primary Use | Audit / Caution |
|---|---:|---|---|---|
| `Core.EventBusDemo` | B | Deep | Event Bus, handlers, behaviors, typed publishers, tracker testing | supplemental audit |
| `Web.AirFlow` | A/B | Deep | Hubs + simulator/background realtime producer | raw thread lifecycle is demo-specific; production hosted service may be better |
| `Web.Dext.Starter.Admin` | A | Deep | vertical slices, HTMX, Tailwind, server-driven admin UI | demo secrets; strong full-stack reference |
| `Web.DextStore` | A | Deep | Controller/service business API | README controller syntax is stale; source is current |
| `Web.EventBusDemo` | B | Deep | scoped Event Bus in HTTP requests | helper collision/unit-isolation lesson |
| `Web.EventHub` | A | Deep | event-management business domain/state rules | name is NOT Dext realtime Hubs |
| `Web.FoodDelivery` | A | Deep | mixed Minimal API + Controllers + ORM + middleware + Data API | strong composition reference |
| `Web.HelpDesk` | A | Deep | layered Minimal API, state machine, tests | strong production-like reference |
| `Web.OrderAPI` | A/B | Deep | DMVC-to-Dext migration | README uses legacy Dext controller attributes |
| `Web.SalesSystem` | A | Deep | layered Minimal API sales/domain system | strong endpoint-module reference |
| `Web.StreamingDemo` | B | Deep | multipart upload and streamed download | README contains legacy `:name` route syntax |
| `Web.TaskFlowAPI` | B/A | Deep | hybrid Minimal API + Controllers, typed handler DI | strong modern Minimal API DI reference |
| `Web.TicketSales` | A | Deep | Controller + domain rules + tests | strong state/business-rule reference |

Primary audits:

- `DEXT_TIER_A_DEEP_AUDIT.md`
- `DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md`

---

# 08-AI

| Example | Tier | Coverage | Primary Use | Caution |
|---|---:|---|---|---|
| `DextGemini` | B | Deep | typed AI provider options, RestClient, JSON DTO boundary | focused provider demo, not complete agent architecture |

Primary audit: `DEXT_08_AI_DEEP_AUDIT.md`.

---

# 09-ActiveArchitecture

| Example | Tier | Coverage | Primary Use | Caution |
|---|---:|---|---|---|
| `Desktop.BasicActiveArchitecture.Demo` | A | Deep | Domain/Infra/Presentation, desktop DI composition root | don't turn global provider into Service Locator |
| `Desktop.EntityDataSet.Demo` | B | Group | TDataSet-compatible entity/data UI bridge, master-detail | business rules stay outside dataset events |

Primary audit: `DEXT_09_ACTIVE_ARCHITECTURE_DEEP_AUDIT.md`.

---

# Master Routing by Requirement

```text
Configuration                -> Core.TestConfig
Logging                      -> Core.LoggingDemo
Minimal API basics           -> Web.MinimalAPI (mechanics only)
Modern typed Minimal API DI  -> Web.TaskFlowAPI
Controllers                  -> Web.ControllerExample / Web.TicketSales
JWT                           -> Web.JwtAuthDemo + Tier-A apps
Basic Auth                    -> Web.BasicAuthDemo
Swagger Minimal API          -> Web.SwaggerExample
Swagger Controller           -> Web.SwaggerControllerExample
Caching                      -> Web.CachingDemo
Rate Limit                   -> Web.RateLimitDemo
TLS/HTTPS                    -> Web.SslDemo
Native server                -> Web.NativeServer
TUUID binding                -> Web.TUUIDBindingExample
ORM entity style             -> Orm.EntityStyles
ORM relationships            -> Orm.EntityDemo
Specifications               -> Orm.Specification
Complex querying             -> ComplexQuerying
Multi-tenancy                -> Dext.Examples.MultiTenancy
Data API                     -> Web.DatabaseAsApi
FastPath ORM                 -> Web.FastPath.OrmPool
REST client                  -> Net.RestClient.Demo
Hubs                         -> 04-Advanced/Hubs
MCP                          -> MCP.FullDemo
Server-rendered views        -> WebStencilsDemo
VCL MVVM                     -> Desktop.MVVM.CustomerCRUD
MVU                           -> Desktop.MVU.Counter
Active Architecture          -> Desktop.BasicActiveArchitecture.Demo
EntityDataSet                -> Desktop.EntityDataSet.Demo
Event Bus core               -> Core.EventBusDemo
Scoped Web Event Bus         -> Web.EventBusDemo
HTMX admin                   -> Web.Dext.Starter.Admin
Realtime control dashboard   -> Web.AirFlow
File upload/download         -> Web.StreamingDemo
DMVC migration               -> Web.OrderAPI
Direct AI provider           -> DextGemini
```

---

# AI Trust Algorithm

When the agent finds a candidate example:

```text
1. identify Tier and audit status here
2. read the relevant deep-audit file
3. inspect current example .pas source
4. compare with repository-wide current Critical Rules
5. inspect current Dext source/skill for exact signature
6. only then generate production code
```

The examples are an executable knowledge base, but they are versioned examples and can lag a newer framework commit.
