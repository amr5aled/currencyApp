import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/currency_rate.dart';
import 'api_endpoint.dart';

class CurrencyExchangeRateService {
  static Future<List<CurrencyExchangeRate>> fetchExchangeRates({
    String? startDate,
    String? endDate,
    String? baseCurrency,
    String? targetCurrency,
  }) async {
    final url = Uri.parse(
        '${AppApi.timeSeries}?start_date=$startDate&end_date=$endDate&base=$baseCurrency&symbols=$targetCurrency');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      final List<CurrencyExchangeRate> exchangeRates = [];

      rates.forEach((key, value) {
        if (value[targetCurrency] != null) {
          exchangeRates.add(CurrencyExchangeRate(
            baseCurrency: baseCurrency!,
            targetCurrency: targetCurrency!,
            date: DateTime.parse(key),
            exchangeRate: value[targetCurrency],
          ));
        }
      });

      return exchangeRates;
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }

  static Future<List<String>> loadCurrencies() async {
    var response = await http.get(Uri.parse(AppApi.currencies),
        headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    List<String> currencies = curMap.keys.toList() as List<String>;

    return currencies;
  }
}
