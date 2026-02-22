import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/action_plan/domain/repositories/action_plan_repository.dart';
import 'package:brain_tracy/features/action_plan/infrastructure/action_plan_repository_impl.dart';
import 'package:brain_tracy/features/action_plan/infrastructure/action_step_hive_model.dart';

final actionPlanBoxProvider = Provider<Box<ActionStepHiveModel>>((ref) {
  return Hive.box<ActionStepHiveModel>(HiveConstants.actionPlanBox);
});

final actionPlanRepositoryProvider = Provider<ActionPlanRepository>((ref) {
  final box = ref.watch(actionPlanBoxProvider);
  return ActionPlanRepositoryImpl(box);
});
