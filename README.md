# DEXT AI CODING PACK

This pack is optimized for AI coding agents working with the Dext Delphi framework.

## Current Release

```text
v2026.08.12-r2-dext-412ed292
```

Compatibility anchor:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

`r2` is a pack-only hardening revision. The audited upstream Dext revision is unchanged.

Release metadata and history:

- `versioning/RELEASE_MANIFEST.md`
- `versioning/VERSIONING_POLICY.md`
- `versioning/README.md`
- `CHANGELOG.md`
- `releases/v2026.08.12-r2-dext-412ed292.md`

Do not interpret this release as compatible with an arbitrary future `main`; run the refresh workflow when upstream moves.

## Continuous Validation and Release Automation

The repository now validates itself:

```text
push / pull request
  -> .github/workflows/quality-gate.yml
  -> python tools/validate_pack.py

scheduled daily
  -> .github/workflows/upstream-drift.yml
  -> compare audited Dext SHA with cesarliws/dext/main
  -> open/update drift issue when changed

successful quality gate on main
  -> .github/workflows/publish-release.yml
  -> revalidate
  -> refuse if upstream moved
  -> create missing immutable tag
  -> create missing GitHub Release
```

Contribution controls:

- `CONTRIBUTING.md`
- `.github/PULL_REQUEST_TEMPLATE.md`

The publisher is intentionally idempotent: an existing version tag or release is never silently moved or replaced.

## Core Files

Root files are intentionally compact and fast to load:

- `DEXT_AI_MEMORY_ENRICHED.md` — compact architectural/behavioral memory
- `DEXT_API_SYMBOL_INDEX.md` — compact symbol/API lookup
- `DEXT_DECISION_TREE.md` — choose the right Dext subsystem/API
- `DEXT_ANTI_PATTERNS.md` — common mistakes, drift guards and forbidden patterns
- `DEXT_CODE_RECIPES.md` — compact implementation patterns

## Agent Integrations

Tool-facing instruction files live under `agents/`:

- `agents/CLAUDE.md` — Claude Code-oriented guidance
- `agents/AGENTS.md` — generic repository-level agent contract
- `agents/CURSOR_RULES.md` — Cursor rule source
- `agents/ANTIGRAVITY_RULES.md` — Antigravity/Gemini guidance
- `agents/AGENT_TASK_PLAYBOOK.md` — task-oriented routing
- `agents/README.md` — recommended wiring and context-loading strategy

These integrations deliberately use the compact root files first and escalate into `skills/`, `prompts/`, `examples/` or `full/` only when a task requires deeper evidence.

## Domain Skill Pack

Small task-focused skills live under `skills/`:

- `skills/dext-web/SKILL.md`
- `skills/dext-orm/SKILL.md`
- `skills/dext-financial/SKILL.md`
- `skills/dext-fastpath/SKILL.md`
- `skills/dext-realtime/SKILL.md`
- `skills/dext-testing/SKILL.md`
- `skills/dext-mcp/SKILL.md`
- `skills/README.md` — skill router

Agent rule: route the task to the smallest relevant skill first, then load prompts/examples/full artifacts only if needed.

## Prompt / Task Templates

Operational workflow templates live under `prompts/`:

- `prompts/create-crud-api.md`
- `prompts/create-financial-module.md`
- `prompts/create-fast-endpoint.md`
- `prompts/create-realtime-feature.md`
- `prompts/create-mcp-server.md`
- `prompts/migrate-dmvc-to-dext.md`
- `prompts/review-dext-code.md`
- `prompts/create-test-suite.md`
- `prompts/README.md`

Use one prompt template per task. Do not load all templates into context.

## Refresh / Maintenance Automation

Pack maintenance guidance lives under `automation/`:

- `automation/README.md`
- `automation/REFRESH_WORKFLOW.md`
- `automation/CHANGE_IMPACT_MATRIX.md`
- `automation/CONSISTENCY_CHECKLIST.md`
- `automation/CHANGELOG_POLICY.md`

Refresh rule: do not regenerate the whole repository blindly. Compare the old audited SHA to the new Dext HEAD, classify the diff, refresh only affected domains, then run the consistency checklist.

## Release Quality Gates

Release-readiness guidance lives under `quality/`:

- `quality/README.md`
- `quality/RELEASE_GATE.md`
- `quality/REFERENCE_INTEGRITY.md`
- `quality/AGENT_BEHAVIOR_GATE.md`
- `quality/RELEASE_CHECKLIST.md`

A release is not ready if any mandatory gate fails. Immediately before publication, upstream Dext HEAD must still equal the audited SHA.

## Full Artifacts

