import 'package:flutter/material.dart';
import '../../components/card/stock_watchlist_card.dart';
import '../../constants.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    List<StockWatchlistCard> stocksWidgets = const [
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
      StockWatchlistCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        nowPrice: 17,
        dailyChange: -5.2,
      ),
    ];

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 78.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: stocksWidgets
                                .map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                                      child: item,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    color: kColorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.76,
                            height: 50,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Ativo',
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: 'search',
                            onPressed: () {},
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            mini: true,
                            elevation: 2,
                            backgroundColor: kColorScheme.primary.withOpacity(0.4),
                            child: Icon(
                              Icons.search,
                              size: 23.0,
                              color: kColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
