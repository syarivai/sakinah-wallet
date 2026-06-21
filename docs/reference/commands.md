---
title: 'Commands'
description: Every Flutter/Dart command used in this project and what it does.
category: reference
---

# Commands

## Everyday

| Command                                  | Purpose                                          |
| ---------------------------------------- | ------------------------------------------------ |
| `flutter pub get`                        | Install dependencies.                            |
| `flutter run`                            | Run on the default connected device (hot reload).|
| `flutter run -d <device-id>`             | Run on a specific device (see `flutter devices`).|
| `flutter devices`                        | List connected devices / simulators.             |

## Quality gate (run before every commit)

| Command                                  | Purpose                                          |
| ---------------------------------------- | ------------------------------------------------ |
| `dart format --set-exit-if-changed .`    | CI-style format check — fails if unformatted.    |
| `dart format .`                          | Auto-format all Dart files.                      |
| `flutter analyze`                        | Static analysis / lints (`analysis_options.yaml`).|
| `flutter test`                           | Run all tests.                                   |

## Testing

| Command                                  | Purpose                                          |
| ---------------------------------------- | ------------------------------------------------ |
| `flutter test test/widget_test.dart`     | Run a single test file.                          |
| `flutter test --name "<test name>"`      | Run a single test by name.                       |
| `flutter test --coverage`                | Write `coverage/lcov.info`.                       |
| `flutter test --update-goldens`          | Regenerate alchemist golden baselines (planned). |

## Code generation

| Command                                              | Purpose                                  |
| ---------------------------------------------------- | ---------------------------------------- |
| `dart run build_runner build --delete-conflicting-outputs` | drift / freezed / json_serializable codegen. |
| `dart run build_runner watch --delete-conflicting-outputs` | Same, in watch mode.                     |
| `flutter gen-l10n`                                   | Regenerate ARB-driven localisations (after Evening 4). |

## Build

| Command                                  | Purpose                                          |
| ---------------------------------------- | ------------------------------------------------ |
| `flutter build apk --debug --no-shrink`  | Debug Android build.                             |
| `flutter build ios`                      | iOS build (requires Xcode).                      |

See [How-to: Run, analyse, and test](../how-to/run-and-test.md) for the common
workflows and [How-to: Run code generation](../how-to/run-codegen.md) for when
to regenerate.
