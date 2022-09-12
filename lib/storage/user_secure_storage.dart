import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _watchlist = 'watchlist';
  static const _transactions = 'transactions';

  static Future setWatchlist(List<String>? data) async {
    String stocks = '';
    if (data!.isNotEmpty) {
      for (var element in data) {
        if (element != '') {
          stocks += element;
          if (element != data.last) {
            stocks += ',';
          }
        }
      }
    }
    await _storage.write(key: _watchlist, value: data.isNotEmpty ? stocks : null);
  }

  static Future<List<String>?> getWatchlist() async {
    String? stocks = await _storage.read(key: _watchlist);

    return stocks != null ? stocks.split(',') : [];
  }

  static Future addTransaction(Map<String, dynamic>? transaction) async {
    String? currentTransactions = await _storage.read(key: _transactions);
    List data = json.decode(currentTransactions ?? '[]');

    if (transaction != null) {
      data.add(transaction);
    }

    await _storage.write(key: _transactions, value: json.encode(data));
  }

  static Future<List> getTransactions() async {
    String? data = await _storage.read(key: _transactions);

    return json.decode(data ?? '[]');
  }

  static Future setTransactions(List data) async {
    await _storage.write(key: _transactions, value: json.encode(data));
  }
}
