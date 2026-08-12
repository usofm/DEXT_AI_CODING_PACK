# DEXT Pack Refresh Workflow

## 1. Resolve upstream state

Read `snapshots/DEXT_VERSION_SNAPSHOT.md` and record the currently audited SHA.
Resolve the current HEAD of `cesarliws/dext:main`.

If the SHAs match, stop: no refresh is required.

## 2. Compare old -> new

Compare the snapshot SHA against the new HEAD and classify every changed path into one or more domains:

```text
Sources/Web            -> web / security / realtime / fastpath
Sources/Data|Entity    -> orm / financial / fastpath
Sources/Testing        -> testing
Sources/MCP            -> mcp
Sources/Events         -> realtime/event bus
Sources/Core|Common    -> potentially cross-cutting
Docs/skills            -> agent-facing usage guidance
Docs/Specs             -> behavior/specification changes
Examples               -> example evidence/drift
Community/Drivers      -> provider integration
```

Merge commits are not sufficient evidence by themselves. Inspect the substantive commits/files behind them.

## 3. Audit public API impact

For each changed public-facing unit, identify:

- added symbols
- removed/renamed symbols
- changed signatures/overloads
- changed defaults
- lifecycle/ownership changes
- security behavior changes
- performance-path changes
- persistence/provider changes

Do not infer exact syntax from commit messages alone. Verify current source.

## 4. Audit official guidance

Inspect changed:

- `Docs/CONTRIBUTING_AI.md`
- `Docs/skills/dext-*.md`
- finalized specs
- feature index / book pages when relevant

If official guidance conflicts with an older pack rule, official current guidance wins.

## 5. Audit changed examples

For every changed Example:

1. classify Tier A/B/C
2. inspect README for intent
3. inspect current `.pas` for exact syntax
4. compare against previous drift register entries
5. update cross-reference/golden patterns only if the new example evidence warrants it

Never promote a Tier C/internal pattern into normal application guidance merely because it appears in an official example.

## 6. Update operational files

Refresh affected sections of:

- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`
- `DEXT_CODE_RECIPES.md`
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_AI_MEMORY_ENRICHED.md`

Then update affected files under:

- `skills/`
- `prompts/`
- `agents/`
- `examples/`

## 7. Update full artifacts selectively

Only rewrite `full/` parts whose content is affected.

Preserve numbered part boundaries when practical. If rebalancing parts is necessary, update README references and verify that no content was dropped.

## 8. Update snapshot

Update:

```text
snapshots/DEXT_VERSION_SNAPSHOT.md
```

with:

- new HEAD SHA
- commit date
- refresh date
- important captured changes
- example count/group count if changed

## 9. Final consistency pass

Run `automation/CONSISTENCY_CHECKLIST.md`.

A refresh is complete only when:

```text
snapshot == upstream audited HEAD
operational rules reflect changed APIs
skills/prompts reflect affected domains
example drift is registered
README navigation remains valid
no stale exact syntax is intentionally retained as current guidance
```
