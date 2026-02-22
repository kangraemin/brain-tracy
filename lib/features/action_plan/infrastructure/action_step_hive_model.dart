import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/action_plan/domain/entities/action_step_entity.dart';

class ActionStepHiveModel extends HiveObject {
  final String id;
  final String goalId;
  final String title;
  final bool isCompleted;
  final int order;
  final DateTime createdAt;

  ActionStepHiveModel({
    required this.id,
    required this.goalId,
    required this.title,
    this.isCompleted = false,
    required this.order,
    required this.createdAt,
  });

  factory ActionStepHiveModel.fromEntity(ActionStepEntity entity) {
    return ActionStepHiveModel(
      id: entity.id,
      goalId: entity.goalId,
      title: entity.title,
      isCompleted: entity.isCompleted,
      order: entity.order,
      createdAt: entity.createdAt,
    );
  }

  ActionStepEntity toEntity() {
    return ActionStepEntity(
      id: id,
      goalId: goalId,
      title: title,
      isCompleted: isCompleted,
      order: order,
      createdAt: createdAt,
    );
  }
}

class ActionStepHiveModelAdapter extends TypeAdapter<ActionStepHiveModel> {
  @override
  final int typeId = 1;

  @override
  ActionStepHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionStepHiveModel(
      id: fields[0] as String,
      goalId: fields[1] as String,
      title: fields[2] as String,
      isCompleted: fields[3] as bool,
      order: fields[4] as int,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActionStepHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionStepHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
