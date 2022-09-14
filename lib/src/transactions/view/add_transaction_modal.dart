import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/services/get_quote/get_quote.dart';
import 'package:investing/src/shared/model/stocks_sector_model.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/buttons/small_button.dart';
import 'package:investing/src/shared/view/cards/transaction_card.dart';
import 'package:investing/src/shared/view/modals/loading_modal.dart';
import 'package:investing/src/shared/view/modals/scaffold_modal.dart';
import 'package:investing/src/shared/view/modals/standard_modal.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:investing/storage/user_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../../constants.dart';

class AddTransactionModal extends StatelessWidget {
  AddTransactionModal({Key? key}) : super(key: key);
  final _transactionKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double quantity = Provider.of<TransactionProvider>(context).getQuantity();
    Operation operation = Provider.of<TransactionProvider>(context).getOperation();
    String? stock = Provider.of<TransactionProvider>(context, listen: false).getStock();
    StockSector? sector = Provider.of<TransactionProvider>(context).getSector();
    DateTime? buyDate = Provider.of<TransactionProvider>(context).getBuyDate();
    double itemWidth = MediaQuery.of(context).size.width * 0.4;
    double fees = Provider.of<TransactionProvider>(context).getFees();
    double price = Provider.of<TransactionProvider>(context).getPrice();

    DateTime now = DateTime.now();

    void showAndroidDatePicker() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1900),
        lastDate: now,
      );
      if (picked != null) {
        Provider.of<TransactionProvider>(context, listen: false).setBuyDate(picked);
      }
    }

    void displayConfirmationModal({required bool success}) {
      // pop loading modal
      Navigator.pop(context);
      // pop add transaction modal
      Navigator.pop(context);

      // display modal
      showScaffoldModal(
        context: context,
        message: success ? "Transação adicionada com sucesso." : "Erro ao adicionar transação.",
        duration: 2,
        backgroundColor: success ? kSuccessColor : kColorScheme.error,
      );
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
              Form(
                key: _transactionKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallButton(
                          width: itemWidth,
                          onPressed: () => Provider.of<TransactionProvider>(context, listen: false).setOperation(Operation.buy),
                          text: 'Compra',
                          backgroundColor: operation == Operation.buy ? kColorScheme.primary : kColorScheme.surface,
                        ),
                        const SizedBox(width: 8),
                        SmallButton(
                          width: itemWidth,
                          onPressed: () => Provider.of<TransactionProvider>(context, listen: false).setOperation(Operation.sell),
                          text: 'Venda',
                          backgroundColor: operation == Operation.sell ? kColorScheme.primary : kColorScheme.surface,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Ativo',
                            ),
                            validator: (stock) {
                              if (stock == null || stock.trim() == '') {
                                return 'Ação inválida.';
                              }
                              return null;
                            },
                            onChanged: (stock) {
                              if (stock.trim() != '') {
                                Provider.of<TransactionProvider>(context, listen: false).setStock(stock.toUpperCase().trim());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: itemWidth,
                          height: 70,
                          child: GestureDetector(
                            onTap: () => Platform.isIOS
                                ? showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => SizedBox(
                                      height: 220,
                                      child: CupertinoDatePicker(
                                        onDateTimeChanged: (date) => Provider.of<TransactionProvider>(context, listen: false).setBuyDate(date),
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
                                      'Data',
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
                                      color: buyDate == null ? kColorScheme.error : Colors.grey.shade600,
                                    ),
                                    SizedBox(height: buyDate == null ? 8 : 10),
                                    buyDate == null
                                        ? Text(
                                            'Selecione uma data.',
                                            style: kBaseTextStyle(
                                              fontSize: 12,
                                              color: kColorScheme.error,
                                            ),
                                          )
                                        : const SizedBox(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          height: 50,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Valor do Ativo',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (price) {
                              if (price == null || price.trim() == '') {
                                return 'Preço inválido.';
                              }
                              return null;
                            },
                            onChanged: (price) {
                              if (price.trim() != '') {
                                Provider.of<TransactionProvider>(context, listen: false).setPrice(double.parse(price));
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: itemWidth,
                          height: 50,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Quantidade',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (quantity) {
                              if (quantity == null || quantity.trim() == '') {
                                return 'Quantidade inválida.';
                              }
                              return null;
                            },
                            onChanged: (quantity) {
                              if (quantity.trim() != '') {
                                Provider.of<TransactionProvider>(context, listen: false).setQuantity(double.parse(quantity));
                              }
                            },
                          ),
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
                          child: DropdownSearch<StockSector>(
                            items: sectors,
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
                                labelText: 'Setor',
                              ),
                            ),
                            validator: (sector) {
                              if (sector == null) {
                                return 'Setor inválido.';
                              }
                              return null;
                            },
                            onChanged: (sector) {
                              Provider.of<TransactionProvider>(context, listen: false).setSector(sector);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: itemWidth,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Taxa',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim() == '') {
                                return 'Valor inválido.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.trim() != '') {
                                Provider.of<TransactionProvider>(context, listen: false).setFees(double.parse(value));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Button(
                      onPressed: () {
                        if (_transactionKey.currentState!.validate() && buyDate != null) {
                          showDialog(
                            context: context,
                            builder: (_) => StandardModal(
                              label: 'Adicionar item',
                              body: 'Você deseja adicionar $stock à suas transações?',
                              confirmButtonLabel: 'Confirmar',
                              bodyWidget: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'Ativo: $stock (${operation.name})',
                                        style: kBaseTextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('Data: ${DateFormat('dd/MM/yyyy').format(buyDate)}'),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Valor: R\$ ${price.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Quantidade: ${quantity.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Taxa: R\$ ${fees.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Setor: ${sector!.sector}'),
                                    ],
                                  ),
                                ],
                              ),
                              confirmButtonFunction: () async {
                                try {
                                  // pop confirmation modal
                                  Navigator.pop(context);
                                  loadingModalCall(context);

                                  // check for stock
                                  Map? data = await getSingleQuote(code: Provider.of<TransactionProvider>(context, listen: false).getStock()!);

                                  // get transaction index
                                  int index = await UserSecureStorage.getTransactionIndex();

                                  // save new transaction
                                  await UserSecureStorage.addTransaction({
                                    '$index': {
                                      'operation': operation.name,
                                      'stock': data!['symbol'],
                                      'company_name': data['companyName'],
                                      'buy_date': DateFormat('dd/MM/yyyy').format(buyDate),
                                      'buy_price': price,
                                      'shares': quantity,
                                      'sector': sector.sector,
                                      'fees': fees,
                                    }
                                  });

                                  // update screen
                                  Provider.of<TransactionProvider>(context, listen: false).addTransactionsWidgets(
                                    TransactionCard(
                                      id: index,
                                      operation: operation,
                                      stockSymbol: data['symbol'],
                                      stockDescription: data['companyName'],
                                      buyDate: buyDate,
                                      buyPrice: price,
                                      fees: fees,
                                      sector: sector.sector,
                                      quantity: quantity,
                                    ),
                                  );
                                  // clear buy date
                                  Provider.of<TransactionProvider>(context, listen: false).setBuyDate(null);
                                  // success/error modal
                                  displayConfirmationModal(success: true);
                                } catch (e) {
                                  // print(e);
                                  // success/error modal
                                  displayConfirmationModal(success: false);
                                }
                              },
                            ),
                          );
                        }
                      },
                      text: 'Confirmar',
                      backgroundColor: kColorScheme.surface,
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
