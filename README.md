# DEXT AI CODING PACK

This pack is optimized for AI coding agents working with the Dext Delphi framework.

## Current Release

```text
v2026.08.12-dext-412ed292
```

Compatibility anchor:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

Release metadata and history:

- `versioning/RELEASE_MANIFEST.md`
- `versioning/VERSIONING_POLICY.md`
- `versioning/README.md`
- `CHANGELOG.md`

Do not interpret this release as compatible with an arbitrary future `main`; run the refresh workflow when upstream moves.

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
- `agents/AGENT_TASK_PLAYBOOK.md` — task-oriented routing for CRUD, FastPath, finance/TBcd, realtime, MCP, migration, testing, and more
- `agents/README.md` — recommended wiring and context-loading strategy

These integrations deliberately use the compact root files first and escalate into `skills/`, `prompts/`, `examples/` or `full/` only when a task requires deeper evidence.

## Domain Skill Pack

Small task-focused skills live under `skills/` and should be preferred over loading the whole memory for ordinary work.

- `skills/dext-web/SKILL.md` — HTTP APIs, controllers, middleware, auth, Swagger
- `skills/dext-orm/SKILL.md` — DbContext, IDbSet, querying, specifications, relations
- `skills/dext-financial/SKILL.md` — TBcd/FmtBcdType and exact financial precision
- `skills/dext-fastpath/SKILL.md` — MapFast, UseSql, direct UTF-8 streaming, pooling
- `skills/dext-realtime/SKILL.md` — SSE, WebSocket, Hubs and Event Bus
- `skills/dext-testing/SKILL.md` — unit/integration tests, Mock<T>, snapshots
- `skills/dext-mcp/SKILL.md` — MCP tools, resources, prompts and transports
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
- `prompts/README.md` — template router and evidence rules

Use one prompt template per task. Do not load all templates into context.

## Refresh / Maintenance Automation

Pack maintenance guidance lives under `automation/`:

- `automation/README.md` — refresh entry point
- `automation/REFRESH_WORKFLOW.md` — old snapshot -> new upstream HEAD procedure
- `automation/CHANGE_IMPACT_MATRIX.md` — changed upstream path -> pack areas to inspect
- `automation/CONSISTENCY_CHECKLIST.md` — final verification before closing a refresh
- `automation/CHANGELOG_POLICY.md` — what upstream changes deserve agent-facing changelog entries

Refresh rule: do not regenerate the whole repository blindly. Compare the old audited SHA to the new Dext HEAD, classify the diff, refresh only affected domains, then run the consistency checklist.

## Release Quality Gates

Release-readiness guidance lives under `quality/`:

- `quality/README.md` — quality gate overview
- `quality/RELEASE_GATE.md` — mandatory structural and compatibility checks
- `quality/REFERENCE_INTEGRITY.md` — internal path/reference validation
- `quality/AGENT_BEHAVIOR_GATE.md` — anti-hallucination and drift behavior checks
- `quality/RELEASE_CHECKLIST.md` — final sign-off before tag/release creation

A release is not considered ready if any mandatory quality gate fails. Immediately before tagging, recheck the current Dext HEAD; if upstream moved, stop the release and run the refresh workflow first.

## Full Artifacts

The complete memory and complete symbol index are preserved under `full/` in numbered parts so agents can load only the relevant ranges without losing any content to context/API limits.

```text
full/
├── DEXT_AI_MEMORY_ENRICHED_PART_01.md ... PART_09.md
└── DEXT_API_SYMBOL_INDEX_PART_01.md ... PART_04.md
```

Use the root compact files for routing and normal coding sessions. Load `full/` parts when deep architecture, historical evidence, exact feature coverage or exhaustive symbol context is needed.

## Example Analysis

The official Dext `Examples/` tree has been audited across all 8 groups, covering 50 directory-level examples.

Core example-analysis files:

- `examples/DEXT_EXAMPLES_INDEX.md`
- `examples/DEXT_EXAMPLE_PATTERNS.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md`
- `examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`
- `examples/DEXT_TIER_A_DEEP_AUDIT.md`

Group deep audits:

- `examples/DEXT_01_BASICS_DEEP_AUDIT.md`
- `examples/DEXT_02_WEB_DEEP_AUDIT.md`
- `examples/DEXT_03_DATA_DEEP_AUDIT.md`
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- `examples/DEXT_05_UI_DEEP_AUDIT.md`
- `examples/DEXT_07_USECASES_SUPPLEMENTAL_AUDIT.md`
- `examples/DEXT_08_AI_DEEP_AUDIT.md`
- `examples/DEXT_09_ACTIVE_ARCHITECTURE_DEEP_AUDIT.md`

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

Do not keep the entire full memory in every prompt unless the agent has a large context budget.

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

Important: official example README files can lag API evolution. Use README text for intent and current `.pas` source for exact syntax.

## Example Trust Tiers

```text
Tier A -> architecture/reference application
Tier B -> focused feature/integration reference
Tier C -> protocol/performance/framework-internal reference
```

A Tier C example must not be generalized into normal application architecture merely because it is fast or low-level.

## Important Drift Guards Captured

The pack explicitly guards against copying known stale patterns, including:

- legacy `:id` route syntax instead of `{id}`
- stale `[StringLength]` examples where repository-wide guidance says `[MaxLength(N)]`
- manual request service resolution when typed/generic injection is available
- old `X-RateLimit-*` naming versus current RFC-oriented `RateLimit-*` headers
- manual pool `Acquire/Release` where current `AcquireScoped` RAII is available
- older controller attribute names in some README files
- assuming `Web.EventHub` is a realtime Hub example; it is an event-management domain application

## Snapshot

- pack version: `v2026.08.12-dext-412ed292`
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
├── DEXT_AI_MEMORY_ENRICHED.md
├── DEXT_API_SYMBOL_INDEX.md
├── DEXT_DECISION_TREE.md
├── DEXT_ANTI_PATTERNS.md
├── DEXT_CODE_RECIPES.md
├── versioning/
│   ├── README.md
│   ├── VERSIONING_POLICY.md
│   └── RELEASE_MANIFEST.md
├── agents/
│   └── agent contracts and task playbook
├── skills/
│   └── task-focused Dext domain skills
├── prompts/
│   └── operational task templates
├── automation/
│   └── refresh and maintenance rules
├── quality/
│   ├── README.md
│   ├── RELEASE_GATE.md
│   ├── REFERENCE_INTEGRITY.md
│   ├── AGENT_BEHAVIOR_GATE.md
│   └── RELEASE_CHECKLIST.md
├── full/
│   ├── DEXT_AI_MEMORY_ENRICHED_PART_01.md ... PART_09.md
│   └── DEXT_API_SYMBOL_INDEX_PART_01.md ... PART_04.md
├── examples/
│   └── audits, cross-reference, drift register and coverage matrix
└── snapshots/
    └── DEXT_VERSION_SNAPSHOT.md
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
  -> choose Tier A/B/C example from Coverage Matrix
  -> inspect example README for intent
  -> inspect actual .pas source for syntax
  -> verify current official Dext skill/source
  -> load full/ memory or symbol parts only if deeper context is needed
  -> generate / review / test code
```

## Refresh Workflow

When Dext `main` moves, follow `automation/REFRESH_WORKFLOW.md` instead of improvising the refresh.

```text
snapshot SHA
  -> current upstream HEAD
  -> compare old -> new
  -> classify via CHANGE_IMPACT_MATRIX
  -> inspect changed source/skills/specs/examples
  -> update affected core/skills/prompts/examples/full parts
  -> run CONSISTENCY_CHECKLIST
  -> run quality gates
  -> update snapshot
  -> update RELEASE_MANIFEST
  -> update CHANGELOG
  -> create new upstream-pinned release identity
```
