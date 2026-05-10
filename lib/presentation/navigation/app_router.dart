import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (context, state) => '/home'),
    GoRoute(
      path: '/home',
      builder: (context, state) => const _SkeletonScaffold(label: 'Home'),
    ),
  ],
);

class _SkeletonScaffold extends StatelessWidget {
  const _SkeletonScaffold({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}
