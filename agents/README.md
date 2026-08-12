# Agent Integration Pack

This directory contains tool-facing instruction files built from the Dext AI Coding Pack.

## Files

- `CLAUDE.md` — Claude Code-oriented project guidance
- `AGENTS.md` — generic repository-level agent contract
- `CURSOR_RULES.md` — Cursor-oriented rules source
- `ANTIGRAVITY_RULES.md` — Antigravity/Gemini-oriented guidance

## Recommended Wiring

### Claude Code
Use `agents/CLAUDE.md` as the project instruction source. Keep `DEXT_DECISION_TREE.md` and `DEXT_ANTI_PATTERNS.md` available as always-on references.

### Cursor
Translate or reference `agents/CURSOR_RULES.md` from your Cursor project rules. Keep symbol/example files on-demand instead of always loading the full memory.

### Antigravity / Gemini
Use `agents/ANTIGRAVITY_RULES.md` as the root behavior contract and expose the compact root files plus the `examples/` directory for retrieval.

### Generic agents / Codex-style tools
Use `agents/AGENTS.md` as the repository contract.

## Shared Retrieval Strategy

```text
Always-on
  DEXT_DECISION_TREE.md
  DEXT_ANTI_PATTERNS.md

On-demand
  DEXT_API_SYMBOL_INDEX.md
  DEXT_CODE_RECIPES.md
  examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
  examples/DEXT_EXAMPLE_DRIFT_REGISTER.md
  matching deep audit

Deep-only
  full/DEXT_AI_MEMORY_ENRICHED_PART_*.md
  full/DEXT_API_SYMBOL_INDEX_PART_*.md
```

## Why This Matters

The goal is not to maximize prompt size. The goal is to give the agent the smallest reliable evidence set that leads it to current Dext source and official examples before code generation.

## Drift Safety

All integrations should preserve this precedence:

```text
current Dext source
> repository-wide AI rules
> finalized specs
> official skills
> current official example source
> example README
> this pack
> framework analogy
```
