# 16. ORM Bulk Safety

`IDbSet<T>` includes:

```pascal
IsBulkInsertSafe
IsBulkUpdateSafe
IsBulkDeleteSafe
```

Bulk operation families:

```text
AddRange
batch insert
batch update
batch delete
dialect-aware batching
```

Agent rule:

```text
Check semantics before replacing tracked CRUD with bulk SQL.
```

---

# 17. ORM Fast Query / Direct Streaming

Core symbols:

```text
IDextFastQuery
IDbSetFastStream
TDextFastQuery
```

DbContext API:

```pascal
UseSql(...)
```

Streaming APIs:

```pascal
ExecuteToUtf8Proc(...)
ExecuteToUtf8Stream(...)
```

Purpose:

```text
database cursor
 -> UTF-8 JSON writer
 -> output stream
```

without mandatory:

```text
entity hydration
IList<T>
JSON DOM
intermediate Unicode string
```

Use for read-heavy high-throughput projections.

---

# 18. ORM Relationships

Attributes / concepts:

```text
[ForeignKey]
[BelongsTo]
[InverseProperty]
[HasMany]
[ManyToMany]
[OnDeleteCascade]
```

Loading:

```pascal
Include(...)
```

Many-to-many helpers:

```pascal
LinkManyToMany(...)
UnlinkManyToMany(...)
SyncManyToMany(...)
```

---

# 19. ORM Strongly-Typed Joins

APIs:

```pascal
JoinInner<TInner>
JoinLeft<TInner>
JoinRight<TInner>
JoinFull<TInner>
JoinCross<TInner>
```

Supports:

```text
explicit alias + ON expression
metadata-driven automatic relation join
cross join
```

---

# 20. ORM Inheritance

Strategies:

```text
TablePerHierarchy
TablePerType
```

Attributes:

```text
[Inheritance]
[DiscriminatorColumn]
[DiscriminatorValue]
```

Abbreviations:

```text
TPH
TPT
```

---

# 21. ORM Specifications

Core concepts:

```text
TSpecification<T>
Where(...)
And(...)
Or(...)
Not
```

Use for:

```text
reusable composable query predicates
```

---

# 22. ORM Raw SQL

API:

```pascal
FromSql(...)
```

Use parameterization:

```pascal
Db.Users
  .FromSql(
    'SELECT * FROM Users WHERE Age >= :Age',
    [MinAge]
  )
  .ToList;
```

Related:

```text
TSqlQueryIterator<T>
AsNoTracking
```

Agent rule:

```text
Never concatenate untrusted input into FromSql/UseSql.
```

---

# 23. ORM Stored Procedures

Attributes:

```text
[StoredProcedure]
[DbParam]
```

Parameter directions:

```text
pdInput
pdOutput
pdInputOutput
pdReturnValue
```

Other concepts:

```text
ExecuteProcedure
multiple result sets
Read<T>
```

---

# 24. ORM Concurrency

Optimistic:

```text
[Version]
optimistic concurrency exception
```

Pessimistic:

```text
TLockMode.None
TLockMode.Update
TLockMode.Shared
Lock(...)
```

---

# 25. ORM Shadow Properties

Model API concept:

```text
ShadowProperty(...)
```

Entry access:

```text
Db.Entry(Entity).Member('TenantId')
CurrentValue
```

Use for:

```text
tenant metadata
audit metadata
infrastructure-only persistence fields
```

---

# 26. ORM Type Converters

Attributes / registry:

```text
[TypeConverter]
TTypeConverterBase
TTypeConverterRegistry
RegisterConverter
RegisterConverterForType
```

Purpose:

```text
custom DB representation of Delphi types
```

---

# 27. ORM Migrations

Core symbols:

```text
TMigration
TTableBuilder
[Migration]
```

Table builder examples:

```pascal
AddColumn(...)
AsInteger
AsString(...)
AsDecimal(...)
AsBoolean
AsDateTime
AsText
AsBlob
AsGuid
PrimaryKey
AutoIncrement
NotNull
Nullable
Unique
Default
Check
AddForeignKey
AddIndex
AddUniqueIndex
AlterTable
DropTable
Execute
```

CLI:

```text
dext migrate:up
dext migrate:down
dext migrate:list
dext migrate:generate
```

---

# 28. Web Application

Core concepts:

```text
WebApplication
TWebApplication
IWebApplication
AppBuilder
THttpAppBuilderHelper
```

Lifecycle:

```text
Start
Run
Stop
Setup
Teardown
```

Important lifecycle rule:

```text
Stopped WebApplication instance is not restartable.
Create a fresh WebApplication instance.
```

---

