---
title: 'Architecture & code conventions'
description: The Clean Architecture layers, the dependency rule, and the reasoning behind the coding conventions.
category: explanation
---

# Architecture & code conventions

## Clean Architecture in one rule

The codebase is four layers — `core`, `data`, `domain`, `presentation` — and one
rule governs them all:

```text
presentation  →  domain  ←  data
```

The **`domain/` layer points nowhere outward.** It imports no Flutter widgets,
no `drift`, no `dio`, no `get_it`. It holds plain Dart: entities, abstract
repository interfaces, and use cases. Because it depends on nothing concrete, it
is trivially unit-testable and survives swapping the database, the UI toolkit, or
the DI container.

- **`presentation/`** depends on `domain/` (calls use cases via BLoC).
- **`data/`** depends on `domain/` (implements its repository interfaces).
- **`core/`** is cross-cutting infrastructure (errors, theme, storage, DI,
  services) used by the outer layers — never by `domain/`.

Dependencies are inverted at the repository boundary: `domain` declares an
abstract `TransactionRepository`; `data` provides `TransactionRepositoryImpl`;
`get_it` wires the implementation in at startup.

## Why this shape

A local-first finance app has logic worth protecting from framework churn — zakat
math, hawl tracking, halal categorisation. Keeping that logic in a framework-free
`domain/` layer means it can be tested as pure functions and reused if a backend
(Phase 4, Go) ever re-implements the same rules. The structure costs more files
up front; it pays off the moment a compliance rule needs a unit test (see
[Sharia compliance](./sharia-compliance.md)).

## State management: BLoC and Cubit

`flutter_bloc` drives presentation state. The rule of thumb:

- **Cubit** when there are no meaningful events — e.g. the biometric `AppLock`
  has only "unlock", so it's a Cubit with an `unlock()` method.
- **BLoC** when events carry intent worth modelling explicitly — transaction
  add/edit/delete/filter, where the event stream is part of the design.

States are immutable and compared with `Equatable` (or a sealed hierarchy, and
`freezed` once it lands). The UI is a pure function of the current state.

## Conventions and the why

- **Barrels (`index.dart`) + package imports, no deep imports.** A folder's
  barrel is its public API; importing through it lets internals be refactored
  without touching callers. (See [Conventions](../reference/conventions.md).)
- **`Either<Failure, T>` over throwing.** Failures are values, not control flow.
  `Failure` is sealed, so handling them is exhaustively checked at compile time.
- **One use case per class.** Small, named, single-responsibility units that read
  like a sentence (`ComputeZakatUseCase`) and mock cleanly in tests.
- **Co-located tests** mirror `lib/` under `test/`, so a layer and its tests move
  together.
- **Generated code is generated.** drift/freezed/l10n outputs are excluded from
  analysis and never hand-edited.

## What exists today

This is a **skeleton**: the layers, barrels, sealed `Failure`, an empty drift
`AppDatabase`, a debug-overridable `BiometricService`, an empty
`setupDependencies()`, and a `go_router` redirect to a placeholder home. No
domain features yet — they arrive vertically, one slice at a time (see
[How-to: Add a feature slice](../how-to/add-a-feature.md)).
