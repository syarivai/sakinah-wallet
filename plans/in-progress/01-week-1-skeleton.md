---
title: "Plan 01 — Week 1 Skeleton Bootstrap"
description: Executable 5–7 evening plan to stand up the Clean Architecture + BLoC skeleton with green CI and no domain features.
status: in-progress
created: 2026-05-09
owner: Muhammad Syarif Abdullah
depends_on: ["00-overview"]
---

# Plan 01 — Sakinah Wallet: Week 1 Skeleton Bootstrap

> [!info] Purpose
> Concrete, executable plan for **Step 1 of the Implementation Order** in [Plan 00 — Project Overview & Roadmap](00-overview.md). Goal: a green CI build with the Clean Architecture skeleton in place — no features yet. Time budget: **5–7 evenings**.

## Definition of Done

- [ ] `flutter analyze` zero issues
- [ ] `flutter test` zero failures (skeleton smoke test only)
- [ ] `dart format --set-exit-if-changed .` passes
- [ ] GitHub Actions workflow green on `main` and on PRs
- [ ] App boots on iOS simulator + Android emulator showing a placeholder home screen
- [ ] Biometric unlock stub gates the home screen (always-allow in debug)
- [ ] Localisation toggle (English ↔ Bahasa Indonesia) works on the placeholder screen
- [ ] First commit pushed to a public GitHub repo with README

## Conventions Source

This skeleton implements the conventions documented in:

- Flutter Best Practices
- Flutter Folder Best Practices

with the project-specific deviations called out in [Plan 00 — Project Overview & Roadmap](00-overview.md) (drift, alchemist, fpdart, optional freezed).

---

## Prerequisites (verify before starting)

```bash
flutter --version       # expect 3.29.x or newer
dart --version          # expect 3.7+
flutter doctor          # all checkmarks for iOS + Android targets
gh auth status          # logged in to GitHub for repo creation
```

If any of those fail, fix the toolchain before continuing. Don't try to bring up the project on a half-broken Flutter install.

---

## Day-by-day breakdown

### Evening 1 — Project bootstrap + repo

1. **Create the project**
   ```bash
   cd ~/Documents/Learn/flutter
   flutter create --org com.sakinahwallet --platforms=ios,android --description "Sharia-compliant personal finance" sakinah_wallet
   cd sakinah_wallet
   ```

2. **Verify it boots** on both platforms (catch native config issues early):
   ```bash
   flutter run -d "iPhone"          # one of the available simulators
   flutter run -d emulator-5554     # an Android emulator
   ```

3. **Initialise git + GitHub**
   ```bash
   git init -b main
   gh repo create sakinah-wallet --public --source=. --description "Sharia-compliant personal finance — Flutter learning + portfolio project"
   ```

4. **First commit** — vanilla `flutter create` output, no edits.

### Evening 2 — Dependencies + analysis_options

