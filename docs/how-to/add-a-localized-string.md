---
title: 'How to add a localised string'
description: Add or change a user-facing string across the English and Bahasa Indonesia ARB files.
category: how-to
---

# How to add a localised string

> Localisation is wired from **Evening 4** of the skeleton plan (`gen_l10n`,
> English + Bahasa Indonesia). If `lib/l10n/` doesn't exist yet, this is the
> shape it will take.

All user-facing copy lives in **ARB files**, never hard-coded in widgets. The
toolchain is Flutter's built-in [`gen_l10n`](./run-codegen.md).

## 1. Add the key to every ARB file

The template is `lib/l10n/app_en.arb`; every other locale must define the same
keys. Add the new key to **both** files:

```jsonc
// lib/l10n/app_en.arb
{
  "homeWelcome": "Welcome",
  "addTransaction": "Add transaction"     // ← new
}
```

```jsonc
// lib/l10n/app_id.arb
{
  "homeWelcome": "Selamat datang",
  "addTransaction": "Tambah transaksi"    // ← new
}
```

## 2. Regenerate

```bash
flutter gen-l10n
```

This produces the typed `AppLocalizations` accessor.

## 3. Use it in a widget

```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.addTransaction);
```

Never concatenate translated fragments — add a full phrase as one key, and use
ARB **placeholders** for interpolated values (amounts, names) so each language
can order them correctly.

## Notes

- Keep keys **camelCase** and grouped by screen/feature in the file.
- Adding a key to `app_en.arb` but not `app_id.arb` (or vice versa) is a
  generation warning — keep the two in sync.
- Locale-aware money and dates go through `intl` helpers, not string formatting.
