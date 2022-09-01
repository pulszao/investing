import 'package:flutter/material.dart';

enum Operation {
  buy,
  sell,
}

class TransactionProvider extends ChangeNotifier {
  Operation _operation = Operation.buy;
  DateTime? _buyDate;
  DateTime? _filterDate;

  void setFilterDate(DateTime? date) {
    _filterDate = date;
    notifyListeners();
  }

  DateTime? getFilterDate() {
    return _filterDate;
  }

  void setBuyDate(DateTime? date) {
    _buyDate = date;
    notifyListeners();
  }

  DateTime? getBuyDate() {
    return _buyDate;
  }

  void setOperation(Operation operation) {
    _operation = operation;
    notifyListeners();
  }

  Operation getOperation() {
    return _operation;
  }
}