# 29. Minimal APIs

Common endpoint APIs:

```pascal
MapGet(...)
MapPost(...)
MapPut(...)
MapDelete(...)
MapPatch(...)
MapQuery(...)
```

Route syntax:

```text
/{id}
```

not:

```text
/:id
```

Results family:

```text
IResult
Results.Ok
Results.Created
Results.BadRequest
Results.NotFound
Results.*
```

---

# 30. FastPath Routing

Core API:

```pascal
MapFast(...)
MapFast<TDbContext>(...)
```

Response APIs:

```pascal
SendJsonUtf8(...)
GetOutputStream
BodyStream
```

Use when:

```text
endpoint is simple
throughput/latency is critical
DI/RTTI/hydration overhead is measurable
direct streaming is appropriate
```

Do not use as the default architecture.

---

# 31. Controllers

Common concepts:

```text
[ApiController]
[HttpGet]
[HttpPost]
[HttpPut]
[HttpDelete]
[HttpQuery]
```

Critical rule:

```text
Never name a controller method Create.
```

Route parameter example:

```pascal
[HttpGet('/{id}')]
```

---

# 32. Web Model Binding / Validation

Related concepts:

```text
body binding
query binding
route binding
header binding
TUUID binding
automatic validation
TWebValidationException
```

If `IValidator<T>` is registered, the web model binder can execute it automatically.

---

# 33. Validation

Core unit:

```text
Dext.Validation
```

Core types:

```text
IValidator
IValidator<T>
TAbstractValidator<T>
TValidator
TValidationPatterns
TValidationError
```

Fluent API:

```pascal
RuleFor(...)
Required
Length(...)
Range(...)
EmailAddress
MatchesPattern(...)
Must(...)
When(...)
WithMessage(...)
```

Common attributes:

```text
[Required]
[MaxLength]
[Range]
[EmailAddress]
```

Documentation warning:

```text
Repository-wide Critical Rules say prefer [MaxLength(N)] over [StringLength].
Some focused validation docs still show [StringLength].
Verify current source if exact attribute behavior matters.
```

---

# 34. Middleware Pipeline

Common middleware families:

```text
HTTP Logging
Exception Handler
Developer Exception Page
CORS
Rate Limiting
Response Caching
Compression
Security Headers
Static Files
PathBase
Forwarded Headers
Antiforgery
```

---

# 35. Problem Details

Current standard:

```text
RFC 9457
```

Related:

```text
TProblemDetails
TraceId
UUIDv7 fallback
production exception sanitization
```

Avoid exposing raw internal exception messages in production.

---

# 36. CORS

Core concept:

```text
TCorsMiddleware
```

Important behaviors:

```text
strict preflight validation
Origin allowlist
Method allowlist
Header allowlist
403 on invalid preflight
Vary: Origin merge
startup fail-fast for AllowAnyOrigin + AllowCredentials
```

---

# 37. Rate Limiting

Core:

```text
TRateLimitMiddleware
```

Headers:

```text
RateLimit-Limit
RateLimit-Remaining
RateLimit-Reset
Retry-After
```

Aligned with:

```text
RFC 9333
```

---

# 38. Response Caching

Core:

```text
TResponseCacheMiddleware
UseResponseCaching
UseRedisCache
TRedisCacheStore
```

Do not cache responses containing/depending on:

```text
Authorization
auth/session cookies
Set-Cookie
Cache-Control: private
no-store
no-cache
```

HTTP QUERY cache keys may include request-body hashing.

---

# 39. Compression

Core concept:

```text
TCompressionMiddleware
```

Supported:

```text
GZip
Brotli
```

---

# 40. Security Headers

Core concept:

```text
TSecurityHeadersMiddleware
```

Common headers:

```text
HSTS
X-Content-Type-Options
X-Frame-Options
X-XSS-Protection
```

---

# 41. Path Base

Core APIs:

```pascal
UsePathBase(...)
Request.PathBase
Request.SetPath(...)
Request.SetPathBase(...)
Request.ToAppUrl(...)
```

Middleware:

```text
TDextPathBaseMiddleware
```

HTTP.sys supports kernel prefix binding with path base.

---

# 42. Forwarded Headers

Unit:

```text
Dext.Web.ForwardedHeaders
```

Purpose:

```text
zero-trust reverse-proxy forwarded-header processing
```

Agent rule:

```text
Forwarded headers are trust-boundary input.
Only trust configured proxies.
```

---

# 43. Antiforgery / CSRF

Unit:

```text
Dext.Web.Antiforgery
```

Security concepts:

```text
HMAC-SHA256
constant-time validation
CSRF protection
```

---

