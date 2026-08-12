# Release Gate

A release is READY only if every mandatory check passes.

## Identity

- [ ] `README.md` release id matches `versioning/RELEASE_MANIFEST.md`
- [ ] `snapshots/DEXT_VERSION_SNAPSHOT.md` uses the same upstream SHA
- [ ] `CHANGELOG.md` contains the release id
- [ ] version format follows `versioning/VERSIONING_POLICY.md`

## Upstream Evidence

- [ ] upstream repo is `cesarliws/dext`
- [ ] audited branch is `main`
- [ ] audited full SHA is recorded
- [ ] short SHA embedded in release id matches the full SHA prefix

## Core Pack

- [ ] `DEXT_DECISION_TREE.md` exists
- [ ] `DEXT_ANTI_PATTERNS.md` exists
- [ ] `DEXT_CODE_RECIPES.md` exists
- [ ] compact memory/index exist
- [ ] full memory has Parts 01..09
- [ ] full symbol index has Parts 01..04

## Domain Routing

- [ ] all skill-router entries resolve
- [ ] all prompt-router entries resolve
- [ ] agent playbook references valid skill/prompt paths
- [ ] no router requires loading the entire full memory for normal tasks

## Examples

- [ ] coverage matrix reflects the audited example count
- [ ] drift register is present
- [ ] cross-reference is present
- [ ] Tier A deep audit is present
- [ ] `Web.EventHub` is not mislabeled as a realtime Hub sample

## High-Signal Guardrails

- [ ] `{id}` route syntax is preferred over `:id`
- [ ] `[MaxLength]` critical guidance overrides stale `[StringLength]` examples
- [ ] typed DI is preferred over service locator patterns
- [ ] `Mock<T>` is treated as a record
- [ ] `TBcd/FmtBcdType` is used for exact high-scale financial values
- [ ] `AcquireScoped` is preferred when current pooling API supports it
- [ ] `MapFast` is not presented as the default HTTP architecture

## Maintenance

- [ ] `automation/REFRESH_WORKFLOW.md` exists
- [ ] impact matrix exists
- [ ] consistency checklist exists
- [ ] changelog policy exists

If any mandatory item fails, mark the pack NOT READY and record the reason before tagging.
