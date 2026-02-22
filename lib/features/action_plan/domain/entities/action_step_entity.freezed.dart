// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_step_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ActionStepEntity {
  String get id => throw _privateConstructorUsedError;
  String get goalId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ActionStepEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionStepEntityCopyWith<ActionStepEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionStepEntityCopyWith<$Res> {
  factory $ActionStepEntityCopyWith(
    ActionStepEntity value,
    $Res Function(ActionStepEntity) then,
  ) = _$ActionStepEntityCopyWithImpl<$Res, ActionStepEntity>;
  @useResult
  $Res call({
    String id,
    String goalId,
    String title,
    bool isCompleted,
    int order,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ActionStepEntityCopyWithImpl<$Res, $Val extends ActionStepEntity>
    implements $ActionStepEntityCopyWith<$Res> {
  _$ActionStepEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionStepEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            goalId: null == goalId
                ? _value.goalId
                : goalId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionStepEntityImplCopyWith<$Res>
    implements $ActionStepEntityCopyWith<$Res> {
  factory _$$ActionStepEntityImplCopyWith(
    _$ActionStepEntityImpl value,
    $Res Function(_$ActionStepEntityImpl) then,
  ) = __$$ActionStepEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String goalId,
    String title,
    bool isCompleted,
    int order,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ActionStepEntityImplCopyWithImpl<$Res>
    extends _$ActionStepEntityCopyWithImpl<$Res, _$ActionStepEntityImpl>
    implements _$$ActionStepEntityImplCopyWith<$Res> {
  __$$ActionStepEntityImplCopyWithImpl(
    _$ActionStepEntityImpl _value,
    $Res Function(_$ActionStepEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionStepEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ActionStepEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        goalId: null == goalId
            ? _value.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ActionStepEntityImpl implements _ActionStepEntity {
  const _$ActionStepEntityImpl({
    required this.id,
    required this.goalId,
    required this.title,
    this.isCompleted = false,
    required this.order,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String goalId;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final int order;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ActionStepEntity(id: $id, goalId: $goalId, title: $title, isCompleted: $isCompleted, order: $order, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionStepEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    goalId,
    title,
    isCompleted,
    order,
    createdAt,
  );

  /// Create a copy of ActionStepEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionStepEntityImplCopyWith<_$ActionStepEntityImpl> get copyWith =>
      __$$ActionStepEntityImplCopyWithImpl<_$ActionStepEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _ActionStepEntity implements ActionStepEntity {
  const factory _ActionStepEntity({
    required final String id,
    required final String goalId,
    required final String title,
    final bool isCompleted,
    required final int order,
    required final DateTime createdAt,
  }) = _$ActionStepEntityImpl;

  @override
  String get id;
  @override
  String get goalId;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  int get order;
  @override
  DateTime get createdAt;

  /// Create a copy of ActionStepEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionStepEntityImplCopyWith<_$ActionStepEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
