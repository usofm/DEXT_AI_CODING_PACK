# 93. Source References Used to Build This Memory

Primary repository sources consulted:

- `github.com/cesarliws/dext`
- `README.md`
- `Docs/Features_Implemented_Index.md`
- `Docs/CONTRIBUTING_AI.md`
- `Docs/skills/README.md`
- `Docs/skills/*` index and trigger guidance
- recent repository commits through 2026-08-11 (30-commit main-branch audit, with detailed inspection of FastPath, pooling, middleware hardening, PathBase, bulk safety, lifecycle and AI governance commits)
- `AI_GOVERNANCE.md`

Cesar Romero technical articles consulted/used for architectural synthesis:

- **Dext Framework: Reaching Maximum Performance with Zero-Alloc Pipeline**
- **Modern Delphi with Dext: From RAD to Decoupling**
- **Dext Framework: Delphi's Design-Time Revolution**
- **The End of Outdated Documentation in Delphi: Swagger & Dext Doc**
- **Dext Framework: Continuous Evolution and Focus on Architecture**
- **Dext Fluent Query: Software Engineering and the Power of Community**
- **The Modern Rest Client Delphi Deserved: Meet Dext Rest Client**
- **Domain Model & CQRS: Modernizing your Delphi Architecture**
- **Revolutionizing High-Performance Encryption in Delphi: Dext Native TLS/SSL, MessagePack and Permessage-Deflate**

---

# 94. Refresh Procedure

Because Dext is under active development, refresh this memory periodically.

Recommended automated refresh:

1. get current `main` HEAD
2. compare to audited HEAD `412ed292...`
3. inspect:
   - README
   - `Docs/CONTRIBUTING_AI.md`
   - `Docs/skills/README.md`
   - changed `Docs/skills/*.md`
   - changed `Docs/Features_Implemented_Index.md`
   - changed specs
   - public API diffs under `Sources/`
4. update critical rules
5. mark deprecated APIs
6. update snapshot commit/date
7. preserve user-specific application conventions separately from framework facts

Never silently keep obsolete method names in long-term coding memory.


# 12A. Smart Property Aliases for High-Precision Decimal Types

Dext defines explicit Smart Property aliases for Delphi's `TBcd` type:

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

These aliases are currently semantically equivalent at the type-system level: both resolve to `Prop<TBcd>`.

They exist to make entity models clearer and more idiomatic when representing exact high-precision decimal values.

## Recommended usage

```pascal
type
  TFinancialTransaction = class
  private
    FAmount: FmtBcdType;
    FRate: FmtBcdType;
    FBalance: BcdType;
  public
    property Amount: FmtBcdType read FAmount write FAmount;
    property Rate: FmtBcdType read FRate write FRate;
    property Balance: BcdType read FBalance write FBalance;
  end;
```

For financial/accounting applications, prefer `FmtBcdType` / `BcdType` over `DoubleType` or `CurrencyType` whenever the database column requires more than 4 decimal places or exact fixed-point semantics.

Examples include:

```text
NUMERIC(28,10)
DECIMAL(28,10)
exchange rates
crypto quantities
gold weights
unit costs
debit/credit amounts
high-precision balances
```

## Query behavior

Because both aliases are `Prop<TBcd>`, they participate in Dext Smart Property query-expression generation.

Conceptually:

```pascal
var E := Prototype.Entity<TFinancialTransaction>;

var Rows := Db.Transactions
  .Where(E.Rate > SomeBcdValue)
  .OrderBy(E.Rate.Desc)
  .ToList;
```

The Smart Property is not merely a storage wrapper; it can operate in Dext's query-expression mode and contribute typed AST nodes for SQL generation.

## Agent rules

