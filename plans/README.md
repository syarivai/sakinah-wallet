---
title: "Plans — Sakinah Wallet"
description: Index of planning documents for Sakinah Wallet, a Sharia-compliant personal finance app (Flutter MVP, Go backend post-MVP).
category: explanation
subcategory: plans
---

# Plans

This folder tracks planning documents for **Sakinah Wallet**, following the
[ose-primer plans convention](https://github.com/wahidyankf/ose-primer/blob/main/repo-governance/conventions/structure/plans.md).

## Lifecycle

Plans move through three states, indicated by folder location (no hidden metadata):

| Folder         | Meaning                          | Filename prefix                  |
| -------------- | -------------------------------- | -------------------------------- |
| `backlog/`     | Planned, not started             | creation date `YYYY-MM-DD-…`     |
| `in-progress/` | Actively being executed          | no date prefix                   |
| `done/`        | Completed                        | completion date `YYYY-MM-DD-…`   |

When work starts on a plan, move it from `backlog/` to `in-progress/` and drop the date prefix.
When it is finished, move it to `done/` and add the completion-date prefix.

## Current plans (in-progress)

1. **[00 — Project Overview & Roadmap](in-progress/00-overview.md)**
   The master plan: problem definition, MoSCoW requirements, pinned tech stack, Clean Architecture
   layout, drift schema, the 6-week MVP roadmap, and the post-MVP phases (CSV/OCR, hajj/portfolio/riba,
   and the deliberately-deferred Go backend).
2. **[01 — Week 1 Skeleton Bootstrap](in-progress/01-week-1-skeleton.md)**
   The executable 5–7 evening plan to stand up the Clean Architecture + BLoC skeleton with green CI and
   **no domain features** — bootstrap, dependencies + strict lints, folder skeleton, localisation,
   biometric gate, CI, and the first golden test. Evenings 1–3 are committed; on Evening 4+.

## Project at a glance

- **Owner:** Muhammad Syarif Abdullah
- **Goal:** A Sharia-compliant personal finance app — budgeting, zakat (with hawl tracking), hajj
  savings, and halal/non-halal categorisation.
- **MVP platform:** Flutter (iOS + Android), **local-first, no backend**.
- **Architecture:** Clean Architecture (`core` / `data` / `domain` / `presentation`) + BLoC.
- **State:** `flutter_bloc` (Cubit when no events matter, BLoC when they do).
- **DI:** `get_it` with per-feature `setupDependencies()` modules.
- **Local DB:** `drift` (type-safe SQL with migrations) — not `sqflite`.
- **Functional types:** `fpdart` — not the unmaintained `dartz`.
- **Routing:** `go_router`. **Sensitive storage / auth:** `flutter_secure_storage` + `local_auth`.
- **Goldens:** `alchemist`. **Localisation:** `gen_l10n` — English + Bahasa Indonesia.
- **CI (non-negotiable):** `dart format` + `flutter analyze` + `flutter test --coverage` must be green
  before any feature work. Ship the skeleton green first.
- **Backend (Phase 4, post-MVP):** Go — tech stack **TBD when that phase begins**.

## Deliberate stack deviations

These are intentional choices documented in Plan 00 — do not substitute the common Flutter defaults:

- `drift` over `sqflite` (type-safe queries + migrations).
- `fpdart` over `dartz` (`dartz` is unmaintained, SDK `<3.0.0`, no verified publisher).
- `alchemist` over `golden_toolkit` (the latter is stuck on Dart `<3.0.0`).
- `freezed` is **deferred** until the first sealed state actually lands.
