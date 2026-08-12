# 91. Minimal Always-Loaded Agent Directive

If context budget is small, load this compact directive:

```text
You are coding against the Dext Framework (github.com/cesarliws/dext).

Use Dext idioms, not generic Delphi patterns, when Dext provides the capability.

Source-of-truth priority:
source > tests > Docs/skills > Docs/Book > feature index > specs > examples > articles.

Before coding, load the relevant Docs/skills/dext-*.md file.

Critical rules:
- routes use /{id}, never /:id
- controller subroutes start with /
- never name a controller action Create
- use DI, not RequestServices service location
- use IList<T>, not TObjectList<T>, for Dext ORM results
- use MaxLength, not StringLength
- use Prop<Nullable<T>> for nullable smart entity fields
- enable DbContext pooling for Web APIs when supported
- detached entities require explicit Update before SaveChanges
- Mock<T> is a record; never Free it
- include Dext.Entity.Core when IDbSet<T> generics require it
- call SetConsoleCharSet in Dext console/test/CLI projects
- preserve uses order Dext -> Dext.Entity -> Dext.Web when helpers matter
- prefer IntType/StringType/DoubleType/BoolType aliases for smart entity properties
- HTTP QUERY is supported through MapQuery/TRestClient.Query where current APIs expose it

Architecture:
controllers/endpoints are thin; business logic belongs in application/domain services.
Prefer typed Fluent Query, DbContext, DI, TDextJson, Dext.Threading, Dext.Net.RestClient, Dext collections.
Respect ownership, scopes, pooling, thread safety, and zero-allocation hot-path design.
Do not invent Dext API names; verify current source.
```

---

# 92. Final Agent Principle

The core philosophy of Dext can be summarized as:

> **Modern architecture without abandoning Delphi. Native performance without returning to unsafe pointer-heavy application code. RAD productivity without coupling the UI to infrastructure. Strong typing instead of magic strings. Framework-provided infrastructure so application code can focus on business behavior.**

When an AI agent proposes Dext code, the code should look like it belongs in the Dext ecosystem—not like generic Delphi code with Dext unit names pasted on top.

---

# 92A. Recent Commit Audit — Main Branch

The following recent history was explicitly reviewed when enriching this memory.

## 2026-08-11 — Web Security / Testing / Feature Flags

### `412ed292` — Merge PR #187
Merged the web-features review line.

### `d905197b` — Feature flags, forwarded headers, antiforgery, WebApplicationFactory

Introduced:

```text
Dext.FeatureFlags
IFeatureManager
percentage rollout
time-window filters

Dext.Web.ForwardedHeaders
zero-trust reverse proxy parsing

Dext.Web.Antiforgery
HMAC-SHA256 CSRF protection
constant-time token validation

Dext.Testing.WebApplicationFactory
```

Agent implications:

- load feature flags through the framework rather than custom boolean configuration scattered throughout code
- forwarded headers are a trust-boundary problem, not a string-parsing convenience
- use constant-time comparison for security tokens
- prefer integration tests through WebApplicationFactory where suitable

---

## 2026-08-10 — Exact Decimal / Pooling / Fast Streaming

### `fcb204ba` — First-class `TBcd` / `ftFMTBcd`

Introduced or hardened:

- TBcd converters
- precision/scale-aware SQL typing
- `Param.AsFMTBCD`
- `BcdType` / `FmtBcdType`
- conversion overflow checks

For accounting/finance code, exact decimal paths are first-class Dext behavior.

### `45bf6fb4` — `TDextPool<T>` concurrency + RAII + FastPath streaming

Important additions:

```text
IPooledObject<T>
AcquireScoped
drain-before-free
active waiter tracking
manual-reset broadcast
monotonic acquisition timeout
MapFast pool-exhaustion -> HTTP 503
direct TDextFastQuery streaming
```

This is one of the most important recent architecture commits for high-throughput services.

### `29526846` — Delphi 10.4 build fix

