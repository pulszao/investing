import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/button/button.dart';
import '../../components/button/small_button.dart';
import '../../components/modal/standard_modal.dart';
import '../../constants.dart';
import '../../models/stocks_sector.dart';
import '../../provider/transactions/transactions_provider.dart';

class AddTransactionModal extends StatelessWidget {
  const AddTransactionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * 0.4;
    Operation operation = Provider.of<TransactionProvider>(context).getOperation();
    DateTime? buyDate = Provider.of<TransactionProvider>(context).getBuyDate();
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

    return Card(
      elevation: 0,
      color: kColorScheme.background,
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
                    height: 50,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Ativo',
                      ),
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
                    child: DropdownSearch<String>(
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
                      onChanged: (values) {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: itemWidth,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Taxa',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => StandardModal(
                    label: 'Adicionar item',
                    body: 'Você deseja adicionar WEGE3 à suas transações?',
                    confirmButtonLabel: 'Remover',
                    bodyWidget: Column(
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Ativo: WEGE3'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Setor: Bens Industriais'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Data da Compra: 28/03/2022'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Valor de Compra: R\$ 22,48'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Quantida: 500'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Taxa: R\$ 4,90'),
                          ],
                        ),
                      ],
                    ),
                    confirmButtonFunction: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                text: 'Confirmar',
                backgroundColor: kColorScheme.surface,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
