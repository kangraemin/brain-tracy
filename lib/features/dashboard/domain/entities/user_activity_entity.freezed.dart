// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserActivityEntity {
  DateTime get date => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of UserActivityEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserActivityEntityCopyWith<UserActivityEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActivityEntityCopyWith<$Res> {
  factory $UserActivityEntityCopyWith(
    UserActivityEntity value,
    $Res Function(UserActivityEntity) then,
  ) = _$UserActivityEntityCopyWithImpl<$Res, UserActivityEntity>;
  @useResult
  $Res call({DateTime date, bool isActive});
}

/// @nodoc
class _$UserActivityEntityCopyWithImpl<$Res, $Val extends UserActivityEntity>
    implements $UserActivityEntityCopyWith<$Res> {
  _$UserActivityEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserActivityEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? isActive = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserActivityEntityImplCopyWith<$Res>
    implements $UserActivityEntityCopyWith<$Res> {
  factory _$$UserActivityEntityImplCopyWith(
    _$UserActivityEntityImpl value,
    $Res Function(_$UserActivityEntityImpl) then,
  ) = __$$UserActivityEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, bool isActive});
}

/// @nodoc
class __$$UserActivityEntityImplCopyWithImpl<$Res>
    extends _$UserActivityEntityCopyWithImpl<$Res, _$UserActivityEntityImpl>
    implements _$$UserActivityEntityImplCopyWith<$Res> {
  __$$UserActivityEntityImplCopyWithImpl(
    _$UserActivityEntityImpl _value,
    $Res Function(_$UserActivityEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserActivityEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? isActive = null}) {
    return _then(
      _$UserActivityEntityImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UserActivityEntityImpl implements _UserActivityEntity {
  const _$UserActivityEntityImpl({required this.date, this.isActive = true});

  @override
  final DateTime date;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'UserActivityEntity(date: $date, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActivityEntityImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, isActive);

  /// Create a copy of UserActivityEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserActivityEntityImplCopyWith<_$UserActivityEntityImpl> get copyWith =>
      __$$UserActivityEntityImplCopyWithImpl<_$UserActivityEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _UserActivityEntity implements UserActivityEntity {
  const factory _UserActivityEntity({
    required final DateTime date,
    final bool isActive,
  }) = _$UserActivityEntityImpl;

  @override
  DateTime get date;
  @override
  bool get isActive;

  /// Create a copy of UserActivityEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserActivityEntityImplCopyWith<_$UserActivityEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
