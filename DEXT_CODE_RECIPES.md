# DEXT CODE RECIPES

> Compact reusable patterns for AI coding agents. Verify exact overloads against current source when necessary.

## Minimal API

```pascal
App.MapGet('/users/{id}',
  function(Id: Integer): IResult
  begin
    Result := Results.Ok(...);
  end);
```

## Controller route

```pascal
[ApiController]
[Route('/api/users')]
TUsersController = class
public
  [HttpGet('/{id}')]
  function GetById(Id: Integer): IResult;
end;
```

Never name a controller action `Create`.

## DbContext + Web pooling

```pascal
Services
  .AddDbContext<TAppDbContext>(...)
  .WithPooling(True);
```

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

For high throughput consider `Builder.AddAsync`.

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
raw bidirectional protocol -> WebSocket
groups/broadcast abstraction -> THub / IHubContext<T>
one-way server push -> SSE
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
1. DEXT_API_SYMBOL_INDEX.md
2. matching Docs/skills/dext-*.md
3. current source
4. official example
5. implement
```