1. **Replace `pubspec.yaml` dependencies** (versions verified 2026-05-09):

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_localizations:
       sdk: flutter

     # State management
     flutter_bloc: ^9.1.1
     equatable: ^2.0.8

     # DI
     get_it: ^9.2.1

     # Local DB
     drift: ^2.33.0
     sqlite3_flutter_libs: ^0.5.0
     path_provider: ^2.1.5
     path: ^1.9.1

     # Functional types — replaces dartz (which is unmaintained)
     fpdart: ^1.2.0

     # Routing
     go_router: ^17.2.3

     # Sensitive storage + biometric
     flutter_secure_storage: ^10.1.0
     local_auth: ^3.0.1

     # Charts
     fl_chart: ^1.2.0

     # Utilities
     intl: ^0.20.2
     logger: ^2.7.0
     cupertino_icons: ^1.0.8

   dev_dependencies:
     flutter_test:
       sdk: flutter
     integration_test:
       sdk: flutter

     # Lint
     flutter_lints: ^6.0.0

     # Testing
     mockito: ^5.6.5
     bloc_test: ^10.0.0
     alchemist: ^0.14.0

     # Code generation
     build_runner: ^2.15.0
     drift_dev: ^2.33.0
     # freezed: ^3.2.5    # uncomment when first sealed state lands
     # json_serializable: ^6.13.2  # uncomment when first remote DTO lands
   ```

   Then `flutter pub get`.

2. **Replace `analysis_options.yaml`** with the project-strict baseline:

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

3. **Verify `flutter analyze`** passes on the vanilla template after applying these rules. Fix any newly-flagged issues from the template (mostly `prefer_const_constructors` on `MyHomePage`).

4. **Commit**: `chore: pin dependencies + strict analysis options`

### Evening 3 — Clean Architecture skeleton (folders + barrel files)

1. **Delete** the auto-generated `lib/main.dart` body — start fresh.
2. **Create the folder skeleton**:

   ```bash
   mkdir -p lib/{core/{config,constant,di/modules,errors,services,storage,theme,utils},data/{datasources/local,mappers,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,navigation,screens,widgets/common}}
   mkdir -p test/{core,data,domain,presentation,goldens}
   mkdir integration_test
   ```

3. **Stub files** — empty `index.dart` barrel files in each leaf folder; stub classes for the non-feature core utilities:

   - `lib/main.dart` — `runApp(const SakinahWalletApp())`
   - `lib/app.dart` — root `MaterialApp.router` skeleton
   - `lib/core/errors/failures.dart` — `sealed class Failure { const Failure(this.message); final String message; }` plus `ServerFailure`, `NetworkFailure`, `CacheFailure`, `UnknownFailure`
   - `lib/core/errors/exceptions.dart` — matching `Exception` types
   - `lib/core/errors/index.dart` — barrel
   - `lib/core/theme/colors.dart` + `typography.dart` + `index.dart` — Material 3 theme stub
   - `lib/core/storage/secure_storage.dart` — thin wrapper around `flutter_secure_storage`
   - `lib/core/storage/storage_keys.dart` — string constants (no PII)
   - `lib/core/storage/drift_database.dart` — empty `@DriftDatabase` class so codegen works
   - `lib/core/services/biometric_service.dart` — wrapper around `local_auth` with always-allow override for debug
   - `lib/core/di/inject_dependencies.dart` — top-level `setupDependencies()` that calls each feature module's registration
   - `lib/presentation/navigation/app_router.dart` — `go_router` skeleton with `/` and `/home`

4. **Run `dart run build_runner build --delete-conflicting-outputs`** to generate `drift_database.g.dart`.

5. **Commit**: `feat(core): scaffold clean-architecture skeleton with empty barrel files`

### Evening 4 — Localisation + theme + placeholder home screen

1. **Set up `gen_l10n`** (the modern Flutter localisation toolchain):

   - Add to `pubspec.yaml` under `flutter:`:
     ```yaml
     generate: true
     ```
   - Create `l10n.yaml` at the project root:
     ```yaml
     arb-dir: lib/l10n
     template-arb-file: app_en.arb
     output-localization-file: app_localizations.dart
     ```
   - Create `lib/l10n/app_en.arb` and `lib/l10n/app_id.arb` with at least:
     ```json
     {
       "appTitle": "Sakinah Wallet",
       "homeWelcome": "Welcome",
       "unlockWithBiometric": "Unlock to view your finances"
     }
     ```
   - Run `flutter gen-l10n`.

2. **Wire the locale** into `MaterialApp.router` via `localizationsDelegates` and `supportedLocales`.

3. **Build a placeholder `HomeScreen`** that displays the localised welcome string, a colour from the theme, and a single button. No BLoC yet — this is just to prove the wiring works.

4. **Commit**: `feat(l10n): wire English + Bahasa Indonesia locales with gen_l10n`

### Evening 5 — Biometric gate + first BLoC

1. **`AppLockBloc`** (Cubit, since it has no events worth modelling):

   ```dart
   sealed class AppLockState {}
   final class AppLockLocked extends AppLockState {}
   final class AppLockChecking extends AppLockState {}
   final class AppLockUnlocked extends AppLockState {}
   final class AppLockFailed extends AppLockState { final String message; AppLockFailed(this.message); }

   class AppLockCubit extends Cubit<AppLockState> {
     AppLockCubit(this._biometric) : super(AppLockLocked());
     final BiometricService _biometric;

     Future<void> unlock() async {
       emit(AppLockChecking());
       final ok = await _biometric.authenticate();
       emit(ok ? AppLockUnlocked() : AppLockFailed('Authentication failed'));
     }
   }
   ```

2. **Wire it as a `BlocProvider` at the root**, gate `HomeScreen` behind `AppLockUnlocked`. Show a "Tap to unlock" button when locked.

3. **Test it**:
   ```dart
   // test/presentation/bloc/app_lock_cubit_test.dart
   blocTest<AppLockCubit, AppLockState>(
     'emits [Checking, Unlocked] when biometric succeeds',
     build: () => AppLockCubit(_FakeBiometricService(allow: true)),
     act: (c) => c.unlock(),
     expect: () => [isA<AppLockChecking>(), isA<AppLockUnlocked>()],
   );
   ```

4. **Commit**: `feat(auth): biometric unlock gate with always-allow debug override`

### Evening 6 — CI pipeline

1. **Create `.github/workflows/ci.yml`** (lifted from Flutter Best Practices § CI/CD Pipeline):

   ```yaml
   name: ci
   on:
     push:
       branches: [main]
     pull_request:

   jobs:
     flutter:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: subosito/flutter-action@v2
           with:
             channel: stable
             cache: true
         - run: flutter pub get
         - run: dart run build_runner build --delete-conflicting-outputs
         - run: dart format --set-exit-if-changed .
         - run: flutter analyze --fatal-infos
         - run: flutter test --coverage
         - uses: codecov/codecov-action@v4
           with:
             files: coverage/lcov.info
             fail_ci_if_error: false
         - run: flutter build apk --debug --no-shrink
   ```

2. **Push** and verify the workflow goes green. Iterate locally if not.

3. **Add a coverage badge** to the README once Codecov reports back.

4. **Commit**: `ci: GitHub Actions for format, analyze, test, build`

### Evening 7 — README + golden test setup + first push

1. **Write the README** — placeholder is fine, but include:
   - One-line elevator pitch ("Sharia-compliant personal finance for Muslim users")
   - Build status badge from the new CI workflow
   - Architecture diagram (copy the Mermaid from the project overview)
   - Quickstart: `flutter pub get` → `flutter run`
   - Link back to the project notes (private vault — keep that link out of the public README)

2. **Add the first golden test** for the placeholder home screen:

   ```dart
   // test/presentation/screens/home_screen_golden_test.dart
   import 'package:alchemist/alchemist.dart';
   import 'package:flutter_test/flutter_test.dart';

   void main() {
     goldenTest(
       'HomeScreen — locked / unlocked',
       fileName: 'home_screen',
       builder: () => GoldenTestGroup(children: [
         GoldenTestScenario(name: 'locked',   child: const HomeScreenPreview.locked()),
         GoldenTestScenario(name: 'unlocked', child: const HomeScreenPreview.unlocked()),
       ]),
     );
   }
   ```

   Generate baselines: `flutter test --update-goldens`. Commit the PNGs.

3. **Tag** the repo as `v0.0.1-skeleton` so you have a clean checkpoint.

4. **Commit**: `docs: README with architecture diagram + first alchemist golden test`

5. **Final check** — re-read the Definition of Done at the top of this file. Every box must be ticked before declaring Week 1 complete.

---

## Common pitfalls (heads-up)

| Pitfall                                                          | Fix                                                                              |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `dart format --set-exit-if-changed` fails on generated files     | Add them to `.gitignore` AND `analyzer.exclude` in `analysis_options.yaml`        |
| Drift `build_runner` complains about missing tables              | Empty `@DriftDatabase(tables: [])` is OK; codegen still runs                     |
| `local_auth` fails on iOS simulator                              | Add `NSFaceIDUsageDescription` to `Info.plist`; on Android add `USE_BIOMETRIC` permission |
| `gen_l10n` says "no .arb files found"                            | `arb-dir` in `l10n.yaml` is relative to project root, not `lib/`                  |
| `MaterialApp.router` stalls on a black screen                    | `GoRouter` needs at least one route AND a `redirect` for the initial location     |
| Codecov action errors out                                        | Set `fail_ci_if_error: false` while bootstrapping; tighten later                  |

---

## Out of scope for Week 1 (resist!)

- Transactions, categories, budgets, zakat — Week 2+
- Real OCR or bank import — Phase 2
- Backend or sync — Phase 4
- Custom themes, animations, advanced UX — Week 5 polish phase

> [!warning] Ship the skeleton green before adding features
> Every feature added to a yellow-CI repo creates compounding pain. The whole point of Week 1 is the boring infrastructure — when you add transactions in Week 2, the test/lint feedback loop already works.

---

## Verification at the end of Week 1

```bash
# All five must succeed locally with zero output noise:
flutter pub get
dart format --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --debug
```

Then check on GitHub:
- [ ] CI workflow run is green on the latest push to `main`
- [ ] Repo has at least one tag (`v0.0.1-skeleton`)
- [ ] README renders with architecture diagram + build badge

If all of those are true, you have a foundation worth building on. If any one is false, fix it before starting Week 2 — feature work on a flaky skeleton compounds into pain.

---

## 🔗 Related

- [Plan 00 — Project Overview & Roadmap](00-overview.md)
- Flutter Best Practices (private notes vault)
- Flutter Folder Best Practices (private notes vault)

---

**Last Updated**: 2026-05-09
**Status**: Ready to execute
**Next Step**: Evening 1 — `flutter create --org com.sakinahwallet sakinah_wallet`
