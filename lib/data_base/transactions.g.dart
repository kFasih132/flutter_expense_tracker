// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionsAdapter extends TypeAdapter<Transactions> {
  @override
  final int typeId = 2;

  @override
  Transactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactions(
      transactionId: fields[0] as String?,
      userId: fields[1] as String?,
      date: fields[2] as DateTime?,
      time: fields[3] as String?,
      amount: fields[4] as num?,
      categoryId: fields[5] as String?,
      description: fields[6] as String?,
      transactionType: fields[7] as String?,
      note: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transactions obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.transactionId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.transactionType)
      ..writeByte(8)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
