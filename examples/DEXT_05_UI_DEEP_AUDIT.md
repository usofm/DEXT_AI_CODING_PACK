# DEXT 05-UI DEEP AUDIT

> Source group: `cesarliws/dext/Examples/05-UI`
> Snapshot: 2026-08-12

## Scope

- `Desktop.MVU.Counter`
- `Desktop.MVU.CounterFrame`
- `Desktop.MVVM.CustomerCRUD`
- `VCLMemoLog`

The UI examples intentionally show more than one architecture. An AI agent must choose deliberately instead of mixing MVVM, MVU and direct-form patterns.

---

## 1. MVVM Customer CRUD — primary business desktop reference

`Desktop.MVVM.CustomerCRUD` is the strongest business-oriented desktop example.

The project uses feature folders and separates:

```text
App/
Features/Customers/
Data/
Layout/
Tests/
```

Within a feature, the example separates concepts such as:

```text
Entity
Service
Controller
ViewModel
List View
Edit View
```

### Golden architecture

```text
VCL View / Frame
  -> ICustomerView abstraction
  -> Controller
  -> Service
  -> ORM/infrastructure
```

The UI is not the business layer.

---

## 2. Feature Folders

The MVVM example explicitly favors business-feature grouping over folders such as only `Forms`, `Models`, `Services` globally.

Recommended scalable structure:

```text
Features/
  Customers/
    Customer.Entity.pas
    Customer.Service.pas
    Customer.Controller.pas
    Customer.ViewModel.pas
    Customer.List.pas
    Customer.Edit.pas
  Orders/
  Products/
```

Shared infrastructure remains outside features when genuinely cross-cutting.

### Agent rule

Prefer feature cohesion for substantial desktop applications. Do not scatter one feature across many global technical folders unless the existing project already follows that convention.

---

## 3. Navigator

The example demonstrates a navigation service with:

```text
INavigator
Push
Pop
PopUntil
Replace
middleware pipeline
adapters
navigation guards
```

Adapters include examples for:

```text
custom container/panel
PageControl/tabs
MDI
```

Representative architecture:

```text
Controller/ViewModel
  -> INavigator
      -> middleware
          -> adapter
              -> VCL container/frame/form
```

### Golden rule

Navigation is application infrastructure, not business logic. Business/domain services should not know about VCL frames/forms.

---

## 4. Magic Binding

The MVVM example demonstrates attribute-driven UI binding concepts such as:

```text
[BindEdit]
[BindText]
[OnClickMsg]
```

The goal is to reduce repetitive UI synchronization while keeping state in a ViewModel/controller boundary.

### Agent rule

Do not reproduce large amounts of manual `Edit.Text := ...` / `Model.X := Edit.Text` plumbing before checking Dext UI binding capabilities.

---

## 5. MVVM testing

The example includes dedicated tests for:

```text
business rules
ViewModel state/validation
Controller behavior with Mock<T>
```

Important pattern:

```text
View interface + mocked service
 -> controller test
```

This allows most desktop application behavior to be tested without creating VCL forms.

### Golden rule

Keep testable behavior out of event handlers.

Wrong direction:

```text
ButtonClick -> business rules + DB + navigation + UI updates
```

Preferred:

```text
ButtonClick/binding message
 -> controller/ViewModel command
 -> service/domain logic
 -> state update
 -> binding/render
```

---

## 6. MVU Counter

`Desktop.MVU.Counter` demonstrates Model-View-Update:

```text
User Event
 -> Message
 -> Update(Model, Msg)
 -> New Model
 -> Render
```

Core characteristics documented by the example:

```text
immutable record model
unidirectional data flow
pure Update function
message enum
render loop
```

Representative shape:

```pascal
class function Update(
  const Model: TCounterModel;
  const Msg: TCounterMessage
): TCounterModel;
```

### When MVU fits

Use MVU when:

- application state is naturally modeled as immutable snapshots
- deterministic state transitions are valuable
- a unidirectional event model simplifies the UI
- high testability of state transitions is desired

### Do not mix casually

Do not create a ViewModel with mutable two-way binding and simultaneously treat the same feature as immutable MVU state unless a clear boundary is designed.

---

## 7. MVU CounterFrame

`Desktop.MVU.CounterFrame` demonstrates applying the MVU pattern at frame/component scale rather than requiring the whole application to be MVU.

Architectural lesson:

```text
UI architecture can be feature/component scoped
```

A large desktop application can use one coherent top-level architecture while encapsulating specialized state-driven components when justified.

---

## 8. VCLMemoLog

`VCLMemoLog` is a focused UI/logging integration example.

Classification:

```text
Tier B focused integration example
```

Use it to learn how a Dext logging sink/output can be surfaced in a VCL control. Do not use it as the architecture template for a business application.

---

## 9. Desktop Architecture Decision Tree

```text
Need desktop architecture?
├─ business CRUD / large application
│  └─ MVVM/Controller + DI + feature folders
├─ deterministic immutable state flow
│  └─ MVU
├─ isolated stateful component/frame
│  └─ scoped MVU may fit
├─ navigation between views
│  └─ Navigator + adapter + middleware
├─ repetitive UI-model synchronization
│  └─ Dext UI/Magic Binding
└─ focused control integration
   └─ use focused Tier B example
```

---

## 10. Desktop Golden Rules

1. VCL controls must not become domain objects.
2. Keep database access out of form event handlers.
3. Put business rules into testable services/domain/rules classes.
4. Use interfaces at View boundaries when controllers need to communicate with UI.
5. Prefer DI for services/controllers/loggers.
6. Choose MVVM or MVU deliberately per boundary.
7. Keep navigation behind `INavigator` rather than constructing arbitrary forms everywhere.
8. Test controllers/ViewModels/state transitions without requiring actual forms whenever possible.
9. Feature folders are preferred for large cohesive desktop business features.
10. Focused demos like `VCLMemoLog` are not full architecture references.

---

## 11. Cross-Platform Caution

These examples are desktop/VCL-oriented evidence. Do not assume the same control classes or binding adapters exist unchanged in FMX, FGX Native, UniGUI, or Web.

The reusable part is the architecture:

```text
Domain/Application Services
Controller/ViewModel/state
DI
navigation abstraction
validation
```

The concrete UI adapter/view layer is platform-specific.

---

## 12. Source Priority

```text
current Dext.UI/Desktop source
> current example .pas
> official desktop skill
> example README
> this audit
```
