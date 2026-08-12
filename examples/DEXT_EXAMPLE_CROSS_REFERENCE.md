# DEXT EXAMPLE CROSS REFERENCE

> Feature/API → best official example(s) to inspect before generating code.

| Feature / API | Primary example | Secondary example |
|---|---|---|
| `MapGet` / Minimal API | `Examples/02-Web/Web.MinimalAPI` | `Examples/07-UseCases/Web.FoodDelivery` |
| Controllers | `Examples/02-Web/Web.ControllerExample` | `Examples/07-UseCases/Web.DextStore` |
| JWT / `[Authorize]` | `Examples/02-Web/Web.JwtAuthDemo` | `Examples/07-UseCases/Web.HelpDesk` |
| Response caching | `Examples/02-Web/Web.CachingDemo` | `Examples/07-UseCases/Web.FoodDelivery` |
| Rate limiting | `Examples/02-Web/Web.RateLimitDemo` | `Examples/07-UseCases/Web.FoodDelivery` |
| SSL / HTTPS | `Examples/02-Web/Web.SslDemo` | — |
| Swagger Minimal API | `Examples/02-Web/Web.SwaggerExample` | `Examples/07-UseCases/Web.FoodDelivery` |
| Swagger Controllers | `Examples/02-Web/Web.SwaggerControllerExample` | `Examples/07-UseCases/Web.DextStore` |
| TUUID binding | `Examples/02-Web/Web.TUUIDBindingExample` | `Examples/02-Web/Web.UUIDExample` |
| ORM CRUD / relations | `Examples/03-Data/Orm.EntityDemo` | `Examples/07-UseCases/Web.DextStore` |
| Entity modeling styles | `Examples/03-Data/Orm.EntityStyles` | — |
| Smart Properties | `Examples/03-Data/Web.SmartPropsDemo` | `Examples/03-Data/Orm.Specification` |
| Specification pattern | `Examples/03-Data/Orm.Specification` | `Examples/03-Data/Dext.Examples.ComplexQuerying` |
| Complex querying | `Examples/03-Data/Dext.Examples.ComplexQuerying` | `Examples/03-Data/Orm.EntityDemo` |
| Multi-tenancy | `Examples/03-Data/Dext.Examples.MultiTenancy` | — |
| Database-as-API | `Examples/03-Data/Web.DatabaseAsApi` | `Examples/07-UseCases/Web.FoodDelivery` |
| FastPath + ORM pool | `Examples/03-Data/Web.FastPath.OrmPool` | — |
| REST client | `Examples/04-Advanced/Net.RestClient.Demo` | — |
| Hubs / realtime | `Examples/04-Advanced/Hubs` | `Examples/07-UseCases/Web.EventHub` |
| MCP | `Examples/04-Advanced/MCP.FullDemo` | `Examples/04-Advanced/MCP.VclDbDemo` |
| gRPC + EntityDataSet | `Examples/04-Advanced/Grpc.EntityDataSet.Demo` | `Examples/09-ActiveArchitecture/Desktop.EntityDataSet.Demo` |
| Web Stencils | `Examples/04-Advanced/WebStencilsDemo` | — |
| MVVM desktop CRUD | `Examples/05-UI/Desktop.MVVM.CustomerCRUD` | — |
| MVU | `Examples/05-UI/Desktop.MVU.Counter` | `Examples/05-UI/Desktop.MVU.CounterFrame` |
| VCL logging | `Examples/05-UI/VCLMemoLog` | `Examples/01-Basics/Core.LoggingDemo` |
| Event bus | `Examples/07-UseCases/Core.EventBusDemo` | `Examples/07-UseCases/Web.EventBusDemo` |
| Streaming upload/download | `Examples/07-UseCases/Web.StreamingDemo` | — |
| Full API composition | `Examples/07-UseCases/Web.FoodDelivery` | `Examples/07-UseCases/Web.DextStore` |
| Sales/business orchestration | `Examples/07-UseCases/Web.SalesSystem` | `Examples/07-UseCases/Web.OrderAPI` |
| Ticket/concurrency domain | `Examples/07-UseCases/Web.TicketSales` | — |
| Help desk domain | `Examples/07-UseCases/Web.HelpDesk` | — |
| Admin starter | `Examples/07-UseCases/Web.Dext.Starter.Admin` | — |
| AI / Gemini | `Examples/08-AI/DextGemini` | — |
| Active Architecture | `Examples/09-ActiveArchitecture/Desktop.BasicActiveArchitecture.Demo` | — |

## Agent rule

For a feature implementation, inspect at least one feature-focused example and, when available, one Tier A use-case. The focused demo shows the isolated API; the use-case shows realistic composition, ownership, DI, startup, and middleware ordering.
