---
title: 'Database schema (drift)'
description: The local SQLite schema managed by drift — current state and the planned MVP tables.
category: reference
---

# Database schema (drift)

The local database is [`drift`](./tech-stack.md) over SQLite, defined in
[`lib/core/storage/drift_database.dart`](./project-structure.md) and generated
into `drift_database.g.dart` via [build_runner](../how-to/run-codegen.md).

## Current state (skeleton)

```dart
@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
```

The table list is intentionally **empty** — codegen still runs and produces a
valid (if trivial) database. The file opens a `LazyDatabase` backed by
`sakinah_wallet.sqlite` in the app documents directory, on a background isolate.

## Planned MVP tables

These land with the feature slices in Week 2+ (see [`plans/`](../../plans)).
Each new table is added to the `@DriftDatabase(tables: [...])` list, after which
`schemaVersion` is bumped and a migration is written.

| Table             | Key columns                                                            | Notes                                  |
| ----------------- | --------------------------------------------------------------------- | -------------------------------------- |
| `accounts`        | `id`, `name`, `type`, `openingBalance`, `currency`, `createdAt`        | Source of funds.                       |
| `categories`      | `id`, `name`, `icon`, `isHalal`, `isUserDefined`                       | Sharia-aware; pre-seeded + user-added. |
| `transactions`    | `id`, `accountId→`, `categoryId→`, `amount`, `type`, `halalStatus`, `occurredOn`, `note`, `createdAt` | `type`: income/expense; `halalStatus`: halal/non_halal/doubtful. |
| `budgets`         | `id`, `categoryId→`, `monthlyLimit`, `effectiveFrom`                    | Per-category monthly cap.              |
| `zakatSnapshots`  | `id`, `computedAt`, `totalAssets`, `nisabThreshold`, `zakatDue`, `computationBasis`, `hawlStartedAt` | `computationBasis`: gold/silver. See [Sharia compliance](../explanation/sharia-compliance.md). |
| `savingsGoals`    | `id`, `name`, `targetAmount`, `targetDate`, `currentAmount`, `status`   | Hajj-savings, Phase 3.                 |

Relationships: `accounts 1─∞ transactions`, `categories 1─∞ transactions`,
`categories 1─∞ budgets`.

## Migrations

drift migrations are explicit. When the schema changes: bump `schemaVersion`,
implement the `MigrationStrategy`, and add a schema test. Migrations are written
from day one rather than retrofitted — that's the reason drift was chosen over a
schemaless store (see [Key decisions](../explanation/key-decisions.md)).
