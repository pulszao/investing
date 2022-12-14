import 'package:flutter/material.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';

import '../../../constants.dart';

class StockSectorCard extends StatelessWidget {
  final String sector;
  final num sectorPercent;
  final List<Widget> stocksInSector;

  const StockSectorCard({
    Key? key,
    required this.sector,
    required this.sectorPercent,
    required this.stocksInSector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kColorScheme.surface,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width - 20) * 0.63),
                child: Text(
                  sector,
                  style: kBaseTextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 73),
                child: Text(
                  '${NumberFormatter(number: sectorPercent * 100, coinName: '').formatNumber()}%',
                  textAlign: TextAlign.end,
                  style: kBaseTextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          children: <Widget>[
            Container(
              color: kColorScheme.background,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kColorScheme.onBackground,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: stocksInSector,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
