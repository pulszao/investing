import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/components/button/small_button.dart';
import 'package:investing/screens/transactions/add_transaction_modal.dart';
import 'package:investing/screens/transactions/filter_transactions_modal.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../../components/modal/bottom_sheet_modal.dart';
import '../../components/card/transaction_card.dart';
import '../../constants.dart';
import '../../provider/transactions/transactions_provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionCard> transactionsWidgets = Provider.of<TransactionProvider>(context).getTransactionsWidgets();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
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
                                  children: transactionsWidgets
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
                      label: 'Nenhuma transação adicionada.',
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
                        text: 'Adicionar',
                        backgroundColor: kColorScheme.surface,
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return BottomSheetModal(
                              maxHeight: MediaQuery.of(context).size.height * 0.65,
                              backgroundColor: kModalBackgroundColor,
                              body: [
                                AddTransactionModal(),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      SmallButton(
                        text: 'Filtrar',
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
    List transactions = await UserSecureStorage.getTransactions();

    for (Map? data in transactions) {
      stocksWidgets.add(
        TransactionCard(
          operation: data!['operation'] == 'buy' ? Operation.buy : Operation.sell,
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
  }
}
