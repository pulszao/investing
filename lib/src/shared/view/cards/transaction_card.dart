import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/constants.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:investing/src/shared/view/modals/standard_modal.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  final String id;
  final Operation operation;
  final String sector;
  final String stockSymbol;
  final String stockDescription;
  final double quantity;
  final double buyPrice;
  final double fees;
  final DateTime buyDate;

  const TransactionCard({
    Key? key,
    required this.id,
    required this.operation,
    required this.stockSymbol,
    required this.quantity,
    required this.buyPrice,
    required this.fees,
    required this.stockDescription,
    required this.buyDate,
    required this.sector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => StandardModal(
            label: 'Delete transaction',
            body: 'Are you sure you want to delete $stockSymbol (${DateFormat('dd/MM/yyyy').format(buyDate)}) from your trasactions?',
            confirmButtonLabel: 'Delete',
            confirmButtonFunction: () async {
              User? authUser = FirebaseAuth.instance.currentUser;
              List<TransactionCard> stocksWidgets = [];

              // delete transaction
              FirebaseFirestore.instance.collection('transactions/${authUser!.uid}/stocks').doc(id).delete();

              // update transactions
              FirebaseFirestore.instance.collection('transactions/${authUser.uid}/stocks').get().then((QuerySnapshot querySnapshot) {
                for (var data in querySnapshot.docs) {
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
                Provider.of<TransactionProvider>(context, listen: false).setTransactionsWidgets(stocksWidgets);
              });

              // rebuild home screen charts
              Provider.of<MenuProvider>(context, listen: false).setRebuild(true);
              // pop modal
              Navigator.pop(context);
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stockSymbol,
                          style: kBaseTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stockDescription,
                          overflow: TextOverflow.ellipsis,
                          style: kBaseTextStyle(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          operation == Operation.buy ? 'Buy' : 'Sell',
                          style: kBaseTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: operation == Operation.buy ? kSuccessColor : kColorScheme.error,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(buyDate),
                          style: kBaseTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity:'),
                        Text(NumberFormatter(number: quantity, decimalPlaces: 5, coinName: '').formatNumber()),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fees: '),
                        Text(NumberFormatter(number: fees).formatNumber()),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${operation == Operation.buy ? 'Buy' : 'Sell'} price:'),
                        Text(NumberFormatter(number: buyPrice).formatNumber()),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price + Fees: '),
                        Text(NumberFormatter(number: (fees / quantity + buyPrice)).formatNumber()),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total: '),
                        Text(NumberFormatter(number: (fees + quantity * buyPrice)).formatNumber()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
