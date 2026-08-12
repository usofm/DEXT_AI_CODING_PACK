# Skill: Dext Testing

Use for unit tests, mocks, assertions, snapshots, integration tests, WebApplicationFactory and example verification.

## Load first
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`

## Core APIs
- `Dext.Testing`
- `Dext.Mocks`
- `Mock<T>`
- `Should(...)`
- snapshot testing via `MatchSnapshot`
- Web integration via `WebApplicationFactory`

## Rules
- `Mock<T>` is a record; never call `.Free`.
- Mocked interfaces may require `{$M+}` depending on RTTI needs.
- Prefer behavioral verification only where it adds signal; do not overspecify implementation details.
- Keep domain tests runnable without HTTP when business logic is independent of transport.
- For API examples, retain `.http`, PowerShell or integration-test coverage when useful.
- Snapshot tests are for stable structured output, not a substitute for semantic assertions.

## Test layering
1. domain/unit tests
2. service/application tests with mocks or lightweight fakes
3. web integration tests
4. end-to-end scripts where transport/environment behavior matters

## Best examples
- `Examples/07-UseCases/Web.HelpDesk/Tests`
- `Examples/07-UseCases/Web.TicketSales/Tests`
- `Examples/07-UseCases/Core.EventBusDemo/EventBusDemo.Tests.pas`
- `Examples/09-ActiveArchitecture/Desktop.BasicActiveArchitecture.Demo/Tests`

## Output checklist
1. name the behavior under test
2. isolate external dependencies
3. cover success + validation + failure paths
4. add precision round-trip tests for TBcd financial code
5. add concurrency/backpressure tests for pools/events when relevant
