---
title: 'Tech stack & versions'
description: The pinned packages in pubspec.yaml and the role each one plays.
category: reference
---

# Tech stack & versions

Versions are the constraints pinned in [`pubspec.yaml`](../../pubspec.yaml)
(verified 2026-05-09). The **Dart floor is effectively 3.10** — `pubspec.yaml`
declares `sdk: ^3.8.1`, but `drift_dev ^2.33.0` resolves to Dart `>=3.10.0`.

## Runtime dependencies

| Package                  | Constraint  | Role                                              |
| ------------------------ | ----------- | ------------------------------------------------- |
| `flutter_bloc`           | `^9.1.1`    | State management — Cubit + BLoC.                  |
| `equatable`              | `^2.0.8`    | Value equality for entities and states.          |
| `get_it`                 | `^9.2.1`    | Dependency injection (service locator).          |
| `drift`                  | `^2.33.0`   | Type-safe SQL local database.                    |
| `sqlite3_flutter_libs`   | `^0.5.0`    | Bundled SQLite native libraries for drift.        |
| `path_provider`          | `^2.1.5`    | Locate the app documents directory for the DB.    |
| `path`                   | `^1.9.1`    | Join filesystem paths.                            |
| `fpdart`                 | `^1.2.0`    | Functional types — `Either<Failure, T>`.         |
| `go_router`              | `^17.2.3`   | Declarative routing.                             |
| `flutter_secure_storage` | `^10.1.0`   | Encrypted key-value storage for sensitive data.  |
| `local_auth`             | `^3.0.1`    | Biometric authentication.                        |
| `fl_chart`               | `^1.2.0`    | Charts (dashboard).                              |
| `intl`                   | `^0.20.2`   | i18n / l10n formatting.                          |
| `logger`                 | `^2.7.0`    | Structured logging.                              |
| `cupertino_icons`        | `^1.0.8`    | iOS-style icon glyphs.                            |
| `flutter_localizations`  | SDK         | Localisation delegates.                          |

## Dev dependencies

| Package          | Constraint | Role                                                  |
| ---------------- | ---------- | ----------------------------------------------------- |
| `flutter_lints`  | `^6.0.0`   | Lint baseline (extended in `analysis_options.yaml`).  |
| `mockito`        | `^5.6.4`   | Mocking. **Pinned below the plan's `^5.6.5`** — see below. |
| `bloc_test`      | `^10.0.0`  | BLoC transition testing.                              |
| `alchemist`      | `^0.14.0`  | Golden / visual-regression tests.                    |
| `build_runner`   | `^2.15.0`  | Code-generation driver.                              |
| `drift_dev`      | `^2.33.0`  | drift codegen (sets the Dart 3.10 floor).            |
| `integration_test` | SDK      | End-to-end test harness.                             |

## Deferred (commented out in `pubspec.yaml`)

| Package             | Activates when…                          |
| ------------------- | ---------------------------------------- |
| `freezed`           | the first sealed state lands.            |
| `json_serializable` | the first remote DTO lands (Phase 2).    |

## Notable version notes

- **`mockito` pinned to `^5.6.4`, not `^5.6.5`.** `5.6.5` pulls `analyzer ^13`,
  which conflicts with `drift_dev`'s `analyzer ^10–12`. The lower pin resolves
  cleanly. See [Key decisions](../explanation/key-decisions.md).
- **`fpdart` over `dartz`** and **`alchemist` over `golden_toolkit`** are
  deliberate deviations — the alternatives are unmaintained. See
  [Key decisions](../explanation/key-decisions.md).
