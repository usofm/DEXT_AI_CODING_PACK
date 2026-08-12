# Versioning and Releases

This directory defines how DEXT AI Coding Pack releases are tied to upstream Dext revisions.

## Files

- `VERSIONING_POLICY.md` — canonical version syntax and compatibility rules
- `RELEASE_MANIFEST.md` — metadata for the current pack release

Root-level release history:

- `CHANGELOG.md`

## Current Version

```text
v2026.08.12-dext-412ed292
```

Audited upstream:

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

## Release Flow

```text
upstream Dext moves
  -> automation/REFRESH_WORKFLOW.md
  -> automation/CHANGE_IMPACT_MATRIX.md
  -> update affected pack artifacts
  -> automation/CONSISTENCY_CHECKLIST.md
  -> update snapshots/DEXT_VERSION_SNAPSHOT.md
  -> update versioning/RELEASE_MANIFEST.md
  -> update CHANGELOG.md
  -> create matching Git tag/release
```

## Compatibility Principle

The exact upstream SHA is the compatibility anchor. A date or branch name alone is not sufficient evidence.
