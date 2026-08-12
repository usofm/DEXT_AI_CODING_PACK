## Purpose

Describe what this PR changes and why.

## Change type

- [ ] Upstream Dext refresh
- [ ] Pack-only correction/revision
- [ ] New domain skill
- [ ] New task prompt
- [ ] Example/drift evidence update
- [ ] Agent integration update
- [ ] Automation/quality/versioning update

## Upstream compatibility

Audited Dext SHA before this PR:

```text
<sha>
```

Audited Dext SHA after this PR:

```text
<sha or unchanged>
```

- [ ] I verified whether upstream `cesarliws/dext/main` moved.
- [ ] If upstream moved, I followed `automation/REFRESH_WORKFLOW.md`.
- [ ] I used `automation/CHANGE_IMPACT_MATRIX.md` to scope affected pack areas.

## Agent behavior impact

- [ ] No agent-facing behavior changed.
- [ ] Agent-facing behavior changed and affected skills/prompts/examples were updated together.

Describe any behavior change:

```text
<details>
```

## Drift / evidence

- [ ] Current Dext source was checked for exact syntax when needed.
- [ ] Relevant official example `.pas` source was checked.
- [ ] `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md` was updated if stale/conflicting example guidance was found.

## Validation

- [ ] `python tools/validate_pack.py` passes.
- [ ] `automation/CONSISTENCY_CHECKLIST.md` passes.
- [ ] `quality/REFERENCE_INTEGRITY.md` passes.
- [ ] `quality/AGENT_BEHAVIOR_GATE.md` passes.

For release-affecting PRs:

- [ ] `versioning/RELEASE_MANIFEST.md` is synchronized.
- [ ] `snapshots/DEXT_VERSION_SNAPSHOT.md` is synchronized.
- [ ] `CHANGELOG.md` is synchronized.
- [ ] matching release notes exist under `releases/`.
- [ ] `quality/RELEASE_CHECKLIST.md` passes.

## Notes

Add anything a reviewer should verify manually.
