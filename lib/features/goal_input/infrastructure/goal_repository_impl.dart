import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_hive_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  Box<GoalHiveModel> get _box =>
      Hive.box<GoalHiveModel>(HiveConstants.goalBox);

  @override
  Future<List<GoalEntity>> getAll() async {
    return _box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> add(GoalEntity goal) async {
    final model = GoalHiveModel.fromEntity(goal);
    await _box.put(goal.id, model);
  }

  @override
  Future<void> update(GoalEntity goal) async {
    final model = GoalHiveModel.fromEntity(goal);
    await _box.put(goal.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
