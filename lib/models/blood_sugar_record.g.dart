// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_sugar_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BloodSugarRecordAdapter extends TypeAdapter<BloodSugarRecord> {
  @override
  final int typeId = 1;

  @override
  BloodSugarRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BloodSugarRecord()
      ..timestamp = fields[0] as DateTime
      ..entryTime = fields[1] as DateTime
      ..value = fields[2] as double
      ..unit = fields[3] as String
      ..type = fields[4] as String
      ..note = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, BloodSugarRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.entryTime)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodSugarRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
