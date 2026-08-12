# ANTIGRAVITY_RULES.md — Dext Antigravity Guidance

Use this document as the root instruction source for Antigravity/Gemini-style coding agents working with Dext.

## Core Context

Always provide:
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

Retrieve on demand:
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_CODE_RECIPES.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
- relevant group deep audit
- `full/` parts only for deep work

## Mandatory Reasoning Discipline

Before generating Dext code:

```text
classify feature
-> locate Dext symbol
-> locate best official example
-> check drift register
-> inspect current source when exact syntax matters
-> generate minimal verified code
```

## Non-Negotiable Rules

- Never invent Dext APIs from framework analogy.
- Routes use `{id}`, not `:id`.
- Controller action routes use `/...`.
- Prefer typed/generic DI injection.
- ORM result collections use `IList<T>`.
- Prefer `[MaxLength(N)]` over stale `[StringLength]` examples.
- Nullable smart properties use `Prop<Nullable<T>>`.
- Web DbContexts should use pooling where appropriate.
- Detached entities require `.Update(Entity)` before `SaveChanges`.
- `Mock<T>` is a record and is not freed.
- Exact decimals use `TBcd`/`FmtBcdType` when scale matters.
- Prefer scoped/RAII pooling (`AcquireScoped`) when available.
- `MapFast` is an optimization path, not the default architecture.
- Do not trust arbitrary forwarded headers.
- Do not use permissive credentialed CORS.
- Do not leak internal production exception details.
- Do not restart a stopped WebApplication instance.
- Keep provider-specific database code isolated.

## Example Selection

- Tier A: use for architecture/composition
- Tier B: use for feature/API syntax
- Tier C: use for internals/performance only

When README and source disagree, current `.pas` source wins for syntax.

## Output Preference

Produce code that is:
- Delphi-native
- explicit about ownership
- strongly typed
- parameterized for SQL
- testable without the web server where business logic is involved
- conservative with context and dependencies

## Context Efficiency

Do not preload all `full/` files. Use the compact files to route the task, then load only the matching full part if the compact evidence is insufficient.
