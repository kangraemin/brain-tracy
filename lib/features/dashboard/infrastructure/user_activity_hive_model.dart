import 'package:hive_flutter/hive_flutter.dart';

import 'package:brain_tracy/features/dashboard/domain/entities/user_activity_entity.dart';

class UserActivityHiveModel extends HiveObject {
  final DateTime date;
  final bool isActive;

  UserActivityHiveModel({
    required this.date,
    this.isActive = true,
  });

  factory UserActivityHiveModel.fromEntity(UserActivityEntity entity) {
    return UserActivityHiveModel(
      date: entity.date,
      isActive: entity.isActive,
    );
  }

  UserActivityEntity toEntity() {
    return UserActivityEntity(
      date: date,
      isActive: isActive,
    );
  }
}

class UserActivityHiveModelAdapter extends TypeAdapter<UserActivityHiveModel> {
  @override
  final int typeId = 3;

  @override
  UserActivityHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserActivityHiveModel(
      date: fields[0] as DateTime,
      isActive: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserActivityHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserActivityHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
