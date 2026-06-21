---
title: 'Getting started'
description: Clone the project, install dependencies, and run the app and its tests for the first time.
category: tutorial
---

# Getting started

This tutorial takes you from a fresh clone to the app running on a device and a
passing test suite. Follow every step in order; by the end you'll have Sakinah
Wallet open on a simulator/emulator and green tests in your terminal. No prior
knowledge of the stack is assumed.

## Before you begin

You need the **Flutter SDK** installed. The effective floor is **Dart 3.10**
(the `pubspec.yaml` declares `sdk: ^3.8.1`, but `drift_dev` resolves to Dart
`>=3.10.0`). Check your toolchain:

```bash
flutter --version       # bundled Dart should be 3.10 or newer
flutter doctor          # all checkmarks for the targets you'll run (iOS / Android)
```

If `flutter doctor` flags a target you intend to use, fix the toolchain before
continuing — don't try to bring the app up on a half-broken install.

## 1. Get the code

```bash
git clone <repo-url> sakinah_wallet
cd sakinah_wallet
```

## 2. Install dependencies

```bash
flutter pub get
```

## 3. Generate code

The drift database has generated companions (`*.g.dart`). Generate them once
after install:

```bash
dart run build_runner build --delete-conflicting-outputs
```

See [How-to: Run code generation](../how-to/run-codegen.md) for when to re-run
this.

## 4. Run the app

List devices, then run:

```bash
flutter devices
flutter run                      # default device
flutter run -d <device-id>       # a specific simulator/emulator
```

You should see a placeholder **Home** screen — the router redirects `/` → `/home`
(see [`lib/presentation/navigation/app_router.dart`](../reference/project-structure.md)).
There are no domain features yet; this is the skeleton.

## 5. Run the checks

```bash
dart format --set-exit-if-changed .   # formatting gate
flutter analyze                       # static analysis / lints
flutter test                          # unit + widget tests
```

Everything should be green. These three are the local quality gate — run them
before every commit. See [How-to: Run, analyse, and test](../how-to/run-and-test.md).

## What you just learned

- The project uses the **Flutter SDK** directly (no extra wrappers); the
  effective Dart floor is **3.10**.
- `dart run build_runner build` generates drift's `*.g.dart` companions.
- `dart format` + `flutter analyze` + `flutter test` is the quality gate.
- The app is a **Clean Architecture skeleton** — infrastructure only, no features.

## Next steps

- Do a real task → [How-to guides](../how-to)
- Understand the structure → [Architecture](../explanation/architecture.md)
- Confused by a term (zakat, hawl, BLoC, drift)? → [Glossary](../explanation/glossary.md)
