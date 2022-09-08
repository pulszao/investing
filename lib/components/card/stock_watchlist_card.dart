import 'package:flutter/material.dart';
import 'package:investing/constants.dart';

import '../modal/standard_modal.dart';

class StockWatchlistCard extends StatelessWidget {
  final double nowPrice;
  final double dailyChange;
  final String stockSymbol;
  final String stockDescription;
  final void Function()? removeStock;

  const StockWatchlistCard({
    Key? key,
    required this.stockSymbol,
    required this.stockDescription,
    required this.nowPrice,
    required this.dailyChange,
    required this.removeStock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => StandardModal(
            label: 'Excluir item',
            body: 'Tem certeza que você deseja remover $stockSymbol de sua watchlist?',
            confirmButtonLabel: 'Remover',
            confirmButtonFunction: removeStock,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockSymbol,
                        style: kBaseTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: Text(
                          stockDescription,
                          overflow: TextOverflow.ellipsis,
                          style: kBaseTextStyle(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$${nowPrice.toStringAsFixed(2)}',
                        style: kBaseTextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        '${dailyChange.toStringAsFixed(2)}%',
                        style: kBaseTextStyle(
                          fontSize: 17,
                          color: dailyChange > 0 ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
