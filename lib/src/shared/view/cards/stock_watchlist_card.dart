import 'package:flutter/material.dart';
import 'package:investing/src/rentability/controller/rentability_controller.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:investing/src/shared/view/modals/standard_modal.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

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
            label: 'Delete item',
            body: 'Are you sure you want to delete $stockSymbol  from your watchlist?',
            confirmButtonLabel: 'Delete',
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
                        NumberFormatter(number: nowPrice).formatNumber(),
                        style: kBaseTextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: rentabilityColor(dailyChange),
                        highlightColor: Colors.grey.shade300,
                        period: const Duration(seconds: 3),
                        child: Text(
                          '${NumberFormatter(number: dailyChange, coinName: '').formatNumber()}%',
                          textAlign: TextAlign.center,
                          style: kBaseTextStyle(
                            fontSize: 17,
                            color: rentabilityColor(dailyChange),
                          ),
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
