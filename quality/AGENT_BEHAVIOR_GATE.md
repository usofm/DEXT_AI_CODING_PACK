# Agent Behavior Gate

This gate verifies that the pack still trains agents toward current Dext usage instead of stale examples or ASP.NET-style guesses.

## Routing and Controllers

- [ ] route parameters use `{id}` form
- [ ] controller route attributes use current Dext syntax
- [ ] generated controller actions avoid reserved/problematic names such as `Create`
- [ ] typed/generic injection is preferred to request service locator calls

## ORM and Ownership

- [ ] ORM result collections use `IList<T>`
- [ ] child-collection ownership is explicit when DbContext owns entities
- [ ] detached updates mention `.Update(Entity)` before `SaveChanges`
- [ ] Web DbContexts prefer pooling when appropriate
- [ ] bulk operations require safety checks

## Precision

- [ ] exact financial values beyond four decimals route to `TBcd`/`FmtBcdType`
- [ ] examples do not normalize `NUMERIC(28,10)` to `Double`
- [ ] provider binding keeps exact decimal semantics

## Performance

- [ ] normal pipeline remains default
- [ ] FastPath requires a measured reason
- [ ] direct UTF-8 streaming is used only where materialization is unnecessary
- [ ] pooling favors scoped/RAII lease patterns when available

## Realtime and Events

- [ ] SSE, WebSocket, Hubs and Event Bus are not conflated
- [ ] `Web.EventHub` remains identified as an event-management application
- [ ] request-scoped event workflows consider `AddScopedEventBus`
- [ ] narrow publishing dependencies consider `IEventPublisher<T>`

## Testing

- [ ] `Mock<T>` is treated as a record and never freed
- [ ] integration tests use current WebApplicationFactory patterns when appropriate
- [ ] snapshot tests are used for structured regression cases, not as a substitute for behavioral assertions

## Security

- [ ] forwarded headers require trusted proxies
- [ ] cache examples do not generalize to authenticated/private responses
- [ ] CORS examples do not imply unsafe production defaults
- [ ] demo secrets/passwords are labeled non-production

## Evidence Rule

When exact syntax is uncertain, the required evidence order is:

```text
current source
-> critical rules / CONTRIBUTING_AI
-> finalized spec
-> current official skill
-> current example .pas
-> example README
-> this pack
```

A release fails this gate if any top-level agent/skill/prompt guidance contradicts this ordering.
