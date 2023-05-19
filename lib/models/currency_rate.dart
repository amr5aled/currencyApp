class CurrencyExchangeRate {
  final DateTime date;
  final String baseCurrency;
  final String targetCurrency;
  final double exchangeRate;

  CurrencyExchangeRate({
    required this.date,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.exchangeRate,
  });

  factory CurrencyExchangeRate.fromJson(Map<String, dynamic> json) {
    return CurrencyExchangeRate(
      date: DateTime.parse(json['date']),
      baseCurrency: json['base'],
      targetCurrency: json['target'],
      exchangeRate: json['rate'],
    );
  }
}
