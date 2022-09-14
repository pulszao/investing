import 'package:flutter/material.dart';

class WatchlistProvider extends ChangeNotifier {
  String _stock = '';

  void setNewStock(String stock) {
    _stock = stock.toUpperCase();
    notifyListeners();
  }

  String getNewStock() {
    return _stock;
  }
}
