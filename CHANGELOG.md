# Changelog

All notable changes to the DEXT AI Coding Pack are documented here.

The pack uses upstream-pinned versions in the form:

```text
vYYYY.MM.DD-dext-<shortsha>
vYYYY.MM.DD-rN-dext-<shortsha>  # pack-only revision
```

## [v2026.08.12-r3-dext-412ed292] - 2026-08-12

### Agent Behavior Correction

- added a Dext-native-first rule across the generic agent contract, ORM skill, CRUD prompt, decision tree and anti-patterns
- ordinary CRUD now defaults to scoped `TDbContext` + `IDbSet<T>` instead of a ceremonial Repository/provider-query stack
- Repository abstractions are explicitly optional and require a meaningful domain/integration reason
- manual `TFDQuery` / `TUniQuery` + ConnectionFactory layers are discouraged for ordinary CRUD already covered by Dext Entity
- standard application composition now explicitly considers `IStartup` + `App.UseStartup(...)`
- provider setup favors `AddDbContext<T>` plus native helpers such as `UsePostgreSQL`, `UseFirebird` or `UseConnectionDef`
- native Dext JWT/auth primitives are preferred before custom token wrappers
- exact financial entity guidance now also emphasizes `[Precision(P, S)]`

### Validation Improvements

- Agent Behavior Gate now checks Dext-native-first architecture
- executable validator checks for `TDbContext`, `IDbSet<T>`, `AddDbContext`, provider-helper, startup and native-auth guard vocabulary
- validator verifies that Repository is explicitly optional in the generic agent contract
- CRUD prompt now requires justification before generating a custom persistence adapter

### Practical Evidence

This correction came from a three-way audit of official Dext source/examples, this Pack, and the `DEXT_ENTERPRISE_STARTER` Golden Sample. The starter initially over-applied generic Delphi Repository/FireDAC patterns and was refactored back to native Dext Entity, startup and authentication patterns.

### Compatibility

Upstream Dext is unchanged:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

This is a pack-only behavior revision.

## [v2026.08.12-r2-dext-412ed292] - 2026-08-12

### Added

- dependency-free executable validator at `tools/validate_pack.py`
- GitHub Actions quality gate for pushes and pull requests
- scheduled upstream Dext drift monitor
- automatic drift issue creation/update
- guarded automatic tag and GitHub Release publisher
- release publisher refusal when upstream Dext moved
- idempotent tag/release behavior for existing releases
- `CONTRIBUTING.md`
- pull request quality/evidence template

### Validation Improvements

- required-file checks
- domain skill and task prompt checks
- 9-part full memory completeness check
- 4-part full symbol index completeness check
- README/manifest/snapshot/changelog version consistency
- release-notes/version consistency
- exact upstream SHA agreement across release metadata
- critical agent behavior guard checks
- preservation of the 50-example audit baseline

### Compatibility

Upstream Dext is unchanged from the canonical release:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

This is a pack-only hardening revision.

## [v2026.08.12-dext-412ed292] - 2026-08-12

### Added

- compact Dext architectural memory
- compact Dext API symbol index
- full memory split into 9 load-on-demand parts
- full symbol index split into 4 load-on-demand parts
- decision tree for API/architecture selection
- anti-pattern and drift guards
- reusable code recipes
- complete official Examples audit across 8 groups and 50 directory-level examples
- example coverage matrix
- example drift register
- Tier A architecture deep audit
- group deep audits for Basics, Web, Data, Advanced, UI, UseCases, AI and Active Architecture
- agent integration contracts for Claude Code, generic agents, Cursor and Antigravity
- agent task playbook
- domain skill router and 7 focused skills
- 8 task-oriented prompt templates
- automation refresh workflow
- change impact matrix
- consistency checklist
- changelog policy
- versioning policy
- release manifest
- quality/release gates

### Captured Upstream Changes

- first-class `TBcd` / `ftFMTBcd` support
- `BcdType` / `FmtBcdType`
- FastPath and direct UTF-8 database streaming
- DbContext pooling and pool RAII guidance
- bulk safety introspection
- feature flags
- forwarded headers
- antiforgery / CSRF
- Problem Details hardening
- cache/security middleware hardening
- PathBase support
- WebSocket receive limits
- WebApplication lifecycle constraints
- UniDAC/provider isolation guidance
- AI governance rules

### Drift Guards Added

- `{id}` route syntax over `:id`
- current `.pas` source over stale example README syntax
- `[MaxLength(N)]` over stale `[StringLength]` examples where repository-wide guidance applies
- typed DI over manual service locator patterns
- current RFC-oriented rate-limit header guidance over stale example headers
- `AcquireScoped` over manual pool release where current API supports it
- explicit distinction between event-management `Web.EventHub` and realtime Hubs

### Compatibility

Audited against:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

## Unreleased

Use this section only for pack-only changes that have not yet been assigned a release version.

When upstream Dext changes, do not keep those changes only under `Unreleased`; create a new upstream-pinned release entry after the refresh workflow completes.
