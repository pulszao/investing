import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/shared/view/buttons/small_button.dart';
import 'package:investing/src/shared/view/cards/transaction_card.dart';
import 'package:investing/src/shared/view/modals/bottom_sheet_modal.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/src/transactions/view/add_transaction_modal.dart';
import 'package:investing/src/transactions/view/filter_transaction_modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  User? authUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Provider.of<TransactionProvider>(context, listen: false).setFilteredTransactionsWidgets([]);
    getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionCard> transactionsWidgets = Provider.of<TransactionProvider>(context).getTransactionsWidgets();
    List<TransactionCard> filteredTransactionsWidgets = Provider.of<TransactionProvider>(context).getFilteredTransactionsWidgets();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        backgroundColor: kColorScheme.background,
        appBar: kBaseAppBar(context),
        body: Stack(
          children: [
            SafeArea(
              child: transactionsWidgets.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: Platform.isIOS ? 45.0 : 60),
                                child: Column(
                                  children: (filteredTransactionsWidgets.isNotEmpty ? filteredTransactionsWidgets : transactionsWidgets)
                                      .map((item) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                                            child: item,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : notFound(
                      height: 0,
                      icon: Icon(
                        MdiIcons.swapHorizontal,
                        size: 50,
                        color: kColorScheme.primary,
                      ),
                      label: 'You have no transactions.',
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: kColorScheme.background,
                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 24 : 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallButton(
                        text: 'Add',
                        backgroundColor: kColorScheme.surface,
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return BottomSheetModal(
                              maxHeight: MediaQuery.of(context).size.height * 0.65,
                              backgroundColor: kModalBackgroundColor,
                              body: const [
                                AddTransactionModal(),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      SmallButton(
                        text: 'Filter',
                        backgroundColor: kColorScheme.surface,
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return BottomSheetModal(
                              maxHeight: MediaQuery.of(context).size.height * 0.65,
                              backgroundColor: kModalBackgroundColor,
                              body: const [
                                FilterTransactionModal(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void getTransactions() async {
    List<TransactionCard> stocksWidgets = [];

    // update stocks
    FirebaseFirestore.instance
        .collection('transactions/${authUser!.uid}/stocks')
        .orderBy('buy_date', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        Provider.of<TransactionProvider>(context, listen: false).addStock(data['stock']);
        stocksWidgets.add(
          TransactionCard(
            id: data.id,
            operation: data['operation'] == 'buy' ? Operation.buy : Operation.sell,
            stockSymbol: data['stock'],
            stockDescription: data['company_name'],
            buyDate: DateFormat('dd/MM/yyyy').parse(data['buy_date']),
            buyPrice: data['buy_price'],
            fees: data['fees'],
            quantity: data['shares'],
            sector: data['sector'],
          ),
        );
      }

      if (!mounted) return;
      Provider.of<TransactionProvider>(context, listen: false).setTransactionsWidgets(stocksWidgets);
    });
  }
}
