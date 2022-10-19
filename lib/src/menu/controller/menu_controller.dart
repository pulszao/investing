import 'package:flutter/material.dart';
import 'package:investing/src/shared/model/chart_data_model.dart';

class MenuProvider extends ChangeNotifier {
  bool _rebuild = false;
  List<ChartData> _portfolioData = [];
  List<ChartData> _portfolioSectorData = [];

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
