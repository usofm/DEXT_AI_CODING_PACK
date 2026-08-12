# DEXT API SYMBOL INDEX

> Fast symbol lookup for AI coding agents working with Dext.
>
> Source: `cesarliws/dext`
> Audited branch: `main`
> Snapshot HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
> Snapshot date: `2026-08-12`

## Critical rules

```text
Routes:                     {id}, not :id
Controller route params:    [HttpGet('/{id}')]
Controller action name:     never Create
Endpoint DI:                prefer typed/generic injection
ORM result collections:     IList<T>
Validation:                 prefer [MaxLength(N)] per global critical rules
Nullable Smart Property:    Prop<Nullable<T>>
Web DbContext:              .WithPooling(True)
Detached update:            .Update(Entity) before SaveChanges
Mock<T>:                    record; never Free
IDbSet<T>:                  include Dext.Entity.Core where required
Console apps:               SetConsoleCharSet
Uses helper order:          Dext -> Dext.Entity -> Dext.Web
HTTP QUERY:                 MapQuery / TRestClient.Query / AcceptsQuery
```

# Core

## `TReflection`
Unit: `Dext.Core.Reflection`

Related:
```text
TTypeMetadata
TPropertyHandler
GetAttributes<T>
HasAttribute<T>
GetPropertyValue
```

## `TActivator`
Unit: `Dext.Core.Activator`

Related:
```text
CreateInstance
[ServiceConstructor]
[Inject]
RegisterDefault
constructor cache
greedy constructor selection
```

## `TMapper`
Unit: `Dext.Mapper`

```pascal
TMapper.Map<TSource, TDest>(...)
TMapper.MapList<TSource, TDest>(...)
TTypeMapConfig<TSource, TDest>
ForMember(...)
Ignore(...)
```

# Dependency Injection

Main surface:
```text
TDextServices
TServiceCollection
TServiceDescriptor
TDextServiceProvider
IServiceProvider
IServiceScope
TDextServiceScope
```

Registration:
```pascal
AddSingleton<T>
AddTransient<T>
AddScoped<T>
AddSingletonInstance<T>
AddSingletonFactory<T>
```

Attributes:
```text
[Inject]
[ServiceConstructor]
```

# Configuration

```text
IConfiguration
TDextConfiguration
TConfigurationBuilder
TConfigurationRoot
IOptions<T>
IOptionsSnapshot<T>
IOptionsMonitor<T>
IChangeToken
```

Providers:
```text
JSON
YAML
Environment Variables
Command Line
In-Memory
```

# Core Types

## `TUUID`
Unit: `Dext.Types.UUID`

```pascal
TUUID.NewV4
TUUID.NewV7
```

Interop:
```text
TUUID <-> TGUID
TUUID <-> string
```

## `Nullable<T>`
Unit: `Dext.Types.Nullable`

```text
HasValue
Value
GetValueOrDefault
Clear
```

## `Lazy<T>`
Unit: `Dext.Types.Lazy`

```text
ILazy
ILazy<T>
TLazy<T>
TValueLazy<T>
```

# Smart Properties

Unit: `Dext.Core.SmartTypes`

Core:
```text
Prop<T>
BooleanExpression
IExpression
IOrderBy
IPropInfo
TQueryPredicate<T>
```

Aliases:
```pascal
StringType
IntType
Int64Type
BoolType
FloatType
CurrencyType
DateTimeType
DateType
TimeType
BcdType
FmtBcdType
```

