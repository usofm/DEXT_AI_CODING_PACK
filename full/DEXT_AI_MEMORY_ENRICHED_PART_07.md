# 74. AI Agent Change Workflow

When the user asks an AI coding agent to change Dext itself:

## Step 1 — Locate design context

Read:

```text
Docs/CONTRIBUTING_AI.md
Docs/skills/<relevant>.md
Docs/Specs/<relevant spec>
Docs/Book/<relevant chapter>
```

Search code for existing utilities.

## Step 2 — Locate implementation

Use:

```text
Docs/skills/dext-symbols.md
source search
tests search
```

Identify:

- public API
- internal type
- provider-specific implementations
- tests
- docs
- examples

## Step 3 — Write failing tests first

Cover:

- happy path
- error path
- boundary conditions
- thread/concurrency behavior if relevant
- memory ownership
- provider differences
- backwards compatibility

## Step 4 — Implement minimally

Preserve:

- naming
- existing abstractions
- memory model
- pooling
- thread safety
- zero-allocation expectations
- API compatibility

## Step 5 — Validate

Run:

- unit tests
- integration tests
- relevant examples
- memory/leak checks where applicable
- benchmarks for performance-sensitive changes

## Step 6 — Document

Update:

```text
Docs/Book
Docs/skills
feature index
spec status
example/readme when needed
PT-BR parallel docs when repository convention requires it
```

---

# 75. AI Agent New Application Workflow

When generating a new app that uses Dext:

1. Determine app type:
   - REST API
   - web app
   - microservice
   - background service
   - desktop VCL
   - MCP server
   - mixed app

2. Load relevant Dext skills.

3. Create:
   - project bootstrap
   - configuration
   - DI
   - application/domain layers
   - persistence
   - web/UI adapter
   - tests

4. Configure observability early.

5. Configure authentication/security before exposing write APIs.

6. Use DbContext pooling for web workloads if supported.

7. Add `.http` files for important API scenarios.

8. Add integration tests.

9. Add production deployment config separately from development defaults.

---

# 76. Questions an AI Should Ask Itself Before Generating Dext Code

- Is this public API signature current?
- Is there already a Dext abstraction for this?
- Should this dependency be Scoped, Singleton, or Transient?
- Who owns this object?
- Does this code run on a hot path?
- Am I introducing avoidable allocations?
- Is this query tracked unnecessarily?
- Can this update be set-based?
- Does this operation require a transaction?
- Is retry safe?
- Is this endpoint authorized?
- Are tenant boundaries enforced?
- Does this need validation?
- Is forwarded-header trust configured?
- Should this use SSE or WebSocket?
- Should this use an in-process event or durable message?
- Is this business logic in the wrong layer?
- Can this be unit-tested without a real DB?
- Do I need to update a Dext skill/doc/spec?

---

# 77. "Do Not Hallucinate" Rules for Dext

An AI agent must not invent:

- attribute names
- middleware names
- configuration methods
- provider classes
- exact exception classes
- exact controller base classes
- exact result types
- exact migration APIs
- exact fluent query operators
- exact Hub APIs
- exact TLS provider enum values

when not verified against current source.

If uncertain, search source/skills first.

Dext evolves rapidly and article examples may reflect different points in the API evolution.

---

# 78. Code Style Memory

Preferred modern Delphi style in Dext:

```pascal
procedure TOrderService.Process(const OrderId: Integer);
begin
  var Order := FOrders.Find(OrderId);

  if Order = nil then
    raise EOrderNotFound.Create(OrderId);

  Order.Process;

  FContext.SaveChanges;
end;
```

Avoid:

```pascal
procedure TOrderService.Process(const OrderId: Integer);
var
  LOrder: TOrder;
begin
  LOrder := ...
```

unless compatibility or local source convention requires classic syntax.

Other style tendencies:

- clear type names
- interfaces at architectural boundaries
- fluent APIs
- attributes for declarative metadata
- short adapters/controllers
- strong typing
- minimal magic strings
- explicit ownership
- tests for framework behavior

---

# 79. Naming Guidance

Typical Dext-oriented application naming:

```text
IOrderService / TOrderService
IOrderRepository / TOrderRepository
TOrderDbContext
TOrderController
TCreateOrderDto
TUpdateOrderDto
TOrderValidator
TOrderByIdSpecification
TOrderCreatedEvent
```

Do not prefix every local variable with `L`.

Avoid overly generic names:

```text
Manager
Helper
Utils
Common
Misc
```

unless the role truly is generic and consistent with existing Dext naming.

---

# 80. Error Handling Guidance

Infrastructure errors should be translated at boundaries.

Example:

```text
DB provider exception
 -> repository/application exception
 -> HTTP problem/result mapping
```

Do not leak:

- SQL
- stack traces
- filesystem paths
- secrets
- provider-specific diagnostics

to public production responses.

Log detailed internal diagnostics with correlation identifiers.

---

# 81. Multi-Tenancy

Dext advanced ORM documentation includes multi-tenancy concepts.

General rules:

- tenant identity must come from authenticated/trusted context
- apply tenant filters centrally
- never trust tenant ID only from request body
- include tenant boundary in unique constraints where relevant
- validate tenant access on direct primary-key lookups
- background jobs must carry tenant context explicitly

Avoid sprinkling:

```pascal
.Where(Entity.TenantId = Request.TenantId)
```

manually in every query if a centralized query-filter mechanism exists.

---

# 82. Migrations

Use Dext migration infrastructure rather than ad-hoc startup DDL where production schema versioning is required.

Migration quality rules:

- deterministic
- ordered
- reversible where practical
- safe for existing data
- provider-aware
- tested against representative DB versions

Never auto-drop production columns merely because an entity property disappeared.

