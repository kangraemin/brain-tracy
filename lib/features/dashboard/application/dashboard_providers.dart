import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/core/constants/hive_constants.dart';
import 'package:brain_tracy/features/dashboard/domain/repositories/user_activity_repository.dart';
import 'package:brain_tracy/features/dashboard/infrastructure/user_activity_hive_model.dart';
import 'package:brain_tracy/features/dashboard/infrastructure/user_activity_repository_impl.dart';

final userActivityBoxProvider = Provider<Box<UserActivityHiveModel>>((ref) {
  return Hive.box<UserActivityHiveModel>(HiveConstants.userActivityBox);
});

final userActivityRepositoryProvider =
    Provider<UserActivityRepository>((ref) {
  final box = ref.watch(userActivityBoxProvider);
  return UserActivityRepositoryImpl(box);
});
