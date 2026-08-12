# Skill: Dext Realtime / Events

Use for SSE, WebSocket, Hubs and the Dext Event Bus.

## Load first
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- `examples/DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Choose the abstraction
- one-way server push -> SSE
- raw bidirectional protocol -> WebSocket
- groups/broadcast/application realtime -> Hubs
- in-process domain/application event dispatch -> Event Bus

Do not confuse `Web.EventHub` with Dext Hubs; it is an event-management domain application.

## Event Bus
Use `AddScopedEventBus` inside HTTP workflows when handlers must share request-scoped services such as the same DbContext.
Use `AddEventBus` for singleton/background dispatch where each publish may create its own child scope.
Prefer `IEventPublisher<T>` when a service should publish only a specific event type.

## WebSocket/Hubs rules
- Bound incoming message sizes; honor `MaximumReceiveMessageSize`.
- Use Hubs when groups/broadcast semantics fit instead of hand-rolling raw WebSocket protocols.
- Treat demo `AllowAnyOrigin` as demo-only.
- Make connection lifecycle, shutdown and background-thread ownership explicit.

## Best examples
- Hubs: `Examples/04-Advanced/Hubs`
- application realtime: `Examples/07-UseCases/Web.AirFlow`
- Event Bus: `Examples/07-UseCases/Core.EventBusDemo`
- scoped Web Event Bus: `Examples/07-UseCases/Web.EventBusDemo`

## Output checklist
1. choose SSE/WebSocket/Hub/EventBus deliberately
2. define connection/event lifetime
3. define DI scope semantics
4. define error/reconnect/backpressure policy
5. add tests for event delivery and failure behavior
