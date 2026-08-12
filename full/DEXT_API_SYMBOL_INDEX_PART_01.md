# DEXT API SYMBOL INDEX

> **Purpose:** Fast symbol lookup for AI coding agents working with the Dext Framework.
>
> **Repository:** `github.com/cesarliws/dext`
>
> **Audited main HEAD:** `412ed29207d2d1dc5d4a259a7739a615aed0c626`
>
> **Snapshot date:** 2026-08-12
>
> **Companion memory:** `DEXT_AI_MEMORY_ENRICHED.md`
>
> This index is intentionally compact and symbol-oriented. It is not a replacement for the
> current source tree or official `Docs/skills`. When exact overloads, attributes, compiler
> directives, ownership rules, or newly-added APIs matter, verify the current source.

---

# 1. How an AI Agent Should Use This Index

Use this file for:

```text
symbol lookup
unit lookup
API family discovery
architecture routing
"what Dext type should I use?"
"where is this feature implemented?"
"which helper/alias exists?"
```

Recommended lookup order:

```text
1. Search symbol in this file
2. Load the matching official Docs/skills/dext-*.md
3. Inspect the source unit
4. Inspect the nearest official example
5. Generate/modify code
```

Do not recursively load the entire Dext repository into context when a symbol-level lookup is enough.

---

# 2. Critical Global Rules

```text
Route parameters:                {id}, not :id
Controller route parameter:      [HttpGet('/{id}')]
Controller methods:              never name one Create
DI from endpoint context:        prefer generic endpoint injection; not RequestServices.GetService<T>
ORM result collections:          IList<T>, not TObjectList<T>
Validation rule:                 prefer [MaxLength(N)] per repository-wide critical rules
Navigation nullability:          Nullable<T>, not legacy NavType<T>
Web DbContexts:                  .WithPooling(True)
Detached update:                 .Update(Entity) before SaveChanges
Mock<T>:                         record; never Free
IDbSet<T> compilation:           include Dext.Entity.Core
Console projects:                SetConsoleCharSet
Uses order:                      Dext -> Dext.Entity -> Dext.Web
Smart nullable composition:      Prop<Nullable<T>>
HTTP QUERY:                      MapQuery / TRestClient.Query / AcceptsQuery
```

---

# 3. Core Facades and Foundation

## `Dext`

**Unit / facade:** `Dext.pas`

Purpose:

```text
top-level public facade
common aliases
core helpers
service registration surface
```

High-value aliases include:

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

Exact high-precision aliases:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

---

## `TReflection`

**Unit:** `Dext.Core.Reflection`

Purpose:

```text
shared RTTI context
metadata cache
attribute lookup
property/field metadata
optimized property access
```

Important related symbols:

```text
TTypeMetadata
TPropertyHandler
GetAttributes<T>
HasAttribute<T>
GetPropertyValue
```

---

## `TActivator`

**Unit:** `Dext.Core.Activator`

Purpose:

```text
RTTI-based construction
constructor selection
DI activation
hybrid explicit-arg + DI construction
collection auto-instantiation
```

Related symbols / concepts:

```text
CreateInstance
[ServiceConstructor]
[Inject]
RegisterDefault
constructor cache
greedy constructor selection
```

---

## `TMapper`

**Unit:** `Dext.Mapper`

Purpose:

```text
object-to-object mapping
record mapping
collection mapping
in-place mapping
custom member mappings
```

Related APIs:

```pascal
TMapper.Map<TSource, TDest>(...)
TMapper.MapList<TSource, TDest>(...)
TTypeMapConfig<TSource, TDest>
ForMember(...)
Ignore(...)
```

Agent rule:

```text
Before writing repetitive DTO/entity copy code, check Dext.Mapper.
```

---

# 4. Dependency Injection

## `TDextServices`

**Units:** `Dext.DI.*`, facade through `Dext`

Service registration:

```pascal
AddSingleton<T>
AddTransient<T>
AddScoped<T>
AddSingletonInstance<T>
AddSingletonFactory<T>
```

Related types:

```text
TServiceCollection
TServiceDescriptor
TDextServiceProvider
IServiceScope
TDextServiceScope
IServiceProvider
```

Attributes:

```pascal
[Inject]
[ServiceConstructor]
```

Collection auto-resolution:

```text
IList<T>
IEnumerable<T>
IDictionary<K,V>
```

---

# 5. Configuration and Options

Core interfaces / builders:

