import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/user.dart';

class UserProvider with ChangeNotifier {
  User _currentUser = User();

  User get currentUser => _currentUser;
  //TODO : also add to database

  void setUser(String username, String email) {
    _currentUser = User(
      name: username,
      email: email,
      isLoggedIn: 1,
      userId: 'Fasih/#12',
      createdAt: DateTime.now().toString(),
    );
    DbService().insertUser(_currentUser);
    notifyListeners(); // Notify widgets listening to this provider
  }

  void clearUser() {
    _currentUser.isLoggedIn = 0;
    DbService().insertUser(_currentUser);
    notifyListeners(); // Notify widgets that the user has logged out
  }

  bool get isLoggedIn => _currentUser.isLoggedIn == 1;
}
