import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/constants.dart';

import '../modal/standard_modal.dart';

class TransactionCard extends StatelessWidget {
  final String stockSymbol;
  final String stockDescription;
  final double quantity;
  final double buyPrice;
  final double fees;
  final DateTime buyDate;

  const TransactionCard({
    Key? key,
    required this.stockSymbol,
    required this.quantity,
    required this.buyPrice,
    required this.fees,
    required this.stockDescription,
    required this.buyDate,
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
            confirmButtonFunction: () {
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
                  Text(
                    DateFormat('dd/MM/yyyy').format(buyDate),
                    style: kBaseTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                        const Text('Quantidade:'),
                        Text('$quantity'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Preço de Compra: '),
                        Text('R\$ $buyPrice'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Taxa: '),
                        Text('R\$ $fees'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Preço + Taxa: '),
                        Text('R\$ ${double.parse((fees / quantity + buyPrice).toStringAsFixed(2))}'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total: '),
                        Text('R\$ ${double.parse((fees + quantity * buyPrice).toStringAsFixed(2))}'),
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
