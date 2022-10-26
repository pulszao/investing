import 'package:flutter/material.dart';
import 'package:investing/services/get_quote/get_quote.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/shared/model/chart_data_model.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:provider/provider.dart';

class MenuProvider extends ChangeNotifier {
  bool _rebuild = false;
  double _sep500 = 0;
  Map? _stocksQuote = {};
  Map? _stocksWatchlistQuote = {};
  List<ChartData> _portfolioData = [];
  List<ChartData> _portfolioSectorData = [];

  void setSep500(double data) {
    _sep500 = data;
    notifyListeners();
  }

  double getSep500() {
    return _sep500;
  }

  void setWatchlistQuote(Map? data) {
    _stocksWatchlistQuote = data;
    notifyListeners();
  }

  Map? getWatchlistQuote() {
    return _stocksWatchlistQuote;
  }

  void setStocksQuote(Map? data) {
    _stocksQuote = data;
    notifyListeners();
  }

  Map? getStocksQuote() {
    return _stocksQuote;
  }

  void setRebuild(bool data) {
    _rebuild = data;
    notifyListeners();
  }

  bool getRebuild() {
    return _rebuild;
  }

  void setPortfolioSectorData(List<ChartData> data) {
    _portfolioSectorData = data;
    notifyListeners();
  }

  List<ChartData> getPortfolioSectorData() {
    return _portfolioSectorData;
  }

  void setPortfolioData(List<ChartData> data) {
    _portfolioData = data;
    notifyListeners();
  }

  List<ChartData> getPortfolioData() {
    return _portfolioData;
  }
}

List<ChartData> getPortfolioChartData(List<Map?> stocks) {
  List<ChartData> portfolioData = [];

  for (Map? data in stocks) {
    if (data!.keys.first != 'total') {
      Map? stock = data[data.keys.first];

      portfolioData.add(
        ChartData(
          description: data.keys.first,
          totalValue: stock!['total'],
        ),
      );
    }
  }

  return portfolioData;
}

List<ChartData> getSectorChartData(List<Map?> sectors) {
  List<ChartData> sectorData = [];

  for (Map? sector in sectors) {
    double sectorTotalizator = 0;

    if (sector!.keys.first != 'totalizator') {
      sectorTotalizator = sector[sector.keys.first].last!['sector_totalizator']['totalizator'];
      sectorData.add(
        ChartData(
          description: sector.keys.first,
          totalValue: sectorTotalizator,
        ),
      );
    }
  }

  return sectorData;
}

void fetchStocksData(BuildContext context) async {
  Map? stocksQuote = await getStocksQuote(context);

  Provider.of<MenuProvider>(context, listen: false).setStocksQuote(stocksQuote);
}

void fetchWatchlistData(BuildContext context) async {
  List<String>? watchlist = await UserSecureStorage.getWatchlist();
  if (watchlist != null) {
    Map? quotes = await getMultipleQuote(codes: watchlist);
    Provider.of<MenuProvider>(context, listen: false).setWatchlistQuote(quotes);
  }
}

void fetchSep500Quote(BuildContext context) async {
  Map? sep500 = await getSingleQuote(code: 'SPY'); // ETF that represents S&P500

  if (sep500 != null) {
    Provider.of<MenuProvider>(context, listen: false).setSep500(sep500['changePercent'] * 100);
  }
}