# 44. Feature Flags

Unit:

```text
Dext.FeatureFlags
```

Core interface:

```text
IFeatureManager
```

Filters / concepts:

```text
percentage rollout
time-window rollout
feature evaluation
```

---

# 45. Authentication / Authorization

Common symbols / concepts:

```text
JWT
[Authorize]
[AllowAnonymous]
TClaimsBuilder
claims
roles
policies
```

Use official `dext-auth` skill for exact setup.

---

# 46. HTTP QUERY

Supported method:

```text
QUERY
```

Related APIs:

```pascal
MapQuery(...)
TRestClient.Query(...)
AcceptsQuery(...)
```

Discovery header:

```text
Accept-Query
```

---

# 47. OpenAPI / Swagger

Concepts:

```text
OpenAPI
Swagger
Swagger UI
schema generation
endpoint metadata
```

Attributes / metadata may include:

```text
[SwaggerOperation]
[SwaggerAuthorize]
```

Documentation tooling:

```text
dext doc
```

---

# 48. Server-Sent Events

Concept:

```text
SSE
Server-Sent Events
```

Use for:

```text
unidirectional server -> client streaming
telemetry/event feeds
fallback transport
```

---

# 49. WebSocket

Unit families:

```text
Dext.WebSocket.Protocol
Dext.WebSocket.Handshake
Dext.WebSocket.Compression
```

Protocol support:

```text
RFC 6455
text
binary
ping
pong
close
64-bit payload
mask/unmask
Sec-WebSocket-Accept
```

Compression:

```text
RFC 7692 permessage-deflate
```

Resource protection:

```text
MaximumReceiveMessageSize
```

---

# 50. Hubs / Real-Time

Unit families:

```text
Dext.Web.Hubs
Dext.Web.Hubs.Transport.WebSocket
Dext.Web.Hubs.Client
```

Core concepts:

```text
THub
IHubClients
IHubContext<T>
groups
broadcast
ping/pong
reconnection
UI-thread marshaling
```

---

# 51. Native Server Engines

Important engine families:

```text
HTTP.sys
epoll
raw sockets
WebBroker
Indy / adapter ecosystem
```

Windows:

```text
HTTP.sys
WSAPoll / IOCP-oriented paths
```

Linux:

```text
epoll
writev
```

Low-level invariant:

```text
wire order must remain [headers][body]
```

---

# 52. TLS / SSL

Related package area:

```text
Dext.Net.Security
```

Concepts:

```text
OpenSSL 3.x
memory BIO
Schannel / HTTP.sys
HTTPS
WSS
certificate tooling
ACME strategy
Taurus/Indy compatibility
```

CLI may include developer certificate tooling:

```text
dext dev-certs
```

Exact command syntax should be verified from current CLI.

---

# 53. REST Client

Core:

```text
TRestClient
```

Unit family:

```text
Dext.Net.RestClient
```

Concepts:

```text
fluent requests
typed deserialization
async HTTP
connection pooling
QUERY method
.http file support
```

Related:

```text
Get
Post
Put
Delete
Query
Await
```

Verify exact overloads against current source.

---

# 54. gRPC / Protobuf

Related symbols / packages:

```text
Dext.Grpc.*
Dext.Serialization.Protobuf
direct/generated codecs
code-first proto export
static gRPC dispatch
```

Adapter-related fast JSON support includes gRPC provider response integration.

---

# 55. Resilience

Concept:

```text
Resilience Pipeline
```

Policy families:

```text
Retry
Circuit Breaker
Fallback
Timeout
```

Use around:

```text
network I/O
external APIs
transient DB/network failures
```

---

# 56. Logging

Core interfaces / builders:

```text
ILogger
ILoggerFactory
ILoggingBuilder
```

Levels:

```text
Trace
Debug
Information
Warning
Error
Critical
```

Sinks / extensions:

```pascal
AddConsole
AddFile
AddSeq
AddOpenTelemetry
AddAsync
```

Batching:

```text
TBatchOptions
BatchSize
FlushInterval
```

High-throughput path:

```text
async buffering / ring-buffer-oriented logging
```

---

# 57. Telemetry

Concepts:

```text
OpenTelemetry
OTLP/HTTP
traces
logs
metrics
SSE telemetry dashboard
```

Testing telemetry:

```text
Dext.Testing.Listeners.Telemetry
```

---

# 58. Background Hosted Services

Core:

```text
IHostedService
ICancellationToken
```

Registration:

```pascal
AddHostedService<T>
```

Lifecycle:

```pascal
StartAsync(...)
StopAsync(...)
```

Long-lived workers should create DI scopes for scoped dependencies.

---
