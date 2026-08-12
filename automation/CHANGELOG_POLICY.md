# DEXT Pack Changelog Policy

Record only upstream changes that materially affect how an AI agent should design, generate, review, test or migrate Dext code.

## Include

- new/removed/renamed public APIs
- changed signatures or defaults
- security behavior changes
- lifecycle/ownership changes
- ORM mapping/query/write semantics
- exact decimal/TBcd behavior
- routing/model-binding changes
- FastPath/pooling/streaming guidance
- testing APIs and mock lifecycle changes
- MCP/realtime/EventBus changes
- official skill/spec rule changes
- example changes that alter canonical patterns or reveal drift

## Exclude by default

- typo-only docs changes
- formatting-only changes
- internal refactors with no agent-visible behavior change
- generated-file noise
- benchmark number changes without architectural consequence

## Entry format

```markdown
## YYYY-MM-DD — upstream <short-sha>

### Added
- ...

### Changed
- ...

### Removed / Deprecated
- ...

### Agent Impact
- skill: `skills/dext-web/SKILL.md`
- prompt: `prompts/create-crud-api.md`
- examples: `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

### Verification
- source unit / spec / official example inspected
```

## Rule

Do not describe a feature as current merely because it appeared in a commit message. Changelog entries must be grounded in the current upstream source/spec/example state.
