# Contributing to DEXT_AI_CODING_PACK

This repository is a source-grounded AI coding pack for the Dext Delphi framework. Contributions should improve correctness, routing, maintainability or agent safety without weakening source provenance.

## Source precedence

When sources disagree, use this order:

1. current Dext source
2. repository-wide Dext critical/AI contribution rules
3. finalized Dext specs
4. current official Dext skills
5. current official example `.pas` source
6. example README/documentation
7. this pack
8. analogy with other frameworks

Do not resolve a conflict by copying stale example syntax.

## Before changing the pack

Read:

- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`
- `automation/CHANGE_IMPACT_MATRIX.md`
- `quality/RELEASE_GATE.md`

If the change follows an upstream Dext update, also follow `automation/REFRESH_WORKFLOW.md`.

## Scope changes narrowly

A change in one Dext subsystem should not force unrelated pack domains to be regenerated. Use the impact matrix to identify the smallest affected set of:

- compact root files
- domain skills
- prompt templates
- example audits/cross-reference/drift register
- full memory/index parts
- agent integration rules

## Upstream compatibility

Every canonical pack release is pinned to one exact Dext commit SHA.

Do not describe a pack release as compatible with an arbitrary future `main`.

If upstream moved, create a new release identity after audit. If only the pack changed, use the `-rN-` revision convention documented in `versioning/VERSIONING_POLICY.md`.

## Required validation

Before merging or releasing:

```bash
python tools/validate_pack.py
```

Then satisfy:

- `automation/CONSISTENCY_CHECKLIST.md`
- `quality/REFERENCE_INTEGRITY.md`
- `quality/AGENT_BEHAVIOR_GATE.md`
- `quality/RELEASE_CHECKLIST.md` for releases

GitHub Actions runs the static validator on pushes and pull requests.

## Agent-facing changes

If a change alters how an agent should generate code, update all affected layers:

```text
core rule
  -> skill
  -> task prompt
  -> example/drift evidence
  -> agent integration if routing changed
```

Do not update only one layer and leave contradictory guidance elsewhere.

## Known safety/correctness guards

Do not regress these rules without current upstream evidence:

- routes use `{id}`, not `:id`
- use current controller attributes/signatures
- prefer typed DI over request service-locator patterns
- ORM query results use Dext collection contracts such as `IList<T>`
- financial precision uses `TBcd`/`FmtBcdType` when exact high precision is required
- prefer `AcquireScoped` where the current pool API supports scoped leases
- `Mock<T>` is not manually freed
- `MapFast` is selective, not a default architecture
- production security must not inherit demo secrets or permissive settings blindly

## Commit quality

Use focused commit messages that explain the pack behavior changed, for example:

```text
Update ORM skill for upstream detached-update change
Refresh web drift rules for controller attribute rename
Add release validator for upstream SHA consistency
```

Avoid vague messages such as `update docs` for compatibility-affecting changes.
