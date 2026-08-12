# 33. Processor Groups / Very High Core Counts

Dext includes support for Windows processor groups for systems with more than 64 logical cores.

Important ideas:

- detect system-wide logical processor topology
- distribute workers across groups
- set thread group affinity
- avoid underutilizing large Windows servers

Do not replace this with naive `TThread.ProcessorCount` assumptions in server worker infrastructure without verifying behavior on >64-core systems.

---

# 34. Resilience

Dext has Polly-inspired resilience concepts.

Expect strategies such as:

```text
Retry
Circuit Breaker
Timeout
Fallback
```

Use for unreliable remote I/O:

- REST calls
- external APIs
- remote databases when semantically appropriate
- message brokers
- network resources

### Retry safety rule

Never blindly retry non-idempotent operations.

Before retrying POST/payment/order creation:

- use idempotency keys, or
- ensure server-side deduplication, or
- ensure the operation is safe to repeat

---

# 35. Logging and Observability

Dext emphasizes structured observability.

Concepts include:

- `ILogger`
- log levels
- structured placeholders
- async logging
- ring-buffer paths
- external sinks
- Seq
- OpenTelemetry / OTLP
- HTTP timing
- SQL tracing
- spans
- metrics
- native visual dashboard

### Logging rule

Prefer:

```text
"Order {OrderId} completed in {ElapsedMs} ms"
```

over concatenating opaque strings.

Do not log:

- passwords
- JWT signing secrets
- full access tokens
- sensitive personal data
- unredacted financial credentials

---

# 36. Telemetry Dashboard

Dext includes a native telemetry dashboard aimed at reducing the friction of local APM setup.

It can surface concepts such as:

- RPS
- latency
- CPU / memory
- active database connections
- logs
- SQL statements
- SQL parameters
- query timings
- tracing spans / Gantt-style visualization

This is a development/diagnostics feature; do not assume it replaces an enterprise production observability stack in every deployment.

---

# 37. SSE and Real-Time Telemetry

Dext supports Server-Sent Events use cases.

SSE is well suited for:

- server-to-browser live telemetry
- logs
- progress feeds
- monitoring dashboards
- one-direction event streams

Prefer WebSockets/Hubs when bidirectional low-latency interaction is required.

---

# 38. WebSockets / Hubs

Dext includes Hubs inspired by SignalR concepts.

Use for:

- live dashboards
- messaging
- push events
- group-based notifications
- collaborative UI
- device/server bidirectional state

Expect concepts similar to:

```text
THub
IHubContext<T>
connections
groups
clients
broadcast
targeted send
```

Do not hold raw socket objects in business services when a Hub abstraction exists.

---

# 38A. Current WebSocket/Hubs Protocol Details

Recent feature synchronization documents a more concrete real-time stack:

```text
Dext.WebSocket.Protocol
Dext.WebSocket.Handshake
Dext.WebSocket.Compression
Dext.Web.Hubs.Transport.WebSocket
Dext.Web.Hubs.Client
```

Supported protocol concepts include:

- RFC 6455 frames
- text and binary frames
- ping/pong
- close frames
- 64-bit payload lengths
- client masking/unmasking
- WebSocket handshake validation
- SHA-1/Base64 `Sec-WebSocket-Accept`
- RFC 7692 permessage-deflate
- group dispatch
- heartbeat
- client reconnection behavior
- optional UI-thread marshaling in Delphi Hub client callbacks

Cross-platform I/O paths include Linux `epoll` and Windows polling/IOCP-oriented implementations.

### Maximum Receive Message Size

Recent fixes also show that receive-loop message limits are treated as a real security/resource boundary.

Do not remove or ignore maximum message size checks in WebSocket/Hubs code.

Large-message handling should be explicit and bounded.

---

# 39. Native TLS / SSL

Dext's advanced networking architecture aims to eliminate a *mandatory* reverse-proxy dependency for TLS termination.

This does **not** mean reverse proxies are obsolete.

Reverse proxies / load balancers remain useful for:

- WAF
- Layer-7 routing
- centralized certificates
- load balancing
- edge caching
- multi-service ingress
- DDoS controls
- operational traffic policy

Dext native TLS gives the Delphi process the option to terminate TLS itself.

S43 concepts described by Cesar Romero include:

- unified `Dext.Net.Security` abstraction
- OpenSSL 3.x engine
- memory BIO usage
- Windows http.sys / Schannel integration
- certificate development CLI
- ACME-oriented certificate strategy
- Indy compatibility through TLS providers
- encrypted Redis (`rediss://`)
- HTTPS REST calls
- WSS
- WebSocket permessage-deflate
- MessagePack real-time protocol support

Always verify which S43 features are fully merged in the exact commit you target.

---

# 40. HTTP/2

Dext's feature index/readme describe HTTP/2 capabilities including concepts such as:

- framing
- HPACK
- multiplexed streams

When working at protocol level:

- preserve flow-control semantics
- preserve stream lifecycle
- avoid cross-stream mutable state races
- do not treat HTTP/2 as "HTTP/1.1 with different headers"

For normal app code, use the high-level server/client API.

---

# 41. MCP — Model Context Protocol

Dext includes native MCP server support designed to expose Delphi application capabilities to AI agents.

Conceptual tool:

