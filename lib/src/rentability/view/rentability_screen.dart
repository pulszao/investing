import 'package:flutter/material.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/rentability/controller/rentability_controller.dart';
import 'package:investing/src/rentability/view/top_pick_stock_card.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    getTopStocks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double total = Provider.of<PortfolioProvider>(context).getTotal();
    double rentability = Provider.of<PortfolioProvider>(context).getRentability();
    double currentAsset = Provider.of<PortfolioProvider>(context).getCurrentAsset();
    List<TopPickStockCard> topStocksGainers = Provider.of<PortfolioProvider>(context).getTopStocksGainers();
    List<TopPickStockCard> topStocksLosers = Provider.of<PortfolioProvider>(context).getTopStocksLosers();

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
                            Shimmer.fromColors(
                              baseColor: rentabilityColor(rentability),
                              highlightColor: Colors.grey.shade300,
                              period: const Duration(seconds: 3),
                              child: Text(
                                '${NumberFormatter(number: rentability, coinName: '').formatNumber()}%',
                                style: kBaseTextStyle(
                                  fontSize: 28,
                                  color: rentabilityColor(rentability),
                                ),
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
                      children: topStocksGainers.isNotEmpty
                          ? topStocksGainers
                          : [
                              Card(
                                color: kColorScheme.surface,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "You don't have stocks profiting!",
                                    style: kBaseTextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
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
                      children: topStocksLosers.isNotEmpty
                          ? topStocksLosers
                          : [
                              Card(
                                color: kColorScheme.surface,
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Wow! You don't have any losers on your portfolio!",
                                    style: kBaseTextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
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
