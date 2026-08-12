# DEXT 09-ACTIVE ARCHITECTURE DEEP AUDIT

> Source group: `cesarliws/dext/Examples/09-ActiveArchitecture`
> Snapshot: 2026-08-12

## Scope

- `Desktop.BasicActiveArchitecture.Demo`
- `Desktop.EntityDataSet.Demo`

This group focuses on desktop application composition, explicit domain/presentation/infrastructure boundaries, DI lifecycle, and dataset-oriented desktop integration.

---

## 1. Basic Active Architecture structure

The example is separated into:

```text
Domain/
Infra/
Presentation/
Tests/
```

The DPR references units such as:

```text
Domain model/entities/specifications
Infrastructure services/startup/logging sink
Presentation form/ViewModels
Tests
```

This is a stronger layered reference than a simple form-centric VCL example.

---

## 2. Desktop composition root

The application entry point performs an explicit lifecycle:

```text
TStartup.Initialize
 -> Application.Initialize
 -> create main form
 -> resolve ViewModel from DI
 -> inject dependencies into form
 -> Application.Run
 -> free form
 -> TStartup.Terminate
```

### Golden rule

Desktop applications need an explicit composition root just as web applications do.

Do not resolve services randomly throughout forms when dependencies can be composed once at application startup.

---

## 3. DI lifecycle

`TStartup` demonstrates:

```text
TDextServices.New
ConfigureServices
BuildServiceProvider
AddSingleton
AddTransient
GetRequiredServiceObject<T>
service-provider cleanup
```

The example registers an external shipping service as singleton and a ViewModel as transient.

### Lifetime rule

Choose lifetime from semantics:

```text
stateless/shared expensive service -> singleton may fit
per-view/per-operation state -> transient/scoped-like boundary
DB/context/session state -> never choose singleton by convenience
```

---

## 4. ViewModel injection

The main form is created using normal VCL lifecycle and then receives a DI-created ViewModel.

Architectural shape:

```text
VCL Form
 -> ViewModel
    -> domain/application interfaces
       -> infrastructure implementation
```

### Golden rule

The Form owns rendering and UI events; it should not become the service locator.

---

## 5. Domain / Infra / Presentation boundary

This example reinforces dependency direction:

```text
Presentation -> domain/application abstractions
Infrastructure -> implements external concerns
Domain -> should not depend on VCL forms
```

Specifications belong with reusable domain/query intent rather than in forms.

---

## 6. Tests as architecture proof

The example ships a separate test project alongside the application.

This is important evidence: the architecture is intended to let domain/ViewModel/service behavior be exercised without driving the full UI manually.

### Agent rule

When adopting this architecture, keep interfaces and state transitions testable outside VCL lifecycle.

---

## 7. EntityDataSet Demo

`Desktop.EntityDataSet.Demo` demonstrates Dext's dataset bridge in a traditional data-aware Delphi UI, including normal and master-detail forms.

Classification:

```text
Tier B integration/reference example
```

Use it when the application intentionally needs:

```text
TDataSet-compatible UI binding
DB-aware controls
master/detail datasets
Dext entity/data bridge
```

### Golden boundary

`EntityDataSet` is an adapter between Dext entity/data models and Delphi's dataset ecosystem. It is not a reason to move domain business logic into dataset events.

---

## 8. When to choose Active Architecture vs MVVM example

Both are valid desktop references, but they emphasize different organization.

### `Desktop.MVVM.CustomerCRUD`

Best evidence for:

```text
feature folders
controller + View interface
Magic Binding
Navigator
business CRUD desktop app
```

### `Desktop.BasicActiveArchitecture.Demo`

Best evidence for:

```text
Domain / Infra / Presentation layers
explicit composition root
DI lifecycle
ViewModel injection
dependency direction
```

### Agent decision

Follow the host project's dominant structure. Do not merge both directory schemes mechanically.

---

## 9. Active Architecture golden rules

1. One explicit composition root.
2. Domain code does not know VCL controls/forms.
3. Infrastructure implementations stay behind abstractions where replacement/testing matters.
4. Presentation receives ViewModels/services; it does not construct infrastructure ad hoc.
5. DI lifetimes reflect object semantics.
6. Application shutdown releases UI references before container teardown where ownership requires it.
7. Specifications/query intent stay outside forms.
8. Dataset adapters do not own business rules.
9. Tests should validate boundaries without requiring manual UI interaction.
10. Do not use a global service provider as an excuse for Service Locator everywhere.

---

## 10. Desktop architecture selection matrix

```text
Need classic business VCL CRUD + navigation/binding?
  -> Desktop.MVVM.CustomerCRUD

Need explicit layered Domain/Infra/Presentation design?
  -> BasicActiveArchitecture

Need immutable state/update loop?
  -> MVU examples

Need TDataSet/DB-aware compatibility?
  -> EntityDataSet demo

Need MCP from VCL/database app?
  -> MCP.VclDbDemo
```

---

## 11. Source priority

```text
current Dext desktop/DI/source
> current example source
> official desktop skill
> this audit
```
