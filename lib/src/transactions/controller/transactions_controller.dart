import 'package:flutter/material.dart';
import 'package:investing/src/shared/model/stocks_sector_model.dart';
import 'package:investing/src/shared/view/cards/transaction_card.dart';

enum Operation {
  buy,
  sell,
}

class TransactionProvider extends ChangeNotifier {
  Operation _operation = Operation.buy;
  DateTime? _buyDate;
  DateTime? _filterDate;
  String? _stock;
  StockSector? _sector;
  double _quantity = 0;
  double _price = 0;
  double _fees = 0;
  List<TransactionCard> _transactions = [];

  void addTransactionsWidgets(TransactionCard transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void setTransactionsWidgets(List<TransactionCard> transaction) {
    _transactions = transaction;
    notifyListeners();
  }

  List<TransactionCard> getTransactionsWidgets() {
    return _transactions;
  }

  void setSector(StockSector? sector) {
    _sector = sector;
    notifyListeners();
  }

  StockSector? getSector() {
    return _sector;
  }

  void setFees(double price) {
    _fees = price;
    notifyListeners();
  }

  double getFees() {
    return _fees;
  }

  void setPrice(double price) {
    _price = price;
    notifyListeners();
  }

  double getPrice() {
    return _price;
  }

  void setQuantity(double quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  double getQuantity() {
    return _quantity;
  }

  void setStock(String? date) {
    _stock = date;
    notifyListeners();
  }

  String? getStock() {
    return _stock;
  }

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
