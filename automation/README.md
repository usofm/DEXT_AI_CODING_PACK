# DEXT AI CODING PACK - Refresh Automation

This folder defines the maintenance workflow for keeping the pack synchronized with `cesarliws/dext`.

## Trigger

Run the refresh workflow when the upstream Dext `main` HEAD differs from the SHA recorded in `snapshots/DEXT_VERSION_SNAPSHOT.md`.

## Refresh Order

```text
1. Resolve upstream HEAD
2. Compare old snapshot SHA -> new HEAD
3. Classify changed files
4. Audit changed public APIs
5. Audit changed official skills/specs
6. Audit changed examples
7. Update drift register
8. Update compact operational files
9. Update affected domain skills
10. Update affected prompt templates
11. Update full artifacts only where needed
12. Update snapshot
13. Run consistency checklist
```

## Files in this folder

- `REFRESH_WORKFLOW.md` — complete step-by-step procedure
- `CHANGE_IMPACT_MATRIX.md` — changed path -> pack files that may need refresh
- `CONSISTENCY_CHECKLIST.md` — final verification before considering a refresh complete
- `CHANGELOG_POLICY.md` — how to record important upstream changes

## Principle

Do not regenerate the whole pack blindly. Refresh only the domains affected by the upstream diff, then verify cross-file consistency.
