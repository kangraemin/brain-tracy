import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/goal_input/presentation/goal_input_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: GoalInputScreen.routePath,
    routes: [
      GoRoute(
        path: GoalInputScreen.routePath,
        builder: (context, state) => const GoalInputScreen(),
      ),
    ],
  );
});
