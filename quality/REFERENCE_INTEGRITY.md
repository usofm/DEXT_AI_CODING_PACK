# Reference Integrity Gate

Use this gate to detect broken internal references and stale repository structure.

## Required Roots

- `agents/`
- `skills/`
- `prompts/`
- `examples/`
- `automation/`
- `quality/`
- `versioning/`
- `snapshots/`
- `full/`

## Required Agent Integrations

- `agents/README.md`
- `agents/CLAUDE.md`
- `agents/AGENTS.md`
- `agents/CURSOR_RULES.md`
- `agents/ANTIGRAVITY_RULES.md`
- `agents/AGENT_TASK_PLAYBOOK.md`

## Required Skills

- `skills/dext-web/SKILL.md`
- `skills/dext-orm/SKILL.md`
- `skills/dext-financial/SKILL.md`
- `skills/dext-fastpath/SKILL.md`
- `skills/dext-realtime/SKILL.md`
- `skills/dext-testing/SKILL.md`
- `skills/dext-mcp/SKILL.md`

## Required Task Templates

- `prompts/create-crud-api.md`
- `prompts/create-financial-module.md`
- `prompts/create-fast-endpoint.md`
- `prompts/create-realtime-feature.md`
- `prompts/create-mcp-server.md`
- `prompts/migrate-dmvc-to-dext.md`
- `prompts/review-dext-code.md`
- `prompts/create-test-suite.md`

## Example Evidence

- coverage matrix
- drift register
- cross-reference
- golden patterns
- Tier A deep audit
- per-group deep audits

## Versioning References

The release id, upstream SHA and snapshot date must agree across:

- `README.md`
- `CHANGELOG.md`
- `versioning/RELEASE_MANIFEST.md`
- `snapshots/DEXT_VERSION_SNAPSHOT.md`

## Rules

If a file is renamed, update all routers and integration files in the same change.

Do not leave an internal path in README, agents, skills, prompts, automation or quality docs unless that path exists on the release branch.
