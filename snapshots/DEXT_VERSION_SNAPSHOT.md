# DEXT VERSION SNAPSHOT

- Pack version: `v2026.08.12-r3-dext-412ed292`
- Source repository: `cesarliws/dext`
- Branch: `main`
- Audited HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
- Audited commit date: `2026-08-11`
- Snapshot date: `2026-08-12`
- Official example directories audited: `50`
- Official example groups audited: `8`

## Release Identity

Canonical release metadata is stored in:

```text
versioning/RELEASE_MANIFEST.md
versioning/VERSIONING_POLICY.md
CHANGELOG.md
releases/v2026.08.12-r3-dext-412ed292.md
```

Compatibility is anchored to the exact upstream SHA, not merely the date or branch name.

## Pack Revision State

`r3` preserves the same upstream compatibility anchor and adds an agent-behavior correction derived from practical Golden Starter validation.

Primary r3 guard:

```text
Prefer native Dext mechanisms before generic Delphi framework wrappers.
```

For ordinary persistence:

```text
Application Service / Manager
  -> scoped TDbContext
      -> IDbSet<TEntity>
          -> Dext Entity ORM
```

A manual Repository + provider query + ConnectionFactory layer is no longer a default recommendation when Dext Entity already covers the requirement.

Native composition/auth guidance now also emphasizes:

- `IStartup` / `App.UseStartup(...)`
- `AddDbContext<TContext>`
- native provider helpers such as `UsePostgreSQL` / `UseFirebird` / `UseConnectionDef`
- `.WithPooling(True)` for appropriate Web workloads
- Smart Properties / `Prototype.Entity<T>`
- `IJwtTokenHandler` / `TJwtTokenHandler`
- `TClaimsBuilder`
- `UseJwtAuthentication`
- `RequireAuthorization`

## Recent architecture changes captured by this pack

- first-class `TBcd` / `ftFMTBcd` precision support
- `BcdType = Prop<TBcd>`
- `FmtBcdType = Prop<TBcd>`
- dynamic high-precision decimal mapping/binding awareness
- FastPath routing and direct UTF-8 database streaming
- DbContext pooling for FastPath/Web workloads
- generic `TDextPool<T>` with scoped/RAII lease pattern
- bulk safety introspection on `IDbSet<T>`
- forwarded headers hardening
- antiforgery / CSRF support
- feature flags
- RFC 9457 Problem Details behavior
- response-cache hardening
- PathBase / reverse-proxy prefix support
- WebSocket receive limits and transport hardening
- WebApplication stop/discard lifecycle semantics
- UniDAC isolation under Community drivers
- AI governance and contribution rules
- Event Bus and scoped Event Bus patterns
- typed `IEventPublisher<T>` capability pattern
- server-rendered Web / HTMX / WebStencils architecture
- MCP Tools / Resources / Prompts reference patterns
- desktop MVVM, MVU and Active Architecture routing
- multipart upload/download security guidance
- multi-tenancy tenant-resolution/isolation guidance

## Example audit state

The `Examples/` tree was audited by group and consolidated into:

```text
examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md
examples/DEXT_EXAMPLE_DRIFT_REGISTER.md
examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md
examples/DEXT_TIER_A_DEEP_AUDIT.md
examples/DEXT_01_BASICS_DEEP_AUDIT.md
examples/DEXT_02_WEB_DEEP_AUDIT.md
examples/DEXT_03_DATA_DEEP_AUDIT.md
examples/DEXT_04_ADVANCED_DEEP_AUDIT.md
examples/DEXT_05_UI_DEEP_AUDIT.md
examples/DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md
examples/DEXT_08_AI_DEEP_AUDIT.md
examples/DEXT_09_ACTIVE_ARCHITECTURE_DEEP_AUDIT.md
```

Known drift is intentionally tracked instead of silently normalizing stale examples. Current source and repository-wide Critical Rules remain higher authority than example README text.

## Full artifact preservation

The complete long-form artifacts are preserved as numbered files under `full/`:

```text
DEXT_AI_MEMORY_ENRICHED_PART_01.md ... PART_09.md
DEXT_API_SYMBOL_INDEX_PART_01.md ... PART_04.md
```

Root memory/index files are compact operational versions. `full/` is the exhaustive reference set.

## Continuous validation

Repository automation enforces:

```text
push / pull request
  -> .github/workflows/quality-gate.yml
  -> tools/validate_pack.py

scheduled daily
  -> .github/workflows/upstream-drift.yml
  -> compare audited SHA with upstream main

successful quality gate on main
  -> .github/workflows/publish-release.yml
  -> revalidate
  -> verify upstream did not move
  -> create missing tag/release only
```

The validator now also checks Dext-native persistence/startup/auth guidance across the operational agent contract, ORM skill, CRUD prompt, anti-patterns and decision tree.

## Refresh rule

When source `main` moves, follow `automation/REFRESH_WORKFLOW.md` and `automation/CHANGE_IMPACT_MATRIX.md`.

Required close-out sequence:

```text
compare old SHA -> new HEAD
  -> update affected pack areas only
  -> run automation/CONSISTENCY_CHECKLIST.md
  -> run quality gates
  -> update this snapshot
  -> update versioning/RELEASE_MANIFEST.md
  -> update CHANGELOG.md
  -> assign a new upstream-pinned pack version
```

Never silently retain obsolete method names, attributes, route syntax, ownership rules, middleware behavior or abstraction defaults in long-term coding memory.
