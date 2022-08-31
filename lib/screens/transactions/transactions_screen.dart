import 'package:flutter/material.dart';
import 'package:investing/components/button/small_button.dart';
import 'package:investing/screens/transactions/add_transaction_modal.dart';
import 'package:investing/screens/transactions/filter_transactions_modal.dart';
import 'dart:io' show Platform;
import '../../components/modal/bottom_sheet_modal.dart';
import '../../components/card/transaction_card.dart';
import '../../constants.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    List<TransactionCard> stocksWidgets = [
      TransactionCard(
        stockSymbol: 'WEGE3',
        stockDescription: 'WEG S.A',
        buyDate: DateTime(2022),
        buyPrice: 17,
        fees: 4.9,
        quantity: 200,
      ),
      TransactionCard(
        stockSymbol: 'LREN3',
        stockDescription: 'Lojas Renner S.A',
        buyDate: DateTime(2022),
        buyPrice: 22,
        fees: 4.9,
        quantity: 100,
      ),
      TransactionCard(
        stockSymbol: 'ITUB3',
        stockDescription: 'Itaú Unibanco S.A',
        buyDate: DateTime(2022),
        buyPrice: 20,
        fees: 4.9,
        quantity: 200,
      ),
      TransactionCard(
        stockSymbol: 'MDIA3',
        stockDescription: 'M. Dias Branco S.A',
        buyDate: DateTime(2022),
        buyPrice: 26,
        fees: 4.9,
        quantity: 200,
      ),
      TransactionCard(
        stockSymbol: 'EGIE3',
        stockDescription: 'Engie Brasil Energia',
        buyDate: DateTime(2022),
        buyPrice: 41.24,
        fees: 4.9,
        quantity: 200,
      ),
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: Platform.isIOS ? 45.0 : 60),
                          child: Column(
                            children: stocksWidgets
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
                              body: const [
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
}