Exact decimal aliases:
```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

Query operations:
```text
Like
StartsWith
EndsWith
Contains
In
NotIn
Between
IsNull
IsNotNull
Asc
Desc
= <> > >= < <= + - * /
and or not xor
```

Expression nodes:
```text
TPropertyExpression
TLiteralExpression
TConstantExpression
TBinaryExpression
TLogicalExpression
TUnaryExpression
TFunctionExpression
TFluentExpression
```

## `Prototype.Entity<T>`
Unit: `Dext.Entity.Prototype`

## `TEntityType<T>`
Unit: `Dext.Entity.TypeSystem`

Use to keep query metadata separate from plain POCO/domain classes.

# TBcd / High Precision

Core type:
```text
TBcd
```

Dext aliases:
```text
BcdType
FmtBcdType
```

Converter support:
```text
TBcd <-> Currency
TBcd <-> Double/Single/Extended
TBcd <-> string
TBcd <-> Integer/Int64
Variant <-> TBcd
```

FireDAC path:
```text
ftBCD / ftFMTBcd
Field.AsBcd
TValue.From<TBcd>
Param.AsFMTBCD
```

Use for exact domains such as `NUMERIC(28,10)` / `DECIMAL(28,10)`.

# Value Conversion

Unit: `Dext.Core.ValueConverters`

```text
TValueConverterRegistry
TValueConverter
ConvertAndSet
ConvertAndSetField
```

# Span / Memory

Units:
```text
Dext.Core.Span
Dext.Core.Memory
```

Types:
```text
TSpan<T>
TReadOnlySpan<T>
TByteSpan
TVector<T>
ILifetime<T>
TLifetime<T>
IDeferred
TDeferredAction
```

# Collections

Units:
```text
Dext.Collections
Dext.Collections.OrderedDict
Dext.Collections.Frozen
Dext.Collections.Pool
```

Interfaces:
```text
IList<T>
IEnumerable<T>
IDictionary<K,V>
IOrderedDictionary<K,V>
IFrozenList<T>
IFrozenDictionary<K,V>
IChannel<T>
```

Factories:
```pascal
TCollections.CreateList<T>
TCollections.CreateObjectList<T>
TCollections.CreateDictionary<K,V>
TCollections.CreateOrderedDictionary<K,V>
```

Channels:
```pascal
TChannel<T>.CreateBounded(...)
Write
Read
Close
IsOpen
```

Pooling:
```text
TDextPool<T>
IDextPool<T>
TDextPoolConfig
IPooledObject<T>
Acquire
AcquireScoped
Release
Use
```

# Threading / Async

```text
TAsyncTask
TCancellationTokenSource
ICancellationToken
```

Representative APIs:
```text
Run
ThenBy
OnComplete
OnException
Start
Await
Cancel
```

Processor groups:
```text
Dext.Threading.ProcessorGroups
GetSystemLogicalProcessorCount
SetThreadGroupAffinity
```

# JSON

Main facade:
```text
TDextJson
```

Units:
```text
Dext.Json
Dext.Json.Types
Dext.Json.Utf8.Serializer
```

```pascal
TDextJson.Serialize<T>
TDextJson.Deserialize<T>
```

Settings:
```text
TJsonSettings
CamelCase
SnakeCase
PascalCase
EnumAsString
EnumAsNumber
IgnoreNullValues
CaseInsensitive
ISODateFormat
UnixTimestamp
CustomDateFormat
```

DOM:
```text
IDextJsonNode
IDextJsonObject
IDextJsonArray
TJsonBuilder
```

Attributes:
```text
[JsonName]
[JsonIgnore]
[JsonCaseStyle]
```

Direct/UTF-8:
```text
TUtf8JsonSerializer
TUtf8JsonWriter
TJsonRecordInfo
Dext.Core.TypeModel
Dext.Core.DirectAccess
Dext.Codecs.Registry
Dext.Serialization.Protobuf
```

# ORM Core

Units:
```text
Dext.Entity
Dext.Entity.Core
```

Types:
```text
TDbContext
IDbSet<T>
IDbSetFastStream
TModelBuilder
```

Operations:
```text
Entities<T>
Add
AddRange
Update
Remove
SaveChanges
Find
Where
ToList
AsNoTracking
```

Bulk safety:
```text
IsBulkInsertSafe
IsBulkUpdateSafe
IsBulkDeleteSafe
```

# ORM Fast Query

```text
IDextFastQuery
TDextFastQuery
IDbSetFastStream
TDbContext.UseSql
ExecuteToUtf8Proc
ExecuteToUtf8Stream
```

Use when entity hydration is not required.

# ORM Relationships

```text
[ForeignKey]
[BelongsTo]
[InverseProperty]
[HasMany]
[ManyToMany]
[OnDeleteCascade]
Include
LinkManyToMany
UnlinkManyToMany
SyncManyToMany
```

# ORM Joins

```pascal
JoinInner<T>
JoinLeft<T>
JoinRight<T>
JoinFull<T>
JoinCross<T>
```

# ORM Inheritance

```text
TablePerHierarchy
TablePerType
[Inheritance]
[DiscriminatorColumn]
[DiscriminatorValue]
```

# Specifications

```text
TSpecification<T>
Where
And
Or
Not
```

# Raw SQL

```text
FromSql
TSqlQueryIterator<T>
AsNoTracking
```

Always parameterize untrusted values.

# Stored Procedures

```text
[StoredProcedure]
[DbParam]
pdInput
pdOutput
pdInputOutput
pdReturnValue
ExecuteProcedure
Read<T>
```

# Concurrency

Optimistic:
```text
[Version]
```

Pessimistic:
```text
TLockMode.None
TLockMode.Update
TLockMode.Shared
Lock(...)
```

# Shadow Properties

```text
ShadowProperty
Db.Entry(Entity).Member(...)
CurrentValue
```

# ORM Type Converters

```text
[TypeConverter]
TTypeConverterBase
TTypeConverterRegistry
RegisterConverter
RegisterConverterForType
```

# Migrations

```text
TMigration
TTableBuilder
[Migration]
```

Builder concepts:
```text
AddColumn
AsInteger
AsString
AsDecimal
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

