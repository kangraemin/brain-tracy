import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';
import 'package:brain_tracy/features/action_plan/domain/repositories/action_plan_repository.dart';
import 'package:brain_tracy/features/action_plan/infrastructure/action_step_hive_model.dart';

class ActionPlanRepositoryImpl implements ActionPlanRepository {
  final Box<ActionStepHiveModel> _box;

  ActionPlanRepositoryImpl(this._box);

  @override
  Future<List<ActionStepEntity>> getByGoalId(String goalId) async {
    try {
      return _box.values
          .where((model) => model.goalId == goalId)
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw Exception('실행 계획을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> add(ActionStepEntity step) async {
    try {
      await _box.put(step.id, ActionStepHiveModel.fromEntity(step));
    } catch (e) {
      throw Exception('실행 계획을 추가하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> update(ActionStepEntity step) async {
    try {
      await _box.put(step.id, ActionStepHiveModel.fromEntity(step));
    } catch (e) {
      throw Exception('실행 계획을 수정하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw Exception('실행 계획을 삭제하는데 실패했습니다: $e');
    }
  }
}
