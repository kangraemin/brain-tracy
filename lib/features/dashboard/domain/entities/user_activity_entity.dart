import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity_entity.freezed.dart';

@freezed
class UserActivityEntity with _$UserActivityEntity {
  const factory UserActivityEntity({
    required DateTime date,
    @Default(true) bool isActive,
  }) = _UserActivityEntity;
}
