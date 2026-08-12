# DEXT 07-USECASES SUPPLEMENTAL AUDIT

> Source group: `cesarliws/dext/Examples/07-UseCases`
> Snapshot: 2026-08-12

This file complements `DEXT_TIER_A_DEEP_AUDIT.md`. The Tier-A file covers the largest business applications; this audit covers the remaining specialized use cases.

## Scope

- `Core.EventBusDemo`
- `Web.EventBusDemo`
- `Web.AirFlow`
- `Web.Dext.Starter.Admin`
- `Web.EventHub`
- `Web.OrderAPI`
- `Web.StreamingDemo`
- `Web.TaskFlowAPI`

Already covered deeply elsewhere:

- `Web.DextStore`
- `Web.FoodDelivery`
- `Web.HelpDesk`
- `Web.SalesSystem`
- `Web.TicketSales`

---

# 1. Core.EventBusDemo — in-process event architecture

This is the primary focused Event Bus reference.

It demonstrates eight major concepts:

```text
AddEventBus
AddEventHandler<TEvent,THandler>
Publish<T>
multiple handlers
AddEventBehavior<TBehavior>
AddEventBehaviorFor<TEvent,TBehavior>
IEventPublisher<T>
PublishBackground<T>
EEventDispatchAggregate
TEventBusTracker
```

## Multiple handlers

One domain event can fan out to multiple independent reactions:

```text
OrderPlaced
├─ Email confirmation
├─ Audit log
└─ Inventory deduction
```

### Golden rule

Use events when the publisher should not need to know every reaction.

Do not use events merely to hide a direct dependency when synchronous orchestration is clearer.

---

## Event pipeline behaviors

The example demonstrates `IEventBehavior` and an `ANext()` pipeline delegate.

Conceptually:

```text
Publish
 -> global/per-event behaviors
 -> handler
```

A behavior may:

```text
log
measure
validate
wrap exceptions
short-circuit deliberately
```

### Critical rule

If a behavior intends downstream execution, it must invoke `ANext()`.

---

## Typed event publisher

The example explicitly contrasts:

```text
IEventPublisher<TSpecificEvent>
```

with the full:

```text
IEventBus
```

### Golden rule

Prefer the narrow typed publisher when a service only needs to publish one event family. This follows interface-segregation principles and makes capabilities explicit.

---

## Event testing

`TEventBusTracker` provides a fake/testing path for asserting published events without invoking production handlers.

Recommended application-service test:

```text
call business service
 -> assert domain/application event was published
 -> separately test handler behavior
```

This prevents every publisher test from becoming a full integration test.

---

# 2. Web.EventBusDemo — request-scoped events

This example demonstrates a particularly important distinction:

```text
AddScopedEventBus
vs
AddEventBus
```

## `AddScopedEventBus`

One Event Bus per HTTP request. Handlers resolve inside the caller's request scope.

This can share:

```text
same scoped DbContext
same request identity/claims
same scoped dependencies
```

## `AddEventBus`

Singleton-style bus behavior creates a fresh child scope for publishes, which is more suitable when no ambient HTTP request scope should be shared.

### Golden decision

```text
handler must participate in request unit-of-work -> Scoped Event Bus may fit
handler is independent/background boundary -> normal bus / background publication may fit
```

Do not assume event publication is automatically transactional. Verify DbContext/transaction boundaries explicitly.

---

## Delphi helper-collision lesson

This example isolates Event Bus registration into a dedicated unit because Delphi permits only one applicable record helper per type in a compilation scope, and both Event Bus and Web extensions can extend `TDextServices`.

### Golden rule

Unit boundaries can be used intentionally to resolve Delphi helper visibility conflicts.

This reinforces the pack's `uses`-ordering and helper-awareness rules.

---

# 3. Web.TaskFlowAPI — strongest hybrid routing reference

`Web.TaskFlowAPI` demonstrates:

```text
Minimal APIs + Controllers in one app
generic typed handler injection
body + service injection in same handler
route primitive binding
IResult helpers
functional middleware
```

Representative modern typed DI style:

```pascal
MapPost<TUser, IUserService, IResult>(
  '/api/users',
  function(User: TUser; UserService: IUserService): IResult
```

and typed route binding:

```pascal
MapGet<Integer, IResult>('/api/tasks/{id}', ...)
```

### Golden rule

When an AI agent needs a current Minimal API DI reference, prefer `TaskFlowAPI`-style generic typed injection over older examples that manually resolve from request services.

---

# 4. Web.StreamingDemo — multipart and streamed files

This example demonstrates:

```text
IFormFile
Request.Files.GetFile(...)
multiple uploads
CopyTo(stream)
streamed file response
MIME/content type
Content-Disposition
inline streaming
```

### Security rules for uploads

An application must not equate a successful multipart parse with a safe upload.

Validate:

```text
size limits
allowed content types/extensions
server-generated storage names
path traversal
malware/scanning policy where required
authorization
storage quotas
```

Never concatenate a user-supplied filename directly into a filesystem path.

### Route drift warning

The README lists older colon-style routes such as:

```text
/download/:name
/stream/:name
```

Current repository route rules require brace syntax:

```text
/download/{name}
/stream/{name}
```

Do not copy the README route syntax into new code.

---

# 5. Web.Dext.Starter.Admin — vertical-slice + HTMX reference

This is an especially valuable full-stack Dext example.

It combines:

```text
Dext backend
Minimal APIs
Service Layer
Dext.Entity
JWT
HTMX
Tailwind CSS
Alpine.js
Chart.js
static/server-returned HTML
Swagger
feature folders / vertical slices
```

Structure:

```text
Domain/
Features/
  Auth/
  Customers/
  Dashboard/
  Settings/
  Shared/
wwwroot/
AppStartup.pas
```

