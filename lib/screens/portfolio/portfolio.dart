import 'package:flutter/material.dart';
import '../../components/card/stock_card.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreen();
}

class _PortfolioScreen extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    List<StockCard> stocksWidgets = [
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 20,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
      StockCard(
        stock: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        avgPrice: 20.22,
        quantity: 1000,
        total: 17000,
        profit: -5.2,
        weight: 8,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
