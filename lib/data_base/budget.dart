import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:flutter_expense_traker/data_base/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'budget.g.dart';


@HiveType(typeId: 0)
class Budget {
  @HiveField(0)
  int? budgetId;
  @HiveField(1) 
  String? userId;
  @HiveField(2)
  int? categoryId;
  @HiveField(3)
  num? budgetAmount;
  @HiveField(4)
  DateTime? startDate;
  @HiveField(5)
  DateTime? endDate;
  @HiveField(6)
  bool? isActive;
  Budget({
    this.budgetId,
    this.userId,
    this.categoryId,
    this.budgetAmount,
    this.startDate,
    this.endDate,
    this.isActive,
  });
 

  static const String tableName = 'budget';
  static const String columnBudgetId = 'budgetId';
  static const String columnUserId = User.columnUserId;
  static const String columnCategoryId = Categories.columnCategoryId;
  static const String columnBudgetAmount = 'budgetAmount';

  static const String columnStartDate = 'startDate';
  static const String columnEndDate = 'endDate';
  static const String columnIsActive = 'isActive';

  static const String createTableSQL = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnBudgetId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUserId TEXT NOT NULL,
      $columnCategoryId INTEGER NOT NULL,
      $columnBudgetAmount REAL NOT NULL,
      $columnStartDate DATE NOT NULL,
      $columnEndDate DATE NOT NULL,
      $columnIsActive BOOLEAN DEFAULT 1,
      FOREIGN KEY ($columnUserId) REFERENCES ${User.tableName}(${User.columnUserId}),
      FOREIGN KEY ($columnCategoryId) REFERENCES ${Categories.tableName}(${Categories.columnCategoryId})
    )
  ''';

  

  Budget copyWith({
    ValueGetter<int?>? budgetId,
    ValueGetter<String?>? userId,
    ValueGetter<int?>? categoryId,
    ValueGetter<num?>? budgetAmount,
    ValueGetter<DateTime?>? startDate,
    ValueGetter<DateTime?>? endDate,
    ValueGetter<bool?>? isActive,
  }) {
    return Budget(
      budgetId: budgetId != null ? budgetId() : this.budgetId,
      userId: userId != null ? userId() : this.userId,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      budgetAmount: budgetAmount != null ? budgetAmount() : this.budgetAmount,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      isActive: isActive != null ? isActive() : this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'categoryId': categoryId,
      'budgetAmount': budgetAmount,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      budgetId: map['budgetId']?.toInt(),
      userId: map['userId'],
      categoryId: map['categoryId']?.toInt(),
      budgetAmount: map['budgetAmount'],
      startDate: map['startDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endDate']) : null,
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Budget(budgetId: $budgetId, userId: $userId, categoryId: $categoryId, budgetAmount: $budgetAmount, startDate: $startDate, endDate: $endDate, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Budget &&
      other.budgetId == budgetId &&
      other.userId == userId &&
      other.categoryId == categoryId &&
      other.budgetAmount == budgetAmount &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.isActive == isActive;
  }

  @override
  int get hashCode {
    return budgetId.hashCode ^
      userId.hashCode ^
      categoryId.hashCode ^
      budgetAmount.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isActive.hashCode;
  }
}
