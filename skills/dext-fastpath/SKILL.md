# Skill: Dext FastPath / Performance

Use for measured hot routes, direct SQL projection, zero/low-allocation response paths, pooled DbContext access, direct UTF-8 JSON streaming and native-server performance work.

## Load first
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_03_DATA_DEEP_AUDIT.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Best examples
- `Examples/03-Data/Web.FastPath.OrmPool`
- `Examples/02-Web/Web.NativeServer`
- low-level performance examples only as Tier C evidence

## Rules
- Normal Dext pipeline is the default.
- Use `MapFast` only after identifying a measured hot path.
- If no domain/entity object is needed, prefer projection/direct streaming over hydration.
- Prefer `AcquireScoped` / RAII lease patterns when current source supports them; do not copy older manual `Acquire/Release` blindly.
- Pool exhaustion is backpressure, not a reason for unbounded allocation.
- Preserve `DEXT_ENABLE_ENTITY` conditional behavior where applicable.
- Benchmark on the actual compiler, OS, database and driver; example numbers are not universal.
- Do not turn Tier C internals into normal application architecture.

## Decision
Normal business endpoint -> standard pipeline.
Hot endpoint but domain behavior required -> optimize selectively, retain domain boundaries.
Hot read-only projection -> `MapFast` + `UseSql` / `IDextFastQuery` + direct UTF-8 response path.

## Output checklist
1. state why FastPath is justified
2. identify what is bypassed
3. preserve validation/security semantics explicitly
4. use bounded pooling/backpressure
5. add benchmark and correctness test
