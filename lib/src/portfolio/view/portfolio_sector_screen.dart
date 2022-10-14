import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/shared/view/cards/stock_sector_card.dart';
import 'package:investing/src/shared/view/cards/stock_card.dart';

class PortfolioSectorScreen extends StatefulWidget {
  const PortfolioSectorScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioSectorScreen> createState() => _PortfolioSectorScreen();
}

class _PortfolioSectorScreen extends State<PortfolioSectorScreen> {
  List sectorsWidgets = [];
  @override
  void initState() {
    buildSectors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: sectorsWidgets.isNotEmpty
            ? SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: sectorsWidgets
                          .map((item) => Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: item,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            : notFound(
                height: 0,
                icon: Icon(
                  Icons.add,
                  size: 50,
                  color: kColorScheme.primary,
                ),
                label: 'Add transactions to see your portfolio.',
              ),
      ),
    );
  }

  void buildSectors() async {
    List<Map?> sectors = await getSectors();
    Map? stocksQuote = await getStocksQuote();
    List<StockSectorCard> stocksBySector = [];
    double totalizator = sectors.last!['totalizator']['total'].toDouble();

    for (Map? sector in sectors) {
      List<Widget> stocksWidgets = [];
      double sectorTotalizator = 0;

      if (sector!.keys.first != 'totalizator') {
        for (Map? data in sector[sector.keys.first]) {
          sectorTotalizator = sector[sector.keys.first].last!['sector_totalizator']['totalizator'];

          if (data!.keys.first != 'sector_totalizator') {
            Map? stock = data[data.keys.first];
            if (stock!['total'] != 0) {
              stocksWidgets.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: StockCard(
                    sectorPage: true,
                    stock: data.keys.first,
                    stockDescription: stock['company_name'],
                    nowPrice: stocksQuote![data.keys.first]['now_price'],
                    avgPrice: stock['buy_price'],
                    quantity: stock['shares'].toInt(),
                    total: stock['total'],
                    profit: ((stocksQuote[data.keys.first]['now_price'] - stock['buy_price']) / stock['buy_price']) * 100,
                    weight: stock['total'] / sectorTotalizator,
                  ),
                ),
              );
            }
          }
        }

        stocksBySector.add(
          StockSectorCard(
            sector: sector.keys.first,
            sectorPercent: sectorTotalizator / totalizator,
            stocksInSector: stocksWidgets,
          ),
        );
      }
    }

    setState(() {
      this.sectorsWidgets = stocksBySector;
    });
  }
}
