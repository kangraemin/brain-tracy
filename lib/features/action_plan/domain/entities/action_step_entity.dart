import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_step_entity.freezed.dart';

@freezed
class ActionStepEntity with _$ActionStepEntity {
  const factory ActionStepEntity({
    required String id,
    required String goalId,
    required String title,
    @Default(false) bool isCompleted,
    required int order,
    required DateTime createdAt,
  }) = _ActionStepEntity;
}
