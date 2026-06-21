---
title: 'Security & privacy'
description: How the app protects financial data — local-first, secure storage, and a biometric gate.
category: explanation
---

# Security & privacy

Sakinah Wallet handles personal financial data, so the security posture is built
into the architecture rather than bolted on.

## Local-first by design

The MVP makes **no network calls** — all data lives on the device in the
[drift](../reference/database-schema.md) SQLite database. There is no backend,
no analytics, and no telemetry to leak. The smallest attack surface is the one
that doesn't exist; cloud sync is deliberately deferred to Phase 4 (see
[Key decisions](./key-decisions.md)).

## Sensitive storage

Secrets and sensitive flags go through `flutter_secure_storage`
([`lib/core/storage/secure_storage.dart`](../reference/project-structure.md)),
which uses the **iOS Keychain** and **Android EncryptedSharedPreferences/Keystore**
— not plain `SharedPreferences`. Storage keys are centralised in
`storage_keys.dart` and must **never encode PII** in the key name itself.

The bulk financial data lives in the drift DB inside the app's private documents
directory, isolated by the OS sandbox from other apps.

## Biometric gate

`BiometricService` ([`lib/core/services/biometric_service.dart`](../reference/project-structure.md))
wraps `local_auth` to gate the app behind Face ID / Touch ID / fingerprint:

```dart
Future<bool> authenticate({String reason = 'Unlock Sakinah Wallet'}) async {
  if (alwaysAllowInDebug && kDebugMode) return true;   // dev convenience only
  try {
    return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
  } on Object {
    return false;   // fail closed
  }
}
```

Two deliberate properties:

- **Fail closed.** Any error returns `false` (stay locked), never `true`.
- **Debug-only override.** `alwaysAllowInDebug` short-circuits authentication
  **only** when `kDebugMode` is true, so developers aren't prompted on every hot
  restart. In release builds `kDebugMode` is false, so the real biometric prompt
  always runs. The override can never weaken a shipped app.

## Defence in depth

- Compliance-critical logic (zakat, riba flags) stays in the framework-free
  `domain/` layer and, when the backend lands, must be **re-validated
  server-side** — the client is never the source of truth for compliance math.
- Lints (`avoid_print`, etc.) keep sensitive values out of logs; use the `logger`
  package with care and never log secrets or full account data.

## Out of scope (for now)

PIN fallback, at-rest DB encryption beyond the OS sandbox, and any cloud transport
security arrive with later phases. Until then, the device's own lockscreen plus
the biometric gate are the boundary.
