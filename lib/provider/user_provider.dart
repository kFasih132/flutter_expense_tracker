import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/user.dart';

class UserProvider with ChangeNotifier {
  User _currentUser = User();
  

  User get currentUser => _currentUser;
//TODO : also add to database

  void setUser(String username , String email) {
    _currentUser = User(name: username , email: email);
    notifyListeners(); // Notify widgets listening to this provider
  }

  void clearUser() {
    _currentUser = User();
    notifyListeners(); // Notify widgets that the user has logged out
  }

  bool get isLoggedIn => _currentUser.name != null;
}