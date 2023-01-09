import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/buttons/small_button.dart';
import 'package:investing/src/shared/view/cards/transaction_card.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class FilterTransactionModal extends StatefulWidget {
  const FilterTransactionModal({Key? key}) : super(key: key);

  @override
  State<FilterTransactionModal> createState() => _FilterTransactionModalState();
}

class _FilterTransactionModalState extends State<FilterTransactionModal> {
  User? authUser = FirebaseAuth.instance.currentUser;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * 0.4;
    Operation operation = Provider.of<TransactionProvider>(context).getOperation();
    DateTime? buyDate = Provider.of<TransactionProvider>(context).getFilterDate();
    List<String> stocks = Provider.of<TransactionProvider>(context).getFilterStocks();

    void showAndroidDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900),
        lastDate: now,
      );
      if (picked != null) {
        Provider.of<TransactionProvider>(context, listen: false).setFilterDate(picked);
      }
    }

    return Container(
      padding: EdgeInsets.only(bottom: Platform.isIOS ? 26 : 0),
      child: Card(
        elevation: 0,
        color: kColorScheme.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallButton(
                        width: itemWidth,
                        onPressed: () => Provider.of<TransactionProvider>(context, listen: false).setOperation(Operation.buy),
                        text: 'Buy',
                        backgroundColor: operation == Operation.buy ? kColorScheme.primary : kColorScheme.surface,
                      ),
                      const SizedBox(width: 8),
                      SmallButton(
                        width: itemWidth,
                        onPressed: () => Provider.of<TransactionProvider>(context, listen: false).setOperation(Operation.sell),
                        text: 'Sell',
                        backgroundColor: operation == Operation.sell ? kColorScheme.primary : kColorScheme.surface,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: DropdownSearch<String>.multiSelection(
                          items: Provider.of<TransactionProvider>(context).getStocks(),
                          popupProps: PopupPropsMultiSelection.dialog(
                            showSearchBox: true,
                            dialogProps: DialogProps(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            containerBuilder: (ctx, popupWidget) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: popupWidget,
                              );
                            },
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Stock',
                            ),
                          ),
                          onChanged: (values) => Provider.of<TransactionProvider>(context, listen: false).setFilterStocks(values),
                          selectedItems: stocks,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: itemWidth,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => Platform.isIOS
                              ? showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => SizedBox(
                                    height: 220,
                                    child: CupertinoDatePicker(
                                      onDateTimeChanged: (date) => Provider.of<TransactionProvider>(context, listen: false).setFilterDate(date),
                                      backgroundColor: Colors.grey.shade300,
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime: now,
                                      maximumDate: now,
                                      minimumDate: DateTime(1950),
                                    ),
                                  ),
                                )
                              : showAndroidDatePicker(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Initial date',
                                    style: kBaseTextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    buyDate != null ? DateFormat('dd/MM/yyyy').format(buyDate) : '',
                                    style: kBaseTextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    width: itemWidth * 0.8,
                                    color: Colors.grey.shade600,
                                  )
                                ],
                              ),
                              Icon(
                                MdiIcons.calendar,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Button(
                    onPressed: () {
                      try {
                        // update stocks
                        FirebaseFirestore.instance
                            .collection('transactions/${authUser!.uid}/stocks')
                            .where('operation', isEqualTo: Operation.buy == operation ? 'buy' : 'sell')
                            .where('buy_date', isGreaterThanOrEqualTo: buyDate)
                            .orderBy('buy_date', descending: true)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          // clear transactions
                          Provider.of<TransactionProvider>(context, listen: false).setFilteredTransactionsWidgets([]);
                          if (querySnapshot.docs.isNotEmpty) {
                            for (var data in querySnapshot.docs) {
                              if (stocks.isNotEmpty) {
                                if (stocks.contains(data['stock'])) {
                                  // filter stocks returned
                                  Provider.of<TransactionProvider>(context, listen: false).addFilteredTransactionsWidgets(
                                    TransactionCard(
                                        id: data.id,
                                        operation: operation,
                                        stockSymbol: data['stock'],
                                        quantity: data['shares'],
                                        buyPrice: data['buy_price'],
                                        fees: data['fees'],
                                        stockDescription: data['company_name'],
                                        buyDate: DateFormat('dd/MM/yyyy').parse(data['buy_date']),
                                        sector: data['sector']),
                                  );
                                }
                              } else {
                                // add all stocks returned
                                Provider.of<TransactionProvider>(context, listen: false).addFilteredTransactionsWidgets(
                                  TransactionCard(
                                      id: data.id,
                                      operation: operation,
                                      stockSymbol: data['stock'],
                                      quantity: data['shares'],
                                      buyPrice: data['buy_price'],
                                      fees: data['fees'],
                                      stockDescription: data['company_name'],
                                      buyDate: DateFormat('dd/MM/yyyy').parse(data['buy_date']),
                                      sector: data['sector']),
                                );
                              }
                            }
                          } else {
                            showScaffoldModal(
                              context: context,
                              message: "There are no transactions with this filter.",
                              duration: 2,
                            );
                          }
                        });
                      } catch (_) {
                        // error scaffold modal
                        showScaffoldModal(
                          context: context,
                          message: "We has a problem filtering your transactions.",
                          duration: 2,
                        );
                      }
                      Navigator.pop(context);
                    },
                    text: 'Filter',
                    backgroundColor: kColorScheme.surface,
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
