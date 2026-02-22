import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/goal_input/presentation/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: HomeScreen.routePath,
    routes: [
      GoRoute(
        path: HomeScreen.routePath,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
