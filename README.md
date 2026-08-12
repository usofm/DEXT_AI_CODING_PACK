# DEXT AI CODING PACK

This pack is optimized for AI coding agents working with the Dext Delphi framework.

## Files

- `DEXT_AI_MEMORY_ENRICHED.md` — full architectural and behavioral memory
- `DEXT_API_SYMBOL_INDEX.md` — fast symbol/API lookup
- `DEXT_DECISION_TREE.md` — choose the right Dext subsystem/API
- `DEXT_ANTI_PATTERNS.md` — common mistakes and forbidden patterns
- `DEXT_CODE_RECIPES.md` — compact implementation patterns

## Recommended Loading Strategy

Always load:
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`

Load on demand:
- `DEXT_API_SYMBOL_INDEX.md`
- relevant sections of `DEXT_AI_MEMORY_ENRICHED.md`
- `DEXT_CODE_RECIPES.md`

Do not keep the entire 90KB+ memory in every prompt unless the agent has a large context budget.

## Source Priority

1. Current Dext source
2. Repository-wide critical rules / CONTRIBUTING_AI
3. Finalized specs
4. Official skills
5. Official examples
6. Feature index
7. This pack

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
│   └── DEXT_EXAMPLE_GOLDEN_PATTERNS.md
└── snapshots/
    └── DEXT_VERSION_SNAPSHOT.md
```
