import 'package:flutter/material.dart';
import 'package:investing/src/constants.dart';

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
                      'R\$ $total',
                      style: kBaseTextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '($profit%)',
                      style: kBaseTextStyle(
                        fontWeight: FontWeight.bold,
                        color: profit > 0 ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  ],
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
                      Text('Peso${sectorPage == true ? ' (no setor):' : ':'}'),
                      Text('${(weight * 100).toStringAsFixed(2)}%'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantidade:'),
                      Text('$quantity'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Preço médio: '),
                      Text('R\$ $avgPrice'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Preço atual: '),
                      Text('R\$ $nowPrice'),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rentabilidade: '),
                      Text(
                        '$profit%',
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
