import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:brain_tracy/features/action_plan/presentation/action_plan_screen.dart';
import 'package:brain_tracy/features/goal_input/presentation/goal_input_screen.dart';
import 'package:brain_tracy/features/goal_selection/presentation/goal_selection_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: GoalInputScreen.routePath,
    routes: [
      GoRoute(
        path: GoalInputScreen.routePath,
        builder: (context, state) => const GoalInputScreen(),
      ),
      GoRoute(
        path: GoalSelectionScreen.routePath,
        builder: (context, state) => const GoalSelectionScreen(),
      ),
      GoRoute(
        path: ActionPlanScreen.routePath,
        builder: (context, state) {
          final goalId = state.pathParameters['goalId']!;
          return ActionPlanScreen(goalId: goalId);
        },
      ),
    ],
  );
});
