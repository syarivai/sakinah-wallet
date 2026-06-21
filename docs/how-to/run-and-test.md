---
title: 'How to run, analyse, and test'
description: The commands for everyday Flutter development, plus what each quality gate checks.
category: how-to
---

# How to run, analyse, and test

For the full list see [Reference: Commands](../reference/commands.md). This guide
covers the common workflows.

## Develop locally

```bash
flutter run                      # run on the default device, with hot reload
flutter run -d <device-id>       # pick a device (see `flutter devices`)
```

While `flutter run` is live: press `r` to hot-reload, `R` to hot-restart, `q` to
quit.

## Run the quality gate

Run these three before every commit — they mirror what CI enforces:

```bash
dart format --set-exit-if-changed .   # fails if anything is unformatted
flutter analyze                       # lints from analysis_options.yaml
flutter test                          # unit + widget tests
```

To fix formatting in place:

```bash
dart format .
```

## Test

```bash
flutter test                                  # all tests
flutter test test/widget_test.dart            # a single file
flutter test --name "<test name>"             # a single test by name
flutter test --coverage                       # writes coverage/lcov.info
flutter test --update-goldens                 # regenerate alchemist baselines (planned)
```

See [Explanation: Testing strategy](../explanation/testing-strategy.md) for the
pyramid (unit / widget / integration) and where each kind of test lives.

## Build

```bash
flutter build apk --debug --no-shrink   # debug Android build
flutter build ios                       # iOS build (requires Xcode)
```

## After changing generated code

If you touch a drift table, a `freezed` class, or the ARB localisation files,
re-run code generation — see [How-to: Run code generation](./run-codegen.md).
Stale generated files are a common cause of confusing analyzer errors.
