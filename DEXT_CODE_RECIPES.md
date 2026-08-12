# DEXT CODE RECIPES

> Compact reusable patterns for AI coding agents. Verify exact overloads against current source when necessary.

## Minimal API — modern typed DI

Prefer generic handler injection for new code:

```pascal
App.Builder.MapPost<TCreateUserRequest, IUserService, IResult>(
  '/api/users',
  function(Request: TCreateUserRequest; Service: IUserService): IResult
  begin
    Result := Results.Created('/api/users', Service.CreateUser(Request));
  end);
```

Use `Web.TaskFlowAPI` and current Tier-A source as reference before copying older request-service-resolution examples.

## Typed route binding

```pascal
App.Builder.MapGet<Integer, IResult>('/api/tasks/{id}',
  function(Id: Integer): IResult
  begin
    Result := Results.Ok(...);
  end);
```

## Controller route

```pascal
[ApiController('/api/users')]
TUsersController = class
public
  [HttpGet('/{id}')]
  function GetById([FromRoute] Id: Integer): IResult;
end;
```

Never name a controller action `Create`.

## Controller constructor injection

```pascal
[ApiController('/api/orders')]
TOrdersController = class
private
  FService: IOrderService;
public
  constructor Create(Service: IOrderService);
end;
```

## DbContext + Web pooling

```pascal
Services
  .AddDbContext<TAppDbContext>(...)
  .WithPooling(True);
```

## Classic entity + typed query metadata

For an existing/native Delphi model, keep ordinary property types and use Dext type metadata/query support instead of rewriting the entity solely for Smart Properties.

```text
Classic entity
 + TEntityType<TEntity>
 -> typed query metadata
```

Verify the exact current `TEntityType<T>` declaration pattern in `Orm.EntityStyles` / source.

## Smart Property entity

```pascal
type
  TUser = class
  private
    FId: IntType;
    FName: StringType;
  public
    property Id: IntType read FId write FId;
    property Name: StringType read FName write FName;
  end;
```

## High precision financial entity

```pascal
type
  TExchangeRate = class
  private
    FRate: FmtBcdType;
    FAmount: FmtBcdType;
  public
    property Rate: FmtBcdType read FRate write FRate;
    property Amount: FmtBcdType read FAmount write FAmount;
  end;
```

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

Use exact database precision such as `NUMERIC(28,10)` when the domain requires it.

## Typed query

```pascal
var U := Prototype.Entity<TUser>;

var Adults := Db.Users
  .Where(U.Age >= 18)
  .OrderBy(U.Name.Asc)
  .ToList;
```

## Detached update

```pascal
User.Name := 'Updated';
Db.Users.Update(User);
Db.SaveChanges;
```

## Specification

```pascal
type
  TActiveUsersSpec = class(TSpecification<TUser>)
  public
    constructor Create;
  end;

constructor TActiveUsersSpec.Create;
begin
  inherited;
  var U := Prototype.Entity<TUser>;
  Where(U.Active = True);
end;
```

## Direct SQL projection

```pascal
var Q := Db.UseSql(
  'select id, name from users where active = :active',
  [True]
);
```

If no domain object is needed, prefer direct UTF-8 streaming over unnecessary hydration.

## FastPath

Use `MapFast + UseSql/IDextFastQuery` only for measured hot paths.

## Ordered dictionary

```pascal
var D := TCollections.CreateOrderedDictionary<string, Integer>;
D.Add('A', 1);
D.Add('B', 2);
```

## Frozen read model

```pascal
var Builder := TCollections.CreateList<TUser>;
var Frozen := Builder.ToFrozenList;
```

## Bounded channel

```pascal
var Ch: IChannel<TOrder> := TChannel<TOrder>.CreateBounded(100);
Ch.Write(Order);
var Next := Ch.Read;
```

## Scoped pool lease

```pascal
var Lease := Pool.AcquireScoped;
if Lease <> nil then
  Lease.Item.DoWork;
```

Prefer this over older manual Acquire/Release examples when supported by the current revision.

## Hosted service

```pascal
type
  TWorker = class(TInterfacedObject, IHostedService)
  public
    procedure StartAsync(Token: ICancellationToken);
    procedure StopAsync(Token: ICancellationToken);
  end;

Services.AddHostedService<TWorker>;
```

## Persistent background job

```pascal
Services.AddBackgroundJobs;
TDextJobs.Initialize(JobClient);
TDextJobs.Enqueue<TEmailService>('SendWelcomeEmail', ['user@example.com']);
```

## Core Event Bus registration

```pascal
Services
  .AddEventBus
  .AddEventHandler<TOrderPlacedEvent, TEmailHandler>
  .AddEventHandler<TOrderPlacedEvent, TAuditHandler>;
```

## Narrow typed event publisher

```pascal
constructor TOrderService.Create(
  const Publisher: IEventPublisher<TOrderPlacedEvent>);
```

Prefer a narrow publisher when the service only needs one event capability.

## Scoped Web Event Bus

```pascal
Services
  .AddScopedEventBus
  .AddEventHandler<TTaskCreatedEvent, TTaskCreatedHandler>;
```

Use when handlers intentionally need the same HTTP request scope/scoped DbContext. Verify transaction semantics separately.

## Event publication test

```text
TEventBusTracker.Register(...)
 -> execute service
 -> Tracker.HasPublished<TEvent>
 -> inspect LastPublished<TEvent>
```

Verify exact tracker overloads in current Event Bus source/example.

