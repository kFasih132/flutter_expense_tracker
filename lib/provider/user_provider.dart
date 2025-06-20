import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/user.dart';
import 'package:flutter_expense_traker/layouts/profile.dart';

class UserProvider with ChangeNotifier {
  User _currentUser = User(userId: userId, isLoggedIn: 1, name: 'Fasih', email: 'kfasih132@gmail.com');

  User get currentUser => _currentUser;
  

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
