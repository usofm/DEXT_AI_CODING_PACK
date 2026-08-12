# 59. Persistent Background Jobs

Unit families:

```text
Dext.BackgroundJobs.Config
Dext.BackgroundJobs.Intf
```

Core symbols:

```text
TDextJobs
IJobClient
TSqliteJobStorage
```

Registration:

```pascal
AddBackgroundJobs
```

Operations:

```pascal
TDextJobs.Initialize(...)
TDextJobs.Enqueue<TService>(...)
TDextJobs.Schedule<TService>(...)
```

Storage:

```text
SQLite
InMemory
```

Use when jobs must survive restart/crash or be delayed.

---

# 60. Testing

Main facade:

```text
Dext.Testing
```

Mocks:

```text
Dext.Mocks
Mock<T>
```

Important fact:

```text
Mock<T> is a record.
Never Free it.
```

Test attributes:

```text
[TestFixture]
[Setup]
[TearDown]
[Test]
[TestCase]
```

Runner:

```text
TTest
Configure
Verbose
RegisterFixtures
Run
SetExitCode
```

Console requirement:

```pascal
SetConsoleCharSet;
```

---

# 61. Mocking

Core:

```pascal
Mock<T>
```

Setup:

```text
Setup.Returns
Setup.Throws
When
Arg.Any<T>
Arg.Is<T>
Arg.IsNot<T>
```

Verification:

```text
Received
DidNotReceive
Times.Once
Times.Never
Times.Exactly
Times.AtLeast
Times.AtMost
VerifyNoOtherCalls
```

Interfaces may require:

```pascal
{$M+}
```

for RTTI/mockability.

---

# 62. Assertions

Fluent entry:

```pascal
Should(...)
```

Representative assertions:

```text
Be
NotBe
BeNil
NotBeNil
BeTrue
BeFalse
BeGreaterThan
BeLessThan
BeInRange
Contain
NotContain
ContainOnly
HaveCount
BeEmpty
NotBeEmpty
BeOrdered
BeOfType<T>
BeAssignableTo<T>
BeEquivalentTo
HaveProperty
Raise<TException>
NotRaise
AllMatch
HaveValue
```

Classic:

```text
Assert.AreEqual
Assert.AreNotEqual
Assert.IsTrue
Assert.IsFalse
Assert.IsNil
Assert.IsNotNil
Assert.Multiple
```

---

# 63. Snapshot Testing

API:

```pascal
MatchSnapshot
```

Options:

```text
TSnapshotOptions
IgnorePaths
```

CLI:

```text
dext test --update-snapshots
```

Snapshot directory:

```text
__snapshots__/
```

---

# 64. Test Framework Integration

Supported integrations include:

```text
DUnitX
DUnit
DUnit2
TestInsight
```

Conditional defines:

```text
DEXT_DUNITX
DEXT_DUNIT
DEXT_DUNIT2
```

Related:

```text
Dext.Testing.Integration
Dext.Testing.DUnitX
Dext.Testing.DUnit
Dext.Testing.DUnit2
Dext.Testing.TestInsight
TTestRunnerRegistry.TryExecuteFromCommandLine
```

---

# 65. Testing History / IDE Tooling

Symbols / concepts:

```text
Dext.Testing.History
Dext.Testing.Listeners.Telemetry
Dext Test Explorer
gutter pass/fail icons
embedded local HTTP/SSE test server
coverage visualization
```

---

# 66. Web Integration Testing

Current Dext testing additions include:

```text
Dext.Testing.WebApplicationFactory
```

Use for:

```text
in-process/controlled web integration tests
```

---

# 67. MCP

Core concept:

```text
Model Context Protocol
```

Related Dext areas:

```text
Dext MCP server
tools
resources
prompts
database function calling
```

Use official:

```text
Docs/skills/dext-mcp.md
```

for exact APIs.

---

# 68. Database as API

Core concept:

```text
MapDataApi<T>
```

Purpose:

```text
zero/low-controller CRUD API generated from ORM entity metadata
```

Use for:

```text
admin CRUD
rapid prototyping
internal APIs
```

Do not use blindly for sensitive domain operations requiring explicit business rules.

---

# 69. Desktop / VCL

Related concepts:

```text
Navigator
Magic Binding
MVVM
EntityDataSet
design-time integration
```

Official skill:

```text
dext-desktop-ui
```

Use for:

```text
VCL navigation
two-way declarative binding
ViewModel/controller/frame patterns
```

---

# 70. Eventing

Related concept:

```text
Event Bus
```

Use for:

```text
decoupled in-process events
background/event-driven workflows
```

When exact symbols matter, inspect current `Sources/Events`.

---

# 71. CLI

Observed command families:

```text
dext doc
dext index
dext test
dext migrate:up
dext migrate:down
dext migrate:list
dext migrate:generate
dev-certs tooling
scaffold tooling
configuration tooling
codecs tooling
UI tooling
```