## Vertical slice pattern

Each feature can own:

```text
DTOs
service
endpoint mapping
feature-specific UI/HTML concerns
```

while cross-cutting persistence/domain infrastructure stays centralized where appropriate.

### Golden rule

This is a strong reference for Dext applications that want modern server-driven web UX without a Node build pipeline.

---

## HTMX pattern

The example uses HTML endpoints/partials triggered by HTMX rather than forcing every screen into a JSON SPA architecture.

Conceptual flow:

```text
HTMX request
 -> Dext endpoint
 -> service
 -> HTML fragment
 -> hx-target replacement
```

### Agent rule

When requirements favor server-driven UI, consider HTMX/WebStencils/server-rendered Dext patterns before proposing a large JavaScript SPA by default.

---

## Starter security drift

The example documents demo username/password and JWT secret constants.

These are demo-only values.

Production must use:

```text
strong secrets
configuration/secret provider
secure cookies/token storage strategy
real credential hashing/identity store
CSRF considerations when credentials are browser-state based
```

---

# 6. Web.EventHub — domain event-management app, NOT Dext Hubs

Important disambiguation:

```text
Web.EventHub example name
    = event-management / attendee registration business application

Dext.Web.Hubs
    = realtime Hub framework
```

Do not route an AI agent to `Web.EventHub` when the user asks how to implement WebSocket groups/broadcasting. Use `04-Advanced/Hubs` or AirFlow for that.

---

## EventHub architecture

This business application demonstrates:

```text
Domain/Data/Services/Server/Tests
Minimal APIs
scoped services
Smart Properties
JWT
CORS
RateLimit
ResponseCache
Swagger
DbSeeder with scope
business rules in entities/services
unit + integration tests
```

Representative typed endpoint DI:

```pascal
MapPost<TCreateRegistrationRequest, IRegistrationService, IResult>(...)
```

Business rules include:

```text
Draft -> Published gating
capacity -> automatic WaitList
cancel -> first WaitList promotion
24-hour cancellation restriction
unique active registration
venue capacity constraint
```

### Golden lesson

This is a strong domain-state-machine example: endpoint code delegates to services/entities rather than encoding the full registration lifecycle in transport code.

---

# 7. Web.AirFlow — realtime telemetry/control use case

`Web.AirFlow` combines:

```text
Dext Hubs
static web UI
background simulator thread
broadcast telemetry/system alerts
REST command endpoints
Hub context from server-side code
```

Observed startup lifecycle:

```text
UseHubs
middleware/static files
MapHub('/hubs/airflow', TAirFlowHub)
REST endpoints
start simulator thread
```

Shutdown explicitly:

```text
Terminate simulator
WaitFor
Free simulator
ShutdownHubs
```

### Golden rule

Long-running background producers must have explicit shutdown/cancellation semantics. Do not start anonymous immortal threads from web startup.

For production code, prefer Dext hosted/background abstractions when they provide the required lifecycle instead of hand-managing a thread.

---

## AirFlow error-handling caveat

The demo returns raw exception messages in one endpoint. The pack's production rule still applies:

```text
never expose raw internal exception messages in production 500 responses
```

Focused examples do not override security hardening rules.

---

# 8. Web.OrderAPI — DMVC migration reference

This example is specifically a migration guide from DelphiMVC Framework.

It demonstrates:

```text
IStartup composition
Controllers
DI services/repositories
ORM/SQLite
Swagger
Basic Auth
integration tests
```

### Strong value

Use it when migrating architectural concepts from DMVC to Dext.

### Major drift warning

Its README still references older controller attributes:

```text
[DextRoute]
[DextGet]
```

Current Dext examples/source use modern controller attributes such as:

```text
[ApiController]
[HttpGet]
[HttpPost]
```

Therefore use OrderAPI for migration intent and architecture, not as the final exact attribute syntax source.

---

# 9. Use-case trust matrix

```text
Core.EventBusDemo       -> primary Event Bus feature reference
Web.EventBusDemo        -> scoped HTTP Event Bus reference
Web.TaskFlowAPI          -> strong modern typed Minimal API + Controller hybrid reference
Web.StreamingDemo       -> file/multipart feature reference; route syntax drift warning
Starter.Admin           -> strong vertical-slice + HTMX full-stack reference
Web.EventHub             -> strong business/domain workflow reference; name disambiguation required
Web.AirFlow              -> Hubs + background realtime producer reference
Web.OrderAPI             -> DMVC migration architecture reference; old attribute names in README
```

---

# 10. Eventing decision tree

```text
Need decoupled in-process reactions?
├─ request handlers share request scope -> AddScopedEventBus
├─ independent/general event bus -> AddEventBus
├─ publisher exposes one event capability -> IEventPublisher<T>
├─ fire-and-forget -> PublishBackground<T> where semantics allow
└─ verify publications in tests -> TEventBusTracker

Need client realtime?
├─ one-way stream -> SSE
├─ raw duplex -> WebSocket
└─ groups/method calls/broadcast -> Hubs
```

Event Bus and Hubs solve different problems:

```text
Event Bus = server-side in-process decoupling
Hubs      = client/server realtime communication abstraction
```

---

# 11. Full-stack decision tree

```text
Need admin/business web UI?
├─ JSON API + separate SPA required -> normal API architecture
├─ server-driven modern UX -> Starter.Admin / HTMX
├─ template view engine -> WebStencils/Dext View Engine
└─ static dashboard + realtime telemetry -> AirFlow-style Hubs + static UI
```

---

# 12. Source precedence

```text
current framework source
> repository-wide Critical Rules
> current example .pas source
> official skills/specs
> example README
> this audit
```
