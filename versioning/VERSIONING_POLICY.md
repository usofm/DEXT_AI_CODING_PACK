# DEXT AI Coding Pack Versioning Policy

The pack version must identify both the pack release date and the upstream Dext revision it was audited against.

## Canonical Version Format

```text
vYYYY.MM.DD-dext-<shortsha>
```

Example:

```text
v2026.08.12-dext-412ed292
```

## Meaning

- `YYYY.MM.DD` = pack release date
- `dext-<shortsha>` = audited upstream `cesarliws/dext` commit

## Compatibility Rule

A pack release is authoritative only for the upstream Dext SHA recorded in its release manifest.

If upstream `main` moves, the previous pack release becomes a historical snapshot. Do not silently reinterpret it as current.

## Patch-Only Pack Changes

If the pack changes without an upstream Dext change, append a pack revision:

```text
v2026.08.12-r2-dext-412ed292
```

Use this only for pack-only corrections such as:

- documentation typo
- missing cross-reference
- agent routing improvement
- prompt refinement
- metadata correction

## Release Types

### Snapshot Release

Normal release tied to an audited Dext SHA.

### Pack-Only Revision

Same Dext SHA, improved pack metadata/rules/prompts.

### Major Refresh

New upstream Dext SHA with meaningful public API, behavior, skills, specs or example changes.

## Never Use Floating Compatibility Claims

Avoid claims such as:

```text
works with latest Dext
compatible with current main
```

without recording the exact verified SHA.

## Required Release Metadata

Every release must record:

- pack version
- pack release date
- upstream repository
- upstream branch
- full upstream SHA
- short upstream SHA
- upstream commit date
- example audit status
- affected skills
- affected prompts
- known drifts
- validation checklist result

## Tagging Rule

Git tag should match the canonical pack version exactly.

Example:

```text
v2026.08.12-dext-412ed292
```

## Release Update Sequence

```text
refresh upstream evidence
  -> update pack files
  -> run consistency checklist
  -> update RELEASE_MANIFEST.md
  -> update CHANGELOG.md
  -> update snapshot
  -> tag/release
```