`dext index`:

```text
generates public symbol maps
Markdown / JSON / CSV
source line metadata
optimized for AI/navigation
```

`dext doc`:

```text
generates static HTML docs
dynamic toc.js navigation
file:// friendly
```

---

# 72. AI / Repository Governance

Files:

```text
AI_GOVERNANCE.md
Docs/CONTRIBUTING_AI.md
Docs/skills/
```

Agent expectations:

```text
check specs / known issues first
avoid duplicate utility implementations
draft plan
TDD first
update docs/skills when behavior changes
human review
license/IP provenance
no local path pollution
```

Style rules include:

```text
avoid L-prefixed local variables
prefer modern Delphi syntax where supported
avoid redundant manual Free when ownership is scope/DI-managed
```

---

# 73. Official Agent Skills

Current skill families:

```text
dext-app-structure
dext-web
dext-orm
dext-orm-advanced
dext-di
dext-auth
dext-testing
dext-collections
dext-json
dext-api-features
dext-validation
dext-background
dext-networking
dext-logging
dext-resilience
dext-realtime
dext-database-as-api
dext-desktop-ui
dext-server-adapters
dext-mcp
dext-symbols
dext-examples
```

Use skill files dynamically rather than keeping all of them permanently in context.

---

# 74. Official Example Projects

High-value architecture references include:

```text
Web.FoodDelivery
Web.HelpDesk
Web.SalesSystem
Web.TicketSales
Web.DextStore
Web.MinimalAPI
Web.ControllerExample
Web.CachingDemo
Web.RateLimitDemo
Web.SmartPropsDemo
Web.SslDemo
Web.StreamingDemo
Web.TUUIDBindingExample
Web.TaskFlowAPI
Web.SwaggerExample
Web.SwaggerControllerExample
Web.JwtAuthDemo
Web.RealTimeChat
Web.EventHub
Orm.EntityDemo
Dext.Examples.ComplexQuerying
Desktop.MVVM.CustomerCRUD
Web.FastPath.OrmPool
```

Agent rule:

```text
Official example > invented pattern, when the example covers the same problem.
```

---

# 75. Quick "Which Symbol Should I Use?" Map

## Need exact financial decimal?

```text
TBcd
FmtBcdType
BcdType
Param.AsFMTBCD
```

## Need typed query?

```text
Prop<T>
Prototype.Entity<T>
TEntityType<T>
Where
IExpression
```

## Need ORM result list?

```text
IList<T>
```

## Need immutable shared lookup data?

```text
IFrozenList<T>
IFrozenDictionary<K,V>
```

## Need producer/consumer backpressure?

```text
IChannel<T>
TChannel<T>.CreateBounded
```

## Need reusable expensive object?

```text
TDextPool<T>
IPooledObject<T>
AcquireScoped
```

## Need normal web endpoint?

```text
MapGet / MapPost / Controller
```

## Need extreme-throughput endpoint?

```text
MapFast
IDextFastQuery
IDbSetFastStream
ExecuteToUtf8Stream
```

## Need DB projection with no entity hydration?

```text
TDbContext.UseSql
IDextFastQuery
```

## Need background process for app lifetime?

```text
IHostedService
AddHostedService<T>
```

## Need persistent/delayed job?

```text
TDextJobs
IJobClient
AddBackgroundJobs
```

## Need object mapping?

```text
TMapper
```

## Need validation?

```text
TAbstractValidator<T>
RuleFor
TValidationPatterns
```

## Need retry/circuit breaker?

```text
Resilience Pipeline
Retry
Circuit Breaker
Fallback
Timeout
```

## Need real-time bidirectional communication?

```text
THub
IHubContext<T>
WebSocket
```

## Need one-way event stream?

```text
SSE
```

## Need API docs?

```text
OpenAPI / Swagger
dext doc
```

## Need codebase symbol navigation?

```text
dext index
dext-symbols skill
```

---

# 76. Unit / Feature Routing Table