---

# 83. Raw SQL Escape Hatch

Fluent Query is the default, but raw SQL is legitimate when:

- provider-specific feature is unavailable
- reporting query is highly specialized
- performance requires a handcrafted query
- migration/admin task requires SQL

Rules:

- parameterize values
- isolate SQL in infrastructure layer
- document provider dependency
- test mapping
- never concatenate user input

---

# 84. ORM Projection Advice

For list APIs, avoid hydrating full aggregate graphs when only 4 fields are needed.

Prefer projection/select APIs if current Dext supports them.

Benefits:

- fewer bytes from DB
- lower memory
- faster JSON
- less tracking
- clearer API contracts

If projection API is not currently available for a required shape, map to DTO after bounded query rather than exposing persistence entities by default.

---

# 85. API DTO Guidance

Do not automatically expose entity classes as public request/response contracts for complex systems.

Use DTOs to:

- version APIs
- protect internal columns
- separate write input from persisted model
- avoid over-posting
- shape query responses
- localize validation

DataApi is the exception for intentionally direct CRUD surfaces.

---

# 86. Security Checklist for Generated Dext APIs

Before declaring a generated API production-ready, verify:

- TLS
- authentication
- authorization
- CORS
- rate limiting
- request size limits
- timeouts
- validation
- SQL injection protection
- output escaping where HTML exists
- CSRF for cookie-based browser writes
- forwarded-header trust
- secrets storage
- structured audit logging
- dependency/package updates
- error redaction
- health checks
- graceful shutdown
- backup/recovery for DB

---

# 87. Performance Checklist for Generated Dext APIs

Check:

- DbContext pooling enabled
- DB connection pooling enabled
- paging present
- N+1 avoided
- no-tracking reads where appropriate
- indexes match filters/order
- JSON model reasonable
- response compression configured where beneficial
- large uploads streamed
- outbound HTTP connections pooled
- timeouts configured
- resilience controlled
- logging not synchronous bottleneck
- telemetry enabled
- no unnecessary object creation in hot loops

---

# 88. Dext vs Traditional Delphi Mental Translation

| Traditional Delphi | Dext-oriented approach |
|---|---|
| DataModule as service locator | DI container |
| Query component on every form | DbContext/repository/service |
| SQL strings | Fluent Query AST |
| `TObjectList<T>` | `IList<T>` |
| manual JSON | `TDextJson` |
| `TThread.CreateAnonymousThread` everywhere | Dext.Threading pipelines |
| `TRestClient` components | `Dext.Net.RestClient` |
| hand-built router | Minimal APIs / Controllers |
| ad-hoc middleware code | Web pipeline |
| manual API docs | OpenAPI + dext doc |
| forms calling each other | Navigator |
| direct UI/database coupling | EntityDataSet + MVVM/application layer |
| custom AI HTTP endpoints | MCP server tools/resources |

---

# 89. Dext vs ASP.NET Core Mental Translation

| ASP.NET Core / EF Core | Dext concept |
|---|---|
| `WebApplicationBuilder` | Dext Web application builder |
| `IServiceCollection` | Dext DI services |
| scoped service | scoped Dext service |
| `DbContext` | Dext DbContext |
| `DbSet<T>` | `IDbSet<T>` / entity sets |
| LINQ expression | Dext smart-property AST |
| Minimal APIs | Dext MapGet/MapPost/etc |
| Controllers | Dext Controllers |
| Middleware | Dext Web middleware |
| `IOptions<T>` | Dext Options pattern |
| `HttpClientFactory` concepts | Dext REST connection pooling |
| SignalR | Dext Hubs |
| OpenTelemetry | Dext OTEL/telemetry integrations |
| `WebApplicationFactory` | Dext testing equivalent |
| source-generated codecs | Dext direct codec/type-plan work |
| Data API scaffolding | Dext DataApi |

Do not assume one-to-one API naming. The analogy is conceptual.

---

# 89A. Official AI Governance

Dext now has a repository-level:

```text
AI_GOVERNANCE.md
```

This is separate from coding conventions in `Docs/CONTRIBUTING_AI.md`.

The governance document establishes that Dext uses AI as an assistive development tool under human architectural direction/review, and expects human-in-the-loop verification of contributions.

Important repository governance principles include:

- human review of AI-assisted PRs
- contributor responsibility for third-party IP
- Developer Certificate of Origin expectations
- rejection/remediation of incompatible copied source
- avoiding copyleft/license contamination
- Apache 2.0 remains the framework's permissive distribution model
- enterprise users should maintain human direction/review over proprietary AI-assisted code

## AI Agent Practical Rule

Never copy source code verbatim from unrelated repositories to solve a Dext task.

Instead:

1. understand the behavior required
2. implement it in Dext's architecture and style
3. preserve provenance
4. verify licensing if external code is necessary
5. subject generated changes to tests and human review

AI-generated implementation is not a shortcut around code review, security review, or licensing review.

---

# 90. Agent Import Recommendation

This memory works best as a **root-level always-loaded context file**, while the official Dext `Docs/skills` remain on-demand detailed context.

Recommended strategy:

```text
project/
  AGENTS.md                 <- copy/adapt this memory
  .claude/
    skills/
      dext-*.md             <- official Dext Docs/skills
  .agents/
    skills/
      dext-*.md             <- for Cursor/OpenCode-style agents
  Docs/
    DEXT_AI_MEMORY.md
```

For Claude Code, put the most critical rules into `CLAUDE.md` and keep detailed Dext skill files under `.claude/skills/`.

For Cursor-style agents, use `AGENTS.md` plus `.agents/skills/`.

For Antigravity/Gemini agents, use the agent's supported root instruction file plus `.gemini/skills/`.

---
