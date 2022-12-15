import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investing/services/get_quote/get_quote.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/rentability/view/top_pick_stock_card.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:provider/provider.dart';

class PortfolioProvider extends ChangeNotifier {
  double _rentability = 0;
  double _total = 0;
  double _currentAsset = 0;
  double _portfolioDailyChange = 0;
  List<TopPickStockCard> _topStocksGainers = [];
  List<TopPickStockCard> _topStocksLosers = [];

  void setTopStocksLosers(List<TopPickStockCard> data) {
    _topStocksLosers = data;
    notifyListeners();
  }

  List<TopPickStockCard> getTopStocksLosers() {
    return _topStocksLosers;
  }

  void setTopStocksGainers(List<TopPickStockCard> data) {
    _topStocksGainers = data;
    notifyListeners();
  }

  List<TopPickStockCard> getTopStocksGainers() {
    return _topStocksGainers;
  }

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
  User? authUser = FirebaseAuth.instance.currentUser;
  QuerySnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore.instance.collection('transactions/${authUser!.uid}/stocks').orderBy('buy_date', descending: true).get();
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
    double changePercent = 0;

    for (String stock in quotes!.keys) {
      changePercent = quotes[stock]['quote']['changePercent'] ??
          (quotes[stock]['quote']['latestPrice'] - quotes[stock]['quote']['previousClose']) / (quotes[stock]['quote']['previousClose']);

      stocksQuotes[quotes[stock]['quote']['symbol']] = {
        'stock': quotes[stock]['quote']['symbol'],
        'company_name': quotes[stock]['quote']['companyName'],
        'now_price': quotes[stock]['quote']['latestPrice'].toDouble(),
        'daily_change': changePercent.toDouble() * 100,
      };
      currentAsset += stocksShares[stock]['shares'] * quotes[stock]['quote']['latestPrice'].toDouble();
    }

    // get daily change
    for (String stock in quotes.keys) {
      changePercent = quotes[stock]['quote']['changePercent'] ??
          (quotes[stock]['quote']['latestPrice'] - quotes[stock]['quote']['previousClose']) / (quotes[stock]['quote']['previousClose']);

      weight = (stocksShares[stock]['shares'] * quotes[stock]['quote']['latestPrice'].toDouble()) / currentAsset;
      dailyChange += changePercent.toDouble() * 100 * weight;
    }
  }

  Provider.of<PortfolioProvider>(context, listen: false).setRentability(currentAsset);
  Provider.of<PortfolioProvider>(context, listen: false).setCurrentAsset(currentAsset);
  Provider.of<PortfolioProvider>(context, listen: false).setPortfolioDailyChange(dailyChange);

  return stocksQuotes;
}

void getTopStocks(BuildContext context) async {
  Map? stocksQuote = Provider.of<MenuProvider>(context, listen: false).getStocksQuote();
  List<Map?> stocks = await getStocks();
  stocks.removeAt(stocks.length - 1); // removing total map
  List<Map?> topStocks = [];
  List<Map?> worstStocks = [];
  List<TopPickStockCard> topStocksWidgets = [];
  List<TopPickStockCard> worstStocksWidgets = [];
  double profit = 0;

  // order stocks by profitability
  stocks.sort((s1, s2) {
    Map? stock1 = s1![s1.keys.first];
    Map? stock2 = s2![s2.keys.first];

    double profit1 = ((stocksQuote![s1.keys.first]['now_price'] - stock1!['buy_price']) / stock1['buy_price']) * 100;
    double profit2 = ((stocksQuote[s2.keys.first]['now_price'] - stock2!['buy_price']) / stock2['buy_price']) * 100;

    var r = profit1.compareTo(profit2);
    if (r != 0) return r;
    return profit1.compareTo(profit2);
  });

  for (Map? item in stocks) {
    Map? stock = item![item.keys.first];

    profit = ((stocksQuote![item.keys.first]['now_price'] - stock!['buy_price']) / stock['buy_price']) * 100;
    stock['stock'] = item.keys.first;
    stock['current_value'] = stocksQuote[item.keys.first]['now_price'] * stock['shares'];

    if (profit > 0 && worstStocks.length <= 4) {
      topStocks.add(stock);
    } else if (profit < 0 && worstStocks.length <= 4) {
      worstStocks.add(stock);
    }
  }

  for (Map? stock in topStocks) {
    profit = ((stocksQuote![stock!['stock']]['now_price'] - stock['buy_price']) / stock['buy_price']) * 100;
    topStocksWidgets.add(
      TopPickStockCard(
        stock: stock['stock'],
        total: stock['current_value'],
        profit: profit,
      ),
    );
  }

  for (Map? stock in worstStocks) {
    profit = ((stocksQuote![stock!['stock']]['now_price'] - stock['buy_price']) / stock['buy_price']) * 100;
    worstStocksWidgets.add(
      TopPickStockCard(
        stock: stock['stock'],
        total: stock['current_value'],
        profit: profit,
      ),
    );
  }

  Provider.of<PortfolioProvider>(context, listen: false).setTopStocksGainers(topStocksWidgets);
  Provider.of<PortfolioProvider>(context, listen: false).setTopStocksLosers(worstStocksWidgets);
}
