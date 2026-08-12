# Release Checklist

Use this as the final sign-off immediately before creating a Git tag or GitHub Release.

## 1. Identity
- [ ] release id is final
- [ ] upstream full SHA is final
- [ ] short SHA matches release id
- [ ] README, manifest, snapshot and changelog agree

## 2. Content
- [ ] core files present
- [ ] all skills present
- [ ] all prompt templates present
- [ ] all agent integration files present
- [ ] example evidence files present
- [ ] full memory parts 01..09 present
- [ ] full symbol parts 01..04 present

## 3. Quality
- [ ] `quality/RELEASE_GATE.md` passed
- [ ] `quality/REFERENCE_INTEGRITY.md` passed
- [ ] `quality/AGENT_BEHAVIOR_GATE.md` passed
- [ ] `automation/CONSISTENCY_CHECKLIST.md` passed

## 4. Upstream freshness
- [ ] current Dext HEAD rechecked immediately before release
- [ ] if HEAD moved, release is stopped and refresh workflow is run first

## 5. Release Notes
- [ ] summarize material upstream capabilities covered
- [ ] summarize pack-side additions
- [ ] state exact Dext compatibility SHA
- [ ] mention known drift/limitations if any

## 6. Publish
Only after all checks pass:

```text
create tag
-> create GitHub Release
-> verify release points at intended pack commit
-> verify manifest/snapshot are unchanged after tagging
```

Never create a release from a dirty or partially refreshed compatibility state.
