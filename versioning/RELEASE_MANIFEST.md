# DEXT AI Coding Pack Release Manifest

## Current Release

```text
Pack version:          v2026.08.12-r3-dext-412ed292
Pack release date:     2026-08-12
Upstream repository:   cesarliws/dext
Upstream branch:       main
Upstream full SHA:     412ed29207d2d1dc5d4a259a7739a615aed0c626
Upstream short SHA:    412ed292
Upstream commit date:  2026-08-11
```

## Revision Type

`r3` is a pack-only agent-behavior correction. The audited upstream Dext SHA did not change.

This revision hardens a practical rule discovered while validating the Pack against a real Golden Starter: **prefer native Dext mechanisms before introducing generic Delphi framework wrappers**.

Changes added in this revision:

- Dext-native-first agent contract
- explicit ordinary-CRUD path through `TDbContext` / `IDbSet<T>`
- Repository abstraction made optional rather than ceremonial
- guard against manual `TFDQuery` / `TUniQuery` repository stacks for ordinary Dext Entity CRUD
- native provider registration guidance (`AddDbContext`, `UsePostgreSQL`, `UseFirebird`, `UseConnectionDef`)
- official `IStartup` / `UseStartup` composition guidance
- native JWT/auth preference (`IJwtTokenHandler`, `TJwtTokenHandler`, `TClaimsBuilder`, `RequireAuthorization`)
- strengthened CRUD task template, ORM skill, decision tree and anti-patterns
- executable validator checks for the new behavior guards

## Audit Coverage

```text
Official example groups audited: 8
Official directory-level examples audited: 50
Full memory parts: 9
Full symbol index parts: 4
Domain skills: 7
Task prompt templates: 8
Agent integrations: 4 primary tool contracts + playbook
Automation/refresh controls: enabled
Quality/release gates: enabled
CI self-validation: enabled
Upstream drift monitor: enabled
Guarded release publisher: enabled
Dext-native-first guard: enabled
```

## Major Upstream Features Captured

- first-class `TBcd` / `ftFMTBcd`
- `BcdType` / `FmtBcdType`
- dynamic precision/scale handling
- FastPath routing and direct UTF-8 streaming
- DbContext pooling patterns
- `TDextPool<T>` scoped/RAII lease guidance
- bulk safety introspection
- feature flags
- forwarded headers
- antiforgery / CSRF
- RFC 9457 Problem Details behavior
- response cache hardening
- PathBase support
- WebSocket receive limits
- WebApplication stop/discard lifecycle
- provider isolation including UniDAC community driver boundary
- AI governance and repository agent rules

## Pack Domains

### Agents

- Claude Code
- generic agents
- Cursor
- Antigravity/Gemini

### Skills

- Web
- ORM
- Financial/TBcd
- FastPath
- Realtime/Event Bus
- Testing
- MCP

### Prompt Templates

- CRUD API
- financial module
- fast endpoint
- realtime feature
- MCP server
- DMVC migration
- code review
- test suite

## Known Drift / Behavior Guards

- use `{id}`, not `:id`
- prefer `[MaxLength(N)]` over stale `[StringLength]` examples per repository-wide guidance
- prefer typed endpoint/controller DI over manual service lookup
- distinguish RFC-oriented `RateLimit-*` from stale `X-RateLimit-*` examples
- prefer `AcquireScoped` where current API supports it
- current source syntax beats stale example README syntax
- `Web.EventHub` is an event-management application, not the Hubs realtime feature demo
- ordinary Dext Entity CRUD defaults to `TDbContext` + `IDbSet<T>`
- custom provider repositories require a concrete reason
- prefer native Dext auth/startup facilities before wrappers

## Compatibility Statement

This release is audited against exactly:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

For a different Dext revision, run the refresh workflow before treating this pack as authoritative.

## Validation Status

- [x] upstream HEAD rechecked for the audited baseline
- [x] examples audited
- [x] drift register created
- [x] compact files created
- [x] full memory preserved
- [x] full symbol index preserved
- [x] domain skills created
- [x] task prompts created
- [x] agent integrations created
- [x] refresh workflow created
- [x] quality gates created
- [x] executable validator created
- [x] CI quality gate created
- [x] upstream drift monitor created
- [x] guarded release publisher created
- [x] contribution/PR controls created
- [x] Dext-native-first behavior correction added
- [x] Golden Starter feedback loop incorporated
- [x] README synchronized for r3

## Release Notes

```text
releases/v2026.08.12-r3-dext-412ed292.md
```

## Next Release Rule

If upstream Dext moves, create a new canonical version using the new upstream short SHA.

If only the pack changes, increment the `-rN-` pack revision while preserving the same upstream SHA.
