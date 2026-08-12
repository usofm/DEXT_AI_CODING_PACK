# Dext Skill Pack

Small domain-focused skills for AI coding agents. Load only the skill matching the current task, then consult the compact pack files and current Dext source as needed.

## Router

| Task | Skill |
|---|---|
| HTTP APIs, controllers, middleware, auth, Swagger | `skills/dext-web/SKILL.md` |
| DbContext, IDbSet, queries, specifications, relations | `skills/dext-orm/SKILL.md` |
| NUMERIC/DECIMAL, TBcd, FmtBcdType, finance/accounting | `skills/dext-financial/SKILL.md` |
| MapFast, UseSql, direct UTF-8 streaming, pools | `skills/dext-fastpath/SKILL.md` |
| SSE, WebSocket, Hubs, Event Bus | `skills/dext-realtime/SKILL.md` |
| unit/integration tests, Mock<T>, snapshots | `skills/dext-testing/SKILL.md` |
| MCP tools/resources/prompts and transports | `skills/dext-mcp/SKILL.md` |

## Universal precedence

1. current Dext source
2. repository-wide critical rules / CONTRIBUTING_AI
3. finalized specs
4. current official Dext skills
5. current official example `.pas`
6. example README
7. this pack

Always consult `DEXT_ANTI_PATTERNS.md` and `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md` before copying syntax from examples.
