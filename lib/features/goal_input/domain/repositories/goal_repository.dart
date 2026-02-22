import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> getAll();
  Future<void> add(GoalEntity goal);
  Future<void> update(GoalEntity goal);
  Future<void> delete(String id);
}
