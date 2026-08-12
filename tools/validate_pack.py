#!/usr/bin/env python3
"""Static consistency checks for DEXT_AI_CODING_PACK.

This validator is intentionally dependency-free so GitHub Actions can run it
with the stock Python runtime.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "CHANGELOG.md",
    "DEXT_AI_MEMORY_ENRICHED.md",
    "DEXT_API_SYMBOL_INDEX.md",
    "DEXT_DECISION_TREE.md",
    "DEXT_ANTI_PATTERNS.md",
    "DEXT_CODE_RECIPES.md",
    "snapshots/DEXT_VERSION_SNAPSHOT.md",
    "versioning/RELEASE_MANIFEST.md",
    "versioning/VERSIONING_POLICY.md",
    "automation/REFRESH_WORKFLOW.md",
    "automation/CHANGE_IMPACT_MATRIX.md",
    "automation/CONSISTENCY_CHECKLIST.md",
    "quality/RELEASE_GATE.md",
    "quality/REFERENCE_INTEGRITY.md",
    "quality/AGENT_BEHAVIOR_GATE.md",
    "quality/RELEASE_CHECKLIST.md",
    "examples/DEXT_EXAMPLE_CROSS_REFERENCE.md",
    "examples/DEXT_EXAMPLE_DRIFT_REGISTER.md",
    "examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md",
    "agents/CLAUDE.md",
    "agents/AGENTS.md",
    "agents/CURSOR_RULES.md",
    "agents/ANTIGRAVITY_RULES.md",
    "skills/README.md",
    "prompts/README.md",
]

SKILLS = [
    "dext-web", "dext-orm", "dext-financial", "dext-fastpath",
    "dext-realtime", "dext-testing", "dext-mcp",
]

PROMPTS = [
    "create-crud-api.md",
    "create-financial-module.md",
    "create-fast-endpoint.md",
    "create-realtime-feature.md",
    "create-mcp-server.md",
    "migrate-dmvc-to-dext.md",
    "review-dext-code.md",
    "create-test-suite.md",
]

EXPECTED_GUARDS = [
    "{id}",
    "[MaxLength",
    "IList<T>",
    "AcquireScoped",
    "Mock<T>",
    "TBcd",
    "MapFast",
]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8-sig")


def fail(errors: list[str], message: str) -> None:
    errors.append(message)
    print(f"[FAIL] {message}")


def ok(message: str) -> None:
    print(f"[ OK ] {message}")


def extract(pattern: str, text: str, label: str, errors: list[str]) -> str | None:
    m = re.search(pattern, text, re.IGNORECASE | re.MULTILINE)
    if not m:
        fail(errors, f"Could not extract {label}")
        return None
    return m.group(1)


def main() -> int:
    errors: list[str] = []

    for rel in REQUIRED_FILES:
        if not (ROOT / rel).is_file():
            fail(errors, f"Missing required file: {rel}")
        else:
            ok(f"Required file exists: {rel}")

    for skill in SKILLS:
        rel = f"skills/{skill}/SKILL.md"
        if not (ROOT / rel).is_file():
            fail(errors, f"Missing skill: {rel}")
        else:
            ok(f"Skill exists: {skill}")

    for prompt in PROMPTS:
        rel = f"prompts/{prompt}"
        if not (ROOT / rel).is_file():
            fail(errors, f"Missing prompt: {rel}")
        else:
            ok(f"Prompt exists: {prompt}")

    for i in range(1, 10):
        rel = f"full/DEXT_AI_MEMORY_ENRICHED_PART_{i:02d}.md"
        if not (ROOT / rel).is_file():
            fail(errors, f"Missing full memory part: {rel}")
    for i in range(1, 5):
        rel = f"full/DEXT_API_SYMBOL_INDEX_PART_{i:02d}.md"
        if not (ROOT / rel).is_file():
            fail(errors, f"Missing full symbol part: {rel}")

    if errors:
        print("\nStructural validation stopped early because required files are missing.")
        return 1

    readme = read("README.md")
    manifest = read("versioning/RELEASE_MANIFEST.md")
    snapshot = read("snapshots/DEXT_VERSION_SNAPSHOT.md")
    changelog = read("CHANGELOG.md")

    version = extract(r"v\d{4}\.\d{2}\.\d{2}(?:-r\d+)?-dext-[0-9a-f]{8}", readme, "pack version", errors)
    # extract() returns group(1), so use an explicit group pattern for version.
    if version is None:
        m = re.search(r"(v\d{4}\.\d{2}\.\d{2}(?:-r\d+)?-dext-[0-9a-f]{8})", readme)
        version = m.group(1) if m else None

    if version:
        for label, text in [("manifest", manifest), ("snapshot", snapshot), ("changelog", changelog)]:
            if version not in text:
                fail(errors, f"Version {version} missing from {label}")
            else:
                ok(f"Version consistent in {label}")

        release_notes = ROOT / "releases" / f"{version}.md"
        if not release_notes.is_file():
            fail(errors, f"Release notes missing: releases/{version}.md")
        else:
            ok("Release notes match current version")

    sha_pattern = r"([0-9a-f]{40})"
    readme_sha = extract(r"cesarliws/dext@" + sha_pattern, readme, "README upstream SHA", errors)
    manifest_sha = extract(r"Upstream full SHA:\s*" + sha_pattern, manifest, "manifest upstream SHA", errors)
    snapshot_sha = extract(r"Audited HEAD:\s*`?" + sha_pattern, snapshot, "snapshot upstream SHA", errors)

    shas = {s for s in [readme_sha, manifest_sha, snapshot_sha] if s}
    if len(shas) != 1:
        fail(errors, f"Upstream SHA mismatch: {sorted(shas)}")
    elif shas:
        ok(f"Upstream SHA consistent: {next(iter(shas))}")

    anti = read("DEXT_ANTI_PATTERNS.md")
    behavior = read("quality/AGENT_BEHAVIOR_GATE.md")
    combined = anti + "\n" + behavior
    for guard in EXPECTED_GUARDS:
        if guard not in combined:
            fail(errors, f"Required behavior guard missing: {guard}")
        else:
            ok(f"Behavior guard present: {guard}")

    coverage = read("examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md")
    if "50" not in coverage:
        fail(errors, "Coverage matrix does not mention the audited 50-example baseline")
    else:
        ok("Coverage matrix retains 50-example baseline")

    if errors:
        print(f"\nValidation failed with {len(errors)} issue(s).")
        return 1

    print("\nDEXT_AI_CODING_PACK validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
