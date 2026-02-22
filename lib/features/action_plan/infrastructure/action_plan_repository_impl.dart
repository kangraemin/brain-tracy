import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/action_plan/domain/repositories/action_plan_repository.dart';
import 'package:brain_tracy/features/action_plan/infrastructure/action_step_hive_model.dart';

class ActionPlanRepositoryImpl implements ActionPlanRepository {
  final Box<ActionStepHiveModel> _box;

  ActionPlanRepositoryImpl(this._box);

  @override
  Future<List<ActionStepEntity>> getByGoalId(String goalId) async {
    return _box.values
        .where((model) => model.goalId == goalId)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> add(ActionStepEntity step) async {
    await _box.put(step.id, ActionStepHiveModel.fromEntity(step));
  }

  @override
  Future<void> update(ActionStepEntity step) async {
    await _box.put(step.id, ActionStepHiveModel.fromEntity(step));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
