import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/rentability/controller/rentability_controller.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';

class TopPickStockCard extends StatelessWidget {
  final String stock;
  final double profit;
  final double total;
  const TopPickStockCard({
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
                  rentabilityIcon(profit),
                  size: 15,
                  color: rentabilityColor(profit),
                ),
                const SizedBox(width: 2),
                Container(
                  constraints: BoxConstraints(maxWidth: width / 5),
                  child: Text(
                    '${NumberFormatter(number: profit, coinName: '').formatNumber()}%',
                    style: kBaseTextStyle(
                      fontSize: 15,
                      color: rentabilityColor(profit),
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
                    NumberFormatter(number: total).formatNumber(),
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