```text
IConfiguration
TDextConfiguration
TConfigurationBuilder
TConfigurationRoot
```

Providers:

```text
JSON
YAML
Environment Variables
Command Line
In-Memory
```

Builder concepts:

```pascal
AddJsonFile(...)
AddYamlFile(...)
AddEnvironmentVariables(...)
AddCommandLine(...)
AddInMemoryCollection(...)
```

Options:

```text
IOptions<T>
IOptionsSnapshot<T>
IOptionsMonitor<T>
```

Reload / validation:

```text
IChangeToken
OnReload
AddSectionValidator
```

Nested environment-variable convention:

```text
Database__ConnectionString
Jwt__SecretKey
```

---

# 6. Core Types

## `TUUID`

**Unit:** `Dext.Types.UUID`

Important APIs:

```pascal
TUUID.NewV4
TUUID.NewV7
```

Interop:

```text
TUUID <-> TGUID
TUUID <-> string
```

Use V7 when time-ordered identifiers are beneficial.

---

## `Nullable<T>`

**Unit:** `Dext.Types.Nullable`

Core APIs:

```text
HasValue
Value
GetValueOrDefault
Clear
```

Preferred nullable Smart Property composition:

```pascal
Prop<Nullable<T>>
```

Avoid:

```pascal
Nullable<Prop<T>>
```

---

## `Lazy<T>`

**Unit:** `Dext.Types.Lazy`

Related:

```text
ILazy
ILazy<T>
TLazy<T>
TValueLazy<T>
```

Purpose:

```text
thread-safe lazy initialization
optional ownership
lazy navigation support
```

---

# 7. Smart Properties and Query Expressions

## `Prop<T>`

**Unit:** `Dext.Core.SmartTypes`

Dual-mode record:

```text
Runtime Mode -> stores actual T
Query Mode   -> builds expression AST
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

High-precision aliases:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

String query methods:

```pascal
Like(...)
StartsWith(...)
EndsWith(...)
Contains(...)
```

Set/range methods:

```pascal
In(...)
NotIn(...)
Between(...)
IsNull
IsNotNull
```

Ordering:

```pascal
Asc
Desc
```

Operators:

```text
= <> > >= < <= + - * / unary -
and or not xor
```

Related expression types:

```text
BooleanExpression
IExpression
TPropertyExpression
TLiteralExpression
TConstantExpression
TBinaryExpression
TLogicalExpression
TUnaryExpression
TFunctionExpression
TFluentExpression
TQueryPredicate<T>
IOrderBy
IPropInfo
```

---

## `Prototype.Entity<T>`

**Unit:** `Dext.Entity.Prototype`

Purpose:

```text
ghost/prototype entity for strongly-typed query and validation expressions
```

Example:

```pascal
var U := Prototype.Entity<TUser>;
Db.Users.Where(U.Age >= 18);
```

---

## `TEntityType<T>`

**Unit:** `Dext.Entity.TypeSystem`

Purpose:

```text
typed query metadata without embedding Prop<T> in POCO/domain entities
```

Use when preserving a clean existing POCO/domain model.

---

# 8. High-Precision Decimal / TBcd

Core Delphi type:

```pascal
TBcd
```

Related Dext aliases:

```pascal
BcdType
FmtBcdType
```

Both are:

```pascal
Prop<TBcd>
```

Value converter support includes:

```text
TBcd <-> Currency
TBcd <-> Double
TBcd <-> Single
TBcd <-> Extended
TBcd <-> string
TBcd <-> Integer
TBcd <-> Int64
Variant <-> TBcd
```

FireDAC read/write path:

```text
ftBCD / ftFMTBcd
Field.AsBcd
TValue.From<TBcd>
Param.AsFMTBCD
```

Use for:

```text
NUMERIC(28,10)
DECIMAL(28,10)
exchange rates
crypto amounts
gold weights
high-precision quantities
financial balances
```

Agent rule:

```text
Do not silently replace TBcd/FmtBcdType with DoubleType or CurrencyType.
```

---

# 9. Value Conversion

## `TValueConverterRegistry`

**Unit:** `Dext.Core.ValueConverters`

Lookup strategy:

```text
exact PTypeInfo pair
kind-based match
variant fallback
```

Related APIs:

```text
TValueConverter
ConvertAndSet
ConvertAndSetField
```

Supports Smart Property and Nullable awareness.

---

# 10. Span, Memory and Lifetime

## `TSpan<T>`

**Unit:** `Dext.Core.Span`

APIs:

```pascal
Slice
ToArray
Clear
GetEnumerator
```

Related:

```text
TReadOnlySpan<T>
TByteSpan
TVector<T>
```

`TByteSpan` includes:

```text
SIMD-aware equality
UTF-8 string comparison
IndexOf
ToString
ToBytes
```

---

## `ILifetime<T>`

**Unit:** `Dext.Core.Memory`

Related:

```text
TLifetime<T>
```

Purpose:

```text
interface/ARC wrapper around non-ARC object lifetime
```

---

## `IDeferred`

**Unit:** `Dext.Core.Memory`

Related:

```text
TDeferredAction
```

Purpose:

```text
scope-exit cleanup / defer pattern
```

---

# 11. Collections

Primary unit:

```text
Dext.Collections
```

Core interfaces:

```text
IList<T>
IEnumerable<T>
IDictionary<K,V>
IOrderedDictionary<K,V>
IFrozenList<T>
IFrozenDictionary<K,V>
IChannel<T>
```

Factory:

```pascal
TCollections.CreateList<T>
TCollections.CreateObjectList<T>
TCollections.CreateDictionary<K,V>
TCollections.CreateOrderedDictionary<K,V>
```

Ordered dictionary related:

```text
TOrderedDictionary<K,V>
KeyAt
ValueAt
```

Frozen collections:

```text
ToFrozenList
lock-free concurrent reads
immutable after freeze
```

Channels:

```pascal
TChannel<T>.CreateBounded(...)
Write(...)
Read(...)
Close
IsOpen
```

ORM ownership rule:

```pascal
TCollections.CreateList<TEntity>(False)
```

when DbContext owns/tracks entities.

Avoid:

```text
TObjectList<T> for ORM results
owning child list + DbContext ownership
```

---

# 12. Generic Object Pooling

**Unit:** `Dext.Collections.Pool`

Core symbols:

```text
TDextPool<T>
IDextPool<T>
TDextPoolConfig
IPoolable
IPooledObject<T>
```

Key APIs:

```pascal
Acquire(...)
AcquireScoped(...)
Release(...)
Use(...)
```

Configuration:

```text
MinSize
MaxSize
AcquireTimeoutMs
```

Concurrency concepts:

```text
TSpinLock
ManualReset event
atomic waiter tracking
monotonic deadline
drain-before-free
```

Preferred lifecycle:

```pascal
var Lease := Pool.AcquireScoped;
if Lease <> nil then
  Lease.Item.DoWork;
