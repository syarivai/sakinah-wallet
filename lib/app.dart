import 'package:flutter/material.dart';

import 'package:sakinah_wallet/core/theme/colors.dart';
import 'package:sakinah_wallet/presentation/navigation/app_router.dart';

class SakinahWalletApp extends StatelessWidget {
  const SakinahWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sakinah Wallet',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
      ),
      routerConfig: appRouter,
    );
  }
}
