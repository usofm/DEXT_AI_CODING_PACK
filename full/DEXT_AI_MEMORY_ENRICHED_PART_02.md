# 6. Reflection, RTTI and Metadata

Dext heavily uses Delphi RTTI but tries to remove RTTI overhead from hot paths.

Concepts to remember:

- shared RTTI context
- metadata caching
- constructor caches
- property/field metadata
- attribute scanning
- smart-type detection
- lock-free fast paths after initialization where possible

Important architectural principle:

> RTTI should be paid for during discovery/caching, not repeatedly in request/database hot paths.

When adding a feature that relies on reflection:

- look for existing cached metadata structures
- never repeatedly create `TRttiContext` in hot loops without checking Dext reflection services
- prefer centralized metadata plans
- integrate with existing type models/direct access when possible

---

# 7. Zero-Allocation and Span Philosophy

Cesar Romero emphasizes that backend performance is frequently limited by transient heap pressure rather than arithmetic.

Dext's performance strategy includes:

- typed spans over raw memory
- stack / bounded temporary structures where appropriate
- avoiding per-request `TList<T>`, `TStrings`, `TDictionary` allocations in hot paths
- lazy request views
- cached routing metadata
- direct UTF-8 handling
- direct field access plans
- avoiding unnecessary UTF-8 ↔ Unicode conversions
- SIMD-accelerated byte operations where supported

Important types/concepts include:

```pascal
TSpan<T>
TReadOnlySpan<T>
TByteSpan
TVector<T>
```

`TByteSpan` is particularly important for:

- HTTP parsing
- JSON parsing
- protocol parsing
- byte comparison
- UTF-8 operations

### Agent performance rule

Never "simplify" a hot-path Dext implementation by replacing spans/records/direct plans with:

```pascal
TStringList
TList<T>
TDictionary<K,V>
string conversions
temporary TBytes
```

unless profiling or correctness requires it.

For application code, normal abstractions may be acceptable; for framework internals and request hot paths, preserve zero-allocation intent.

---

# 8. Dext Collections

Dext has its own collection abstractions partly to improve ownership semantics, binary size, compile time, and developer ergonomics.

Prefer:

```pascal
IList<T>
IDictionary<K,V>
TCollections
```

when working with Dext APIs.

Benefits include:

- interface-based lifetime handling
- reduced manual free patterns
- Dext-native LINQ-like operations
- cleaner interoperability with ORM and DI
- compile-time/binary optimizations targeted by the framework

Do not reflexively replace Dext collections with `Generics.Collections`.

---

# 9. JSON Architecture

Dext JSON has multiple layers.

## 9.1 High-level JSON API

Use `TDextJson` for normal application serialization.

Conceptually:

```pascal
var Json := TDextJson.Serialize<TUser>(User);
var User := TDextJson.Deserialize<TUser>(Json);
```

Settings include ideas like:

```pascal
TJsonSettings
  .CamelCase
  .EnumAsString
  .IgnoreNullValues
  .ISODateFormat
```

Other supported concepts include:

- SnakeCase
- PascalCase
- enum number/string strategy
- custom date formatting
- case-insensitive deserialization
- service-provider integration

## 9.2 DOM abstraction

Dext abstracts underlying JSON engines through interfaces such as:

```pascal
IDextJsonNode
IDextJsonObject
IDextJsonArray
```

Do not tightly couple higher-level framework code to `System.JSON` unless intentionally working in a provider.

## 9.3 Low-level UTF-8 / direct codecs

For massive payloads or hot-path serialization, Dext includes low-level direct UTF-8 approaches.

Key idea:

> Avoid converting the entire payload into Delphi `string` if it can be parsed or serialized directly in UTF-8 memory.

The newer direct-codec architecture connects:

- field plans
- direct offset reads/writes
- JSON
- ORM hydration
- Protobuf
- gRPC dispatch
- code-first schema generation

When modifying serialization internals, check the direct-codec/type-model architecture before adding RTTI-only behavior.

---

# 10. Dependency Injection

Dext DI supports familiar service lifetimes:

```text
Singleton
Scoped
Transient
```

Typical style:

```pascal
Builder.Services
  .AddSingleton<IClock, TSystemClock>
  .AddScoped<IOrderService, TOrderService>
  .AddTransient<IEmailFormatter, TEmailFormatter>;
```

### Preferred injection order

1. constructor injection
2. supported typed endpoint/controller injection
3. explicit `[Inject]` where appropriate
4. manual service location only when necessary

### Constructor activation

Dext's activator supports constructor discovery and can use a greedy strategy for resolvable constructor parameters, with explicit constructor selection support.

Be careful when:

- adding multiple constructors
- adding a constructor whose dependencies are not registered
- mixing manual parameters with DI parameters

### Scoped lifetime

Web request services and DbContexts generally belong to scopes.

Do not hold a scoped dependency inside a long-lived singleton unless the dependency is intentionally resolved via a scope/factory.

---

# 11. Configuration and Options Pattern

Dext adopts a layered configuration model similar to modern .NET hosting.

Potential sources include:

```pascal
.AddJsonFile(...)
.AddYamlFile(...)
.AddEnvironmentVariables(...)
.AddCommandLine
.AddInMemoryCollection(...)
```

Hierarchical keys use section semantics, e.g.:

```text
Database:ConnectionString
Jwt:Issuer
Jwt:Audience
```

Typed options concepts:

```pascal
IOptions<T>
IOptionsSnapshot<T>
IOptionsMonitor<T>
```