```pascal
type
  [MCPTool('search_products', 'Search active products')]
  [MCPParam('query', 'Search text')]
  TSearchProductsTool = class
  public
    function Execute(const AQuery: string): IList<TProduct>;
  end;
```

MCP can expose:

- tools/actions
- resources
- prompts
- database-backed functions
- application logic

### MCP security rules

Treat AI tool invocation like an API surface.

For write tools:

- authenticate caller
- authorize operation
- validate inputs
- enforce tenant boundaries
- log/audit
- use explicit transaction boundaries
- guard destructive actions
- never expose arbitrary SQL unless intentionally sandboxed

Do not give an AI unrestricted DB access just because MCP makes it easy.

---

# 42. AI Integration Beyond MCP

Dext articles also discuss model/API integrations such as Gemini.

General design rule:

Separate:

```text
AI provider adapter
prompt/domain service
application logic
controller/MCP exposure
```

Do not scatter provider-specific HTTP calls throughout controllers/forms.

Use DI so provider implementations can be swapped or mocked.

---

# 43. Desktop / VCL Integration

Dext explicitly aims not to sacrifice Delphi RAD productivity.

Important components/concepts include:

- `TEntityDataProvider`
- `TEntityDataSet`
- design-time entity metadata
- static TFields generation/compatibility
- live data preview in IDE
- VCL data-aware controls
- MVVM-oriented architecture
- Navigator
- declarative/magic binding

This enables a modernization path where:

```text
UI -> ViewModel/Application Service -> Dext ORM / API
```

instead of:

```text
Form -> Query component -> SQL -> database
```

---

# 44. EntityDataSet

`TEntityDataSet` bridges object-oriented ORM entities into Delphi's `TDataSet` world.

Use cases:

- DBGrid
- reporting
- existing data-aware controls
- gradual migration of legacy VCL applications
- design-time previews

Agent rule:

Do not interpret EntityDataSet as a reason to put persistence/business logic back inside forms.

It is an adapter between modern domain/data layers and classic Delphi visual controls.

---

# 45. Design-Time Tooling

Dext's design-time tooling supports a flow roughly like:

```text
physical DB
 -> generate entity definitions
 -> configure provider
 -> inspect entity metadata in Object Inspector
 -> connect EntityDataSet
 -> preview records inside Delphi IDE
```

The strategic goal is to combine:

- code-first architecture
- strong typing
- DDD/Clean Architecture
- RAD visual productivity

---

# 46. Desktop Navigation / MVVM

Dext UI includes a Navigator abstraction to avoid ad-hoc:

```pascal
Form.Show;
Frame.Parent := Panel;
Panel.Visible := True;
```

Prefer an application-level navigation abstraction.

MVVM-style separation:

```text
View
ViewModel
Controller/Application service
Domain
Infrastructure
```

Do not force MVVM onto every tiny dialog, but use it where UI logic is becoming hard to test/maintain.

---

# 47. Event Bus

Dext.Events is an in-process publish/subscribe abstraction inspired by mediator/event-bus patterns.

Use for decoupling same-process components.

Good use:

```text
OrderPlaced
 -> inventory handler
 -> audit handler
 -> notification handler
```

Do not confuse an in-memory event bus with durable messaging.

If events must survive process crash or cross machines, use a durable external broker/outbox architecture.

---

# 48. Testing Philosophy

Testing is a first-class Dext concern.

Repository guidance expects TDD for framework contributions.

Concepts include:

```text
[TestFixture]
tests
Mock<T>
fluent Should assertions
snapshots
integration testing
WebApplicationFactory
```

### Test pyramid

Prefer:

1. pure unit tests for domain/business logic
2. component tests for services
3. ORM/provider tests where translation matters
4. web integration tests
5. smaller number of full end-to-end tests

Do not use a real database for every business rule test.

---

# 49. Mocking

Dext Mocks provide interface-oriented test doubles.

Conceptual:

```pascal
var ServiceMock := Mock<IEmailService>;
```

Remember:

- it is record-oriented in current guidance
- do not `.Free`
- configure behavior via Dext mock setup API
- mock interfaces at architectural boundaries
- avoid mocking everything internally

Prefer testing actual value objects/domain logic directly.

---

# 50. WebApplicationFactory / Integration Testing

Recent Dext repository work includes a WebApplicationFactory-style integration test abstraction.

Use this to test:

- routes
- middleware
- authentication behavior
- model binding
- validation
- controller wiring
- DI replacement with test doubles

This is preferable to booting a full external production server for every integration test when in-memory/test-host semantics are supported.

---

# 51. Feature Flags

Recent source work includes feature flag infrastructure.

Expected scenarios:

- percentage rollout
- time-window activation
- gradual release
- environment-dependent features

Rules:

- feature flags are temporary decision points, not permanent architecture
- name flags by behavior/capability
- remove stale flags after rollout
- never use a client-side-only flag for security authorization

---

# 52. Server Deployment Thinking

Dext can be deployed in multiple patterns.

Potential patterns include:

```text
self-hosted executable
Windows service
Linux process/container
native HTTPS endpoint
behind reverse proxy
behind load balancer
legacy integration
```

Do not choose a reverse proxy or remove it based only on raw throughput.

Consider:

- TLS operations
- WAF
- certificates
- horizontal scaling
- host security
- graceful restarts
- static assets
- observability
- organization policy

---
