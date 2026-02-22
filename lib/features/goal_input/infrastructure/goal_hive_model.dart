import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/goal_input/domain/entities/goal_entity.dart';

class GoalHiveModel extends HiveObject {
  final String id;
  final String title;
  final DateTime createdAt;
  final bool isSelected;

  GoalHiveModel({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isSelected = false,
  });

  factory GoalHiveModel.fromEntity(GoalEntity entity) {
    return GoalHiveModel(
      id: entity.id,
      title: entity.title,
      createdAt: entity.createdAt,
      isSelected: entity.isSelected,
    );
  }

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      title: title,
      createdAt: createdAt,
      isSelected: isSelected,
    );
  }
}

class GoalHiveModelAdapter extends TypeAdapter<GoalHiveModel> {
  @override
  final int typeId = 0;

  @override
  GoalHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      createdAt: fields[2] as DateTime,
      isSelected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GoalHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
