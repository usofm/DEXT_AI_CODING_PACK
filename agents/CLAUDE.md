# CLAUDE.md — Dext AI Coding Pack

This repository is a curated reasoning and reference pack for coding against the Dext Delphi framework.

## Mission

Generate Dext code that is current, idiomatic, source-verified, ownership-safe, and aligned with official repository patterns.

## Always Load First

1. `DEXT_DECISION_TREE.md`
2. `DEXT_ANTI_PATTERNS.md`

Then load only what the task needs.

## Reference Order

When exact syntax matters, use this precedence:

1. Current `cesarliws/dext` source
2. `Docs/CONTRIBUTING_AI.md` and repository-wide critical rules
3. Finalized specs
4. Official Dext skills
5. Current official example `.pas` source
6. Example README/documentation
7. Feature index
8. This pack
9. Analogy with ASP.NET Core or other frameworks

Never invent a Dext API because a similar .NET API exists.

## Agent Workflow

```text
User task
  -> classify with DEXT_DECISION_TREE.md
  -> check DEXT_ANTI_PATTERNS.md
  -> locate symbol in DEXT_API_SYMBOL_INDEX.md
  -> locate best example in examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
  -> check examples/DEXT_EXAMPLE_DRIFT_REGISTER.md
  -> inspect current example source
  -> inspect current Dext skill/source when exact signature matters
  -> generate code
```

## Load-on-Demand Guidance

Use compact root files by default.

Load `full/DEXT_AI_MEMORY_ENRICHED_PART_*.md` only for deep architectural context or historical evidence.
Load `full/DEXT_API_SYMBOL_INDEX_PART_*.md` only when the compact symbol index is insufficient.

Do not flood context with all full parts unless the task genuinely requires it.

## Critical Dext Rules

- Route parameters use `{id}`, not `:id`.
- Controller route parameters start with `/`, e.g. `[HttpGet('/{id}')]`.
- Do not name controller methods `Create`; use a domain-specific action name.
- Prefer typed/generic DI injection instead of manual request service lookup.
- Use `IList<T>` for ORM results; do not substitute `TObjectList<T>`.
- Prefer `[MaxLength(N)]` over stale `[StringLength]` examples.
- Use `Prop<Nullable<T>>` for nullable smart properties.
- For Web DbContexts, prefer `.WithPooling(True)` where applicable.
- For detached entities, call `.Update(Entity)` before `SaveChanges`.
- `Mock<T>` is a record; never `.Free` it.
- Keep helper order compatible with repository guidance: `Dext`, `Dext.Entity`, `Dext.Web`.
- Use `FmtBcdType`/`BcdType` for exact high-precision decimal domains.
- Prefer `AcquireScoped` over manual pool acquire/release when available.
- Use normal endpoints first; use `MapFast` only for measured hot paths.
- Trust forwarded headers only from configured trusted proxies.
- Never combine permissive CORS origins with credentials.
- Never leak raw production exception messages.
- Bound WebSocket receive size.
- A stopped `WebApplication` instance is discarded, not restarted.
- Keep third-party DB drivers isolated from core/domain layers.

## Example Trust

- Tier A: architecture/composition reference
- Tier B: focused feature/API reference
- Tier C: protocol/performance/framework-internal reference

Never generalize Tier C style into normal app architecture.

## Known Example Drift

Before copying syntax from examples, read `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`.
Known drift includes old route syntax, stale validation attributes, manual DI, old rate-limit headers, older controller attribute names, and manual pool handling.

## Preferred Architecture

```text
Transport
  -> Application/Service
      -> Domain
          -> Data/Integration
```

Keep significant business rules out of route lambdas/controllers.

## Financial Precision

For exact financial, FX, gold, crypto, quantity, or rate data that needs scale beyond 4 decimals:

```pascal
FmtBcdType = Prop<TBcd>;
```

Preserve exact decimal precision end-to-end. Do not downgrade to `Double` or `Currency` by convenience.

## Verification Discipline

If an exact overload, attribute, unit name, compiler define, middleware option, or new feature is uncertain, verify it against current source before generating code.
