import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/shared/view/cards/stock_watchlist_card.dart';
import 'package:investing/src/shared/view/modals/loading_modal.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:investing/src/watchlist/controller/watchlist_controller.dart';
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
  User? authUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');
    getStockQuotes();
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
                            label: 'You have none stock added to your watchlist.',
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
                                          return 'Invalid stock.';
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
      Map? quotes = Provider.of<MenuProvider>(context, listen: false).getWatchlistQuote();

      // update stocks
      FirebaseFirestore.instance.collection('watchlist/${authUser!.uid}/stocks').get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc['stock'] == code && doc['active'] == false) {
            doc.reference.update({'active': false});
          }
        }
      });
      quotes!.remove(code);
      Provider.of<MenuProvider>(context, listen: false).setWatchlistQuote(quotes);
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
      bool hasStock = false;

      if (!mounted) return;
      loadingModalCall(context);

      String stock = Provider.of<WatchlistProvider>(context, listen: false).getNewStock();

      // check if the stock is already on the watchlist
      FirebaseFirestore.instance.collection('watchlist/${authUser!.uid}/stocks').get().then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            if (doc['stock'] == stock) {
              hasStock = true;
            }
          }
        }
      });

      if (!hasStock) {
        // get stock quote
        Map? data = await getSingleQuote(code: stock);

        try {
          // add stock to firebase
          FirebaseFirestore.instance.collection('watchlist/${authUser!.uid}/stocks').add({
            'stock': data!['symbol'],
            'active': true,
            'timestamp': DateFormat('dd/MM/yyyy').format(DateTime.now()),
          });

          getStockQuotes();
        } catch (_) {
          // pop loading modal
          if (!mounted) return;
          Navigator.pop(context);
          Provider.of<WatchlistProvider>(context, listen: false).setNewStock('');

          // error scaffold modal
          showScaffoldModal(
            context: context,
            message: "Sorry, we has a problem adding '$stock' into your watchlist.",
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
          message: "'$stock' already is in your watchlist.",
          duration: 3,
        );
      }
    }
  }

  void getStockQuotes({bool remove = false}) async {
    String newStock = Provider.of<WatchlistProvider>(context, listen: false).getNewStock();
    List<StockWatchlistCard> stocksWidgets = [];

    FirebaseFirestore.instance.collection('watchlist/${authUser!.uid}/stocks').get().then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        Map? quotes = Provider.of<MenuProvider>(context, listen: false).getWatchlistQuote() ?? {};

        for (String stock in quotes.keys) {
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
        // }

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
    });
  }
}
