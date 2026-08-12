# DEXT 02-WEB DEEP AUDIT

> Source group: `cesarliws/dext/Examples/02-Web`
> Snapshot: 2026-08-12

## Scope

- `Web.BasicAuthDemo`
- `Web.CachingDemo`
- `Web.ControllerExample`
- `Web.Http2Framing`
- `Web.JwtAuthDemo`
- `Web.MinimalAPI`
- `Web.NativeServer`
- `Web.RateLimitDemo`
- `Web.SslDemo`
- `Web.SwaggerControllerExample`
- `Web.SwaggerExample`
- `Web.TUUIDBindingExample`
- `Web.UUIDExample`

This group is the primary feature-level web reference. It contains both current and older examples, so trust classification matters.

---

## 1. Minimal APIs

`Web.MinimalAPI` demonstrates direct route mapping, query access, JSON/binary responses and basic DI concepts.

Core concepts:

```text
MapGet
MapPost
IHttpContext
Request.Query
Response.Write
Response.Json
static files
stream response
```

### Important drift warning

The current example source manually resolves `IGreetingService` through `Context.Services.GetService(TypeInfo(...))`.

Repository-wide current AI rules prefer typed/generic endpoint injection and explicitly warn against service-locator style request resolution.

Therefore:

```text
MinimalAPI example -> useful for endpoint/request/response mechanics
NOT golden for current endpoint DI style
```

For new code prefer typed handler parameters/generic injection where current Dext supports them.

---

## 2. Controllers

`Web.ControllerExample` is a broad controller feature laboratory.

Observed features:

```text
[ApiController]
[HttpGet]
[HttpPost]
[FromRoute]
[FromQuery]
[Authorize]
[AllowAnonymous]
constructor injection
IOptions<T>
action filters
response caching filter
custom headers
required header filter
custom filters
record/class serialization
```

Action-filter concepts include:

```text
ActionFilterAttribute
IActionExecutingContext
IActionExecutedContext
controller-level filters
action-level filters
short circuit
```

### Route rule

Use:

```pascal
[HttpGet('/{name}')]
```

not colon-style routes.

### Controller naming rule

Never name a controller method simply `Create`; use an explicit action name such as `CreateProduct`.

### Validation drift warning

`ControllerExample.Controller.pas` still contains `[StringLength(...)]`.

Repository-wide current Critical Rules say:

```text
NEVER use [StringLength]; prefer [MaxLength(N)]
```

Treat this as example drift. Do not copy `[StringLength]` into new agent-generated code without verifying current source policy.

---

## 3. Basic Authentication

`Web.BasicAuthDemo` demonstrates:

```text
UseBasicAuthentication
custom username/password validation
RequireAuthorization
public vs protected Minimal API routes
```

### Security rule

Basic Authentication is appropriate only in contexts where its security properties are understood and TLS is enforced. It is not a replacement for modern token/session architecture merely because it is simple.

Hardcoded demo credentials are never production defaults.

---

## 4. JWT Authentication

`Web.JwtAuthDemo` demonstrates:

```text
UseJwtAuthentication
TJwtTokenHandler
TClaimsBuilder
name/role/email claims
Bearer token validation
User.Identity.IsAuthenticated
User.IsInRole
protected/admin endpoints
```

Controller examples also demonstrate `[Authorize]` / `[AllowAnonymous]` attribute-based authorization.

### Golden distinction

```text
authentication -> establish who the principal is
authorization  -> decide whether that principal may perform the operation
```

Do not stop at valid JWT verification; enforce role/policy/domain authorization for protected operations.

### Production rule

Secrets, issuer, audience, expiration and signing strategy must come from configuration/secret management, not demo constants.

---

## 5. Response Caching

`Web.CachingDemo` demonstrates:

```text
UseResponseCache
cache duration
VaryByQueryString
cache-control behavior
HIT/MISS test script
```

Current Dext hardening additionally prevents unsafe caching of authenticated/private/session responses.

### Golden rule

Caching is semantic, not just a performance toggle.

Do not cache a response if its correctness depends on:

```text
Authorization
private user/session state
Set-Cookie
Cache-Control private/no-store/no-cache
unmodeled tenant/user variation
```

If query/body/user/tenant dimensions affect output, they must be represented in cache policy/key or caching must be disabled.

---

## 6. Rate Limiting

`Web.RateLimitDemo` demonstrates fixed-window limiting, rejection status `429`, rejection payload and client feedback headers.

### Version drift warning

Older example documentation refers to `X-RateLimit-*` headers. Current Dext middleware hardening moved toward RFC 9333 `RateLimit-*` semantics.

For generated code/documentation, verify current middleware behavior and prefer the current standard names.

### Golden rule

Partition the limit at the right boundary:

```text
IP
authenticated user
API key
service/tenant
route/operation
```

A global anonymous IP limit is not sufficient for every multi-tenant/financial API.

---

## 7. Swagger / OpenAPI

`Web.SwaggerExample` demonstrates Minimal API documentation through fluent metadata.

Observed concepts:

```text
Swagger UI
/swagger
/swagger.json
SwaggerEndpoint.From(...)
Summary
Description
Tag/Tags
Response
RequestType
RequireAuthorization
Swagger schema/property attributes
```

`Web.SwaggerControllerExample` is the corresponding Controller/attribute reference.

### Golden rule

Keep API metadata next to executable endpoint/controller definitions where practical so documentation evolves with code.

Do not maintain a parallel hand-written API contract when Dext can derive it, unless an external contract-first workflow specifically requires it.

---

## 8. TUUID Binding

`Web.TUUIDBindingExample` demonstrates:

```text
TUUID route binding
TUUID body binding
mixed route + body validation
TUUID.FromString
TUUID.NewV7
TUUID equality
multiple accepted textual UUID forms
```

Representative typed endpoint:

```pascal
MapGet<TUUID, IResult>('/api/products/lookup/{id}', ...)
```

### Golden rule

Prefer direct typed binding when supported instead of parsing identifiers manually in every endpoint.

UUID v7 is useful when roughly time-ordered IDs improve index locality or operational tracing, while v4 remains appropriate for random IDs.

---

## 9. UUID General Example

`Web.UUIDExample` is the broader UUID/TGUID interoperability reference.

Use it for:

```text
TUUID generation
parsing/formatting
TGUID interop
serialization
```

Use `TUUIDBindingExample` when the question is specifically web model binding.

---

## 10. SSL / HTTPS

`Web.SslDemo` documents two major TLS hosting models:

```text
Windows http.sys / SChannel kernel TLS
socket engines / OpenSSL / Taurus / Indy-style TLS
```

It also demonstrates Dext CLI development certificate tooling:

```text
dext dev-certs https --trust
```

### Golden rule

TLS configuration is server-engine-specific. Do not copy `http.sys` certificate binding steps into a Linux/OpenSSL deployment or vice versa.

Production private keys, certificate passwords and hashes must be managed securely.

---

## 11. Native Server

`Web.NativeServer` demonstrates selecting the high-performance native engine with:

```pascal
(Host as IWebApplication).UseNativeServer;
```

and normal endpoint mapping on top of it.

Classification:

```text
Tier B/C server adapter reference
```

### Golden rule

Application code should remain mostly engine-agnostic. Choose the server adapter at host/composition level unless a feature genuinely requires engine-specific behavior.

---

## 12. HTTP/2 Framing

`Web.Http2Framing` is a low-level protocol/framing reference.

Classification:

```text
Tier C
```

Do not treat it as an application endpoint architecture template.

---

## 13. Web Feature Trust Matrix

```text
ControllerExample          -> broad feature reference; validation attribute drift warning
SwaggerExample             -> OpenAPI Minimal API reference
SwaggerControllerExample   -> OpenAPI Controller reference
TUUIDBindingExample        -> strong typed binding reference
JwtAuthDemo                -> JWT feature reference
BasicAuthDemo              -> Basic auth feature reference
CachingDemo                -> caching feature reference; security rules supplement it
RateLimitDemo              -> rate limit feature reference; header naming drift warning
SslDemo                    -> TLS/server deployment reference
NativeServer               -> server adapter reference
MinimalAPI                 -> endpoint mechanics; DI style is legacy relative to current rules
UUIDExample                -> UUID general reference
Http2Framing               -> low-level Tier C
```

---

## 14. Web Golden Pipeline

For a normal production API, think in concerns rather than copying one demo:

```text
host/server selection
 -> forwarded headers / PathBase when behind proxy
 -> exception handling
 -> HTTP logging with redaction
 -> security headers
 -> CORS
 -> rate limiting
 -> compression/cache where semantically safe
 -> authentication
 -> authorization
 -> endpoints/controllers
 -> Swagger in intended environments
```

Exact order must follow current Dext middleware semantics.

---

## 15. Current-source-over-example rules

This audit found multiple cases where official examples lag the latest framework rules:

```text
MinimalAPI -> manual request service resolution
ControllerExample -> [StringLength]
RateLimit README -> older X-RateLimit-* header names
Data API README -> may show older overload
FastPath example -> manual Acquire/Release despite newer AcquireScoped API
```

Therefore the final AI precedence is:

```text
current framework source
> repository-wide Critical Rules / CONTRIBUTING_AI
> finalized specs
> current official skills
> current example .pas source
> example README
> coding pack summaries
```

An official example is evidence, not absolute authority over a newer framework revision.

---

## 16. Web Decision Tree

```text
Need web feature?
├─ compact business endpoint -> typed Minimal API
├─ larger attributed endpoint surface -> Controller
├─ generic low-risk CRUD -> Data API
├─ API docs -> Swagger/OpenAPI
├─ auth principal -> JWT/Basic/etc as appropriate
├─ authorization -> [Authorize]/policy/domain checks
├─ abuse protection -> Rate Limiting
├─ safe read acceleration -> Response Cache
├─ TLS -> engine-specific HTTPS config
├─ typed UUID identifier -> TUUID binding
├─ high-performance server adapter -> Native Server
└─ protocol internals -> Tier C examples only
```