# Web Application

```text
IWebApplication
TWebApplication
WebApplication
App.Builder
Start
Run
Stop
```

Lifecycle rule:
```text
stopped instance is not restartable; create a fresh instance
```

# Minimal APIs

```text
MapGet
MapPost
MapPut
MapDelete
MapPatch
MapQuery
IResult
Results.Ok
Results.Created
Results.BadRequest
Results.NotFound
```

# FastPath

```text
MapFast
MapFast<TDbContext>
IHttpResponse.SendJsonUtf8
IHttpResponse.GetOutputStream
```

Use selectively for measured hot routes.

# Controllers

```text
[ApiController]
[Route]
[HttpGet]
[HttpPost]
[HttpPut]
[HttpDelete]
[HttpQuery]
```

# Validation

Unit: `Dext.Validation`

```text
IValidator
IValidator<T>
TAbstractValidator<T>
TValidator
TValidationPatterns
TValidationError
RuleFor
Required
Length
Range
EmailAddress
MatchesPattern
Must
When
WithMessage
```

Global rule: prefer `[MaxLength(N)]` over stale `[StringLength]` examples.

# Middleware

Families:
```text
Exception Handler
HTTP Logging
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

Problem Details:
```text
RFC 9457
TProblemDetails
TraceId
```

Rate-limit headers:
```text
RateLimit-Limit
RateLimit-Remaining
RateLimit-Reset
Retry-After
```

# PathBase

```text
UsePathBase
Request.PathBase
Request.SetPath
Request.SetPathBase
Request.ToAppUrl
```

# Forwarded Headers

Unit: `Dext.Web.ForwardedHeaders`

Trust only configured proxies.

# Antiforgery

Unit: `Dext.Web.Antiforgery`

Concepts:
```text
CSRF protection
HMAC-SHA256
constant-time validation
```

# Feature Flags

Unit: `Dext.FeatureFlags`

```text
IFeatureManager
percentage rollout
time-window rollout
```

# Auth

```text
JWT
[Authorize]
[AllowAnonymous]
TClaimsBuilder
claims
roles
policies
```

# HTTP QUERY

```text
MapQuery
TRestClient.Query
AcceptsQuery
Accept-Query
```

# OpenAPI / Swagger

```text
OpenAPI
Swagger
Swagger UI
[SwaggerOperation]
[SwaggerAuthorize]
dext doc
```

# Realtime

SSE:
```text
one-way server push
```

WebSocket:
```text
RFC 6455
RFC 7692 permessage-deflate
MaximumReceiveMessageSize
```

Hubs:
```text
THub
IHubClients
IHubContext<T>
groups
broadcast
reconnection
```

# Server Engines

```text
HTTP.sys
epoll
raw sockets
WebBroker
Indy/adapters
WSAPoll/IOCP paths
writev
```

# TLS

```text
Dext.Net.Security
OpenSSL 3.x
memory BIO
Schannel / HTTP.sys
HTTPS
WSS
ACME strategy
```

# REST Client

```text
TRestClient
Dext.Net.RestClient
Get
Post
Put
Delete
Query
Await
```

# gRPC / Protobuf

```text
Dext.Grpc.*
Dext.Serialization.Protobuf
direct/generated codecs
code-first proto export
```

# Resilience

```text
Retry
Circuit Breaker
Fallback
Timeout
```

# Logging

```text
ILogger
ILoggerFactory
ILoggingBuilder
AddConsole
AddFile
AddSeq
AddOpenTelemetry
AddAsync
TBatchOptions
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

