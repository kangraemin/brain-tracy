// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DashboardState {
  GoalEntity? get selectedGoal => throw _privateConstructorUsedError;
  List<ActionStepEntity> get actionSteps => throw _privateConstructorUsedError;
  double get progressPercent => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
    DashboardState value,
    $Res Function(DashboardState) then,
  ) = _$DashboardStateCopyWithImpl<$Res, DashboardState>;
  @useResult
  $Res call({
    GoalEntity? selectedGoal,
    List<ActionStepEntity> actionSteps,
    double progressPercent,
    int streakDays,
  });

  $GoalEntityCopyWith<$Res>? get selectedGoal;
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res, $Val extends DashboardState>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedGoal = freezed,
    Object? actionSteps = null,
    Object? progressPercent = null,
    Object? streakDays = null,
  }) {
    return _then(
      _value.copyWith(
            selectedGoal: freezed == selectedGoal
                ? _value.selectedGoal
                : selectedGoal // ignore: cast_nullable_to_non_nullable
                      as GoalEntity?,
            actionSteps: null == actionSteps
                ? _value.actionSteps
                : actionSteps // ignore: cast_nullable_to_non_nullable
                      as List<ActionStepEntity>,
            progressPercent: null == progressPercent
                ? _value.progressPercent
                : progressPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            streakDays: null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalEntityCopyWith<$Res>? get selectedGoal {
    if (_value.selectedGoal == null) {
      return null;
    }

    return $GoalEntityCopyWith<$Res>(_value.selectedGoal!, (value) {
      return _then(_value.copyWith(selectedGoal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardStateImplCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$$DashboardStateImplCopyWith(
    _$DashboardStateImpl value,
    $Res Function(_$DashboardStateImpl) then,
  ) = __$$DashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GoalEntity? selectedGoal,
    List<ActionStepEntity> actionSteps,
    double progressPercent,
    int streakDays,
  });

  @override
  $GoalEntityCopyWith<$Res>? get selectedGoal;
}

/// @nodoc
class __$$DashboardStateImplCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res, _$DashboardStateImpl>
    implements _$$DashboardStateImplCopyWith<$Res> {
  __$$DashboardStateImplCopyWithImpl(
    _$DashboardStateImpl _value,
    $Res Function(_$DashboardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedGoal = freezed,
    Object? actionSteps = null,
    Object? progressPercent = null,
    Object? streakDays = null,
  }) {
    return _then(
      _$DashboardStateImpl(
        selectedGoal: freezed == selectedGoal
            ? _value.selectedGoal
            : selectedGoal // ignore: cast_nullable_to_non_nullable
                  as GoalEntity?,
        actionSteps: null == actionSteps
            ? _value._actionSteps
            : actionSteps // ignore: cast_nullable_to_non_nullable
                  as List<ActionStepEntity>,
        progressPercent: null == progressPercent
            ? _value.progressPercent
            : progressPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        streakDays: null == streakDays
            ? _value.streakDays
            : streakDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DashboardStateImpl implements _DashboardState {
  const _$DashboardStateImpl({
    this.selectedGoal,
    final List<ActionStepEntity> actionSteps = const [],
    this.progressPercent = 0,
    this.streakDays = 0,
  }) : _actionSteps = actionSteps;

  @override
  final GoalEntity? selectedGoal;
  final List<ActionStepEntity> _actionSteps;
  @override
  @JsonKey()
  List<ActionStepEntity> get actionSteps {
    if (_actionSteps is EqualUnmodifiableListView) return _actionSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionSteps);
  }

  @override
  @JsonKey()
  final double progressPercent;
  @override
  @JsonKey()
  final int streakDays;

  @override
  String toString() {
    return 'DashboardState(selectedGoal: $selectedGoal, actionSteps: $actionSteps, progressPercent: $progressPercent, streakDays: $streakDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStateImpl &&
            (identical(other.selectedGoal, selectedGoal) ||
                other.selectedGoal == selectedGoal) &&
            const DeepCollectionEquality().equals(
              other._actionSteps,
              _actionSteps,
            ) &&
            (identical(other.progressPercent, progressPercent) ||
                other.progressPercent == progressPercent) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedGoal,
    const DeepCollectionEquality().hash(_actionSteps),
    progressPercent,
    streakDays,
  );

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      __$$DashboardStateImplCopyWithImpl<_$DashboardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DashboardState implements DashboardState {
  const factory _DashboardState({
    final GoalEntity? selectedGoal,
    final List<ActionStepEntity> actionSteps,
    final double progressPercent,
    final int streakDays,
  }) = _$DashboardStateImpl;

  @override
  GoalEntity? get selectedGoal;
  @override
  List<ActionStepEntity> get actionSteps;
  @override
  double get progressPercent;
  @override
  int get streakDays;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStateImplCopyWith<_$DashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