Prefer strongly typed configuration objects over scattering string keys across application logic.

---

# 12. Web Application Model

There are two broad idioms visible across Dext evolution:

- builder/host-oriented setup
- concise `WebApplication` / fluent application setup

Always verify the current examples/skills for exact startup signature.

Typical conceptual flow:

```pascal
var Builder := WebApplication.CreateBuilder;

Builder.Services
  .AddScoped<IOrderService, TOrderService>;

var App := Builder.Build;

App.MapGet(...);
App.MapPost(...);

App.Run(...);
```

or a concise form:

```pascal
var App := WebApplication;
App.MapGet(...);
App.Run(...);
```

Use whichever form current Dext version supports for the required features.

---

# 13. Minimal APIs

Minimal APIs are preferred for small, direct endpoints.

Example style:

```pascal
App.MapGet('/hello',
  function: string
  begin
    Result := 'Hello from Dext';
  end
);
```

Typed DTO + service injection pattern:

```pascal
App.MapPost<TRegisterDto, IUserService, IResult>(
  '/register',
  function(Dto: TRegisterDto; UserService: IUserService): IResult
  begin
    UserService.Register(Dto);
    Result := Results.Created('/login', 'registered');
  end
);
```

### Agent rules for Minimal APIs

- use typed DTOs
- inject dependencies rather than resolving manually
- use `Results.*` / Dext result abstractions
- keep endpoint logic thin
- move business logic into services/domain/application layer
- let model binding / validation do infrastructure work where possible

---

# 14. Controllers

Use Controllers when endpoint groups require:

- cohesive route prefix
- shared authorization
- filters/attributes
- larger API surface
- clearer action organization

Conceptual pattern:

```pascal
[DextController('/api/orders')]
TOrdersController = class(TController)
private
  FService: IOrderService;
public
  constructor Create(AService: IOrderService);

  [DextGet('/{id}')]
  function GetById(Id: Integer): IResult;

  [DextPost]
  function CreateOrder([Body] Dto: TCreateOrderDto): IResult;
end;
```

Exact attribute names may vary by current API. Search current `dext-web` skill before generating production code.

Do not put SQL or direct connection manipulation in controller actions.

---

# 15. Middleware Pipeline

Dext follows an ordered middleware pipeline model.

Middleware ordering matters.

Typical concerns may include:

- forwarded headers
- exception handling
- request logging
- CORS
- authentication
- authorization
- anti-forgery
- compression
- caching
- endpoints
- static files
- telemetry

### Agent rule

Do not reorder middleware casually. State why a middleware belongs before or after another.

Examples of dependency:

- forwarded headers should be processed before logic that trusts client scheme/IP
- authentication must run before authorization
- exception handling should wrap downstream execution
- telemetry should cover the intended pipeline section
- compression should operate on suitable responses, not already finalized streams

---

# 16. Security Features

Current Dext evolution includes enterprise-oriented web security infrastructure.

Recent observed implementation work includes:

- forwarded header processing with Zero-Trust awareness
- anti-forgery / CSRF protection
- HMAC-SHA256 validation
- constant-time validation
- feature flags
- integration test application factory

Other security concepts across Dext include:

- JWT authentication
- authorization policies/attributes
- TLS/SSL
- WSS
- CORS
- rate limiting
- secure header-aware reverse proxy deployment

### Forwarded headers

Do not blindly trust:

```text
X-Forwarded-For
X-Forwarded-Proto
Forwarded
```

Only trust forwarded information when the proxy/network trust model is configured.

### CSRF

For cookie-authenticated browser workflows, anti-forgery matters.

For pure bearer-token APIs, CSRF threat modeling differs.

Do not blindly apply or disable anti-forgery without considering auth transport.

---

# 16A. Hardened Production Middleware Details

Recent Web reviews hardened Dext's production middleware behavior.

## HTTP Logging

`THttpLoggingMiddleware` supports case-insensitive sensitive-header redaction.

Examples of headers that should normally be redacted:

```text
Authorization
Cookie
Set-Cookie
X-API-Key
```

Never weaken the redaction list merely to simplify debugging in production.

## Problem Details

Dext's current exception handling aligns with:

```text
RFC 9457 — Problem Details for HTTP APIs
```

not the older RFC 7807 reference.

Current behavior includes a trace/correlation identifier fallback based on UUIDv7 and production-oriented sanitization of internal exception messages for HTTP 500 responses.

Do not return raw `Exception.Message` to production clients unless the exception is deliberately public-safe.

## Strict CORS

Current CORS behavior includes strict validation of:

- Origin
- requested method
- requested headers
- preflight shape

Invalid preflights may be rejected with HTTP 403.

The configuration should fail fast for the dangerous combination:

```text
AllowAnyOrigin + AllowCredentials
```

Do not "fix" a CORS problem by enabling wildcard origins with credentials.

## RFC 9333 Rate-Limit Headers

Dext rate limiting emits standardized information such as:

```text
RateLimit-Limit
RateLimit-Remaining
RateLimit-Reset
Retry-After
```

on allowed/rejected flows as appropriate.

## Hardened Response Cache

Dext avoids caching sensitive/authenticated responses.

Important no-cache triggers include:

- `Authorization`
- authentication/session cookies
- response `Set-Cookie`
- `Cache-Control: private`
- `no-store`
- `no-cache`

Cached public hits can reconstruct suitable:

```text
Cache-Control: public, max-age=N
```

### Cache Agent Rule

Never make authenticated responses cacheable merely to improve performance without a complete user/tenant-specific cache key and security review.

---
