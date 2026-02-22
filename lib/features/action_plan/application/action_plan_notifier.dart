import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:brain_tracy/features/action_plan/application/action_plan_providers.dart';
import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/action_plan/domain/repositories/action_plan_repository.dart';

const _uuid = Uuid();
const maxStepCount = 7;

class ActionPlanNotifier
    extends FamilyAsyncNotifier<List<ActionStepEntity>, String> {
  ActionPlanRepository get _repository =>
      ref.read(actionPlanRepositoryProvider);

  String get _goalId => arg;

  bool get canAddStep {
    final currentState = state;
    if (currentState is AsyncData<List<ActionStepEntity>>) {
      return currentState.value.length < maxStepCount;
    }
    return false;
  }

  @override
  FutureOr<List<ActionStepEntity>> build(String arg) async {
    final steps = await _repository.getByGoalId(arg);
    steps.sort((a, b) => a.order.compareTo(b.order));
    return steps;
  }

  Future<void> addStep(String title) async {
    if (!canAddStep) return;
    final currentSteps = state.valueOrNull ?? [];
    final step = ActionStepEntity(
      id: _uuid.v4(),
      goalId: _goalId,
      title: title,
      order: currentSteps.length,
      createdAt: DateTime.now(),
    );
    await _repository.add(step);
    state = AsyncData(await _fetchSorted());
  }

  Future<void> toggleComplete(String id) async {
    final currentSteps = state.valueOrNull;
    if (currentSteps == null) return;

    final step = currentSteps.firstWhere((s) => s.id == id);
    await _repository.update(step.copyWith(isCompleted: !step.isCompleted));
    state = AsyncData(await _fetchSorted());
  }

  Future<void> deleteStep(String id) async {
    await _repository.delete(id);
    state = AsyncData(await _fetchSorted());
  }

  Future<List<ActionStepEntity>> _fetchSorted() async {
    final steps = await _repository.getByGoalId(_goalId);
    steps.sort((a, b) => a.order.compareTo(b.order));
    return steps;
  }
}

final actionPlanNotifierProvider = AsyncNotifierProvider.family<
    ActionPlanNotifier, List<ActionStepEntity>, String>(
  ActionPlanNotifier.new,
);
