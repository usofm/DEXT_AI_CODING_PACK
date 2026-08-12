# DEXT AI Coding Pack — Quality Gate

This directory defines release-readiness checks for the pack itself.

## Quality Gates

Before a release is tagged, validate:

1. version identity is consistent across README, snapshot, manifest and changelog
2. upstream Dext SHA exists and matches the audited snapshot
3. every skill listed by the router exists
4. every prompt listed by the router exists
5. example coverage count/group count matches the snapshot
6. drift register is consulted for known stale syntax
7. full memory and symbol-index part counts are complete
8. agent integration files point to valid paths
9. refresh automation points to the current snapshot/manifest model
10. no release claims say merely "latest Dext" without an upstream SHA

## Files

- `RELEASE_GATE.md` — mandatory pre-release gate
- `REFERENCE_INTEGRITY.md` — path/reference consistency checks
- `AGENT_BEHAVIOR_GATE.md` — hallucination/drift guard checks
- `RELEASE_CHECKLIST.md` — sign-off checklist

A failed mandatory gate blocks the release until corrected or explicitly documented as a known limitation.
