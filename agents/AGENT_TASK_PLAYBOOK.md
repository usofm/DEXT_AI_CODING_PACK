# AGENT TASK PLAYBOOK

> Task -> evidence -> recommended Dext path.

## Build a normal CRUD API

Read:
1. `DEXT_DECISION_TREE.md`
2. `DEXT_ANTI_PATTERNS.md`
3. `DEXT_API_SYMBOL_INDEX.md`
4. `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
5. `Examples/07-UseCases/Web.HelpDesk` or `Web.FoodDelivery`

Prefer:
```text
Endpoint/Controller
-> Service
-> DbContext
-> Domain
```

Use Data API only when the operation is genuinely metadata-driven CRUD.

## Build a high-throughput endpoint

Read:
- FastPath symbols
- `examples/DEXT_03_DATA_DEEP_AUDIT.md`
- `Web.FastPath.OrmPool`
- drift register

Decision:
```text
need domain objects? -> normal ORM path
no domain object and hot projection? -> UseSql / IDextFastQuery
tiny measured hot route? -> MapFast
```

Prefer current `AcquireScoped` RAII patterns over older manual pool examples.

## Build a financial/accounting API

Read:
- TBcd sections in symbol index/full memory
- `DEXT_ANTI_PATTERNS.md`

Default exact path:
```text
Firebird NUMERIC/DECIMAL precision
-> TBcd
-> FmtBcdType/BcdType
-> AsFMTBCD parameter binding
```

Do not downgrade exact rates/amounts to Double or Currency when required scale exceeds their semantics.

## Build multi-tenant SaaS data access

Read:
- `examples/DEXT_03_DATA_DEEP_AUDIT.md`
- official MultiTenancy example

Verify:
- tenant resolution boundary
- tenant key isolation/filtering
- request/scoped tenant context
- database strategy before copying the demo

## Build realtime groups/broadcasts

Read:
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- official `Hubs` example
- `Web.AirFlow` for composed realtime use case

Choose:
```text
SSE -> one-way events
WebSocket -> raw bidirectional protocol
Hubs -> application groups/broadcasts
```

Do not confuse `Web.EventHub` with the Hubs realtime subsystem.

## Build Event Bus integration

Read:
- `Core.EventBusDemo`
- `Web.EventBusDemo`
- `examples/DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md`

Choose:
```text
background/no ambient request -> AddEventBus
web request + shared scoped services/DbContext -> AddScopedEventBus
narrow publisher dependency -> IEventPublisher<T>
```

## Build server-driven UI

Options:
```text
WebStencils -> Dext view engine / templating reference
Starter.Admin -> HTMX + Tailwind + feature-oriented backend
```

Read:
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- `examples/DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md`

Do not copy demo JWT secrets or permissive CORS into production.

## Build desktop app

For MVVM:
- `Desktop.MVVM.CustomerCRUD`

For MVU:
- `Desktop.MVU.Counter`
- `Desktop.MVU.CounterFrame`

For layered desktop composition:
- `Desktop.BasicActiveArchitecture.Demo`

Read UI and Active Architecture audits before choosing the pattern.

## Build MCP server

Read:
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- `MCP.FullDemo`

Core model:
```text
TMCPToolProvider
+ [MCPTool]
+ [MCPResource]
+ [MCPPrompt]
-> RegisterProvider
-> HTTP Streamable / SSE legacy / stdio transport as supported
```

Verify exact current MCP protocol/API source before production use.

## Build AI/Gemini integration

Read:
- `examples/DEXT_08_AI_DEEP_AUDIT.md`
- `DextGemini`

Patterns:
- Options/config for provider settings
- RestClient for outbound calls
- typed request/response models
- JSON serialization
- explicit provider error mapping

Never hard-code provider secrets in committed source.

## Migrate from DelphiMVC Framework

Read:
- `Web.OrderAPI`
- current controller examples
- drift register

Important: migration-oriented README files can retain historical attribute names. Verify current `.pas` source and current Dext source before translating APIs.

## Add Swagger/OpenAPI

Read:
- `Web.SwaggerExample`
- `Web.SwaggerControllerExample`

Use current source to select Fluent DSL vs controller metadata/attributes.

## Add authentication

Read:
- `Web.JwtAuthDemo`
- `Web.BasicAuthDemo`
- Tier A use case with auth

Never treat demo credentials, demo secrets, or permissive policies as production defaults.

## Add caching/rate limiting/security middleware

Read feature demo + current middleware source + drift register.

Remember:
- current RFC-oriented rate-limit behavior may differ from old example headers
- authenticated/private content must not be cached accidentally
- CORS credentials require explicit origins
- forwarded headers require trusted proxy configuration

## Add tests

Read:
- `DEXT_API_SYMBOL_INDEX.md` testing section
- Tier A test projects
- EventBus tracker example where relevant

Prefer testable domain/service rules independent of transport.

## Final Agent Checklist

Before returning code:

```text
[ ] exact symbol verified or uncertainty stated
[ ] route syntax current
[ ] DI pattern current
[ ] ownership correct
[ ] ORM collection correct
[ ] precision type correct
[ ] SQL parameterized
[ ] example drift checked
[ ] demo security not copied
[ ] Tier C pattern not generalized
```