```

FastPath pool exhaustion may map to:

```text
HTTP 503 Service Unavailable
```

---

# 13. Threading / Async

## `TAsyncTask`

**Unit:** `Dext.Core.Async` / threading family

Representative APIs:

```pascal
TAsyncTask.Run(...)
ThenBy(...)
OnComplete(...)
OnException(...)
Start
Await
```

Cancellation:

```text
TCancellationTokenSource
ICancellationToken
IsCancellationRequested
Cancel
WaitForCancellation
```

---

## Processor Groups

**Unit:** `Dext.Threading.ProcessorGroups`

Symbols / concepts:

```text
GetSystemLogicalProcessorCount
SetThreadGroupAffinity
round-robin processor group allocation
NUMA awareness
```

Use on Windows systems with more than 64 logical CPUs.

---

# 14. JSON

Main facade:

```text
TDextJson
```

Unit family:

```text
Dext.Json
Dext.Json.Types
Dext.Json.Utf8.Serializer
```

Core APIs:

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
ServiceProvider
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

UTF-8 / direct codec path:

```text
TUtf8JsonSerializer
TUtf8JsonWriter
TJsonRecordInfo
ToUtf8JSON
Dext.Core.TypeModel
Dext.Core.DirectAccess
Dext.Codecs.Registry
Dext.Serialization.Protobuf
```

---

# 15. ORM Core

Main facade / unit family:

```text
Dext.Entity
Dext.Entity.Core
```

Core symbols:

```text
TDbContext
IDbSet<T>
IDbSetFastStream
TModelBuilder
```

High-level operations:

```pascal
Add(...)
AddRange(...)
Update(...)
Remove(...)
SaveChanges
Find(...)
Where(...)
ToList
AsNoTracking
```

Detached entity rule:

```pascal
Db.Entities.Update(Entity);
Db.SaveChanges;
```

Web API DbContext rule:

```pascal
.WithPooling(True)
```

---
