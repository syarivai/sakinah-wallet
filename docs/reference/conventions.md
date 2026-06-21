---
title: 'Conventions'
description: Lints, naming, barrels, state-management and commit rules for the codebase.
category: reference
---

# Conventions

## Lints

Analysis is `flutter_lints` plus a strict rule set, configured in
[`analysis_options.yaml`](../../analysis_options.yaml):

```yaml
include: package:flutter_lints/flutter.yaml
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - prefer_final_locals
    - always_declare_return_types
    - require_trailing_commas
    - avoid_print
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - use_key_in_widget_constructors
    - prefer_is_empty
    - prefer_is_not_empty
analyzer:
  errors:
    missing_required_param: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.gr.dart"
```

Generated files are **excluded from analysis** (and re-created by codegen, never
edited by hand). `flutter analyze` must be clean on every commit.

## Naming

- **Files:** `snake_case.dart` (`transaction_local_data_source.dart`).
- **Types:** `PascalCase`; **members/variables:** `lowerCamelCase`.
- **Use cases:** one class per file, suffixed `UseCase` (`ComputeZakatUseCase`).
- **BLoC triplet:** `<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart`.
- **DI modules:** `<feature>_di.dart` under `core/di/modules/<feature>/`.
- **Localisation keys:** `lowerCamelCase`, grouped by screen.

## Barrels

Each folder exposes its public API through `index.dart`. Import from the folder's
barrel (`import 'package:sakinah_wallet/core/errors/index.dart'`), not from
internal files — internals stay swappable.

## State management

`flutter_bloc`: use a **Cubit** when there are no meaningful events, a **BLoC**
when events matter. States use `Equatable` (or a sealed hierarchy / `freezed`
once it lands). See [Architecture](../explanation/architecture.md).

## Error handling

Operations that can fail return `Either<Failure, T>` (`fpdart`). `Failure` is a
**sealed** class (`ServerFailure`, `NetworkFailure`, `CacheFailure`,
`UnknownFailure`) so `switch` is exhaustive. Throw `Exception` types only at the
data-source boundary; map them to `Failure` in the repository.

## Commits

Conventional Commits (`feat`, `fix`, `chore`, `docs`, `ci`, …), scoped where
useful (`feat(core): …`). This is the direction set in
[`OSE_PRIMER_ADOPTION.md`](../../OSE_PRIMER_ADOPTION.md); a `commitlint` gate may
enforce it later.

## Generated code

`*.g.dart`, `*.freezed.dart`, `*.gr.dart` are generated. Never edit them — change
the source and re-run [code generation](../how-to/run-codegen.md).
