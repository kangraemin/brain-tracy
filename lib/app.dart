import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/core/theme/app_theme.dart';
import 'package:brain_tracy/routing/app_router.dart';

class BrainTracyApp extends ConsumerWidget {
  const BrainTracyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Brain Tracy',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
