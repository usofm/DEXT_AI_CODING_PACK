# Task Template — Create a Dext MCP Server

## Goal

Build an MCP server/provider using current Dext MCP patterns for Tools, Resources and Prompts.

## Load first

- `skills/dext-mcp/SKILL.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_04_ADVANCED_DEEP_AUDIT.md`

Primary reference: `Examples/04-Advanced/MCP.FullDemo`.

## Design decisions

Define:

1. transport: Streamable HTTP, SSE legacy, or stdio
2. provider boundaries
3. which operations are Tools vs Resources vs Prompts
4. input schema and validation
5. ownership/lifetime of registered providers
6. authentication if exposed beyond local development
7. error/result contract

## Pattern

Use RTTI provider methods with current MCP attributes and verify exact signatures in current source before emitting code.

Conceptual form:

```pascal
[MCPTool(...)]
[MCPParam(...)]
function DoWork(const Args: TJSONObject): TMCPToolResult;
```

Use Resources for readable context/state and Prompts for reusable prompt templates rather than turning everything into a Tool.

## Deliverables

Produce:

- provider unit
- startup/server bootstrap
- tool/resource/prompt definitions
- validation and error handling
- sample MCP client configuration
- `.http` or curl test sequence
- health endpoint where HTTP transport is used

## Verification checklist

- exact MCP protocol/API signatures checked against current Dext source
- provider ownership is explicit
- external input is validated
- secrets are not hard-coded
- server-side database/business logic remains in services, not huge MCP methods
- HTTP exposure has an authentication/network-boundary plan
