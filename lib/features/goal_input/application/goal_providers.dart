import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brain_tracy/features/goal_input/domain/repositories/goal_repository.dart';
import 'package:brain_tracy/features/goal_input/infrastructure/goal_repository_impl.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepositoryImpl();
});
