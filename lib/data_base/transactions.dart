import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:flutter_expense_traker/data_base/user.dart';

class Transactions {
  String? transactionId;
  String? userId;
  DateTime? date;
  String? time;
  num? amount;
  int? categoryId;
  String? description;
  String? transactionType;
  String? note;
  Transactions({
    this.transactionId,
    this.userId,
    this.date,
    this.time,
    this.amount,
    this.categoryId,
    this.description,
    this.transactionType,
    this.note,
  });

  static const String tableName = 'Transactions';
  static const String columnTransactionId = 'TransactionId';
  static const String columnUserId = User.columnUserId;
  static const String columnDate = 'Date';
  static const String columnTime = 'Time';
  static const String columnAmount = 'Amount';
  static const String columnCategoryId = Categories.columnCategoryId;
  static const String columnDescription = 'Description';
  static const String columnTransactionType = 'TransactionType';
  static const String columnNote = 'Note';

  static const String createTableSQL = '''
  CREATE TABLE IF NOT EXISTS $tableName (
      $columnTransactionId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUserId TEXT NOT NULL,
      $columnDate DATE NOT NULL,
      $columnTime TEXT ,
      $columnAmount REAL NOT NULL,
      $columnCategoryId INTEGER NOT NULL,
      $columnDescription TEXT,
      $columnTransactionType TEXT NOT NULL CHECK(type IN ('expense', 'income')),
      $columnNote TEXT
      FOREIGN KEY ($columnUserId) REFERENCES ${User.tableName}($columnUserId),
      FOREIGN KEY ($columnCategoryId) REFERENCES ${Categories.tableName}($columnCategoryId)
    )
  ''';

  Transactions copyWith({
    ValueGetter<String?>? transactionId,
    ValueGetter<String?>? userId,
    ValueGetter<DateTime?>? date,
    ValueGetter<String?>? time,
    ValueGetter<num?>? amount,
    ValueGetter<int?>? categoryId,
    ValueGetter<String?>? description,
    ValueGetter<String?>? transactionType,
    ValueGetter<String?>? note,
  }) {
    return Transactions(
      transactionId:
          transactionId != null ? transactionId() : this.transactionId,
      userId: userId != null ? userId() : this.userId,
      date: date != null ? date() : this.date,
      time: time != null ? time() : this.time,
      amount: amount != null ? amount() : this.amount,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      description: description != null ? description() : this.description,
      transactionType:
          transactionType != null ? transactionType() : this.transactionType,
      note: note != null ? note() : this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'date': date?.millisecondsSinceEpoch,
      'time': time,
      'amount': amount,
      'categoryId': categoryId,
      'description': description,
      'transactionType': transactionType,
      'note': note,
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      transactionId: map['transactionId'],
      userId: map['userId'],
      date:
          map['date'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['date'])
              : null,
      time: map['time'],
      amount: map['amount'],
      categoryId: map['categoryId']?.toInt(),
      description: map['description'],
      transactionType: map['transactionType'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transactions(transactionId: $transactionId, userId: $userId, date: $date, time: $time, amount: $amount, categoryId: $categoryId, description: $description, transactionType: $transactionType, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transactions &&
        other.transactionId == transactionId &&
        other.userId == userId &&
        other.date == date &&
        other.time == time &&
        other.amount == amount &&
        other.categoryId == categoryId &&
        other.description == description &&
        other.transactionType == transactionType &&
        other.note == note;
  }

  @override
  int get hashCode {
    return transactionId.hashCode ^
        userId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        amount.hashCode ^
        categoryId.hashCode ^
        description.hashCode ^
        transactionType.hashCode ^
        note.hashCode;
  }
}
