# Skill: Dext Financial / Exact Decimal

Use for accounting, FX, gold, crypto, pricing, tax, settlement and any database field where exact fixed-point precision matters.

## Core rule
For exact values beyond four decimal places, do not default to `Double` or `Currency`.

```pascal
BcdType    = Prop<TBcd>;
FmtBcdType = Prop<TBcd>;
```

Dext first-class TBcd support includes exact `ftFMTBcd` reading/binding and value conversion paths. For Firebird 5, schemas such as `NUMERIC(28,10)` / `DECIMAL(28,10)` are valid when required by the domain.

## Load first
- `DEXT_ANTI_PATTERNS.md`
- `DEXT_API_SYMBOL_INDEX.md`
- relevant full memory parts when exact converter/dialect behavior is needed

## Rules
- Preserve precision/scale end to end: database -> TBcd -> Smart Property -> parameter -> serialization.
- Do not silently convert exact values to binary floating point.
- `Currency` is appropriate only when its precision/scale constraints match the domain.
- Use invariant conversions for machine-readable decimal strings.
- Verify current precision/scale mapping APIs before generating schema attributes/configuration.
- Treat rates, quantities, monetary equivalents and high-precision unit prices separately; choose scale from domain requirements.

## Firebird guidance
Firebird 5 supports fixed-point precision up to 38 digits and stores high precision on INT128. Do not assume old `DECIMAL(18,4)` defaults are sufficient for financial systems.

## Output checklist
1. identify required precision and scale
2. choose TBcd/FmtBcdType for exact values
3. verify database column definition
4. verify ORM read/write parameter binding
5. avoid float conversions in calculations and DTO mapping
6. add round-trip precision tests
