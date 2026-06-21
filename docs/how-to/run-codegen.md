---
title: 'How to run code generation'
description: Regenerate drift database companions, freezed classes, and gen_l10n localisations.
category: how-to
---

# How to run code generation

Three things in this project are generated, not hand-written. Generated files
(`*.g.dart`, `*.freezed.dart`) are git-ignored from analysis via
[`analysis_options.yaml`](../reference/conventions.md) and must be regenerated
when their sources change.

## drift + freezed + json_serializable (`build_runner`)

Run this after editing a drift table, a `freezed` class, or a serialisable model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

- `--delete-conflicting-outputs` overwrites stale companions instead of erroring.
- For a tight edit loop, use watch mode:

  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```

Currently this generates [`lib/core/storage/drift_database.g.dart`](../reference/database-schema.md)
from the (still empty) `@DriftDatabase` class. `freezed` and `json_serializable`
are **commented out** in `pubspec.yaml` and activate when the first sealed state
or remote DTO lands.

## Localisations (`gen_l10n`)

ARB-driven localisations regenerate with:

```bash
flutter gen-l10n
```

This is wired in from **Evening 4** (`l10n.yaml` + `lib/l10n/app_*.arb`). To add
or change a string, see [How-to: Add a localised string](./add-a-localized-string.md).

## When in doubt

If the analyzer complains about a missing generated symbol (a `_$…` class, a
`AppLocalizations` getter), the fix is almost always to re-run the matching
generator above, not to edit the `*.g.dart` file by hand — those are overwritten.
