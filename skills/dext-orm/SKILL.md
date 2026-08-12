# Skill: Dext ORM

Use for `TDbContext`, `IDbSet<T>`, entities, Smart Properties, specifications, joins, relationships, raw SQL, migrations, multi-tenancy, converters and database-backed application services.

## Load first
- `DEXT_API_SYMBOL_INDEX.md`
- `DEXT_ANTI_PATTERNS.md`
- `examples/DEXT_03_DATA_DEEP_AUDIT.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`

## Best examples
- Entity styles: `Examples/03-Data/Orm.EntityStyles`
- CRUD/relations: `Examples/03-Data/Orm.EntityDemo`
- Specifications: `Examples/03-Data/Orm.Specification`
- Complex querying: `Examples/03-Data/Dext.Examples.ComplexQuerying`
- Multi-tenancy: `Examples/03-Data/Dext.Examples.MultiTenancy`
- Database as API: `Examples/03-Data/Web.DatabaseAsApi`
- Smart Properties: `Examples/03-Data/Web.SmartPropsDemo`

## Dext-native persistence first

For ordinary database-backed CRUD, the default path is:

```text
Endpoint / Controller
  -> Application Service / Manager
      -> scoped TDbContext
          -> IDbSet<TEntity>
              -> Dext Entity ORM
                  -> database driver
```

Do **not** insert a manual `IRepository -> TFDQuery/TUniQuery -> ConnectionFactory` stack by default when Dext Entity already models the operation cleanly.

A repository abstraction is optional. Introduce one only when it represents a meaningful domain/integration boundary, for example:

- specialized vendor SQL not naturally expressed by Dext Entity
- stored-procedure-heavy integration contracts
- bulk/import pipelines with provider-specific behavior
- external persistence systems
- an explicit domain port that materially improves isolation or testing

Do not add a Repository merely as ceremony around `IDbSet<T>`.

For standard Web persistence, prefer:

```pascal
Services
  .AddDbContext<TAppDbContext>(ConfigureDatabase)
  .AddScoped<IAccountService, TAccountService>;

procedure TStartup.ConfigureDatabase(Options: TDbContextOptions);
begin
  Options
    .UsePostgreSQL(ConnectionString)
    .WithPooling(True);
end;
```

Use the matching native provider helper (`UsePostgreSQL`, `UseFirebird`, `UseSQLServer`, `UseConnectionDef`, etc.) rather than hand-building provider connection objects unless a verified requirement requires direct driver access.

## Rules
- ORM results use Dext `IList<T>`, not `TObjectList<T>`.
- For DbContext-owned child entities use non-owning collections where appropriate.
- Include `Dext.Entity.Core` when `IDbSet<T>` generic declarations require it.
- Prefer Dext entity attributes and Smart Properties where they serve the model/query requirements.
- Exact high-precision financial properties should use `BcdType` / `FmtBcdType` and `[Precision(P, S)]` as appropriate.
- Detached objects require `.Update(Entity)` before `SaveChanges`.
- For Web DbContext registration prefer pooling when supported/appropriate.
- Use typed query expressions and Specifications over magic strings where possible.
- Parameterize `FromSql` / `UseSql`; never concatenate untrusted SQL values.
- Check `IsBulkInsertSafe`, `IsBulkUpdateSafe`, `IsBulkDeleteSafe` before bulk paths.
- Provider-specific code stays at a genuine infrastructure/driver boundary.

## Read/write decision

```text
Normal entity CRUD?                -> TDbContext + IDbSet<T>
Reusable predicate?                -> Specification
Typed filter/order query?          -> Smart Properties / Prototype.Entity<T>
Raw SQL with entity hydration?     -> FromSql
Projection / streaming only?       -> UseSql / IDextFastQuery / FastPath when justified
CRUD metadata exposure?            -> Database-as-API only when business rules permit it
Specialized provider operation?    -> explicit infrastructure adapter/repository
```

## Before generating code

Before creating any persistence wrapper, answer:

1. Can `TDbContext` + `IDbSet<T>` express this operation directly?
2. Is a provider-specific repository genuinely adding a domain/integration capability?
3. Would the wrapper hide Dext-native features such as tracking, Smart Properties, Specifications, pooling or bulk-safety semantics?

If the answer to #1 is yes and #2 is no, use Dext Entity directly.

Verify exact relation attributes, migration DSL, converter registration and multi-tenancy APIs against current Dext source because these evolve rapidly.
