import 'package:brain_tracy/features/dashboard/domain/entities/user_activity_entity.dart';

abstract class UserActivityRepository {
  Future<void> markActive(DateTime date);
  Future<int> getCurrentStreak();
  Future<UserActivityEntity?> getActivity(DateTime date);
  Future<List<UserActivityEntity>> getAll();
}
