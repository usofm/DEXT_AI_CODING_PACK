# Task Template — Create a Realtime Feature

## Goal

Choose and implement the correct Dext realtime abstraction without confusing SSE, WebSocket, Hubs and EventBus.

## Load first

- `skills/dext-realtime/SKILL.md`
- `skills/dext-web/SKILL.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Choose the abstraction

```text
one-way server push            -> SSE
raw bidirectional connection   -> WebSocket
application groups/broadcast   -> Hubs
in-process application events  -> EventBus
```

Do not use `Web.EventHub` as the primary Hub reference; that example is an event-management domain application.

## EventBus lifetime decision

```text
background/non-request flow -> AddEventBus
HTTP-request shared scope   -> AddScopedEventBus
narrow publish capability   -> IEventPublisher<T>
```

## Design decisions

Specify:

1. delivery direction
2. connection lifetime
3. authentication/authorization
4. grouping/channel semantics
5. payload size limits
6. reconnect/resume behavior
7. persistence requirements
8. backpressure/failure policy

## Deliverables

Produce:

- abstraction choice and rationale
- startup registration
- server-side handlers/hub/event definitions
- client interaction contract
- auth/security handling
- bounded message/payload behavior
- tests

## Verification checklist

- WebSocket receive size is bounded
- broadcast/group authorization is explicit
- connection cleanup is handled
- EventBus is not mistaken for network messaging
- HTTP-scoped EventBus handlers share scope only when intended
- raw WebSocket is not chosen when Hubs already satisfy the requirement
