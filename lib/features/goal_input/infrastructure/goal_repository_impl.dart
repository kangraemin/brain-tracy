import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_hive_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  final Box<GoalHiveModel> _box;

  GoalRepositoryImpl(this._box);

  @override
  Future<List<GoalEntity>> getAll() async {
    try {
      return _box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('목표 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> add(GoalEntity goal) async {
    try {
      final model = GoalHiveModel.fromEntity(goal);
      await _box.put(goal.id, model);
    } catch (e) {
      throw Exception('목표를 추가하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> update(GoalEntity goal) async {
    try {
      final model = GoalHiveModel.fromEntity(goal);
      await _box.put(goal.id, model);
    } catch (e) {
      throw Exception('목표를 수정하는데 실패했습니다: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw Exception('목표를 삭제하는데 실패했습니다: $e');
    }
  }
}