# Background Services

```text
IHostedService
ICancellationToken
AddHostedService<T>
StartAsync
StopAsync
```

# Persistent Jobs

```text
Dext.BackgroundJobs.Config
Dext.BackgroundJobs.Intf
TDextJobs
IJobClient
TSqliteJobStorage
AddBackgroundJobs
TDextJobs.Initialize
TDextJobs.Enqueue<T>
TDextJobs.Schedule<T>
```

# Testing

```text
Dext.Testing
Dext.Mocks
Mock<T>
TTest
Should
Assert
MatchSnapshot
Dext.Testing.WebApplicationFactory
Dext.Testing.History
Dext.Testing.Listeners.Telemetry
```

Attributes:
```text
[TestFixture]
[Setup]
[TearDown]
[Test]
[TestCase]
```

Mocking:
```text
Setup.Returns
Setup.Throws
When
Arg.Any<T>
Arg.Is<T>
Received
Times.Once
Times.Never
Times.Exactly
VerifyNoOtherCalls
```

Integrations:
```text
DUnit
DUnit2
DUnitX
TestInsight
```

# MCP

```text
Model Context Protocol
tools
resources
prompts
database function calling
```

# Database as API

```text
MapDataApi<T>
TDataApiHandler<T>
TDataApiOptions<T>
```

# Desktop

```text
Navigator
Magic Binding
MVVM
MVU
EntityDataSet
Active Architecture
```

# Eventing

```text
Event Bus
```

# CLI

```text
dext doc
dext index
dext test
dext migrate:up
dext migrate:down
dext migrate:list
dext migrate:generate
dev-certs
scaffold
codecs
```

# AI Governance

```text
AI_GOVERNANCE.md
Docs/CONTRIBUTING_AI.md
Docs/skills/
```

Agent rules:
```text
check specs/KIs first
avoid duplicate utilities
plan before code
TDD first
update docs/skills when behavior changes
preserve license/provenance
avoid local path pollution
```

# Official Skills

```text
dext-app-structure
dext-web
dext-orm
dext-orm-advanced
dext-di
dext-auth
dext-testing
dext-collections
dext-json
dext-api-features
dext-validation
dext-background
dext-networking
dext-logging
dext-resilience
dext-realtime
dext-database-as-api
dext-desktop-ui
dext-server-adapters
dext-mcp
dext-symbols
dext-examples
```

# Quick Routing

```text
exact decimal            -> TBcd / FmtBcdType
normal ORM read          -> IDbSet<T>
reusable predicate       -> Specification
raw entity SQL           -> FromSql
raw projection           -> UseSql / IDextFastQuery
direct JSON streaming    -> IDextFastQuery / IDbSetFastStream
normal HTTP              -> Minimal API / Controller
hot HTTP path            -> MapFast
background worker        -> IHostedService
persistent job           -> TDextJobs
object mapping           -> TMapper
producer/consumer        -> bounded IChannel<T>
immutable shared data    -> Frozen collections
realtime groups          -> Hubs
one-way realtime         -> SSE
raw bidirectional        -> WebSocket
```

# Source precedence

```text
1. current source
2. repository-wide critical rules / CONTRIBUTING_AI
3. finalized specs
4. official skills
5. official examples
6. feature index
7. this pack
```
