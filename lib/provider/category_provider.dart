import 'package:flutter/foundation.dart';
import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:hive/hive.dart';

class CategoryProvider extends ChangeNotifier {
  late Box<Categories> _categoryBox;

  List<Categories> _categories = [];

  List<Categories> get categories => _categories;

  Future<void> loadCategories() async {
    _categoryBox = Hive.box<Categories>('categoriesBox');
    _categories = _categoryBox.values.toList();
    notifyListeners();
  }

  Future<void> addCategory(Categories category) async {
    await _categoryBox.put(category.categoryId, category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> removeCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
    _categories.removeWhere((cat) => cat.categoryId == categoryId);
    notifyListeners();
  }

  Categories? getCategoryById(String id) {
    return _categories.firstWhere((cat) => cat.categoryId == id, orElse: () => Categories());
  }

  void clearCategories() async {
    await _categoryBox.clear();
    _categories.clear();
    notifyListeners();
  }
}
