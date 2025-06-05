import 'package:flutter_expense_traker/database/budget.dart';
import 'package:flutter_expense_traker/database/category.dart';
import 'package:flutter_expense_traker/database/transactions.dart';
import 'package:flutter_expense_traker/database/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static const String dbName = 'Expense_DB';
  static const int dbVersion = 1;
  static DbService? _instance;
  DbService._internal();

  factory DbService() {
    return _instance ??= DbService._internal();
  }
  Future<Database> get database async {
    var dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, dbName),
      version: dbVersion,
      onCreate: (db, version) {
        // Create the tables
        db.execute(User.createTableSQL);
        db.execute(Categories.createTableSQL);
        db.execute(Transactions.createTableSQL);
        db.execute(Budget.createTableSQL);
      },
    );
  }
  //insert tables commands

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      User.tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTransaction(Transactions transaction) async {
    final db = await database;
    await db.insert(
      Transactions.tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertCategory(Categories category) async {
    final db = await database;
    await db.insert(
      Categories.tableName,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBudget(Budget budget) async {
    final db = await database;
    await db.insert(
      Budget.tableName,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  ///////////////////////////////////////////////////////////////////
  ///
  ///

  // Fetch all data from tables
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(User.tableName);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<List<Transactions>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Transactions.tableName,
    );
    return List.generate(maps.length, (i) {
      return Transactions.fromMap(maps[i]);
    });
  }

  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Categories.tableName,
    );
    return List.generate(maps.length, (i) {
      return Categories.fromMap(maps[i]);
    });
  }

  Future<List<Budget>> getAllBudget() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Budget.tableName);
    return List.generate(maps.length, (i) {
      return Budget.fromMap(maps[i]);
    });
  }

  // Fetch data by ID
  Future<User?> getUserById(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      User.tableName,
      where: '${User.columnUserId} = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<Transactions?> getTransactionById(String transactionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Transactions.tableName,
      where: '${Transactions.columnTransactionId} = ?',
      whereArgs: [transactionId],
    );
    if (maps.isNotEmpty) {
      return Transactions.fromMap(maps.first);
    }
    return null;
  }

  Future<Categories?> getCategoryById(String categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Categories.tableName,
      where: '${Categories.columnCategoryId} = ?',
      whereArgs: [categoryId],
    );
    if (maps.isNotEmpty) {
      return Categories.fromMap(maps.first);
    }
    return null;
  }

  // Query For getting Transactions by Category or sum up and get total amount spent in a category
  Future<double> getTotalSpentByTransactionType({
    required String userId,
    required String transactionType,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT SUM(${Transactions.columnAmount}) AS TotalExpense
      FROM ${Transactions.tableName}
      WHERE ${User.columnUserId} = ?
        AND ${Transactions.columnTransactionType} = '$transactionType';
      ''',
      [userId],
    );

    if (result.isNotEmpty && result.first['TotalExpense'] != null) {
      return result.first['TotalExpense'] as double;
    } else {
      return 0.0; // Return 0.0 if no expenses found or sum is null
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
