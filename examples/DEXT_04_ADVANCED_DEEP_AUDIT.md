# DEXT 04-ADVANCED DEEP AUDIT

> Source group: `cesarliws/dext/Examples/04-Advanced`
> Snapshot: 2026-08-12

## Scope

Audited examples:

- `Core.TestHttpParser`
- `Grpc.EntityDataSet.Demo`
- `Hubs`
- `MCP.FullDemo`
- `MCP.VclDbDemo`
- `Net.RestClient.Demo`
- `WebStencilsDemo`

This group is not a normal starting point for application architecture. It contains protocol, integration, desktop bridge and advanced composition examples.

---

## 1. Hubs: application-level realtime

The `Hubs` example demonstrates:

```text
THub
[HubMethod]
OnConnectedAsync
OnDisconnectedAsync
Clients.All
Clients.Caller
Clients.Group(...)
Groups.AddToGroupAsync
MapHub
server-side push
JavaScript client
```

Representative shape:

```pascal
type
  TDemoHub = class(THub)
  public
    [HubMethod]
    procedure SendMessage(const User, Message: string);
  end;
```

Transport behavior described by the example:

```text
WebSocket when current HTTP engine supports upgrade
SSE fallback
Long Polling not advertised
principal/auth preserved across negotiation and invocation
```

### Golden rule

Choose realtime abstraction by requirement:

```text
one-way server push -> SSE
raw duplex protocol -> WebSocket
method invocation + groups + broadcasts -> Hubs
```

Do not implement application chat/group semantics directly on raw WebSocket if Hubs already supplies the needed abstraction.

---

## 2. MCP Full Demo

`MCP.FullDemo` is the strongest official MCP reference in the examples tree.

It demonstrates the MCP 2025-03-26 pillars:

```text
Tools
Resources
Prompts
```

RTTI/attribute provider pattern:

```text
TMCPToolProvider
[MCPTool]
[MCPParam]
[MCPResource]
[MCPPrompt]
[MCPPromptArg]
```

Representative registration:

```pascal
Server.RegisterProvider(TDemoProvider.Create);
```

The example documents that the server assumes provider ownership.

### Supported transport modes in example

```text
HTTP Streamable -> POST /mcp
SSE legacy
stdio
Mcp-Session-Id session header
```

### Agent rules

1. Prefer a dedicated provider class per coherent domain/tool area.
2. Keep MCP transport/protocol concerns separate from business logic.
3. Treat tool arguments as untrusted input and validate authorization/domain invariants.
4. Provider ownership is server-managed where documented; do not double-free it.
5. Use the official MCP skill/source to verify the exact current protocol and attribute signatures.

### Verification pattern

The example ships a large `.http` request suite and Claude configuration guidance. For MCP integrations, protocol-level request tests are part of the reference architecture.

---

## 3. REST Client

`Net.RestClient.Demo` demonstrates both shorthand and builder-style client APIs.

Observed API families:

```text
RestClient(baseUrl)
.Get(...)
.Post<T>(...)
.PostJson(...)
.Request.Get(...)
.Request.Post(...)
.Request(Method, Endpoint)
TRestRequest
.Header(...)
.JsonBody(...)
.Body<T>(...)
.BodyArray<T>(...)
.Execute
.Execute<T>
.Await
.OnCompleteAsync
.OnExceptionAsync
.Start
.WithCancellation
```

The demo explicitly exercises Delphi records as DTOs and arrays of records.

### Lifetime note

The example comments that `TRestClient` is a record wrapper over an interface and should not be manually freed.

### Golden rules

```text
simple typed request -> fluent RestClient shorthand
complex request composition -> Request builder / TRestRequest
async callback flow -> Start + completion/exception callbacks
linear async flow -> Await
cancelable operation -> WithCancellation
```

Do not wrap Dext's client in another ad-hoc HTTP abstraction unless the application needs a real domain gateway boundary.

---

## 4. Web Stencils / Dext Templating

`WebStencilsDemo` demonstrates server-rendered views integrated with Dext Web + ORM.

Observed composition:

```text
AddWebStencils (conditional)
AddDextTemplating fallback
UseViewEngine
Results.View(...)
UseStaticFiles
DbContext
Prototype.Entity<T>
server-rendered search result partial
```

The startup uses conditional compilation:

```pascal
{$IFDEF DEXT_ENABLE_WEB_STENCILS}
  .AddWebStencils;
{$ELSE}
  .AddDextTemplating;
{$ENDIF}
```

and view results such as:

```pascal
Results.View('index')
Results.View<TCustomer>('customers', Query)
```

### Golden rule

Server-rendered HTML is a first-class Dext architecture option. Do not assume every Dext web application must be JSON REST-only.

For HTML/server-driven UI:

```text
Dext Web endpoint
 -> query/application service
 -> view model/query result
 -> Results.View
 -> template engine
```

### Conditional feature rule

Preserve `DEXT_ENABLE_WEB_STENCILS` boundaries. Do not generate unconditional Web Stencils dependencies if the project is intended to build without that feature.

---

## 5. gRPC + EntityDataSet

`Grpc.EntityDataSet.Demo` exists specifically at the boundary between Dext gRPC transport and Delphi dataset-oriented desktop/data access.

Agent classification:

```text
Tier B/C integration reference
not a default web/API architecture
```

Use it when the requirement explicitly involves:

```text
gRPC
EntityDataSet
remote dataset transport
Delphi desktop data binding over RPC
```

Do not generalize dataset transport into domain-service architecture for new APIs.

---

## 6. MCP VCL DB Demo

`MCP.VclDbDemo` is an integration-specific reference for:

```text
VCL application
local/desktop database access
MCP exposure
AI tool integration
```

Golden boundary:

```text
UI/database objects
  -> application/domain service
      -> MCP provider/tool
```

Do not expose arbitrary SQL execution or raw UI/database internals to an MCP client without an explicit security model.

---

## 7. HTTP Parser Demo

`Core.TestHttpParser` is a low-level engine/protocol test example.

Classification:

```text
Tier C
framework internals/testing reference
```

Do not copy parser loops, raw buffer handling or low-level HTTP state handling into normal applications.

---

## 8. Advanced Trust Matrix

```text
Hubs                 -> feature/application realtime reference
MCP.FullDemo          -> primary MCP feature reference
MCP.VclDbDemo         -> desktop integration reference
Net.RestClient.Demo   -> client API reference
WebStencilsDemo       -> server-rendered UI reference
Grpc.EntityDataSet    -> transport/dataset integration reference
Core.TestHttpParser   -> framework internals reference
```

---

## 9. Cross-Layer Golden Rules

### Rule A — prefer the highest useful abstraction

```text
raw socket < WebSocket < Hubs
raw HTTP < RestClient request builder < domain gateway
raw template writes < Results.View + view engine
raw MCP JSON-RPC < TMCPServer/provider attributes
```

Use low-level APIs only when higher-level APIs cannot satisfy the requirement.

### Rule B — integration examples are not universal architecture

A VCL DB MCP demo, gRPC dataset demo or parser test is evidence for a specific integration, not a recommendation to structure every application that way.

### Rule C — preserve conditional features

Feature defines such as `DEXT_ENABLE_WEB_STENCILS` are part of the build architecture.

### Rule D — tests should match protocol level

```text
REST -> .http / API integration tests
MCP -> initialize/session/tool/resource/prompt protocol tests
Hubs -> connection/group/invocation tests
low-level HTTP -> parser/protocol tests
```

---

## 10. Agent Decision Tree for Advanced Features

```text
Need advanced integration?
├─ app realtime groups/methods
│  └─ Hubs
├─ one-way browser updates
│  └─ SSE
├─ raw duplex framing/control
│  └─ WebSocket
├─ outbound HTTP API
│  └─ Dext.Net.RestClient
├─ LLM/agent tool protocol
│  └─ MCP provider/server
├─ server-rendered HTML
│  └─ View Engine / WebStencils/Dext templating
├─ remote dataset over RPC
│  └─ gRPC EntityDataSet example
└─ protocol/framework internals
   └─ low-level Tier C examples
```

---

## 11. Source Priority

```text
current source
> current example .pas
> official skills/specs
> example README
> this audit
```
