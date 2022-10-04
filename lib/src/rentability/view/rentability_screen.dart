import 'package:flutter/material.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';

import '../../constants.dart';

class RentabilityScreen extends StatefulWidget {
  const RentabilityScreen({Key? key}) : super(key: key);

  @override
  State<RentabilityScreen> createState() => _RentabilityScreenState();
}

class _RentabilityScreenState extends State<RentabilityScreen> {
  @override
  Widget build(BuildContext context) {
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
                          NumberFormatter(number: 10543.23).formatNumber(),
                          style: kBaseTextStyle(
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Initial asset: ${NumberFormatter(number: 10000).formatNumber()}',
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
                            const Icon(
                              Icons.arrow_upward,
                              size: 22,
                              color: Colors.greenAccent,
                            ),
                            Text(
                              '5,43%',
                              style: kBaseTextStyle(
                                fontSize: 28,
                                color: Colors.greenAccent,
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
                        TopPickStock(
                          stock: 'EGIE3',
                          total: 7435.20,
                          profit: 5.53,
                        ),
                        TopPickStock(
                          stock: 'WEGE3',
                          total: 2435.20,
                          profit: 23.53,
                        ),
                        TopPickStock(
                          stock: 'ITUB3',
                          total: 21435.20,
                          profit: 13.53,
                        ),
                        TopPickStock(
                          stock: 'ITUB3',
                          total: 21435.20,
                          profit: 13.53,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
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
                        TopPickStock(
                          stock: 'MGLU3',
                          total: 435.20,
                          profit: -69.51,
                        ),
                        TopPickStock(
                          stock: 'IRBR3',
                          total: 335.20,
                          profit: -59.50,
                        ),
                        TopPickStock(
                          stock: 'AZUL4',
                          total: 1035.20,
                          profit: -45.93,
                        ),
                        TopPickStock(
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
}

class TopPickStock extends StatelessWidget {
  final String stock;
  final double profit;
  final double total;
  const TopPickStock({
    Key? key,
    required this.stock,
    required this.profit,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 0,
      color: kColorScheme.surface,
      margin: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: width / 2 - 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width / 4 - 15,
                  child: Text(
                    stock,
                    style: kBaseTextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Icon(
                  profit >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 15,
                  color: profit >= 0 ? Colors.greenAccent : Colors.redAccent,
                ),
                const SizedBox(width: 2),
                Container(
                  constraints: BoxConstraints(maxWidth: width / 5),
                  child: Text(
                    profit >= 0 ? '$profit%' : '${profit * -1}%',
                    style: kBaseTextStyle(
                      fontSize: 15,
                      color: profit >= 0 ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: width / 2.5),
                  child: Text(
                    '$total',
                    style: kBaseTextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
