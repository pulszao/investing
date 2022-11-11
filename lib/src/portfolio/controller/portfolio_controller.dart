import 'package:flutter/material.dart';
import 'package:investing/services/get_quote/get_quote.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:provider/provider.dart';

class PortfolioProvider extends ChangeNotifier {
  double _rentability = 0;
  double _total = 0;
  double _currentAsset = 0;
  double _portfolioDailyChange = 0;

  void setCurrentAsset(double data) {
    _currentAsset = data;
    notifyListeners();
  }

  double getCurrentAsset() {
    return _currentAsset;
  }

  void setTotal(double data) {
    _total = data;
    notifyListeners();
  }

  double getTotal() {
    return _total;
  }

  void setRentability(double currentAsset) {
    _rentability = ((currentAsset - _total) / _total) * 100;
    notifyListeners();
  }

  double getRentability() {
    return _rentability;
  }

  void setPortfolioDailyChange(double data) {
    _portfolioDailyChange = data;
    notifyListeners();
  }

  double getPortfolioDailyChange() {
    return _portfolioDailyChange;
  }
}

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

Future<List<Map?>> getSectors() async {
  List stocks = await getStocks();
  List<String>? auxSectors = [];
  List<Map?> sectors = [];

  for (Map? item in stocks) {
    Map? data = item![item.keys.first];

    if (item.keys.first != 'total' && !auxSectors.contains(data!['sector'])) {
      auxSectors.add(data['sector']);
    }
  }

  for (String sector in auxSectors) {
    List<Map?> stockInSector = [];
    Map totals = {};
    totals['totalizator'] = 0;

    for (Map? item in stocks) {
      Map? data = item![item.keys.first];

      if (data!['sector'] == sector) {
        stockInSector.add(item);
        totals['totalizator'] += data['total'];
      }
    }
    stockInSector.add({'sector_totalizator': totals});
    sectors.add({sector: stockInSector});
  }

  sectors.add({'totalizator': stocks[stocks.length - 1]!['total']});

  return sectors;
}

Future<Map?> getStocksQuote(BuildContext context) async {
  List transactions = await UserSecureStorage.getTransactions();
  List<String>? stocks = [];
  Map? stocksShares = {};
  Map? stocksQuotes = {};
  double currentAsset = 0;
  double weight = 0;
  double totalWeight = 0;
  double dailyChange = 0;

  for (Map? item in transactions) {
    // add stocks to a list
    stocks.add(item![item.keys.first]['stock']);
    stocksShares[item[item.keys.first]['stock']] = {
      'stock': item[item.keys.first]['stock'],
      'shares': item[item.keys.first]['shares'],
    };
  }

  // get stocks quote
  if (stocks.isNotEmpty) {
    Map? quotes = await getMultipleQuote(codes: stocks);

    for (String stock in quotes!.keys) {
      stocksQuotes[quotes[stock]['quote']['symbol']] = {
        'stock': quotes[stock]['quote']['symbol'],
        'company_name': quotes[stock]['quote']['companyName'],
        'now_price': quotes[stock]['quote']['latestPrice'].toDouble(),
        'daly_change': (quotes[stock]['quote']['changePercent'] * 100).toDouble(),
      };
      currentAsset += stocksShares[stock]['shares'] * quotes[stock]['quote']['latestPrice'].toDouble();
    }

    // get daily change
    for (String stock in quotes.keys) {
      totalWeight += (stocksShares[stock]['shares'] * quotes[stock]['quote']['latestPrice'].toDouble()) / currentAsset;
      weight = (stocksShares[stock]['shares'] * quotes[stock]['quote']['latestPrice'].toDouble()) / currentAsset;
      dailyChange += (quotes[stock]['quote']['changePercent'] * 100).toDouble() * weight;
    }
  }

  Provider.of<PortfolioProvider>(context, listen: false).setRentability(currentAsset);
  Provider.of<PortfolioProvider>(context, listen: false).setCurrentAsset(currentAsset);
  Provider.of<PortfolioProvider>(context, listen: false).setPortfolioDailyChange(dailyChange / totalWeight);

  return stocksQuotes;
}
