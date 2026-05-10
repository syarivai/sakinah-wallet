# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`sakinah_wallet` is a Flutter app intended to be a Sharia-compliant personal finance tool.

The repository starts from the default `flutter create` scaffold and is being built up over a deliberate **Week 1 skeleton bootstrap** — Clean Architecture + BLoC, infrastructure only, **no domain features yet**. The bootstrap is paced across ~5-7 evenings against a plan kept in the user's personal notes vault (and mirrored in Claude Code project memory). Before starting any evening's work, re-read the plan, do exactly that evening's steps, and resist scope creep.

Dart SDK constraint: `^3.8.1` (see `pubspec.yaml`). Lints come from `flutter_lints` via `analysis_options.yaml`. Until structural code lands, treat any architectural decision as greenfield against the conventions below.

## Target architecture (not all on disk yet)

Layers under `lib/`:

- `core/` — config, constants, DI, errors, services, storage, theme, utils
- `data/` — datasources/local, mappers, models, repositories
- `domain/` — entities, repository interfaces, usecases
- `presentation/` — bloc, navigation, screens, widgets/common

Stack deviations from common Flutter defaults (deliberate — don't substitute):

- **State**: `flutter_bloc` — Cubit when there are no meaningful events, BLoC when events matter
- **DB**: `drift` + `sqlite3_flutter_libs` (not `sqflite` — drift gives type-safe queries and migrations)
- **Functional types**: `fpdart` (not `dartz` — `dartz` is unmaintained)
- **DI**: `get_it` with per-feature module registration via `setupDependencies()`
- **Routing**: `go_router`
- **Sensitive storage / auth**: `flutter_secure_storage` + `local_auth` (biometric gate has an always-allow override in debug)
- **Goldens**: `alchemist` (preferred over the raw `flutter_test` golden harness)
- **Sealed states / data classes**: `freezed` is **deferred** until the first sealed state actually lands — do not pull it in pre-emptively
- **Localisation**: `gen_l10n` toolchain, English + Bahasa Indonesia

Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`) are excluded from analysis via `analysis_options.yaml`.

## Commands

```bash
flutter pub get                        # install dependencies
flutter run                            # run on the default connected device
flutter run -d <device-id>             # run on a specific device (see `flutter devices`)
flutter analyze                        # static analysis / lints
flutter test                           # run all tests
flutter test test/widget_test.dart     # run a single test file
flutter test --name "<test name>"      # run a single test by name
dart format .                          # format all Dart files
dart format --set-exit-if-changed .    # CI-style format check (must pass before commit)
flutter build apk --debug --no-shrink  # debug Android build
flutter build ios                      # iOS build (requires Xcode)
```

Once code generation dependencies land (Evening 2+), also:

```bash
dart run build_runner build --delete-conflicting-outputs   # drift / freezed / json_serializable codegen
flutter gen-l10n                                            # regenerate ARB-driven localisations
```

## Out of scope until later phases

The Week 1 plan explicitly defers these — do not introduce them while still on the skeleton:

- Transactions, categories, budgets, zakat — Week 2+
- Real OCR or bank import — Phase 2
- Backend or sync — Phase 4
- Custom themes, animations, advanced UX — Week 5 polish phase

> Ship the skeleton green before adding features. Every feature added to a yellow-CI repo creates compounding pain.
