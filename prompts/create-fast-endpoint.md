# Task Template — Create / Optimize a Dext Fast Endpoint

## Goal

Implement or optimize a measured hot endpoint without turning the entire application into a low-level FastPath design.

## Load first

- `skills/dext-fastpath/SKILL.md`
- `skills/dext-web/SKILL.md`
- `skills/dext-orm/SKILL.md` when DB access is involved
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Preconditions

Do not choose `MapFast` only because it sounds faster.

Establish first:

1. current latency/throughput baseline
2. allocation/hydration bottleneck
3. whether domain/entity materialization is actually needed
4. whether normal middleware/DI/model binding can be bypassed safely
5. expected concurrency and pool capacity

## Preferred optimization ladder

```text
normal endpoint
  -> fix query/indexing
  -> reduce payload/projection
  -> avoid unnecessary entity hydration
  -> direct SQL projection / IDextFastQuery
  -> direct UTF-8 streaming
  -> MapFast only when measured and justified
```

## Pooling rule

Prefer scoped/RAII lease APIs such as `AcquireScoped` when current source supports them. Do not copy stale manual `Acquire/Release` examples blindly.

Pool exhaustion is backpressure; for HTTP, 503 can be an appropriate failure mode.

## Deliverables

Produce:

- baseline description
- optimized route implementation
- pool/query configuration
- explicit bypassed features/risks
- benchmark or load-test plan
- fallback/error behavior

## Verification checklist

- FastPath is limited to the hot route
- no required auth/security/middleware behavior was accidentally bypassed
- query is parameterized
- pool lifetime is safe
- response serialization does not reintroduce avoidable allocations
- benchmark is run against the actual compiler/OS/database environment
