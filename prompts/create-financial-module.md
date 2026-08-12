# Task Template — Create a Financial / Accounting Module

## Goal

Build a Dext module for exact financial/accounting data where decimal precision, transaction boundaries and auditability matter.

## Load first

- `skills/dext-financial/SKILL.md`
- `skills/dext-orm/SKILL.md`
- `DEXT_ANTI_PATTERNS.md`
- relevant TBcd sections from `full/DEXT_AI_MEMORY_ENRICHED_PART_*.md`

## Numeric rules

For exact values beyond 4 decimal places use `TBcd` / `BcdType` / `FmtBcdType` rather than `Double` or `Currency`.

Preserve precision and scale end-to-end:

```text
Database NUMERIC/DECIMAL
  -> TBcd
  -> ORM
  -> calculations
  -> parameter binding
  -> serialization / reporting
```

Do not silently convert exact values to binary floating point.

For Firebird 5, schema precision such as `NUMERIC(28,10)` / `DECIMAL(28,10)` is valid when required by the domain.

## Architecture decisions

Define explicitly:

1. monetary vs rate vs quantity fields
2. precision and scale for each exact field
3. base/transaction currency semantics
4. rounding policy and rounding boundary
5. transaction/unit-of-work boundary
6. immutable/auditable fields
7. concurrency strategy
8. reversal/correction strategy instead of destructive mutation when appropriate

## Deliverables

Produce:

- schema proposal with precision/scale
- Dext entity types
- application/service logic
- typed queries/specifications
- transactional write path
- validation rules
- tests for precision round-trip
- tests for rounding edge cases
- tests for concurrency/business invariants

## Verification checklist

Verify that:

- exact fields never pass through `Double`
- Currency is not used when scale > 4 is required
- DB provider binding preserves TBcd
- calculations specify rounding deliberately
- raw SQL is parameterized
- no generic CRUD endpoint bypasses financial invariants
- update/delete operations respect audit requirements
