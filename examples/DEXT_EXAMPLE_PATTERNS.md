# DEXT EXAMPLE PATTERNS

> Patterns extracted from official Dext examples. Use these as composition guidance, then verify exact signatures in current source.

## 1. Startup as composition root

Tier A applications commonly centralize application composition in a `TStartup` implementing `IStartup`:

```pascal
type
  TStartup = class(TInterfacedObject, IStartup)
  public
    procedure ConfigureServices(
      const Services: TDextServices;
      const Configuration: IConfiguration
    );

    procedure Configure(const App: IWebApplication);
  end;
```

Use `ConfigureServices` for DI and persistence registration; use `Configure` for middleware, endpoints, controllers, Swagger and other HTTP-pipeline concerns.

## 2. Typed DbContext

`Web.FoodDelivery` demonstrates a typed context with `IDbSet<T>` accessors:

```pascal
type
  TAppDbContext = class(TDbContext)
  private
    function GetOrders: IDbSet<TOrder>;
  public
    property Orders: IDbSet<TOrder> read GetOrders;
  end;

function TAppDbContext.GetOrders: IDbSet<TOrder>;
begin
  Result := Entities<TOrder>;
end;
```

Keep `Dext.Entity.Core` in `uses` where needed for `IDbSet<T>` generic symbols.

## 3. Business services via DI

Tier A examples separate business behavior from route code:

```pascal
Services.AddSingleton<IOrderService, TOrderService>;
```

For request-scoped resources, use an appropriate scoped lifetime rather than copying singleton examples blindly.

## 4. Controllers + Minimal APIs can coexist

`Web.FoodDelivery` combines:

```text
Services.AddControllers
App.MapControllers
MapGet / MapPost
```

Use Minimal APIs for compact endpoints and Controllers when grouped behavior, attributes, filters or larger endpoint surfaces justify them.

## 5. Middleware before endpoint exposure

A representative pipeline from `Web.FoodDelivery` includes:

```text
UseExceptionHandler
UseHttpLogging
UseRateLimiting
UseResponseCache
UseCors
MapGet / MapPost
Data API mapping
MapControllers
UseSwagger
```

Do not copy ordering mechanically; understand which middleware must wrap downstream execution and verify current Dext conventions.

## 6. Global JSON policy

Examples can configure a single application-wide JSON policy, such as camelCase, case-insensitive reads and enum-as-string behavior.

Keep serialization policy centralized rather than configuring individual endpoints inconsistently.

## 7. Typed endpoint DI

`Web.FoodDelivery` demonstrates generic endpoint signatures where Dext resolves dependencies directly, for example a business service or DbContext supplied as typed parameters.

Prefer this over manually resolving services from `RequestServices`.

## 8. Smart Properties in application queries

Representative pattern:

```pascal
var Order := Prototype.Entity<TOrder>;
var List := Db.Orders
  .Where(Order.Total > 50)
  .ToList;
```

This is the preferred typed-query style when the entity/query metadata supports Smart Properties.

## 9. Database as API

`Web.DatabaseAsApi` and `Web.FoodDelivery` show metadata-driven CRUD exposure for appropriate entities.

Use Data API for admin/internal/rapid CRUD surfaces; do not bypass domain business rules for sensitive operations merely because automatic CRUD is available.

## 10. Swagger from application metadata

Focused Swagger examples plus Tier A use cases demonstrate documenting both Minimal APIs and Controllers.

Use official metadata/attributes rather than hand-maintaining a separate OpenAPI description when Dext can derive it.

## 11. Integration test scripts next to examples

Tier A examples such as `Web.FoodDelivery` and `Web.DextStore` include PowerShell integration scripts and/or `.http` files.

Agent rule: when adding a significant API example, add executable request-level verification rather than relying only on compilation.

## 12. Domain + Service + Startup separation

`Web.FoodDelivery` separates files such as:

```text
Domain
Services
DbSeeder
Startup
HTTP test file
integration test script
DPR
```

This is a useful small-application separation model.

`Web.DextStore` goes further with dedicated Controllers, Models, Services, migration documentation and multiple integration scripts.

## 13. ORM-focused learning sequence

For ORM work, inspect in this order:

```text
Orm.EntityStyles        -> how entities can be represented
Orm.EntityDemo          -> CRUD/relations/navigation behavior
Orm.Specification       -> reusable predicates
ComplexQuerying         -> advanced composition
MultiTenancy            -> tenant-aware data access
Web.DatabaseAsApi       -> ORM metadata exposed as API
Web.FastPath.OrmPool    -> performance specialization
```

## 14. Performance examples are not default architecture

`Web.FastPath.OrmPool`, `Web.NativeServer`, `Web.Http2Framing`, and parser demos are specialized references.

Do not infer that low-level bypasses, direct streaming or protocol code should replace normal Dext application patterns.

## 15. Realtime choice

Use:

```text
Hubs example -> group/broadcast/higher-level realtime
EventHub     -> event-streaming use case
raw WebSocket internals -> only when protocol-level control is required
```

## 16. UI architecture choice

Official UI examples intentionally demonstrate multiple approaches:

```text
MVVM -> Desktop.MVVM.CustomerCRUD
MVU  -> Desktop.MVU.Counter / CounterFrame
Active Architecture -> 09-ActiveArchitecture
```

Do not mix patterns accidentally. Choose one architecture deliberately per feature/application boundary.

## 17. MCP and AI examples

Use `MCP.FullDemo` for the full MCP mental model and `MCP.VclDbDemo` for desktop/database integration. `DextGemini` is the focused AI-provider example.

## 18. Golden-source priority

When docs and examples differ:

```text
current source
> repository-wide critical rules
> finalized specs
> official skills
> current official example
> pack summary
```

Examples are strong evidence of composition but may lag a just-landed API change.
