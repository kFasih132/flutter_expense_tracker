import 'dart:convert';

import 'package:flutter/widgets.dart';

class Categories {
  String? categoryId;
  String? name;
  String? categoryType;
  String? icon;
  Categories({this.categoryId, this.name, this.categoryType, this.icon});

  static const String tableName = 'Categories';
  static const String columnCategoryId = 'CategoryId';
  static const String columnName = 'Name';
  static const String columnCategoryType = 'CategoryType';
  static const String columnIcon = 'Icon';

  static const String createTableSQL = '''
  CREATE TABLE IF NOT EXISTS $tableName (
      $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL UNIQUE,
      $columnCategoryType TEXT NOT NULL CHECK(type IN ('expense', 'income')),
      $columnIcon TEXT
    )
  ''';

  Categories copyWith({
    ValueGetter<String?>? categoryId,
    ValueGetter<String?>? name,
    ValueGetter<String?>? categoryType,
    ValueGetter<String?>? icon,
  }) {
    return Categories(
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      name: name != null ? name() : this.name,
      categoryType: categoryType != null ? categoryType() : this.categoryType,
      icon: icon != null ? icon() : this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'categoryType': categoryType,
      'icon': icon,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      categoryId: map['categoryId'],
      name: map['name'],
      categoryType: map['categoryType'],
      icon: map['icon'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) =>
      Categories.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Categories(categoryId: $categoryId, name: $name, categoryType: $categoryType, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Categories &&
        other.categoryId == categoryId &&
        other.name == name &&
        other.categoryType == categoryType &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
        name.hashCode ^
        categoryType.hashCode ^
        icon.hashCode;
  }
}
