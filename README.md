# DEXT AI CODING PACK

This pack is optimized for AI coding agents working with the Dext Delphi framework.

## Files

- `DEXT_AI_MEMORY_ENRICHED.md` — full architectural and behavioral memory
- `DEXT_API_SYMBOL_INDEX.md` — fast symbol/API lookup
- `DEXT_DECISION_TREE.md` — choose the right Dext subsystem/API
- `DEXT_ANTI_PATTERNS.md` — common mistakes and forbidden patterns
- `DEXT_CODE_RECIPES.md` — compact implementation patterns

## Example Analysis

- `examples/DEXT_EXAMPLES_INDEX.md` — categorized official example catalog
- `examples/DEXT_EXAMPLE_PATTERNS.md` — recurring composition patterns extracted from examples
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md` — feature/API -> best official example
- `examples/DEXT_EXAMPLE_GOLDEN_PATTERNS.md` — canonical patterns and trust rules
- `examples/DEXT_TIER_A_DEEP_AUDIT.md` — deep audit of architecture-grade examples

## Recommended Loading Strategy

Always load:
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

Load on demand:
- `DEXT_API_SYMBOL_INDEX.md`
- relevant sections of `DEXT_AI_MEMORY_ENRICHED.md`
- `DEXT_CODE_RECIPES.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md` when choosing a reference implementation
- `examples/DEXT_TIER_A_DEEP_AUDIT.md` for architecture decisions

Do not keep the entire full memory in every prompt unless the agent has a large context budget.

## Source Priority

1. Current Dext source
2. Repository-wide critical rules / CONTRIBUTING_AI
3. Finalized specs
4. Official skills
5. Current official example source code
6. Example README/documentation
7. Feature index
8. This pack

Important: official example README files can lag API evolution. Use README text for intent and current `.pas` source for exact syntax.

## Snapshot

- source repository: `cesarliws/dext`
- branch: `main`
- audited HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
- snapshot date: `2026-08-12`

## Repository Layout

```text
DEXT_AI_CODING_PACK/
├── README.md
├── DEXT_AI_MEMORY_ENRICHED.md
├── DEXT_API_SYMBOL_INDEX.md
├── DEXT_DECISION_TREE.md
├── DEXT_ANTI_PATTERNS.md
├── DEXT_CODE_RECIPES.md
├── examples/
│   ├── DEXT_EXAMPLES_INDEX.md
│   ├── DEXT_EXAMPLE_PATTERNS.md
│   ├── DEXT_EXAMPLE_CROSS_REFERENCE.md
│   ├── DEXT_EXAMPLE_GOLDEN_PATTERNS.md
│   └── DEXT_TIER_A_DEEP_AUDIT.md
└── snapshots/
    └── DEXT_VERSION_SNAPSHOT.md
```

## Agent Reference Flow

```text
Question
  -> DEXT_DECISION_TREE.md
  -> DEXT_API_SYMBOL_INDEX.md
  -> DEXT_EXAMPLE_CROSS_REFERENCE.md
  -> choose Tier A/B/C example
  -> inspect example README for intent
  -> inspect actual .pas source for syntax
  -> verify current skill/source
  -> generate code
```