## Fluent validator

```pascal
type
  TUserValidator = class(TAbstractValidator<TUser>)
  public
    constructor Create; override;
  end;

constructor TUserValidator.Create;
begin
  inherited;
  var M := Prototype.Entity<TUser>;
  RuleFor(M.Name).Required.Length(3, 100);
  RuleFor(M.Email).EmailAddress;
end;
```

## Protected action

```pascal
[Authorize]
[HttpGet('/me')]
function Me: IResult;
```

## Structured logging

```pascal
Logger.Information(
  'Order {OrderId} processed for {CustomerId}',
  [OrderId, CustomerId]
);
```

For high throughput consider async logging.

## Logging scope

```pascal
var Scope := Logger.BeginScope('Transaction {Id}', ['TX-001']);
try
  ...
finally
  Scope.Dispose;
end;
```

## Layered configuration

```text
appsettings.json
 -> local/environment-specific optional config
 -> environment variables
 -> command-line/host override
```

Later providers override earlier providers.

## Typed options

```pascal
Services.Configure<TMyOptions>(Configuration.GetSection('MyFeature'));
```

Inject `IOptions<TMyOptions>` rather than reading raw configuration throughout business code.

## REST client — typed record response

```pascal
var Response := RestClient('https://api.example.com')
  .Get('/users/1')
  .Await;
```

For complex requests use the `Request` / `TRestRequest` builder and verify exact current signatures.

## External provider adapter

```text
HTTP endpoint/use case
 -> IAIService / domain gateway
 -> Gemini/OpenAI/etc adapter
 -> Dext.Net.RestClient
```

Keep provider DTOs and errors at the adapter boundary.

## MCP provider

```pascal
type
  TMyProvider = class(TMCPToolProvider)
  public
    [MCPTool('lookup-customer', 'Looks up a customer')]
    [MCPParam('id', 'Customer ID', ptNumber)]
    function LookupCustomer(const Args: TJSONObject): TMCPToolResult; virtual;
  end;
```

Registration pattern from the official demo:

```pascal
Server.RegisterProvider(TMyProvider.Create);
```

Verify current MCP protocol/attribute signatures and ownership rules in source/skill.

## Hub method

```pascal
type
  TChatHub = class(THub)
  public
    [HubMethod]
    procedure SendMessage(const User, Message: string);
  end;
```

Use groups/clients APIs rather than rebuilding application-level broadcast semantics on raw WebSocket.

## Server-side Hub broadcast

```text
resolve/use IHubContext
 -> Clients.All / Clients.Group(...)
 -> SendAsync(...)
```

Use `Web.AirFlow` / Hubs source for current exact APIs.

## Server-rendered view

```pascal
Result := Results.View('index');
```

Typed model/query variants are demonstrated by `WebStencilsDemo`. Preserve `DEXT_ENABLE_WEB_STENCILS` conditional boundaries when applicable.

## HTMX vertical-slice flow

```text
hx-get / hx-post
 -> Dext feature endpoint
 -> service
 -> HTML partial
 -> hx-target replacement
```

Use `Web.Dext.Starter.Admin` as the architecture reference.

## Multipart upload

```pascal
var File := Ctx.Request.Files.GetFile('myfile');
if Assigned(File) then
  File.CopyTo(TargetStream);
```

Add size/type/path/authorization/quota validation; never trust client filenames as server paths.

## Stream download

```text
set Content-Type
set Content-Disposition when attachment is intended
stream TStream/file directly to response
```

Verify current response-stream API in `Web.StreamingDemo` source.

## MVU state transition

```pascal
class function Update(
  const Model: TCounterModel;
  const Msg: TCounterMessage
): TCounterModel;
```

Treat Model as immutable state; messages describe intent; Update returns a new model; View renders it.

## Desktop composition root

```text
TStartup.Initialize
 -> Application.Initialize
 -> create form
 -> resolve/inject ViewModel
 -> Application.Run
 -> free UI references
 -> TStartup.Terminate
```

Do not resolve infrastructure ad hoc from every form.

## Mock test

```pascal
var Repo := Mock<IUserRepository>.Create;

Repo.Setup
  .Returns(User)
  .When
  .FindById(1);

var Result := Service.GetById(1);

Should(Result).NotBeNil;
Repo.Received(Times.Once).FindById(1);
```

Never free `Mock<T>`.

## Snapshot test

```pascal
Result.MatchSnapshot;
```

## Real-time choice

```text
server-only internal decoupling -> Event Bus
one-way client stream -> SSE
raw bidirectional protocol -> WebSocket
groups/broadcast abstraction -> THub / IHubContext<T>
```

## Reverse proxy deployment

```text
UsePathBase -> app mounted below subpath
ForwardedHeaders -> trusted proxy IP/scheme/host
SecurityHeaders -> browser hardening
Strict CORS -> browser cross-origin policy
```

## Raw SQL safety

```pascal
Db.Users.FromSql(
  'select * from users where email = :email',
  [Email]
);
```

## Official pattern discovery

```text
1. DEXT_DECISION_TREE.md
2. DEXT_API_SYMBOL_INDEX.md
3. examples/DEXT_EXAMPLE_CROSS_REFERENCE.md
4. examples/DEXT_EXAMPLES_COVERAGE_MATRIX.md
5. examples/DEXT_EXAMPLE_DRIFT_REGISTER.md
6. relevant deep audit
7. current official example .pas
8. current Dext skill/source
9. implement
```
