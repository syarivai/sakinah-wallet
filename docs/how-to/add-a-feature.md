---
title: 'How to add a feature slice'
description: Add a vertical feature across the domain, data, and presentation layers without breaking the dependency rule.
category: how-to
---

# How to add a feature slice

> This is the **target** workflow. No domain features exist yet (Week 1 is
> infrastructure only). Adding one is **Week 2+** work — see [`plans/`](../../plans).
> Read [Explanation: Architecture](../explanation/architecture.md) first.

A feature is a vertical slice through all layers. The golden rule is the
**dependency direction**: `presentation → domain ← data`. The `domain/` layer
imports nothing from Flutter, `drift`, or `dio`.

Take `transaction` as the worked example. Add files in this order:

## 1. Domain (the contract — no framework imports)

```text
domain/entities/transaction.dart          # the entity (Equatable / sealed)
domain/repositories/transaction_repository.dart   # abstract interface
domain/usecases/transaction/add_transaction_usecase.dart
domain/usecases/transaction/list_transactions_usecase.dart
```

Use cases return `Either<Failure, T>` from `fpdart` (see
[`core/errors/failures.dart`](../reference/project-structure.md)).

## 2. Data (implements the contract)

```text
data/models/transaction/transaction_model.dart    # drift-row-shaped DTO
data/mappers/transaction_mapper.dart               # model ⇄ entity
data/datasources/local/transaction_local_data_source.dart
data/repositories/transaction_repository_impl.dart # implements the domain interface
```

Add the drift table to [`core/storage/drift_database.dart`](../reference/database-schema.md)
and re-run [code generation](./run-codegen.md).

## 3. Presentation (consumes use cases via BLoC)

```text
presentation/bloc/transaction/transaction_bloc.dart   (+ _event.dart, _state.dart)
presentation/screens/transactions_screen.dart
presentation/widgets/transaction/transaction_tile.dart
```

Use a **Cubit** when there are no meaningful events, a **BLoC** when events
matter (see [Conventions](../reference/conventions.md)).

## 4. Wire dependency injection

Register the feature's data source, repository, use cases, and BLoC in a
per-feature module, called from `setupDependencies()` in
[`core/di/inject_dependencies.dart`](../reference/project-structure.md):

```dart
// core/di/modules/transaction/transaction_di.dart
void registerTransactionModule(GetIt getIt) { /* … */ }
```

## 5. Barrels and a route

- Re-export the public API from each folder's `index.dart` (see
  [Conventions § Barrels](../reference/conventions.md)).
- Add a `GoRoute` in [`presentation/navigation/app_router.dart`](../reference/project-structure.md).

## 6. Tests (mirror `lib/` under `test/`)

Unit-test the use cases and mapper, `bloc_test` the BLoC transitions, and add a
widget test for the screen. See [Testing strategy](../explanation/testing-strategy.md).

## Before committing

```bash
dart run build_runner build --delete-conflicting-outputs
dart format . && flutter analyze && flutter test
```
