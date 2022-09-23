import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/storage/user_secure_storage.dart';

Future<List<Map?>> getStocks() async {
  List transactions = await UserSecureStorage.getTransactions();
  Map totals = {};
  List<String>? auxStocks = [];
  List<Map?> stocks = [];
  totals['total'] = 0;

  for (Map? item in transactions) {
    Map? data = item![item.keys.first];

    if (!auxStocks.contains(data!['stock'])) {
      auxStocks.add(data['stock']);
    }
  }

  for (String stock in auxStocks) {
    Map stockInfo = {};
    for (Map? item in transactions) {
      Map? data = item![item.keys.first];
      if (data!['operation'] == Operation.buy.name) {
        if (data['stock'] == stock) {
          totals['total'] += (data['shares'] * data['buy_price'] + data['fees']);
          if (stockInfo.isEmpty) {
            stockInfo['company_name'] = data['company_name'];
            stockInfo['buy_price'] = (data['fees'] / data['shares'] + data['buy_price']);
            stockInfo['shares'] = data['shares'];
            stockInfo['sector'] = data['sector'];
            stockInfo['total'] = (data['shares'] * data['buy_price'] + data['fees']);
          } else {
            stockInfo['buy_price'] =
                ((stockInfo['buy_price'] * stockInfo['shares']) + ((data['fees'] / data['shares'] + data['buy_price']) * data['shares'])) /
                    (stockInfo['shares'] + data['shares']);
            stockInfo['shares'] += data['shares'];
            stockInfo['total'] += (data['shares'] * data['buy_price'] + data['fees']);
          }
        }
      } else {
        if (data['stock'] == stock) {
          totals['total'] -= (data['shares'] * data['buy_price'] + data['fees']);
          if (stockInfo.isEmpty) {
            stockInfo['company_name'] = data['company_name'];
            stockInfo['buy_price'] = (data['fees'] / data['shares'] + data['buy_price']);
            stockInfo['shares'] = data['shares'];
            stockInfo['sector'] = data['sector'];
            stockInfo['total'] = (data['shares'] * data['buy_price'] + data['fees']);
          } else {
            stockInfo['buy_price'] =
                ((stockInfo['buy_price'] * stockInfo['shares']) - ((data['fees'] / data['shares'] + data['buy_price']) * data['shares'])) /
                    (stockInfo['shares'] + data['shares']);
            stockInfo['shares'] -= data['shares'];
            stockInfo['total'] -= (data['shares'] * data['buy_price'] + data['fees']);
          }
        }
      }
    }
    stocks.add({stock: stockInfo});
  }
  stocks.add({'total': totals});

  return stocks;
}
