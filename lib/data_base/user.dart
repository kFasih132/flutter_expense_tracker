import 'dart:convert';

import 'package:flutter/widgets.dart';

class User {
  String? userId;
  String? email;
  String? name;
  String? currency;
  String? createdAt;
  User({
    this.userId,
    this.email,
    this.name,
    this.currency,
    this.createdAt,
  });
  static const String tableName = 'User';
  static const String columnUserId = 'UserId';
  static const String columnEmail = 'Email';
  static const String columnName = 'Name';
  static const String columnCurrency = 'Currency';
  static const String columnCreatedAt = 'CreatedAt';
  static const String createTableSQL = '''
  CREATE TABLE IF NOT EXISTS $tableName (
      $columnUserId TEXT PRIMARY KEY,
      $columnEmail TEXT NOT NULL UNIQUE,
      $columnName TEXT,
      $columnCurrency TEXT DEFAULT 'USD',
      $columnCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';
  

  User copyWith({
    ValueGetter<String?>? userId,
    ValueGetter<String?>? email,
    ValueGetter<String?>? name,
    ValueGetter<String?>? currency,
    ValueGetter<String?>? createdAt,
  }) {
    return User(
      userId: userId != null ? userId() : this.userId,
      email: email != null ? email() : this.email,
      name: name != null ? name() : this.name,
      currency: currency != null ? currency() : this.currency,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'currency': currency,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      currency: map['currency'],
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, name: $name, currency: $currency, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.userId == userId &&
      other.email == email &&
      other.name == name &&
      other.currency == currency &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      email.hashCode ^
      name.hashCode ^
      currency.hashCode ^
      createdAt.hashCode;
  }
}
