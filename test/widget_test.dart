import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sakinah_wallet/app.dart';

void main() {
  testWidgets('SakinahWalletApp boots a routed MaterialApp', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SakinahWalletApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
