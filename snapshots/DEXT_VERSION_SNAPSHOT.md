# DEXT VERSION SNAPSHOT

- Source repository: `cesarliws/dext`
- Branch: `main`
- Audited HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
- Audited commit date: `2026-08-11`
- Snapshot date: `2026-08-12`
- Official example directories audited: `50`
- Official example groups audited: `8`

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

## Refresh rule

When source `main` moves:

1. update this snapshot with the new HEAD SHA/date;
2. compare commits since `412ed29207d2d1dc5d4a259a7739a615aed0c626`;
3. inspect public symbol/API changes under `Sources/`;
4. inspect `Docs/CONTRIBUTING_AI.md`, repository-wide Critical Rules, changed skills and finalized specs;
5. inspect changed official examples and update drift/coverage evidence;
6. refresh compact operational files;
7. refresh only affected `full/` parts;
8. verify README loading/reference flow.

Never silently retain obsolete method names, attributes, route syntax, ownership rules or middleware behavior in long-term coding memory.
