import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_providers.dart';
import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/dashboard/application/dashboard_providers.dart';
import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';

part 'dashboard_notifier.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    GoalEntity? selectedGoal,
    @Default([]) List<ActionStepEntity> actionSteps,
    @Default(0) double progressPercent,
    @Default(0) int streakDays,
  }) = _DashboardState;
}

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  FutureOr<DashboardState> build() async {
    final goalRepository = ref.read(goalRepositoryProvider);
    final actionPlanRepository = ref.read(actionPlanRepositoryProvider);
    final userActivityRepository = ref.read(userActivityRepositoryProvider);

    final goals = await goalRepository.getAll();
    final selectedGoal =
        goals.where((g) => g.isSelected).firstOrNull;

    List<ActionStepEntity> actionSteps = [];
    double progressPercent = 0;

    if (selectedGoal != null) {
      actionSteps = await actionPlanRepository.getByGoalId(selectedGoal.id);
      actionSteps.sort((a, b) => a.order.compareTo(b.order));

      if (actionSteps.isNotEmpty) {
        final completed = actionSteps.where((s) => s.isCompleted).length;
        progressPercent = completed / actionSteps.length * 100;
      }
    }

    final streakDays = await userActivityRepository.getCurrentStreak();

    return DashboardState(
      selectedGoal: selectedGoal,
      actionSteps: actionSteps,
      progressPercent: progressPercent,
      streakDays: streakDays,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
