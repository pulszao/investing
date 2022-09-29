import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:investing/src/shared/view/modals/standard_modal.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:provider/provider.dart';

import '../../../../storage/user_secure_storage.dart';
import '../../../constants.dart';

class TransactionCard extends StatelessWidget {
  final int id;
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
            label: 'Excluir item',
            body: 'Tem certeza que você deseja remover $stockSymbol (${DateFormat('dd/MM/yyyy').format(buyDate)}) de suas transações?',
            confirmButtonLabel: 'Remover',
            confirmButtonFunction: () async {
              List updatedTransactions = [];
              List<TransactionCard> stocksWidgets = [];
              // get all transactions
              List transactions = await UserSecureStorage.getTransactions();

              // remove (don't add to updatedTransactions List) selected transaction
              for (Map? item in transactions) {
                if (item!.keys.first != '$id') {
                  updatedTransactions.add(item);

                  // build stocks widgets
                  Map? data = item[item.keys.first];
                  stocksWidgets.add(
                    TransactionCard(
                      id: id,
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
              }

              // update transactions
              Provider.of<TransactionProvider>(context, listen: false).setTransactionsWidgets(stocksWidgets);
              // rebuild home screen charts
              Provider.of<MenuProvider>(context, listen: false).setRebuild(true);
              // pop modal
              Navigator.pop(context);

              await UserSecureStorage.setTransactions(updatedTransactions);
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
                      Text(
                        stockDescription,
                        overflow: TextOverflow.ellipsis,
                        style: kBaseTextStyle(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        operation == Operation.buy ? 'Compra' : 'Venda',
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
                        const Text('Quantidade:'),
                        Text(NumberFormatter(number: quantity, decimalPlaces: 5).formatNumber()),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Taxa: '),
                        Text('R\$ ${NumberFormatter(number: fees).formatNumber()}'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Preço de ${operation == Operation.buy ? 'Compra:' : 'Venda:'} '),
                        Text('R\$ ${NumberFormatter(number: buyPrice).formatNumber()}'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Preço + Taxa: '),
                        Text('R\$ ${NumberFormatter(number: (fees / quantity + buyPrice)).formatNumber()}'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total: '),
                        Text('R\$ ${NumberFormatter(number: (fees + quantity * buyPrice)).formatNumber()}'),
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
