import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/dashboard/domain/entities/user_activity_entity.dart';
import 'package:brain_tracy/features/dashboard/domain/repositories/user_activity_repository.dart';
import 'package:brain_tracy/features/dashboard/infrastructure/user_activity_hive_model.dart';

class UserActivityRepositoryImpl implements UserActivityRepository {
  final Box<UserActivityHiveModel> _box;

  UserActivityRepositoryImpl(this._box);

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<void> markActive(DateTime date) async {
    try {
      final key = _dateKey(date);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final model = UserActivityHiveModel(date: normalizedDate, isActive: true);
      await _box.put(key, model);
    } catch (e) {
      throw Exception('활동 기록에 실패했습니다: $e');
    }
  }

  @override
  Future<int> getCurrentStreak() async {
    try {
      var streak = 0;
      var current = DateTime.now();
      current = DateTime(current.year, current.month, current.day);

      while (true) {
        final key = _dateKey(current);
        final model = _box.get(key);
        if (model == null || !model.isActive) break;
        streak++;
        current = current.subtract(const Duration(days: 1));
      }

      return streak;
    } catch (e) {
      throw Exception('스트릭 계산에 실패했습니다: $e');
    }
  }

  @override
  Future<UserActivityEntity?> getActivity(DateTime date) async {
    try {
      final key = _dateKey(date);
      final model = _box.get(key);
      return model?.toEntity();
    } catch (e) {
      throw Exception('활동 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<List<UserActivityEntity>> getAll() async {
    try {
      return _box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('활동 목록 조회에 실패했습니다: $e');
    }
  }
}
