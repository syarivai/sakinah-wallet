---
title: 'Sharia compliance'
description: The Islamic-finance concepts the app models — zakat, nisab, hawl, halal categorisation, riba — and how accuracy is safeguarded.
category: explanation
---

# Sharia compliance

Sakinah Wallet's reason to exist is first-class support for the financial
concepts mainstream apps ignore. This page explains the domain so the code (and
its tests) can be read with the right mental model. For term definitions see the
[Glossary](./glossary.md).

## Zakat, nisab, and hawl

**Zakat** is the obligatory annual alms — **2.5%** of qualifying wealth — due once
two conditions hold:

1. **Nisab** — total qualifying wealth crosses a threshold, pegged to either
   **gold (~85g)** or **silver (~595g)**. The two bases give different thresholds;
   the app records which basis a snapshot used (`computationBasis` in
   [`zakatSnapshots`](../reference/database-schema.md)).
2. **Hawl** — a full **lunar year** has elapsed while wealth stayed at or above
   nisab. Tracking hawl means recording when the qualifying period started and
   detecting if it was broken — the genuinely hard part, tracked per snapshot via
   `hawlStartedAt`.

`ComputeZakatUseCase` and `TrackHawlUseCase` (domain layer, Week 4) encode this.
Because nisab depends on live gold/silver prices, thresholds are **sourced at
runtime**, not hard-coded — the constants file documents the basis and fatwa
source rather than baking in a number.

## Halal categorisation

Every transaction carries a `halalStatus` of **halal**, **non_halal**, or
**doubtful** — distinguishing sharia-compliant income/expense from interest
income, gambling, or riba-bearing instruments. Categories themselves are
`isHalal`-aware and pre-seeded with sharia-relevant defaults (zakat, sadaqah,
halal-investment, flagged riba-income). The dashboard surfaces the halal vs.
non-halal split.

## Riba detection (Phase 3)

**Riba** (interest) detection — heuristically flagging transactions that look
like interest income/expense so the user can purify or avoid them — is a
**Could-Have**, deferred to Phase 3.

## Why correctness is an architectural concern

Getting a religious obligation wrong is a high-impact failure. The safeguards:

- **Compliance logic lives in the framework-free `domain/` layer** so it is pure,
  unit-testable, and — when the Phase 4 Go backend lands — **re-implementable and
  re-validated server-side**. The client is never the source of truth for
  compliance math (see [Key decisions](./key-decisions.md)).
- **Zakat is validated against at least three worked examples** from a recognised
  fatwa source, as unit tests (see [Testing strategy](./testing-strategy.md)).
- **Fatwa sources are cited** per computation (planned `docs/zakat-references.md`),
  and the app carries a disclaimer — it's a calculation aid, not a fatwa.

## Scope boundary

The app models personal obligation and categorisation; it does not issue
religious rulings. Where scholars differ (e.g. nisab basis), the app exposes the
choice and records which basis a result used, rather than silently picking one.
