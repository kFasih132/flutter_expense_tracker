import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User {
  @HiveField(0)
  String? userId;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? currency;
  @HiveField(4)
  String? createdAt;
  @HiveField(5)
  int? isLoggedIn;
  User({
    this.userId,
    this.email,
    this.name,
    this.currency,
    this.createdAt,
    this.isLoggedIn,
  });
  static const String tableName = 'User';
  static const String columnUserId = 'UserId';
  static const String columnEmail = 'Email';
  static const String columnName = 'Name';
  static const String columnCurrency = 'Currency';
  static const String columnCreatedAt = 'CreatedAt';
  static const String columnIsLoggedIn = 'IsLoggedIn';
  static const String createTableSQL = '''
  CREATE TABLE IF NOT EXISTS $tableName (
      $columnUserId TEXT PRIMARY KEY,
      $columnEmail TEXT NOT NULL UNIQUE,
      $columnName TEXT,
      $columnCurrency TEXT DEFAULT 'USD',
      $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
      $columnIsLoggedIn INTEGER DEFAULT 0
    )
  ''';

  User copyWith({
    ValueGetter<String?>? userId,
    ValueGetter<String?>? email,
    ValueGetter<String?>? name,
    ValueGetter<String?>? currency,
    ValueGetter<String?>? createdAt,
    ValueGetter<int?>? isLoggedIn,
  }) {
    return User(
      userId: userId != null ? userId() : this.userId,
      email: email != null ? email() : this.email,
      name: name != null ? name() : this.name,
      currency: currency != null ? currency() : this.currency,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
      isLoggedIn: isLoggedIn != null ? isLoggedIn() : this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'currency': currency,
      'createdAt': createdAt,
      'isLoggedIn': isLoggedIn ?? 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      currency: map['currency'],
      createdAt: map['createdAt'],
      isLoggedIn: map['isLoggedIn'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, name: $name, currency: $currency, createdAt: $createdAt, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userId == userId &&
        other.email == email &&
        other.name == name &&
        other.currency == currency &&
        other.createdAt == createdAt &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        name.hashCode ^
        currency.hashCode ^
        createdAt.hashCode ^
        isLoggedIn.hashCode;
  }
}
