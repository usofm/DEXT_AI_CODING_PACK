# AGENTS.md — Dext Agent Contract

This file defines repository-level behavior for coding agents using the Dext AI Coding Pack.

## Scope

Use this contract for any task that generates, edits, reviews, or explains Dext Delphi code.

## Mandatory First Reads

- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

## Evidence Before Code

Before emitting non-trivial Dext code:

1. identify the feature/subsystem
2. locate the public symbol in `DEXT_API_SYMBOL_INDEX.md`
3. identify the nearest official example in `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
4. inspect `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
5. prefer current `.pas` source over README syntax
6. verify current Dext source/skill if the exact API is uncertain

## No-Hallucination Rules

Do not infer exact Dext APIs from ASP.NET Core similarity.
Do not invent attributes, overloads, helper names, registration methods, middleware options, or compiler defines.
When uncertain, say what is verified and what still requires source confirmation.

## Architecture Defaults

Prefer:

```text
Endpoint/Controller
  -> Application Service / Manager
      -> Domain
          -> DbContext / Repository / External Integration
```

For large Minimal API applications, group routes into feature endpoint units instead of growing Startup into one monolithic file.

## Data Rules

- ORM query collections: `IList<T>`
- DbContext-owned child collections: non-owning collections when appropriate
- typed queries: `Prototype.Entity<T>` / smart properties
- reusable predicates: Specifications
- exact financial decimals: `TBcd` / `FmtBcdType`
- detached update: `.Update(Entity)` before `SaveChanges`
- bulk operations: check `IsBulk*Safe`
- raw SQL: parameterize; never concatenate untrusted input

## Web Rules

- `{id}` route syntax
- controller action route parameters start with `/`
- typed/generic DI over manual service locator
- normal pipeline first, FastPath selectively
- production exceptions must be sanitized
- forwarded headers require trusted proxies
- strict CORS when credentials are used
- authenticated/private responses must not be cached accidentally

## Concurrency and Lifetime

- prefer RAII/scoped pool leases
- respect DI/interface ownership
- do not `.Free` `Mock<T>`
- bound producer/consumer channels and websocket receives when needed
- do not restart a stopped WebApplication instance

## Example Trust Model

Tier A = architecture
Tier B = focused feature
Tier C = low-level/internals

The example source is evidence, not an immutable API contract. Current Dext source wins when they diverge.

## Context Budget

Start compact. Escalate only when needed:

- compact root docs first
- example audit docs second
- `full/` memory/symbol parts only for deep tasks

## Completion Standard

A Dext answer is considered complete when it:

- uses current verified symbols or clearly marks uncertainty
- avoids known drift/anti-patterns
- follows Dext ownership/lifetime rules
- uses the appropriate example tier
- preserves exact decimal semantics for exact domains
- does not copy demo-only security settings into production guidance
