// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CloudNoteModelAdapter extends TypeAdapter<CloudNoteModel> {
  @override
  final int typeId = 1;

  @override
  CloudNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudNoteModel(
      id: fields[1] as int?,
      uuid: fields[2] as String?,
      title: fields[3] as String?,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CloudNoteModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
