import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/shared/view/cards/stock_card.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<StockCard> stocksWidgets = [];

  @override
  void initState() {
    buildStocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<StockCard> stocksWidgets = [
    //   StockCard(
    //     stock: 'WEGE3',
    //     stockDescription: 'WEG S.A',
    //     nowPrice: 20,
    //     avgPrice: 20.22,
    //     quantity: 1000,
    //     total: 17000,
    //     profit: -5.2,
    //     weight: 8,
    //   ),
    // ];

    return Scaffold(
      body: SafeArea(
        child: stocksWidgets.isNotEmpty
            ? SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: stocksWidgets
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
                label: 'Adicione transações para ver seu portfolio.',
              ),
      ),
    );
  }

  void buildStocks() async {
    List<Map?> stocks = await getStocks();
    List<StockCard> stocksWidgets = [];

    for (Map? item in stocks) {
      Map? stock = item![item.keys.first];

      if (stock!['total'] != 0 && item.keys.first != 'total') {
        stocksWidgets.add(
          StockCard(
            stock: item.keys.first,
            stockDescription: stock['company_name'],
            nowPrice: 0, // TODO: get price
            avgPrice: stock['buy_price'],
            quantity: 1000,
            total: stock['total'],
            profit: -5.2, // TODO: get profit
            weight: stock['total'] / stocks[stocks.length - 1]!['total']['total'],
          ),
        );
      }
    }

    setState(() {
      this.stocksWidgets = stocksWidgets;
    });
  }
}
