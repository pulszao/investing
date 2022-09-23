import 'package:flutter/material.dart';
import 'package:investing/src/shared/view/cards/stock_watchlist_card.dart';
import 'package:investing/src/shared/view/modals/loading_modal.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:investing/src/watchlist/controller/watchlist_controller.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../../services/get_quote/get_quote.dart';
import '../../constants.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  bool buildWidgets = false;
  final _newStockKey = GlobalKey<FormState>();
  TextEditingController stockFormController = TextEditingController();
  List<StockWatchlistCard> stocksWidgets = [];

  @override
  void initState() {
    getStockQuotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        body: SafeArea(
          child: !buildWidgets
              ? kCircularLoading
              : Stack(
                  children: [
                    stocksWidgets.isNotEmpty
                        ? Padding(
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
                          )
                        : notFound(
                            height: 0,
                            label: 'Nenhuma ação adicionada à watchlist.',
                          ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                          color: kColorScheme.surface,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.76,
                                  height: 50,
                                  child: Form(
                                    key: _newStockKey,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Ativo',
                                      ),
                                      controller: stockFormController,
                                      validator: (stock) {
                                        if (stock != null && stock.trim() == '') {
                                          return 'Ação inválida.';
                                        }
                                        return null;
                                      },
                                      onChanged: (stock) {
                                        if (stock.trim() != '') {
                                          Provider.of<WatchlistProvider>(context, listen: false).setNewStock(stock.trim());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                FloatingActionButton(
                                  heroTag: 'search',
                                  onPressed: addStockToWatchlist,
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

  void removeStockFromWatchlist({required String code}) async {
    loadingModalCall(context);

    Provider.of<WatchlistProvider>(context, listen: false).setNewStock(code);

    try {
      List<String>? watchlist = await UserSecureStorage.getWatchlist();
      watchlist!.remove(code);

      // update stocks
      UserSecureStorage.setWatchlist(watchlist);

      getStockQuotes(remove: true);
    } catch (_) {
      // pop loading modal
      if (!mounted) return;
      Navigator.pop(context);
      Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');
    }
  }

  void addStockToWatchlist() async {
    if (_newStockKey.currentState!.validate()) {
      List<String>? watchlist = await UserSecureStorage.getWatchlist();

      if (!mounted) return;
      loadingModalCall(context);

      String stock = Provider.of<WatchlistProvider>(context, listen: false).getNewStock();

      if (!watchlist!.contains(stock)) {
        // get stock quote
        Map? data = await getSingleQuote(code: stock);

        try {
          watchlist.add(data!['symbol']);

          // save stock locally
          UserSecureStorage.setWatchlist(watchlist);

          getStockQuotes();
        } catch (_) {
          // pop loading modal
          if (!mounted) return;
          Navigator.pop(context);
          Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');

          // error scaffold modal
          showScaffoldModal(
            context: context,
            message: "Desculpa, tivemos problemas ao adicionar '$stock' à sua watchlist.",
            duration: 3,
          );

          // no stock was added
          setState(() {
            buildWidgets = true;
            stockFormController.clear();
          });
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');
        stockFormController.clear();

        // error scaffold modal
        showScaffoldModal(
          context: context,
          message: "'$stock' já está em sua watchlist.",
          duration: 3,
        );
      }
    }
  }

  void getStockQuotes({bool remove = false}) async {
    String newStock = Provider.of<WatchlistProvider>(context, listen: false).getNewStock();
    List<String>? watchlist = await UserSecureStorage.getWatchlist();
    List<StockWatchlistCard> stocksWidgets = [];

    if (watchlist!.isNotEmpty) {
      Map? quotes = await getMultipleQuote(codes: watchlist);

      for (String stock in quotes!.keys) {
        stocksWidgets.add(
          StockWatchlistCard(
            stockSymbol: quotes[stock]['quote']['symbol'],
            stockDescription: quotes[stock]['quote']['companyName'],
            nowPrice: quotes[stock]['quote']['latestPrice'].toDouble(),
            dailyChange: (quotes[stock]['quote']['changePercent'] * 100).toDouble(),
            removeStock: () {
              // pop modal
              Navigator.pop(context);
              removeStockFromWatchlist(code: quotes[stock]['quote']['symbol']);
            },
          ),
        );
      }

      if (newStock != '') {
        // pop loading modal
        if (!mounted) return;
        Navigator.pop(context);
        Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');
        // success scaffold modal
        showScaffoldModal(
          context: context,
          message: "'$newStock' foi ${remove ? 'removido' : 'adicionado'} com sucesso ${remove ? 'da' : 'à'} sua watchlist.",
          duration: 3,
          backgroundColor: remove ? kWarningColor : kSuccessColor,
        );
      }

      setState(() {
        buildWidgets = true;
        stockFormController.clear();
        this.stocksWidgets = stocksWidgets;
      });
    } else {
      if (!mounted) return;
      if (newStock != '') {
        Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');

        if (remove == true) {
          // pop loading modal
          Navigator.pop(context);
          // success scaffold modal
          showScaffoldModal(
            context: context,
            message: "'$newStock' foi removido com sucesso da sua watchlist.",
            duration: 3,
            backgroundColor: Colors.amber,
          );
        } else {
          showScaffoldModal(
            context: context,
            message: "Desculpa, tivemos problemas ao adicionar '$newStock' à sua watchlist",
            duration: 2,
          );
        }
      }

      // no stock was added
      setState(() {
        buildWidgets = true;
        stockFormController.clear();
        this.stocksWidgets = [];
      });
    }
  }
}