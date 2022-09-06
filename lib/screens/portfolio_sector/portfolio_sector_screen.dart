import 'package:flutter/material.dart';

import '../../components/card/stock_card.dart';
import '../../components/card/stock_sector_card.dart';

class PortfolioSectorScreen extends StatefulWidget {
  const PortfolioSectorScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioSectorScreen> createState() => _PortfolioSectorScreen();
}

class _PortfolioSectorScreen extends State<PortfolioSectorScreen> {
  @override
  Widget build(BuildContext context) {
    List stocksWidgets = const [
      StockSectorCard(
        sector: 'Bens Industriais',
        sectorPercent: 20,
        stocksInSector: [
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
        ],
      ),
      StockSectorCard(
        sector: 'Utilidade Pública',
        sectorPercent: 24,
        stocksInSector: [
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
        ],
      ),
      StockSectorCard(
        sector: 'Consumo Não Cíclico',
        sectorPercent: 32,
        stocksInSector: [
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
        ],
      ),
      StockSectorCard(
        sector: 'Financeiro',
        sectorPercent: 24,
        stocksInSector: [
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
          SizedBox(height: 10),
          StockCard(
            sectorPage: true,
            stock: 'WEGE3',
            stockDescription: 'WEG S.A',
            nowPrice: 17,
            avgPrice: 20.22,
            quantity: 1000,
            total: 17000,
            profit: -5.2,
            weight: 8,
          ),
        ],
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
