import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/currency_provider.dart';

class DropDownButtonWidget extends StatelessWidget {
  final bool isFrom;
  const DropDownButtonWidget({super.key, this.isFrom = true});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: isFrom
            ? context.watch<CurrencyProvider>().fromCurrency
            : context.watch<CurrencyProvider>().toCurrency,
        isExpanded: true,
        items: context
            .read<CurrencyProvider>()
            .currencies
            .map((String value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (value) => context
            .read<CurrencyProvider>()
            .onChangeCurrency(value, isFrom: isFrom));
  }
}
