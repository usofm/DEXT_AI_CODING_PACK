# DEXT AI CODING PACK

This pack is optimized for AI coding agents working with the Dext Delphi framework.

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

These integrations deliberately use the compact root files first and escalate into `skills/`, `examples/` or `full/` only when a task requires deeper evidence.

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

Agent rule: route the task to the smallest relevant skill first, then load examples/full artifacts only if that skill cannot resolve the question safely.

## Full Artifacts

The complete memory and complete symbol index are preserved under `full/` in numbered parts so agents can load only the relevant ranges without losing any content to context/API limits.

```text
full/
├── DEXT_AI_MEMORY_ENRICHED_PART_01.md
├── DEXT_AI_MEMORY_ENRICHED_PART_02.md
├── DEXT_AI_MEMORY_ENRICHED_PART_03.md
├── DEXT_AI_MEMORY_ENRICHED_PART_04.md
├── DEXT_AI_MEMORY_ENRICHED_PART_05.md
├── DEXT_AI_MEMORY_ENRICHED_PART_06.md
├── DEXT_AI_MEMORY_ENRICHED_PART_07.md
├── DEXT_AI_MEMORY_ENRICHED_PART_08.md
├── DEXT_AI_MEMORY_ENRICHED_PART_09.md
├── DEXT_API_SYMBOL_INDEX_PART_01.md
├── DEXT_API_SYMBOL_INDEX_PART_02.md
├── DEXT_API_SYMBOL_INDEX_PART_03.md
└── DEXT_API_SYMBOL_INDEX_PART_04.md
```

Use the root compact files for routing and normal coding sessions. Load `full/` parts when deep architecture, historical evidence, exact feature coverage or exhaustive symbol context is needed.

## Example Analysis

The official Dext `Examples/` tree has been audited across all 8 groups, covering 50 directory-level examples.

Core example-analysis files:

- `examples/DEXT_EXAMPLES_INDEX.md` — categorized official example catalog
- `examples/DEXT_EXAMPLE_PATTERNS.md` — recurring composition patterns extracted from examples
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md` — feature/API -> best official example
- `examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md` — canonical patterns and trust rules
- `examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md` — 50-example coverage/tier matrix
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md` — known README/source/API drift and unsafe copy patterns
- `examples/DEXT_TIER_A_DEEP_AUDIT.md` — deep audit of architecture-grade examples

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

Then route to one domain skill from `skills/README.md`.

Load on demand:

- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_CODE_RECIPES.md`
- `agents/AGENT_TASK_PLAYBOOK.md` for task-specific routing
- relevant sections/parts of the full memory
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md` when choosing a reference implementation
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md` before copying syntax from an example
- `examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md` when selecting Tier A/B/C evidence
- `examples/DEXT_TIER_A_DEEP_AUDIT.md` for architecture decisions

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
├── DEXT_AI_MEMORY_ENRICHED.md
├── DEXT_API_SYMBOL_INDEX.md
├── DEXT_DECISION_TREE.md
├── DEXT_ANTI_PATTERNS.md
├── DEXT_CODE_RECIPES.md
├── agents/
│   ├── README.md
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   ├── CURSOR_RULES.md
│   ├── ANTIGRAVITY_RULES.md
│   └── AGENT_TASK_PLAYBOOK.md
├── skills/
│   ├── README.md
│   ├── dext-web/SKILL.md
│   ├── dext-orm/SKILL.md
│   ├── dext-financial/SKILL.md
│   ├── dext-fastpath/SKILL.md
│   ├── dext-realtime/SKILL.md
│   ├── dext-testing/SKILL.md
│   └── dext-mcp/SKILL.md
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
Question
  -> agent-specific contract in agents/
  -> DEXT_DECISION_TREE.md
  -> DEXT_ANTI_PATTERNS.md
  -> skills/README.md
  -> smallest relevant skills/dext-*/SKILL.md
  -> DEXT_API_SYMBOL_INDEX.md
  -> agents/AGENT_TASK_PLAYBOOK.md when useful
  -> DEXT_EXAMPLE_CROSS_REFERENCE.md
  -> DEXT_EXAMPLE_DRIFT_REGISTER.md
  -> choose Tier A/B/C example from Coverage Matrix
  -> inspect example README for intent
  -> inspect actual .pas source for syntax
  -> verify current official Dext skill/source
  -> load full/ memory or symbol parts only if deeper context is needed
  -> generate code
```

## Refresh Workflow

When Dext `main` moves:

```text
1. record the new HEAD
2. compare with snapshots/DEXT_VERSION_SNAPSHOT.md
3. inspect changed commits and public API symbols
4. inspect changed Docs/skills and finalized specs
5. inspect changed official examples
6. update drift register and coverage evidence if needed
7. refresh compact root files
8. refresh affected domain skills
9. refresh affected full/ parts
10. update agent integration rules if behavior changed
11. update snapshot SHA/date
```