1. Treat `BcdType` and `FmtBcdType` as aliases of `Prop<TBcd>`.
2. Do not invent behavioral differences between them unless the current source introduces such a distinction.
3. For exact decimal business fields, prefer these aliases over floating-point types.
4. Preserve precision/scale metadata end-to-end through ORM mapping, SQL generation, parameter binding and reads.
5. When targeting Firebird 5, `NUMERIC(28,10)` / `DECIMAL(28,10)` are valid high-precision mappings and should not be unnecessarily downgraded to `DECIMAL(18,4)`.
6. Never convert `TBcd` through `Double` or `Currency` unless the conversion is explicitly required and precision loss is acceptable.
7. Prefer FireDAC `AsFMTBCD` / native `TBcd` binding when available.



## High-Precision Smart Property Quick Reference

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

Both aliases currently represent the same underlying Smart Property type and are suitable for exact high-precision decimal fields.



# 94. Official Examples Audit — Architecture Evidence

A full audit of the official `Examples/` tree (50 directory-level examples across 8 groups) is maintained in the companion coding pack. Examples are treated as executable architecture evidence, but not as higher authority than current source or repository-wide Critical Rules.

## 94.1 Example trust levels

```text
Tier A -> architecture/reference application
Tier B -> focused feature/integration reference
Tier C -> protocol/performance/framework-internal reference
```

## 94.2 Example source precedence

```text
current Dext source
> repository-wide Critical Rules / CONTRIBUTING_AI
> finalized specs
> current official skills
> current example .pas source
> example README
> AI coding pack summaries
```

Known drift includes older `[StringLength]`, legacy route `:name`, manual request service resolution, old rate-limit header names, manual pool Acquire/Release, and legacy controller attributes in some README files.

## 94.3 Event Bus

Official examples confirm:

```text
AddEventBus
AddScopedEventBus
AddEventHandler<TEvent,THandler>
AddEventBehavior<TBehavior>
AddEventBehaviorFor<TEvent,TBehavior>
IEventPublisher<T>
Publish<T>
PublishBackground<T>
EEventDispatchAggregate / EEventDispatchException
TEventBusTracker
```

Use scoped Event Bus when handlers intentionally participate in the same HTTP request scope. Prefer narrow `IEventPublisher<T>` capabilities when a service only publishes a specific event family. Event Bus is server-side in-process decoupling; it is not a client realtime transport.

## 94.4 Server-rendered Web and HTMX

Official examples confirm Dext supports server-rendered architectures as first-class options:

```text
UseViewEngine
Results.View
AddWebStencils
AddDextTemplating
DEXT_ENABLE_WEB_STENCILS
HTMX feature endpoints / partial HTML responses
static assets + Dext backend
```

Do not default to a large SPA when server-driven HTML meets the product requirements.

## 94.5 Desktop architecture variants

Official examples demonstrate three deliberate approaches:

```text
MVVM -> Controller/ViewModel/View abstraction, Navigator, Magic Binding, feature folders
MVU  -> immutable Model + Message + Update + Render
Active Architecture -> Domain / Infra / Presentation + explicit DI composition root
```

Choose one coherently per feature/application boundary; do not mix them accidentally.

## 94.6 MCP and direct AI provider integrations

MCP FullDemo confirms Tools, Resources and Prompts with RTTI attributes and HTTP Streamable / SSE / stdio transports. DextGemini demonstrates direct AI-provider integration via typed Options + RestClient + JSON DTOs.

Use MCP for agent/tool interoperability. Use provider adapters for ordinary LLM API calls.

## 94.7 File streaming/security

Official Streaming example confirms `IFormFile`, multipart file collections, streamed responses, MIME and Content-Disposition handling. Multipart parsing is not a security policy: validate size/type/path/authorization/quota and never trust client filenames as storage paths.

## 94.8 Multi-tenancy

Official MultiTenancy example demonstrates tenant-resolution middleware and tenant-column isolation. Tenant hints (headers/routes) must be verified against authenticated/authorized tenant membership in production. Missing tenant scoping is a data-leak defect.

## 94.9 FastPath example freshness

The FastPath ORM pool example uses manual Acquire/Release, while newer pool APIs provide `AcquireScoped` RAII leases. Prefer the current scoped lease API when available.