This indicates compatibility work is active. Do not assume syntax/API that compiles only on the newest compiler when contributing to framework internals without checking supported compiler targets.

### `0cac30a2` — Dynamic `toc.js` documentation navigation

`dext doc` HTML now centralizes generated navigation in `toc.js`, reducing huge documentation diffs and allowing `file://` browsing without CORS-related fetch issues.

---

## 2026-08-09 — FastPath ORM Integration

### `5ed4a118` — WebBroker/gRPC `WriteJson`, bulk-safety, optional Entity integration

Key additions:

```text
Status(Code, Message)
WriteJson(...)
IsBulkInsertSafe
IsBulkUpdateSafe
IsBulkDeleteSafe
DEXT_ENABLE_ENTITY
```

### `03c39c3d` / `017c5531` — Pooled FastPath ORM and documentation

Introduced/finalized the pattern where `MapFast<TDbContext>` acquires a pooled context and `IDbSetFastStream` writes data directly as UTF-8 JSON.

Agent takeaway:

- FastPath + pooled context + direct streaming is an intentional integrated performance stack.
- It should be used selectively, not as a replacement for all normal routes.

---

## 2026-08-08 — Linux epoll Response Correctness

### `8e9bced6`

Fixed Linux native server response ordering and `Content-Length` calculation by separating the serialized header buffer from body segments before `writev`/TLS output.

Architecture lesson:

- network response writers must preserve `[headers][body]` wire order
- header calculation cannot occur before body length is known when using content-length responses
- partial-write cursors must account for header bytes

An AI modifying low-level server output must maintain this invariant.

---

## 2026-08-06 — Middleware Hardening

### `fa0d86a3`

Major web middleware hardening/documentation synchronization included:

- RFC 9457 Problem Details
- RFC 9333 RateLimit headers
- strict CORS preflight validation
- sensitive-header redaction
- production exception sanitization
- authenticated/private response cache protections
- GZip/Brotli
- security headers
- richer WebSocket/Hubs protocol docs
- testing history/telemetry and IDE testing features

This commit establishes the current production-security assumptions for generated Dext Web applications.

---

## 2026-08-04 — FastQuery / Benchmarks / Generic Pool Spec

### `bf3c6d28`

Integrated `TDextFastQuery` directly with `TUtf8JsonWriter`, removing custom intermediate formatting and redundant helper layers.

### `1deb1696`

Added PostgreSQL benchmark coverage and S57 FastPath ORM hydration/streaming spec.

### `40190c39`

Added scoped-DI endpoint benchmarking, per-request context isolation and step-level tracing.

### `9d3438bb`

Introduced the major FastPath primitives:

```text
MapFast
SendJsonUtf8
GetOutputStream
TDbContext.UseSql
IDextFastQuery
direct UTF-8 SQL streaming
```

The commit's benchmark suite reported substantial gains in its tested environment, but those numbers are environment-specific and must not be presented as universal performance guarantees.

### `422ad70a`

Documented interface-scoped RAII pool lease (`IPooledObject<T>` / GetLease-style pattern), later implemented through the pool API.

---

## 2026-08-03 — UniDAC Isolation / Base Path / AI Governance

### `cc5a6ed9`

Moved UniDAC integration into:

```text
Community/Drivers/UniDAC
```

and deliberately removed UniDAC-specific conditionals from Dext core.

This is architecturally important:

> Third-party database drivers should remain isolated from core abstractions.

The related S56 design direction is toward a cleaner driver factory/DI abstraction.

### `68589a23`

Added:

```text
UsePathBase
Request.PathBase
Request.ToAppUrl
TDextPathBaseMiddleware
HTTP.sys PathBase kernel prefix binding
```

### `167d4134`

Added official `AI_GOVERNANCE.md`.

---

## 2026-07-31 — Host Lifecycle and WebSocket Safety

### `63c7c40c`

A stopped `WebApplication` cannot be restarted; create a fresh instance.

