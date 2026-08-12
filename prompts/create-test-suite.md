# Task Template — Create a Dext Test Suite

## Goal

Create a focused unit/integration regression suite for a Dext feature.

## Load first

- `skills/dext-testing/SKILL.md`
- relevant domain skill
- `DEXT_ANTI_PATTERNS.md`

## Test layers

Choose the smallest useful layers:

```text
pure domain rules         -> unit tests
service/application logic -> unit tests with mocks/fakes
serialization/output      -> snapshot tests when useful
web pipeline/routes       -> WebApplicationFactory/integration tests
end-to-end HTTP flow      -> .http / PowerShell/curl automation
```

## Mocking rules

`Mock<T>` is a record. Never call `.Free` on it.

Verify interface RTTI requirements such as `{$M+}` when current mocking support requires them.

Prefer testing domain behavior without booting a web server when the web layer is irrelevant.

## Required edge cases

Include relevant cases for:

- validation failure
- not-found/conflict state
- authorization boundary
- transaction/concurrency rule
- exact numeric precision
- serialization/binding
- ownership/lifetime-sensitive behavior
- error mapping

## Deliverables

Produce:

- test project/unit layout
- setup/teardown
- mocks/fakes
- unit tests
- integration tests if needed
- snapshot artifacts if justified
- command/runner instructions

## Verification checklist

- tests assert behavior, not internal implementation unnecessarily
- mocks are not manually freed
- deterministic data/time handling is used where needed
- database tests isolate state
- web tests cover status code + body + relevant headers
- regression tests are added for any bug being fixed
