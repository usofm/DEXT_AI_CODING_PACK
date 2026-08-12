# DEXT EXAMPLE DRIFT REGISTER

> Purpose: record places where an official example or README lags current Dext conventions, so an AI agent does not blindly copy stale syntax.
> Snapshot: 2026-08-12

## Why this file exists

Dext evolves quickly. Official examples remain extremely valuable, but a framework commit can land before every example and README is synchronized.

Use this precedence:

```text
current Dext source
> repository-wide Critical Rules / CONTRIBUTING_AI
> finalized specs
> current official skills
> current example .pas source
> example README
> this coding pack
```

---

## DRIFT-001 — `Web.DextStore` README uses legacy controller names

README describes older concepts such as:

```text
[DextController]
[DextGet]
[DextPost]
```

Current `DextStore.Controllers.pas` uses:

```text
[ApiController]
[HttpGet]
[HttpPost]
[HttpDelete]
[FromRoute]
[FromServices]
```

### Agent action

Use the current `.pas` controller source for exact syntax.

---

## DRIFT-002 — `Web.ControllerExample` still uses `[StringLength]`

Current example source contains DTO fields with:

```pascal
[StringLength(3, 50)]
```

Repository-wide current AI Critical Rules state:

```text
NEVER use [StringLength]; use [MaxLength(N)]
```

### Agent action

For new code follow the repository-wide Critical Rule unless current source explicitly changes that rule.

---

## DRIFT-003 — `Web.MinimalAPI` manually resolves request services

The focused Minimal API example uses request-context service resolution:

```text
Context.Services.GetService(...)
```

Current Dext agent guidance prefers generic/typed endpoint injection rather than Service Locator style request resolution.

`Web.TaskFlowAPI` demonstrates the stronger current pattern:

```pascal
MapPost<TRequest, IService, IResult>(...)
```

### Agent action

Use `Web.MinimalAPI` for routing/request/response mechanics, but prefer TaskFlow/Tier-A typed injection for new endpoint DI code.

---

## DRIFT-004 — `Web.RateLimitDemo` README uses older header names

README describes:

```text
X-RateLimit-Limit
X-RateLimit-Remaining
Retry-After
```

Current Dext middleware hardening moved toward RFC 9333-style:

```text
RateLimit-Limit
RateLimit-Remaining
RateLimit-Reset
Retry-After
```

### Agent action

Verify current middleware source and document the current standard headers.

---

## DRIFT-005 — `Web.FastPath.OrmPool` uses manual pool Acquire/Release

Example demonstrates:

```pascal
Acquire(...)
try
  ...
finally
  Release(...)
end;
```

Newer Dext pool work introduced:

```text
IPooledObject<T>
AcquireScoped
```

for RAII-style lease management.

### Agent action

Prefer `AcquireScoped` where present in the target Dext revision; retain manual Acquire/Release only when required by the exact API/version.

---

## DRIFT-006 — `Web.DatabaseAsApi` documentation may show older `Map` overloads

The Data API feature has evolved. Example README/source and current handler overloads may differ.

### Agent action

Use the example to choose the architecture and options (`UseSnakeCase`, Swagger, Tag, DbContext), then inspect current `TDataApiHandler<T>` source for the exact call signature.

---

## DRIFT-007 — `Web.StreamingDemo` README uses colon-style routes

README lists routes like:

```text
/download/:name
/stream/:name
```

Current Dext route syntax is:

```text
/download/{name}
/stream/{name}
```

### Agent action

Never copy colon route syntax into new Dext code.

---

## DRIFT-008 — `Web.OrderAPI` README uses legacy Dext controller attributes

The DMVC migration README references:

```text
[DextRoute]
[DextGet]
```

Current controller syntax elsewhere in the repo uses:

```text
[ApiController]
[HttpGet]
[HttpPost]
...
```

### Agent action

Use OrderAPI for migration concepts and layering, not as the final authority for current attribute names.

---

## DRIFT-009 — Example security values are illustrative only

Multiple official examples intentionally contain demo-only values such as:

```text
admin/admin
admin/password
hardcoded JWT secrets
local SQLite credentials/settings
broad AllowAnyOrigin CORS
DeveloperExceptionPage
```

### Agent action

Never promote demo credentials/secrets/CORS/error handling directly into production configuration.

Production code should use:

```text
secret/config providers
strong credentials/password hashing
least-privilege CORS
production exception sanitization
trusted proxy configuration
TLS
real authorization rules
```

---

## DRIFT-010 — Fast demos may manually return raw exception messages

Some focused examples, such as realtime/control demos, return `E.Message` for simplicity.

Current production middleware guidance uses sanitized RFC 9457 Problem Details for unexpected production 500 errors.

### Agent action

Treat raw exception responses as demo code only.

---

## DRIFT-011 — README terminology can be semantically ambiguous

Example names can collide with framework feature names.

Important case:

```text
Web.EventHub
```

is an event-management / attendee-registration business application, while:

```text
Dext.Web.Hubs
```

is the realtime Hubs framework.

### Agent action

Route realtime group/broadcast questions to `04-Advanced/Hubs` or `Web.AirFlow`, not `Web.EventHub`.

---

## DRIFT-012 — Older server/bootstrap APIs coexist with newer WebApplication facade examples

Some older examples use lower-level:

```text
TDextWebHost.CreateDefaultBuilder
IWebHostBuilder
IApplicationBuilder
```

while newer examples favor:

```text
WebApplication
IStartup
IWebApplication
App.Builder
```

### Agent action

Follow the target application's existing hosting style and prefer the current recommended facade for new projects. Do not mechanically rewrite working legacy bootstrap code unless modernization is requested.

---

# Drift Handling Algorithm

```text
Encounter example code
  ↓
Check this register
  ↓
Compare with current Critical Rules
  ↓
Inspect current framework symbol/signature
  ↓
If conflict exists:
  source/current rule wins
  ↓
Generate modern code and mention migration only when relevant
```

---

# Maintenance Rule

Whenever a new Dext commit changes an agent-facing API:

1. inspect affected official examples;
2. remove resolved drift entries;
3. add newly discovered drift entries;
4. update symbol index, recipes and decision tree when architecture/usage changes.
