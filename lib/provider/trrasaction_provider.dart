import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
import 'package:flutter_expense_traker/layouts/profile.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transactions> _transactions = [];

  List<Transactions> get transactions => _transactions;

  Future<void> loadTransactionsForCurrentMonth() async {
    _transactions = await DbService().getTransactionsForMonth(
      userId,
      DateTime.now().year,
      DateTime.now().month,
    );
    notifyListeners();
  }

  void addTransaction(Transactions transaction) async {
    await DbService().insertTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((tx) => tx.transactionId == id);
    notifyListeners();
  }
}

