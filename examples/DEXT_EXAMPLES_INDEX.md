# DEXT EXAMPLES INDEX

> Curated map of the official Dext `Examples/` tree for AI coding agents.

## Tier model

- **Tier A — Architecture Reference:** complete/use-case projects suitable for studying application composition.
- **Tier B — Feature Reference:** focused examples for one subsystem or feature.
- **Tier C — Low-Level / Experimental:** protocol, parser, benchmark, transport, or engine-oriented examples; do not copy as normal app architecture.

## 01-Basics

### Tier B

- `Core.LoggingDemo` — core logging registration and usage.
- `Core.TestConfig` — configuration/testing-oriented core setup.

## 02-Web

### Tier B

- `Web.BasicAuthDemo` — Basic authentication.
- `Web.CachingDemo` — response caching.
- `Web.ControllerExample` — attribute/controller routing and DI.
- `Web.JwtAuthDemo` — JWT and authorization.
- `Web.MinimalAPI` — Minimal API routing.
- `Web.RateLimitDemo` — rate limiting and headers.
- `Web.SslDemo` — HTTPS/TLS setup.
- `Web.SwaggerControllerExample` — controller OpenAPI/Swagger.
- `Web.SwaggerExample` — Minimal API OpenAPI/Swagger.
- `Web.TUUIDBindingExample` — TUUID model/route binding.
- `Web.UUIDExample` — UUID usage.

### Tier C

- `Web.Http2Framing` — low-level HTTP/2 framing/protocol work.
- `Web.NativeServer` — native server engine internals / adapter behavior.

## 03-Data

### Tier B

- `Dext.Examples.ComplexQuerying` — advanced query composition.
- `Dext.Examples.MultiTenancy` — multi-tenancy patterns.
- `Orm.EntityDemo` — broad ORM CRUD, navigation and relationship coverage.
- `Orm.EntityStyles` — alternative entity modeling styles.
- `Orm.Specification` — Specification pattern.
- `Web.DatabaseAsApi` — metadata-driven CRUD API.
- `Web.SmartPropsDemo` — Smart Properties and typed query expressions.

### Tier C / Performance Reference

- `Web.FastPath.OrmPool` — FastPath + DbContext/object pooling; use only for measured hot paths.

## 04-Advanced

### Tier B

- `Grpc.EntityDataSet.Demo` — gRPC + EntityDataSet integration.
- `Hubs` — real-time Hubs/WebSocket patterns.
- `MCP.FullDemo` — full MCP server/tool/resource workflow.
- `MCP.VclDbDemo` — MCP + VCL/database integration.
- `Net.RestClient.Demo` — outbound REST client patterns.
- `WebStencilsDemo` — Web Stencils integration.

### Tier C

- `Core.TestHttpParser` — HTTP parser internals/testing.

## 05-UI

### Tier B

- `Desktop.MVU.Counter` — MVU pattern basics.
- `Desktop.MVU.CounterFrame` — MVU with frame composition.
- `Desktop.MVVM.CustomerCRUD` — MVVM CRUD architecture.
- `VCLMemoLog` — VCL logging sink/UI integration.

## 07-UseCases

### Tier A — Primary architecture references

- `Web.Dext.Starter.Admin` — starter/admin application composition.
- `Web.DextStore` — e-commerce/domain services/controllers/migrations/testing.
- `Web.FoodDelivery` — typed DbContext, DI services, controllers, Minimal APIs, rate limiting, caching, CORS, Data API, Swagger and integration tests.
- `Web.HelpDesk` — ticket/helpdesk domain modeling and API composition.
- `Web.OrderAPI` — order-focused business API.
- `Web.SalesSystem` — sales/domain orchestration and layered architecture.
- `Web.TaskFlowAPI` — hybrid routing/workflow API.
- `Web.TicketSales` — ticket/event business rules and concurrency-oriented domain flow.

### Tier B

- `Core.EventBusDemo` — core event bus.
- `Web.EventBusDemo` — event bus in Web application.
- `Web.EventHub` — event streaming/realtime use case.
- `Web.StreamingDemo` — upload/download streaming.
- `Web.AirFlow` — workflow/airflow-oriented use case.

## 08-AI

### Tier B

- `DextGemini` — AI/Gemini integration example.

## 09-ActiveArchitecture

### Tier B

- `Desktop.BasicActiveArchitecture.Demo` — Active Architecture desktop pattern.
- `Desktop.EntityDataSet.Demo` — EntityDataSet desktop integration.

## Agent usage rule

When a feature has both a Tier A use-case and a Tier B demo:

1. use Tier B to understand the isolated API,
2. use Tier A to understand how it belongs in a real application,
3. verify exact signatures in current source.

Never promote a Tier C low-level sample into a general application pattern without a measured reason.
