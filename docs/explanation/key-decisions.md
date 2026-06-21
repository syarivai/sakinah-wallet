---
title: 'Key decisions'
description: A log of notable technical decisions and deviations, with their rationale.
category: explanation
---

# Key decisions

A lightweight decision log (ADR-style) for choices that aren't obvious from the
code or that deviate from common Flutter defaults.

## `drift` for the local database (not `sqflite`/`hive`/`isar`)

drift gives **type-safe SQL queries and explicit migrations** from day one. For a
finance app where the schema will evolve (accounts → categories → budgets →
zakat snapshots), versioned migrations are a feature, not overhead — and the
typed query surface is a richer learning target than a schemaless store. The cost
is a build step (`build_runner`); accepted.

## `fpdart` for functional types (not `dartz`)

`dartz` last shipped 2021-12-03, constrains the SDK to `<3.0.0`, and has no
verified publisher on pub.dev — a non-starter on Dart 3.10. `fpdart` (verified
publisher, Dart-3-idiomatic) preserves the same `Either<L, R>` shape with better
extensions. The migration is mechanical at the call sites.

## `alchemist` for golden tests (not `golden_toolkit`)

`golden_toolkit` is unmaintained (last release 2023-02, SDK `<3.0.0`) and won't
resolve on Dart 3. `alchemist` is actively maintained and Flutter-team-adjacent.

## `freezed` is deferred, not pre-installed

The sealed `Failure` hierarchy is hand-written with Dart 3 `sealed class` today.
`freezed` (and `json_serializable`) stay **commented out** in `pubspec.yaml`
until the first real sealed state / remote DTO needs them — adding a code
generator before there's anything to generate is pure overhead.

## `mockito` pinned to `^5.6.4` (below the plan's `^5.6.5`)

`mockito 5.6.5` pulls `analyzer ^13`, which conflicts with `drift_dev`'s
`analyzer ^10–12`. Pinning `mockito` one patch lower resolves the dependency
graph cleanly. Revisit when `drift_dev` widens its `analyzer` constraint.

## Effective Dart floor is 3.10, not the declared 3.8.1

`pubspec.yaml` declares `environment: sdk: ^3.8.1`, but `drift_dev ^2.33.0`
resolves to Dart `>=3.10.0`. The real floor for contributors and CI is **Dart
3.10** — documented here and in [Tech stack](../reference/tech-stack.md) so the
mismatch doesn't surprise anyone.

## Local-first MVP; Go backend deliberately deferred to Phase 4

The MVP is Flutter-only, offline, no network calls — to keep scope honest and
ship in evenings. A Go backend is scheduled post-MVP as a focused
language-learning track, with its stack **chosen at that phase**, not now. See
[`plans/in-progress/00-overview.md`](../../plans/in-progress/00-overview.md).

## Sharia logic stays framework-free in `domain/`

Zakat math, hawl tracking, and halal categorisation live in the `domain/` layer
with no framework imports, so they're unit-testable and re-implementable
server-side later. Compliance-critical logic is never trusted to the UI layer.
See [Sharia compliance](./sharia-compliance.md).
