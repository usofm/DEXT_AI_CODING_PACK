# DEXT Upstream Change Impact Matrix

Use this matrix after comparing the old snapshot SHA to the new Dext HEAD.

| Upstream path/change | Primary pack impact | Secondary checks |
|---|---|---|
| `Sources/Web/**` | `skills/dext-web`, decision tree, anti-patterns, recipes | prompts/web-related, examples/02-Web, Tier A web apps |
| `Sources/Web/**Fast*`, pool/streaming | `skills/dext-fastpath` | ORM, code recipes, drift register |
| `Sources/Web/Hubs*`, WebSocket, SSE | `skills/dext-realtime` | realtime prompt, Hubs/AirFlow examples |
| `Sources/Events/**` | `skills/dext-realtime` | EventBus examples, recipes, task playbook |
| `Sources/Data/**`, `Sources/Entity/**` | `skills/dext-orm` | symbol index, recipes, examples/03-Data |
| TBcd/FMTBcd/decimal/dialect changes | `skills/dext-financial` | ORM skill, financial prompt, memory, symbol index |
| provider/driver changes | ORM/provider notes | anti-patterns, provider isolation guidance |
| `Sources/Testing/**` | `skills/dext-testing` | review/test prompts, recipes |
| `Sources/MCP/**` | `skills/dext-mcp` | MCP prompt, advanced examples |
| DI/lifetime/hosting changes | agents + decision tree | all affected domain skills, ownership rules |
| Collections/pooling/threading changes | recipes + fastpath/ORM | ownership anti-patterns, full memory |
| Security/auth/CORS/CSRF/forwarded headers | web skill + anti-patterns | review prompt, Tier A examples |
| Logging/observability | memory/recipes | basics/UI logging examples |
| `Docs/skills/**` | affected pack skill | agent rules, prompt templates |
| `Docs/Specs/**` | affected domain memory/rules | symbol index, golden patterns if usage changes |
| `Examples/01-Basics/**` | basics audit evidence | recipes/memory if canonical pattern changes |
| `Examples/02-Web/**` | web cross-reference/drift | web skill, prompt templates |
| `Examples/03-Data/**` | ORM cross-reference/drift | ORM/financial/fastpath skills |
| `Examples/04-Advanced/**` | MCP/realtime/integration evidence | corresponding skill/prompt |
| `Examples/05-UI/**` | UI/desktop evidence | agent task playbook |
| `Examples/07-UseCases/**` | Tier A architecture evidence | golden patterns, cross-reference |
| `Examples/08-AI/**` | AI integration evidence | playbook/memory |
| `Examples/09-ActiveArchitecture/**` | desktop architecture evidence | golden patterns/playbook |
| route/model-binding syntax change | anti-patterns + web skill | all prompts generating endpoints |
| lifecycle/ownership change | anti-patterns | recipes, skills, agent contracts |
| removed API | symbol index + anti-patterns | every prompt/skill referencing it |

## Update rule

A changed upstream file does not automatically require changing every mapped pack file. It requires **inspection** of those files. Modify only when the upstream behavior or recommended usage actually changed.
