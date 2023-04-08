// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cli_command_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CliCommandAdapter extends TypeAdapter<CliCommand> {
  @override
  final int typeId = 0;

  @override
  CliCommand read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CliCommand()
      ..command = fields[0] as String?
      ..alias = fields[1] as String?
      ..id = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, CliCommand obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.command)
      ..writeByte(1)
      ..write(obj.alias)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CliCommandAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
