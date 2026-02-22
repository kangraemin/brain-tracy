import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_input/application/goal_providers.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';

class GoalSelectionState {
  final List<GoalEntity> goals;
  final String? selectedGoalId;

  const GoalSelectionState({
    required this.goals,
    this.selectedGoalId,
  });

  GoalSelectionState copyWith({
    List<GoalEntity>? goals,
    String? Function()? selectedGoalId,
  }) {
    return GoalSelectionState(
      goals: goals ?? this.goals,
      selectedGoalId:
          selectedGoalId != null ? selectedGoalId() : this.selectedGoalId,
    );
  }
}

class GoalSelectionNotifier extends AsyncNotifier<GoalSelectionState> {
  GoalRepository get _repository => ref.read(goalRepositoryProvider);

  @override
  FutureOr<GoalSelectionState> build() async {
    final goals = await _repository.getAll();
    final selected = goals.where((g) => g.isSelected).firstOrNull;
    return GoalSelectionState(
      goals: goals,
      selectedGoalId: selected?.id,
    );
  }

  void selectGoal(String id) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newSelectedId =
        currentState.selectedGoalId == id ? null : id;
    state = AsyncData(
      currentState.copyWith(selectedGoalId: () => newSelectedId),
    );
  }

  Future<void> confirmSelection() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.selectedGoalId == null) return;

    // 기존 선택 해제
    for (final goal in currentState.goals) {
      if (goal.isSelected) {
        await _repository.update(goal.copyWith(isSelected: false));
      }
    }

    // 새 선택 저장
    final selectedGoal = currentState.goals.firstWhere(
      (g) => g.id == currentState.selectedGoalId,
    );
    await _repository.update(selectedGoal.copyWith(isSelected: true));
  }
}

final goalSelectionNotifierProvider =
    AsyncNotifierProvider<GoalSelectionNotifier, GoalSelectionState>(
  GoalSelectionNotifier.new,
);
