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

## Rules
- ORM results use Dext `IList<T>`, not `TObjectList<T>`.
- For DbContext-owned child entities use non-owning collections where appropriate.
- Include `Dext.Entity.Core` when `IDbSet<T>` generic declarations require it.
- Detached objects require `.Update(Entity)` before `SaveChanges`.
- For Web DbContext registration prefer pooling when supported/appropriate.
- Use typed query expressions and Specifications over magic strings where possible.
- Parameterize `FromSql` / `UseSql`; never concatenate untrusted SQL values.
- Check `IsBulkInsertSafe`, `IsBulkUpdateSafe`, `IsBulkDeleteSafe` before bulk paths.
- Provider-specific code stays at infrastructure/driver boundaries.

## Read/write decision
Domain/entity needed -> `IDbSet<T>`.
Reusable predicate -> Specification.
Raw SQL with entity hydration -> `FromSql`.
Projection only -> `UseSql` / `IDextFastQuery`.
CRUD metadata exposure -> Database-as-API only when business rules permit it.

## Before generating code
Verify exact relation attributes, migration DSL, converter registration and multi-tenancy APIs against current Dext source because these evolve rapidly.
