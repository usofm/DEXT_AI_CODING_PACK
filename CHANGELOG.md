# Changelog

All notable changes to the DEXT AI Coding Pack are documented here.

The pack uses upstream-pinned versions in the form:

```text
vYYYY.MM.DD-dext-<shortsha>
```

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
