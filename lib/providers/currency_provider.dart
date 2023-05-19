import 'dart:math';

import 'package:currencyapp/helper/exchangeHelper.dart';
import 'package:flutter/foundation.dart';

import '../models/currency_rate.dart';

class CurrencyProvider extends ChangeNotifier {
  List<CurrencyExchangeRate> allData = [];
  List<String> currencies = [];
  List<CurrencyExchangeRate> displayedData = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String? startDate, endDate;

  Future<void> fetchData({
    String? startDate,
    String? endDate,
  }) async {
    allData = await CurrencyExchangeRateService.fetchExchangeRates(
        baseCurrency: fromCurrency,
        targetCurrency: toCurrency,
        startDate: startDate,
        endDate: endDate);

    updateDisplayedData();
  }

  void updateDisplayedData() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    displayedData.addAll(allData.sublist(startIndex, endIndex));

    notifyListeners();
  }

  void loadMoreData() {
    currentPage++;
    updateDisplayedData();
  }

  Future<void> loadCurrencies() async {
    currencies = await CurrencyExchangeRateService.loadCurrencies();
    notifyListeners();
  }

  void onFromChanged(String value) {
    fromCurrency = value;
    notifyListeners();
  }

  void onToChanged(String value) {
    toCurrency = value;
    notifyListeners();
  }

  void onChangeCurrency(String? value, {bool isFrom = true}) {
    if (isFrom) {
      onFromChanged(value!);
    } else {
      onToChanged(value!);
    }
  }
}
