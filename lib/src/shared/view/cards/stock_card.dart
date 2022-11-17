import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';

class StockCard extends StatelessWidget {
  final bool sectorPage;
  final int quantity;
  final double avgPrice;
  final double nowPrice;
  final double profit;
  final double total;
  final double weight;
  final String stock;
  final String stockDescription;

  const StockCard({
    Key? key,
    this.sectorPage = false,
    required this.stock,
    required this.quantity,
    required this.avgPrice,
    required this.nowPrice,
    required this.profit,
    required this.weight,
    required this.total,
    required this.stockDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 12,
      decoration: BoxDecoration(
        color: kColorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stock,
                  style: kBaseTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      NumberFormatter(number: total).formatNumber(),
                      style: kBaseTextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '(${NumberFormatter(number: profit, coinName: '').formatNumber()}%)',
                      style: kBaseTextStyle(
                        fontWeight: FontWeight.bold,
                        color: profit > 0 ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    stockDescription,
                    overflow: TextOverflow.ellipsis,
                    style: kBaseTextStyle(),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Weight${sectorPage == true ? ' (in the sector):' : ':'}'),
                      Text('${NumberFormatter(number: weight * 100, coinName: '').formatNumber()}%'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity:'),
                      Text('$quantity'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Average price: '),
                      Text(NumberFormatter(number: avgPrice).formatNumber()),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current price: '),
                      Text(NumberFormatter(number: nowPrice).formatNumber()),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rentability: '),
                      Text(
                        '${NumberFormatter(number: profit, coinName: '').formatNumber()}%',
                        style: kBaseTextStyle(
                          color: profit > 0 ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
