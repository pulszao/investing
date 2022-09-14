import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investing/src/shared/view/buttons/button.dart';
import 'package:investing/src/shared/view/buttons/small_button.dart';
import 'package:investing/src/transactions/controller/transactions_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../../constants.dart';

class FilterTransactionModal extends StatelessWidget {
  const FilterTransactionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * 0.4;
    Operation operation = Provider.of<TransactionProvider>(context).getOperation();
    DateTime? buyDate = Provider.of<TransactionProvider>(context).getFilterDate();
    DateTime now = DateTime.now();

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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: DropdownSearch<String>.multiSelection(
                          items: const ['WEGE3', 'LREN3', 'ITUB3', 'MDIA3'], // TODO: GET USER's STOCKS
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
                              labelText: 'Ativo',
                            ),
                          ),
                          onChanged: (values) {},
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
                                    'Data início',
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
                    onPressed: () {},
                    text: 'Filtrar',
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
