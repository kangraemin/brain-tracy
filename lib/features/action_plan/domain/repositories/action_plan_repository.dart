import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';

abstract class ActionPlanRepository {
  Future<List<ActionStepEntity>> getByGoalId(String goalId);
  Future<void> add(ActionStepEntity step);
  Future<void> update(ActionStepEntity step);
  Future<void> delete(String id);
}
