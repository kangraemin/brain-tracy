import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_entity.freezed.dart';

@freezed
class GoalEntity with _$GoalEntity {
  const factory GoalEntity({
    required String id,
    required String title,
    required DateTime createdAt,
    @Default(false) bool isSelected,
  }) = _GoalEntity;
}
