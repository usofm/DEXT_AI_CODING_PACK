# Dext Prompt / Task Templates

Reusable task templates for AI coding agents working with Dext.

These prompts are intentionally operational. They should be used together with:

1. `agents/AGENTS.md` or the tool-specific agent contract
2. `DEXT_DECISION_TREE.md`
3. `DEXT_ANTI_PATTERNS.md`
4. `skills/README.md` and the smallest relevant skill
5. `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
6. `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Available templates

- `create-crud-api.md`
- `create-financial-module.md`
- `create-fast-endpoint.md`
- `create-realtime-feature.md`
- `create-mcp-server.md`
- `migrate-dmvc-to-dext.md`
- `review-dext-code.md`
- `create-test-suite.md`

## Usage rule

Do not paste every template into context. Pick the task that best matches the work, then load only the matching Dext skill and examples.

## Evidence rule

Whenever exact Dext syntax matters:

```text
current source > official critical rules/specs > current skill > current .pas example > example README > this pack
```

The templates are workflow guides, not frozen API signatures.