The complete memory and complete symbol index are preserved under `full/`:

```text
full/
├── DEXT_AI_MEMORY_ENRICHED_PART_01.md ... PART_09.md
└── DEXT_API_SYMBOL_INDEX_PART_01.md ... PART_04.md
```

Use compact root files for normal coding sessions. Load `full/` parts only when deep architecture, historical evidence, exact feature coverage or exhaustive symbol context is required.

## Example Analysis

The official Dext `Examples/` tree has been audited across all 8 groups, covering 50 directory-level examples.

Core files:

- `examples/DEXT_EXAMPLES_INDEX.md`
- `examples/DEXT_EXAMPLE_PATTERNS.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md`
- `examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
- `examples/DEXT_TIER_A_DEEP_AUDIT.md`

Group deep audits cover Basics, Web, Data, Advanced, UI, UseCases, AI and Active Architecture.

## Recommended Loading Strategy

Always load:

- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

Then:

1. route to one domain skill from `skills/README.md`
2. select one matching task template from `prompts/README.md`
3. consult compact symbol index
4. inspect example cross-reference and drift register
5. load full artifacts only when deeper evidence is required

## Source Priority

When information conflicts, use this precedence:

1. Current Dext source
2. Repository-wide critical rules / `Docs/CONTRIBUTING_AI.md`
3. Finalized specs
4. Current official Dext skills
5. Current official example `.pas` source
6. Example README/documentation
7. Feature index
8. This pack
9. General analogy with ASP.NET Core or other frameworks

Official example README files can lag API evolution. Use README text for intent and current `.pas` source for exact syntax.

## Example Trust Tiers

```text
Tier A -> architecture/reference application
Tier B -> focused feature/integration reference
Tier C -> protocol/performance/framework-internal reference
```

A Tier C example must not be generalized into normal application architecture merely because it is fast or low-level.

## Important Drift Guards Captured

- use `{id}` instead of legacy `:id`
- prefer `[MaxLength(N)]` over stale `[StringLength]` examples where repository-wide guidance applies
- prefer typed DI over manual request service lookup
- use current RFC-oriented `RateLimit-*` guidance over stale `X-RateLimit-*` examples
- prefer `AcquireScoped` where the current pool API supports it
- current `.pas` source beats stale example README syntax
- `Web.EventHub` is an event-management application, not the realtime Hubs feature demo

## Snapshot

- pack version: `v2026.08.12-r2-dext-412ed292`
- source repository: `cesarliws/dext`
- branch: `main`
- audited HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
- audited commit date: `2026-08-11`
- snapshot date: `2026-08-12`
- official examples audited: `50`
- example groups audited: `8`

## Repository Layout

```text
DEXT_AI_CODING_PACK/
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── DEXT_AI_MEMORY_ENRICHED.md
├── DEXT_API_SYMBOL_INDEX.md
├── DEXT_DECISION_TREE.md
├── DEXT_ANTI_PATTERNS.md
├── DEXT_CODE_RECIPES.md
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│       ├── quality-gate.yml
│       ├── upstream-drift.yml
│       └── publish-release.yml
├── tools/
│   └── validate_pack.py
├── versioning/
├── agents/
├── skills/
├── prompts/
├── automation/
├── quality/
├── releases/
├── full/
├── examples/
└── snapshots/
```

## Agent Reference Flow

```text
Question / Task
  -> agent-specific contract in agents/
  -> DEXT_DECISION_TREE.md
  -> DEXT_ANTI_PATTERNS.md
  -> skills/README.md
  -> smallest relevant skills/dext-*/SKILL.md
  -> matching prompts/*.md task template
  -> DEXT_API_SYMBOL_INDEX.md
  -> DEXT_EXAMPLE_CROSS_REFERENCE.md
  -> DEXT_EXAMPLE_DRIFT_REGISTER.md
  -> choose Tier A/B/C example
  -> inspect example README for intent
  -> inspect actual .pas source for syntax
  -> verify current official Dext skill/source
  -> load full/ parts only if deeper context is needed
  -> generate / review / test code
```

## Refresh Workflow

When Dext `main` moves, follow `automation/REFRESH_WORKFLOW.md`.

```text
snapshot SHA
  -> current upstream HEAD
  -> compare old -> new
  -> classify via CHANGE_IMPACT_MATRIX
  -> inspect changed source/skills/specs/examples
  -> update affected pack areas
  -> run CONSISTENCY_CHECKLIST
  -> run quality gates
  -> update snapshot + manifest + changelog + release notes
  -> assign new upstream-pinned release identity
  -> guarded publisher creates tag/release
```
