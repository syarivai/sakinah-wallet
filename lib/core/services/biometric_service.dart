import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  const BiometricService(this._auth, {this.alwaysAllowInDebug = true});

  final LocalAuthentication _auth;
  final bool alwaysAllowInDebug;

  Future<bool> authenticate({String reason = 'Unlock Sakinah Wallet'}) async {
    if (alwaysAllowInDebug && kDebugMode) {
      return true;
    }
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on Object {
      return false;
    }
  }
}
