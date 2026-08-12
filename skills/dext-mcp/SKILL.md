# Skill: Dext MCP

Use for Model Context Protocol servers, tools, resources, prompts, HTTP Streamable transport, SSE legacy transport and stdio integrations.

## Load first
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`

## Primary example
`Examples/04-Advanced/MCP.FullDemo`

It demonstrates the three MCP pillars:
- Tools
- Resources
- Prompts

and multiple transports:
- HTTP Streamable
- SSE legacy
- stdio

## Core pattern
Subclass the Dext MCP provider abstraction, annotate methods with current MCP attributes, then register the provider with the server. The server owns registered providers in the official example; do not add manual frees unless current source says otherwise.

## Rules
- Verify current MCP protocol/version support before emitting transport or header details.
- Use current source for exact `[MCPTool]`, `[MCPParam]`, `[MCPResource]`, `[MCPPrompt]`, `[MCPPromptArg]` signatures.
- Keep tool methods small and domain-focused.
- Validate and sanitize tool inputs before database/file/network operations.
- Do not expose unrestricted database or filesystem access merely because MCP makes tool invocation easy.
- Separate domain/application services from MCP transport/provider code.
- Use Resources for retrievable context and Prompts for reusable prompt templates; do not collapse everything into Tools.

## Architecture
```text
MCP transport/provider
    -> application service
        -> domain/infrastructure
```

## Output checklist
1. choose tool/resource/prompt deliberately
2. verify current transport support
3. define ownership/lifetime
4. validate tool arguments
5. define structured errors/results
6. add manual `.http` or integration tests for initialize/session/call flow
