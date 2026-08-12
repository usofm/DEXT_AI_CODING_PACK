# DEXT EXAMPLE CROSS REFERENCE

> Feature/API → best official example(s) to inspect before generating code.
> Full coverage and drift status: see `DEXT_EXAMPLES_COVERAGE_MATRIX.md` and `DEXT_EXAMPLE_DRIFT_REGISTER.md`.

| Feature / API | Primary example | Secondary example / note |
|---|---|---|
| Configuration | `Examples/01-Basics/Core.TestConfig` | typed Options in `Examples/08-AI/DextGemini` |
| Async/structured logging | `Examples/01-Basics/Core.LoggingDemo` | VCL sink: `Examples/05-UI/VCLMemoLog` |
| Minimal API mechanics | `Examples/02-Web/Web.MinimalAPI` | DI style is older; prefer TaskFlow for current typed injection |
| Modern typed Minimal API DI | `Examples/07-UseCases/Web.TaskFlowAPI` | `Web.EventHub`, `Web.FoodDelivery` |
| Hybrid Minimal API + Controllers | `Examples/07-UseCases/Web.TaskFlowAPI` | `Web.FoodDelivery` |
| Controllers | `Examples/02-Web/Web.ControllerExample` | architecture-grade: `Web.TicketSales` |
| Action filters | `Examples/02-Web/Web.ControllerExample` | — |
| JWT / `[Authorize]` | `Examples/02-Web/Web.JwtAuthDemo` | `Web.TicketSales`, `Web.HelpDesk` |
| Basic Auth | `Examples/02-Web/Web.BasicAuthDemo` | migration use case: `Web.OrderAPI` |
| Response caching | `Examples/02-Web/Web.CachingDemo` | `Web.FoodDelivery`; apply current private/auth safety rules |
| Rate limiting | `Examples/02-Web/Web.RateLimitDemo` | `Web.FoodDelivery`; verify current RFC 9333 headers |
| SSL / HTTPS | `Examples/02-Web/Web.SslDemo` | — |
| Native server | `Examples/02-Web/Web.NativeServer` | Tier B/C hosting reference |
| Swagger Minimal API | `Examples/02-Web/Web.SwaggerExample` | `Web.FoodDelivery` |
| Swagger Controllers | `Examples/02-Web/Web.SwaggerControllerExample` | `Web.TicketSales` |
| TUUID web binding | `Examples/02-Web/Web.TUUIDBindingExample` | `Web.UUIDExample` for general UUID usage |
| HTTP/2 framing | `Examples/02-Web/Web.Http2Framing` | Tier C only |
| ORM CRUD / relations | `Examples/03-Data/Orm.EntityDemo` | `Web.HelpDesk` / `Web.TicketSales` |
| Classic vs Smart entity style | `Examples/03-Data/Orm.EntityStyles` | — |
| `TEntityType<T>` | `Examples/03-Data/Orm.EntityStyles` | classic-model typed queries |
| Smart Properties | `Examples/03-Data/Web.SmartPropsDemo` | `Orm.EntityStyles`, `Web.EventHub` |
| Specification pattern | `Examples/03-Data/Orm.Specification` | `Dext.Examples.ComplexQuerying` |
| Complex querying/reporting | `Examples/03-Data/Dext.Examples.ComplexQuerying` | `Web.SalesSystem` |
| Multi-tenancy | `Examples/03-Data/Dext.Examples.MultiTenancy` | tenant identity must be verified in production |
| Database-as-API | `Examples/03-Data/Web.DatabaseAsApi` | `Web.FoodDelivery` |
| FastPath + ORM pool | `Examples/03-Data/Web.FastPath.OrmPool` | prefer newer `AcquireScoped` when current API provides it |
| REST client | `Examples/04-Advanced/Net.RestClient.Demo` | AI provider use: `Examples/08-AI/DextGemini` |
| Hubs / realtime groups | `Examples/04-Advanced/Hubs` | real use case: `Examples/07-UseCases/Web.AirFlow` |
| Server-side Hub broadcast | `Examples/07-UseCases/Web.AirFlow` | `04-Advanced/Hubs` |
| MCP | `Examples/04-Advanced/MCP.FullDemo` | VCL/DB integration: `MCP.VclDbDemo` |
| gRPC + EntityDataSet | `Examples/04-Advanced/Grpc.EntityDataSet.Demo` | desktop dataset: `09-ActiveArchitecture/Desktop.EntityDataSet.Demo` |
| Server-rendered view engine | `Examples/04-Advanced/WebStencilsDemo` | HTMX full-stack: `Web.Dext.Starter.Admin` |
| HTMX / vertical-slice admin | `Examples/07-UseCases/Web.Dext.Starter.Admin` | WebStencils for template-engine variant |
| MVVM desktop CRUD | `Examples/05-UI/Desktop.MVVM.CustomerCRUD` | — |
| Navigator / Magic Binding | `Examples/05-UI/Desktop.MVVM.CustomerCRUD` | — |
| MVU | `Examples/05-UI/Desktop.MVU.Counter` | `Desktop.MVU.CounterFrame` |
| Active Architecture | `Examples/09-ActiveArchitecture/Desktop.BasicActiveArchitecture.Demo` | MVVM example for feature-folder alternative |
| EntityDataSet desktop | `Examples/09-ActiveArchitecture/Desktop.EntityDataSet.Demo` | gRPC dataset integration in 04-Advanced |
| Event Bus core | `Examples/07-UseCases/Core.EventBusDemo` | — |
| Scoped Event Bus in Web | `Examples/07-UseCases/Web.EventBusDemo` | same request scope / DbContext |
| Event Bus testing | `Examples/07-UseCases/Core.EventBusDemo` | `TEventBusTracker` |
| File upload/download | `Examples/07-UseCases/Web.StreamingDemo` | use brace route syntax, not README colon routes |
| Full API composition | `Examples/07-UseCases/Web.FoodDelivery` | `Web.HelpDesk`, `Web.TicketSales` |
| Domain state machine / SLA | `Examples/07-UseCases/Web.HelpDesk` | `Web.TicketSales`, `Web.EventHub` |
| Ticket stock/capacity rules | `Examples/07-UseCases/Web.TicketSales` | — |
| Event-registration/waitlist rules | `Examples/07-UseCases/Web.EventHub` | this is a business app, NOT Dext Hubs |
| Sales/business orchestration | `Examples/07-UseCases/Web.SalesSystem` | `Web.OrderAPI` |
| DMVC migration | `Examples/07-UseCases/Web.OrderAPI` | README has legacy controller attributes |
| Realtime telemetry/control dashboard | `Examples/07-UseCases/Web.AirFlow` | Hubs reference in 04-Advanced |
| AI / Gemini provider | `Examples/08-AI/DextGemini` | MCP is a different agent/tool protocol concern |

## Agent rule

For a feature implementation:

```text
1. locate the feature here
2. inspect Coverage Matrix / Drift Register
3. read one focused Tier B example
4. when available, read one Tier A use-case
5. use README for intent
6. use current .pas source for example syntax
7. verify exact API against current Dext source/skill
8. generate code
```

Focused examples teach isolated APIs; Tier A examples teach composition, ownership, DI, domain boundaries, startup, middleware and testing.