### `2f5e7b60`

Made teardown single-run and fixed concurrent Stop/teardown host lifetime race.

### `3adf97a8`

Hubs now honor `MaximumReceiveMessageSize` in the WebSocket receive loop.

These commits are especially relevant for:

- VCL-hosted Dext servers
- Windows Service hosting
- long-lived background hosts
- real-time servers exposed to untrusted clients

---

# 92B. Commit-Derived Agent Decision Rules

Add these to the AI agent's permanent working behavior:

1. **Normal route first, FastPath selectively.**
2. Use `MapFast` only where DI/RTTI/hydration overhead is materially relevant.
3. Prefer direct UTF-8 streaming when no entity/domain object is needed.
4. Prefer `AcquireScoped`/RAII for pooled objects.
5. Treat pool exhaustion as backpressure; HTTP 503 is a valid failure mode.
6. Check `IsBulk*Safe` before aggressive bulk substitution.
7. Preserve `DEXT_ENABLE_ENTITY` modularity in Web internals.
8. For exact decimals, preserve TBcd precision/scale end-to-end.
9. Use PathBase APIs rather than hardcoded deployment prefixes.
10. Trust forwarded headers only from configured/trusted proxies.
11. Use RFC 9457 semantics for Problem Details.
12. Never cache authenticated/private HTTP responses by accident.
13. Follow strict CORS credential/origin rules.
14. Bound WebSocket receive sizes.
15. Treat WebApplication instances as single lifecycle objects: start, stop, discard.
16. Keep third-party drivers such as UniDAC isolated from framework core.
17. Benchmark actual target DB/OS/compiler before claiming performance.
18. Do not copy external source into Dext without provenance/license review.
19. When changing server internals, verify both Windows and Linux engine behavior.
20. Update `Docs/skills` when a framework change changes how an AI should write Dext code.

---

# 92C. Gap Audit Notes

After the TBcd Smart Property alias correction, a second comparison was made
against the current exhaustive feature index.

Items explicitly added during this audit:

```text
BcdType = Prop<TBcd>
FmtBcdType = Prop<TBcd>
Dext.Mapper / TMapper
TEntityType<T>
IOptionsMonitor<T>
IOptionsSnapshot<T>
IChangeToken / OnReload
ILifetime<T> / TLifetime<T>
IDeferred / TDeferredAction
Windows Processor Groups support
Dext.Testing.History
test OpenTelemetry listener
RAD Studio Test Explorer / coverage tooling
dext index public symbol indexing
```

The purpose of this section is also a warning to AI agents:

> This memory is a high-value architectural map, not a substitute for the
> current source tree. When exact overloads, attributes, compiler directives,
> or recently-added APIs matter, verify the current source/official skill
> before generating code.

# 92D. Symbol-Level Audit Findings

A symbol/API-oriented audit was performed against:

- current main tree at `412ed292...`
- exhaustive feature index
- agent skills index
- collections skill
- validation skill
- testing skill
- background skill
- logging skill
- advanced ORM skill
- examples index

High-value omissions corrected during this pass:

```text
IOrderedDictionary<K,V>
IFrozenList<T> / IFrozenDictionary<K,V>
IChannel<T>
ORM non-owning collection rule
TValidationPatterns
persistent BackgroundJobs / TDextJobs
IHostedService / AddHostedService
async logging / RingBuffer path
TBatchOptions
Seq / OTLP logging sinks
typed JoinInner/Left/Right/Full/Cross
TPH / TPT inheritance mapping
migration CLI commands
custom ORM TypeConverter registry
stored-procedure parameter directions
pessimistic TLockMode
shadow properties
official dext-examples architecture index
```

A documentation conflict was also detected:

```text
Docs/skills/README.md: NEVER use [StringLength], use [MaxLength(N)]
dext-validation.md: still shows [StringLength(...)] examples
```

The repository-level Critical Rules must win until the focused validation skill is synchronized with the source/current conventions.
