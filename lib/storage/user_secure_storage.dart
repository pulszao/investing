import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _watchlist = 'watchlist';

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
}
