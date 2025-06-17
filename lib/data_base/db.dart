import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter_expense_traker/data_base/budget.dart';
import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
import 'package:flutter_expense_traker/data_base/user.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter

class DbService {
  // Use unique names for your Hive boxes, typically related to the model type
  static const String userBoxName = 'userBox';
  static const String categoriesBoxName = 'categoriesBox';
  static const String transactionsBoxName = 'transactionsBox';
  static const String budgetBoxName = 'budgetBox';

  static DbService? _instance;

  // Private constructors for each Box
  late Box<User> _userBox;
  late Box<Categories> _categoriesBox;
  late Box<Transactions> _transactionsBox;
  late Box<Budget> _budgetBox;

  DbService._internal();

  factory DbService() {
    return _instance ??= DbService._internal();
  }

  // --- Initialization ---
  Future<void> initHive() async {
    // Initialize Hive (should be called once, e.g., in main() before runApp)
    await Hive.initFlutter();

    // Register TypeAdapters for your custom classes
    // These need to be generated for your User, Categories, etc., classes.
    // Ensure you have generated these adapters (explained below).
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CategoriesAdapter());
    Hive.registerAdapter(TransactionsAdapter());
    Hive.registerAdapter(BudgetAdapter());

    // Open your boxes. Each box is like a table in SQL.
    _userBox = await Hive.openBox<User>(userBoxName);
    _categoriesBox = await Hive.openBox<Categories>(categoriesBoxName);
    _transactionsBox = await Hive.openBox<Transactions>(transactionsBoxName);
    _budgetBox = await Hive.openBox<Budget>(budgetBoxName);

    // Insert default categories if the categories box is empty
    if (_categoriesBox.isEmpty) {
      await _insertDefaultCategories();
    }
  }

  // --- Insert Operations (PUT with ID as key) ---
  // Hive's put method will insert if the key doesn't exist,
  // or update if the key already exists (similar to SQL's REPLACE).

  Future<void> insertUser(User user) async {
    await _userBox.put(user.userId, user); // Assuming userId is the unique key
  }

  Future<void> insertTransaction(Transactions transaction) async {
    // Assuming transactionId is the unique key. If you want auto-incrementing, use box.add(transaction)
    // and let Hive assign a key, but then you'll need to fetch the key.
    // For consistency with ID-based lookups, using transactionId as key is recommended.
    await _transactionsBox.put(transaction.transactionId, transaction);
  }

  Future<void> insertCategory(Categories category) async {
    await _categoriesBox.put(category.categoryId, category); // Assuming categoryId is the unique key
  }

  Future<void> insertBudget(Budget budget) async {
    await _budgetBox.put(budget.budgetId, budget); // Assuming budgetId is the unique key
  }

  // --- Fetch All Data ---
  Future<List<User>> getAllUsers() async {
    return _userBox.values.toList();
  }

  Future<List<Transactions>> getAllTransactions() async {
    return _transactionsBox.values.toList();
  }

  Future<List<Categories>> getAllCategories() async {
    return _categoriesBox.values.toList();
  }

  Future<List<Budget>> getAllBudget() async {
    return _budgetBox.values.toList();
  }

  // --- Fetch Data by ID ---
  // Hive's get method directly retrieves an object by its key.
  Future<User?> getUserById(String userId) async {
    return _userBox.get(userId);
  }

  Future<Transactions?> getTransactionById(String transactionId) async {
    return _transactionsBox.get(transactionId);
  }

  Future<Categories?> getCategoryById(String categoryId) async {
    return _categoriesBox.get(categoryId);
  }

  // --- Query For getting Transactions by Category or sum up and get total amount spent ---
  // Hive doesn't have SQL-like queries. You iterate and filter in Dart.
  Future<double> getTotalSpentByTransactionType({
    required String userId,
    required String transactionType,
  }) async {
    double totalExpense = 0.0;
    for (var transaction in _transactionsBox.values) {
      if (transaction.userId == userId &&
          transaction.transactionType == transactionType) {
        totalExpense += transaction.amount ?? 0.0;
      }
    }
    return totalExpense;
  }

  // --- Default Categories Insertion (Internal) ---
  Future<void> _insertDefaultCategories() async {
    // These default categories should also have unique IDs assigned
    // For example, using a UUID generator or fixed string IDs.
    // For simplicity, I'm generating a simple ID here, but ideally
    // you'd have a mechanism to generate unique IDs consistently.

    // Example: Using a simple counter for default category IDs,
    // or better, generate actual UUIDs.
    // If your Categories model has a constructor that generates IDs, use that.

    // Expense Categories
    final categories = [
      Categories(
        categoryId: 'cat_food', // Assign a unique ID
        name: 'Food',
        categoryType: 'expense',
        icon: 'icon_food',
      ),
      Categories(
        categoryId: 'cat_transport',
        name: 'Transport',
        categoryType: 'expense',
        icon: 'icon_transport',
      ),
      Categories(
        categoryId: 'cat_utilities',
        name: 'Utilities',
        categoryType: 'expense',
        icon: 'icon_utilities',
      ),
      Categories(
        categoryId: 'cat_entertainment',
        name: 'Entertainment',
        categoryType: 'expense',
        icon: 'icon_entertainment',
      ),
      Categories(
        categoryId: 'cat_other',
        name: 'Other',
        categoryType: 'expense',
        icon: 'icon_shopping',
      ),
      // Add other income/transfer categories if needed
    ];

    for (var category in categories) {
      await _categoriesBox.put(category.categoryId, category);
    }
    if (kDebugMode) {
      debugPrint('Default categories inserted into Hive.');
    }
  }

  // --- Close (Optional) ---
  // Hive typically doesn't require explicit closing for standard app lifecycle,
  // but you can close specific boxes or all of Hive if needed (e.g., before app exit).
  Future<void> close() async {
    await _userBox.close();
    await _categoriesBox.close();
    await _transactionsBox.close();
    await _budgetBox.close();
    await Hive.close(); // Closes all open boxes
  }

  // --- Clear All Data (For testing/resetting) ---
  Future<void> clearAllData() async {
    await _userBox.clear();
    await _categoriesBox.clear();
    await _transactionsBox.clear();
    await _budgetBox.clear();
    if (kDebugMode) {
      debugPrint('All Hive boxes cleared.');
    }
    // Re-insert default categories after clearing if desired
    await _insertDefaultCategories();
  }
}
