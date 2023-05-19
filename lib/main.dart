import 'package:currencyapp/providers/currency_provider.dart';
import 'package:currencyapp/screens/exchange_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrencyProvider>(
          lazy: false,
            create: (context) => CurrencyProvider()..loadCurrencies()),
      ],
      child: MaterialApp(
        title: 'Currency App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ExchangeRatesScreen(),
      ),
    );
  }
}
