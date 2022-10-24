import 'package:flutter/material.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/rentability/controller/rentability_controller.dart';
import 'package:investing/src/rentability/view/top_pick_stock_card.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RentabilityScreen extends StatefulWidget {
  const RentabilityScreen({Key? key}) : super(key: key);

  @override
  State<RentabilityScreen> createState() => _RentabilityScreenState();
}

class _RentabilityScreenState extends State<RentabilityScreen> {
  double total = 0;

  @override
  void initState() {
    getTotals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double total = Provider.of<PortfolioProvider>(context).getTotal();
    double rentability = Provider.of<PortfolioProvider>(context).getRentability();
    double currentAsset = Provider.of<PortfolioProvider>(context).getCurrentAsset();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asset Value',
                          style: kBaseTextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          NumberFormatter(number: currentAsset).formatNumber(),
                          style: kBaseTextStyle(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Initial asset: ${NumberFormatter(number: total).formatNumber()}',
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rentability',
                          style: kBaseTextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              rentabilityIcon(rentability),
                              size: 22,
                              color: rentabilityColor(rentability),
                            ),
                            Text(
                              '${NumberFormatter(number: rentability, coinName: '').formatNumber()}%',
                              style: kBaseTextStyle(
                                fontSize: 28,
                                color: rentabilityColor(rentability),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Stock Gainers',
                      style: kBaseTextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      children: [
                        TopPickStockCard(
                          stock: 'EGIE3',
                          total: 7435.20,
                          profit: 5.53,
                        ),
                        TopPickStockCard(
                          stock: 'WEGE3',
                          total: 2435.20,
                          profit: 23.53,
                        ),
                        TopPickStockCard(
                          stock: 'ITUB3',
                          total: 21435.20,
                          profit: 13.53,
                        ),
                        TopPickStockCard(
                          stock: 'ITUB3',
                          total: 21435.20,
                          profit: 13.53,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Stock Losers',
                      style: kBaseTextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      children: [
                        TopPickStockCard(
                          stock: 'MGLU3',
                          total: 435.20,
                          profit: -69.51,
                        ),
                        TopPickStockCard(
                          stock: 'IRBR3',
                          total: 335.20,
                          profit: -59.50,
                        ),
                        TopPickStockCard(
                          stock: 'AZUL4',
                          total: 1035.20,
                          profit: -45.93,
                        ),
                        TopPickStockCard(
                          stock: 'AZUL4',
                          total: 1035.20,
                          profit: -45.93,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getTotals() async {
    List<Map?> stocks = await getStocks();
    setState(() {
      total = stocks.last!['total']['total'].toDouble();
    });
  }
}
