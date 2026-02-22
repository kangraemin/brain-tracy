import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_hive_model.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_repository_impl.dart';

final goalBoxProvider = Provider<Box<GoalHiveModel>>((ref) {
  return Hive.box<GoalHiveModel>(HiveConstants.goalBox);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final box = ref.watch(goalBoxProvider);
  return GoalRepositoryImpl(box);
});
