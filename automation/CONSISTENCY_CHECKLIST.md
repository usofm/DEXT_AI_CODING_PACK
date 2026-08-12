# DEXT Pack Consistency Checklist

Use this after every upstream refresh or major pack edit.

## Snapshot

- [ ] `snapshots/DEXT_VERSION_SNAPSHOT.md` matches the audited upstream HEAD.
- [ ] Snapshot date and upstream commit date are explicit.
- [ ] Important behavioral/API changes are summarized.

## Core routing

- [ ] `DEXT_DECISION_TREE.md` routes to currently supported APIs.
- [ ] `DEXT_ANTI_PATTERNS.md` contains no rule contradicted by current source.
- [ ] `DEXT_CODE_RECIPES.md` does not present stale syntax as current.
- [ ] Compact symbol index contains newly important public symbols.

## Skills

- [ ] Every changed domain has its corresponding `skills/dext-*/SKILL.md` reviewed.
- [ ] Skills use current syntax and source priority.
- [ ] Skill examples are not copied from stale README-only evidence.

## Prompts

- [ ] Prompt templates still point to existing skills/examples/files.
- [ ] Security-sensitive prompts include production guards.
- [ ] Financial prompts preserve exact decimal semantics.
- [ ] FastPath prompts still require measurement before optimization.

## Examples

- [ ] Changed examples were reclassified if their architectural role changed.
- [ ] `DEXT_EXAMPLE_CROSS_REFERENCE.md` points to the best current examples.
- [ ] `DEXT_EXAMPLE_DRIFT_REGISTER.md` records known stale README/source patterns.
- [ ] Golden Patterns are supported by repeated/current evidence.
- [ ] Coverage Matrix count is correct.

## Agent integration

- [ ] `agents/` files point to current routing files.
- [ ] `skills/README.md` lists all skills.
- [ ] `prompts/README.md` lists all task templates.
- [ ] README top-level flow matches the actual repository structure.

## Full artifacts

- [ ] Every affected `full/` part was refreshed.
- [ ] Unaffected parts were not needlessly rewritten.
- [ ] Numbered part sequence has no gaps.
- [ ] Compact files do not falsely claim to be exhaustive when full parts are required.

## Critical drift guards

Verify these explicitly when relevant:

- [ ] routes use current `{id}`-style syntax
- [ ] validation attributes match current repository-wide guidance
- [ ] endpoint DI does not regress to unnecessary service locator usage
- [ ] `Mock<T>` lifetime guidance is current
- [ ] DbContext pooling/lifetime guidance is current
- [ ] pool lease guidance reflects current RAII/scoped APIs
- [ ] RateLimit/CORS/security header guidance is current
- [ ] TBcd/FMTBcd mappings remain exact
- [ ] WebSocket receive limits/lifecycle guidance is current
- [ ] provider-specific code remains isolated

## Completion condition

Do not mark a refresh complete if an exact API signature is uncertain. Verify current source first or label the pack guidance as conceptual rather than exact.