| Need | Primary Unit / Area |
|---|---|
| Reflection | `Dext.Core.Reflection` |
| Smart Properties | `Dext.Core.SmartTypes` |
| Value converters | `Dext.Core.ValueConverters` |
| Mapping | `Dext.Mapper` |
| Span / memory | `Dext.Core.Span`, `Dext.Core.Memory` |
| Nullable | `Dext.Types.Nullable` |
| UUID | `Dext.Types.UUID` |
| Lazy | `Dext.Types.Lazy` |
| DI | `Dext.DI.*` |
| Collections | `Dext.Collections*` |
| Object pooling | `Dext.Collections.Pool` |
| JSON | `Dext.Json*` |
| Async | `Dext.Core.Async`, `Dext.Threading.*` |
| Processor groups | `Dext.Threading.ProcessorGroups` |
| ORM | `Dext.Entity*` |
| Entity core | `Dext.Entity.Core` |
| Entity prototype | `Dext.Entity.Prototype` |
| Entity type system | `Dext.Entity.TypeSystem` |
| Fast query | `Dext.Entity.FastQuery` |
| Migrations | `Dext.Entity.Migrations` |
| Web | `Dext.Web*` |
| PathBase | `Dext.Web.PathBase` |
| Forwarded headers | `Dext.Web.ForwardedHeaders` |
| Antiforgery | `Dext.Web.Antiforgery` |
| Feature flags | `Dext.FeatureFlags` |
| WebSocket protocol | `Dext.WebSocket.*` |
| Hubs | `Dext.Web.Hubs*` |
| Logging | `Dext.Logging*` |
| Testing | `Dext.Testing*` |
| Mocks | `Dext.Mocks` |
| Background jobs | `Dext.BackgroundJobs.*` |
| MCP | Dext MCP units / skill |
| REST client | `Dext.Net.RestClient` |
| TLS | `Dext.Net.Security` |
| gRPC | `Dext.Grpc.*` |

---

# 77. AI Hallucination Guard

Before generating code with any of these, verify current source if the exact signature matters:

```text
attributes
generic overloads
helper methods
compiler directives
provider-specific APIs
server-engine adapters
TLS options
OpenAPI metadata
MCP registration
migration builder overloads
stored procedure attributes
feature-flag registration
forwarded-header options
antiforgery configuration
```

Never invent an attribute or overload merely because a similar .NET API exists.

Dext is ASP.NET-Core-inspired, not API-identical to ASP.NET Core.

---

# 78. Freshness / Source of Truth

Use this precedence when information conflicts:

```text
1. Current Dext source code
2. Current repository-wide critical rules / CONTRIBUTING_AI
3. Current specs marked finalized
4. Current official Docs/skills
5. Current official examples
6. Feature index
7. Dext Book
8. Blog articles
9. This symbol index
10. General framework analogy / memory
```

Known current documentation inconsistency:

```text
Global skill critical rule:
  NEVER use [StringLength]; use [MaxLength(N)]

Focused validation skill:
  still shows [StringLength(...)] examples
```

Treat the repository-wide critical rule as authoritative unless current source proves otherwise.

---

# 79. Refresh Procedure

When Dext `main` changes:

```text
1. Record new HEAD SHA
2. Run/inspect `dext index` output if available
3. Review new commits
4. Compare public type/alias/interface additions
5. Compare Docs/skills changes
6. Compare Features_Implemented_Index
7. Add/remove renamed/deprecated symbols here
8. Update DEXT_AI_MEMORY_ENRICHED.md if architectural behavior changed
```

---

# 80. Snapshot Identity

```text
Repository: cesarliws/dext
Branch:     main
HEAD:       412ed29207d2d1dc5d4a259a7739a615aed0c626
Date:       2026-08-12
Artifact:   DEXT_API_SYMBOL_INDEX.md
Companion:  DEXT_AI_MEMORY_ENRICHED.md
```


# 81. Event Bus Symbols

```text
IEventBus
IEventHandler<T>
IEventBehavior
IEventPublisher<T>
AddEventBus
AddScopedEventBus
AddEventHandler<TEvent,THandler>
AddEventBehavior<TBehavior>
AddEventBehaviorFor<TEvent,TBehavior>
Publish<T>
PublishBackground<T>
TEventBusTracker
EEventDispatchAggregate
EEventDispatchException
```

Primary examples: `Core.EventBusDemo`, `Web.EventBusDemo`.

# 82. View / Server-Rendered Web Symbols

```text
UseViewEngine
Results.View
AddWebStencils
AddDextTemplating
DEXT_ENABLE_WEB_STENCILS
UseStaticFiles
```

Primary examples: `WebStencilsDemo`, `Web.Dext.Starter.Admin`.

# 83. MCP Provider Symbols

```text
TMCPServer
TMCPToolProvider
[MCPTool]
[MCPParam]
[MCPResource]
[MCPPrompt]
[MCPPromptArg]
RegisterProvider
Mcp-Session-Id
```

Primary example: `MCP.FullDemo`. Verify current protocol/signatures in source.

# 84. Event/Realtime Distinction

```text
IEventBus / IEventPublisher<T> -> internal server eventing
SSE                           -> one-way client stream
WebSocket                     -> raw bidirectional transport
THub / IHubContext            -> application-level client realtime
```

# 85. Desktop Architecture Routing

```text
INavigator
MVVM
Magic Binding
MVU
EntityDataSet
Active Architecture
```

Primary examples: `Desktop.MVVM.CustomerCRUD`, `Desktop.MVU.Counter`, `Desktop.BasicActiveArchitecture.Demo`, `Desktop.EntityDataSet.Demo`.
