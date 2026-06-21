---
title: 'Testing strategy'
description: The test pyramid, what each layer covers, and the tools used.
category: explanation
---

# Testing strategy

Testing follows a **70 / 20 / 10 pyramid** — lots of fast unit tests, fewer
widget tests, a handful of end-to-end flows.

```text
        ▲
       /E2E\        integration_test (10%)  — unlock → add tx → see it → compute zakat
      /─────\
     /Widget \      bloc_test + pumpWidget (20%) — state transitions + screen smokes
    /─────────\
   /   Unit    \    flutter_test (70%) — use cases, mappers, zakat math, validators
  /─────────────\
```

## What goes where

| Layer / kind      | Tools                                       | Examples                                          |
| ----------------- | ------------------------------------------- | ------------------------------------------------- |
| Domain unit       | `flutter_test`                              | `ComputeZakatUseCase` math, hawl boundary checks. |
| Data unit         | `flutter_test` + `mockito`                  | mapper round-trips, repository error mapping.     |
| BLoC behaviour    | `bloc_test`                                 | `TransactionBloc` emits Loading → Loaded.         |
| Screen widget     | `flutter_test` + `pumpWidget` + mocked BLoC | renders empty / loading / loaded states.          |
| Visual regression | `alchemist` (golden)                        | one golden per main screen.                       |
| Critical flow     | `integration_test`                          | unlock → add transaction → list shows → zakat.    |

## Why a pyramid

Unit tests on the framework-free `domain/` layer are fast and deterministic, so
the compliance-critical math (zakat, hawl, riba) gets the heaviest coverage —
that's where a bug does real harm. Widget and integration tests are slower and
fewer; they prove the wiring, not the arithmetic.

## Conventions

- Tests mirror `lib/` under `test/` and are **co-located by layer**.
- Mocks use `mockito` + `build_runner` (`@GenerateMocks`), not `mocktail` — one
  mocking library, by convention.
- Goldens use `alchemist`; regenerate baselines with
  `flutter test --update-goldens` and commit the PNGs.
- Zakat is validated against **worked examples from a recognised fatwa source**
  (see [Sharia compliance](./sharia-compliance.md)).

## Current state

Only the scaffold `test/widget_test.dart` exists — the skeleton has no features
to test yet. The pyramid above is the **target** as feature slices land in
Week 2+. Coverage goals: **≥ 70% on `domain/` and `data/`** (≥ 80% on
compliance-critical paths), ≥ 50% overall.

## Running tests

See [How-to: Run, analyse, and test](../how-to/run-and-test.md) and
[Reference: Commands](../reference/commands.md).
