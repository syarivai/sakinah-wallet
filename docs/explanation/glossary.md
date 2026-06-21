---
title: 'Glossary'
description: Plain-language definitions of the Islamic-finance and Flutter/architecture terms used across the project.
category: explanation
---

# Glossary

Unfamiliar term? It's probably here. Split into the two vocabularies this project
straddles: Islamic finance and the Flutter/architecture stack.

## Islamic finance

| Term               | Meaning                                                                                          |
| ------------------ | ------------------------------------------------------------------------------------------------ |
| **Zakat**          | Obligatory annual alms — 2.5% of qualifying wealth — once nisab and hawl are met.                |
| **Nisab**          | The wealth threshold (pegged to ~85g gold or ~595g silver) above which zakat becomes due.        |
| **Hawl**           | The lunar year that must elapse, with wealth ≥ nisab throughout, before zakat is owed.            |
| **Riba**           | Interest/usury — forbidden; the app flags interest-like income/expense (Phase 3).               |
| **Halal / haram**  | Permissible / forbidden under sharia. Transactions are tagged halal, non-halal, or doubtful.     |
| **Doubtful (shubha)** | Of uncertain status — neither clearly halal nor haram; tracked as its own `halalStatus`.      |
| **Sadaqah**        | Voluntary charity (distinct from obligatory zakat); a pre-seeded category.                       |
| **Hajj**           | The pilgrimage to Mecca; the long-horizon savings-goal use case (Phase 3).                        |
| **Sukuk**          | Sharia-compliant fixed-income instruments (≈ "Islamic bonds"); relevant to the portfolio (Phase 3). |
| **Hijri**          | The Islamic lunar calendar; used for hawl tracking and optional date display.                     |
| **Fatwa**          | A scholarly ruling; zakat math is validated against recognised fatwa sources.                     |

See [Sharia compliance](./sharia-compliance.md) for how these drive the domain.

## Flutter & architecture

| Term                  | Meaning                                                                                       |
| --------------------- | --------------------------------------------------------------------------------------------- |
| **Clean Architecture**| Layered design (`core`/`data`/`domain`/`presentation`) with dependencies pointing inward.     |
| **BLoC**              | Business Logic Component — maps an event stream to a state stream (`flutter_bloc`).            |
| **Cubit**             | A simpler BLoC with methods instead of events; used when events add no value.                 |
| **Entity**            | A framework-free domain object (lives in `domain/entities`).                                   |
| **Use case**          | One unit of application logic, one class (e.g. `ComputeZakatUseCase`); returns `Either`.        |
| **Repository**        | An interface in `domain/`, implemented in `data/` — the seam that inverts the dependency.      |
| **Mapper**            | Converts between a data-layer model (DTO) and a domain entity.                                 |
| **drift**             | Type-safe SQL ORM over SQLite, with code-generated queries and explicit migrations.            |
| **`Either<L, R>`**    | A functional result type (`fpdart`): `Left` = failure, `Right` = success.                     |
| **Failure**           | A sealed error value returned from use cases (vs. throwing exceptions).                        |
| **get_it**            | Service-locator used for dependency injection via `setupDependencies()`.                       |
| **go_router**         | Declarative, URL-based routing.                                                               |
| **Barrel (`index.dart`)** | A file that re-exports a folder's public API so callers don't deep-import.                 |
| **freezed**           | Code generator for immutable/sealed data classes — **deferred** until first needed.            |
| **alchemist**         | Golden (visual-regression) testing library.                                                   |
| **gen_l10n / ARB**    | Flutter's localisation toolchain; `.arb` files hold the translated strings.                    |
| **codegen**           | Generated `*.g.dart` / `*.freezed.dart` files produced by `build_runner`; never hand-edited.   |

See [Architecture](./architecture.md) and [Conventions](../reference/conventions.md).
