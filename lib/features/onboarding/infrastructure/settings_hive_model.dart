import 'package:hive_flutter/hive_flutter.dart';

class SettingsHiveModel extends HiveObject {
  final bool hasCompletedOnboarding;

  SettingsHiveModel({
    this.hasCompletedOnboarding = false,
  });
}

class SettingsHiveModelAdapter extends TypeAdapter<SettingsHiveModel> {
  @override
  final int typeId = 2;

  @override
  SettingsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsHiveModel(
      hasCompletedOnboarding: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.hasCompletedOnboarding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
