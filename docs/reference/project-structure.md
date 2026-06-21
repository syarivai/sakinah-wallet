---
title: 'Project structure'
description: The Clean Architecture folder layout under lib/, plus the skeleton files already on disk.
category: reference
---

# Project structure

```text
sakinah_wallet/
├─ docs/                  # this documentation (Diátaxis)
├─ plans/                 # staged execution plans (backlog/ in-progress/ done/)
├─ lib/
│  ├─ main.dart           # entry: runApp(const SakinahWalletApp())
│  ├─ app.dart            # root MaterialApp.router (theme + appRouter)
│  ├─ core/               # cross-cutting infrastructure (no feature logic)
│  │  ├─ config/          #   app_config (barrel only so far)
│  │  ├─ constant/        #   date/zakat constants (barrel only so far)
│  │  ├─ di/              #   inject_dependencies.dart → setupDependencies()
│  │  │  └─ modules/      #   per-feature DI registration (lands per feature)
│  │  ├─ errors/          #   failures.dart (sealed Failure), exceptions.dart
│  │  ├─ services/        #   biometric_service.dart (local_auth wrapper)
│  │  ├─ storage/         #   drift_database.dart (+ .g.dart), secure_storage.dart, storage_keys.dart
│  │  ├─ theme/           #   colors.dart, typography.dart (Material 3 stub)
│  │  └─ utils/           #   formatters/helpers (barrel only so far)
│  ├─ data/               # implements domain contracts
│  │  ├─ datasources/local/   #   drift / secure-storage backed sources
│  │  ├─ mappers/         #   model ⇄ entity
│  │  ├─ models/          #   drift-row-shaped DTOs
│  │  └─ repositories/    #   *_repository_impl.dart
│  ├─ domain/             # pure: no Flutter / drift / dio imports
│  │  ├─ entities/        #   business objects
│  │  ├─ repositories/    #   abstract interfaces
│  │  └─ usecases/        #   one class per use case → Either<Failure, T>
│  └─ presentation/       # UI + state
│     ├─ bloc/            #   <feature>/{_bloc,_event,_state}.dart
│     ├─ navigation/      #   app_router.dart (go_router)
│     ├─ screens/         #   one file per screen
│     └─ widgets/common/  #   shared widgets
├─ test/                  # mirrors lib/ (currently widget_test.dart only)
├─ integration_test/      # end-to-end flows (planned)
├─ analysis_options.yaml  # lints (flutter_lints + strict rules)
└─ pubspec.yaml           # pinned dependencies
```

## The dependency rule

`presentation → domain ← data`. The `domain/` layer has **zero outward arrows** —
it imports no Flutter, no `drift`, no `dio`. This is what makes the layers
independently testable. See [Explanation: Architecture](../explanation/architecture.md).

## Barrels (`index.dart`)

Every leaf folder has an `index.dart` that re-exports its public API. Import from
the folder's barrel, not from internal files, so internals stay swappable. See
[Conventions § Barrels](./conventions.md).

## What's on disk now (skeleton)

Already implemented as stubs: `main.dart`, `app.dart`, the sealed `Failure`
hierarchy, the drift `AppDatabase` (empty tables), `BiometricService` (with a
debug always-allow override), `setupDependencies()` (empty), and the `go_router`
config redirecting `/` → `/home`. Everything under `data/`, `domain/`, and most
of `presentation/` is currently just barrel files — features land in Week 2+.
