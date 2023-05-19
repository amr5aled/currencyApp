import 'package:currencyapp/screens/widgets/app_date_picker_widget.dart';
import 'package:currencyapp/screens/widgets/currency_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/currency_provider.dart';

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  _ExchangeRatesScreenState createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _baseCurrencyController = TextEditingController();
  final TextEditingController _targetCurrencyController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _baseCurrencyController.dispose();
    _targetCurrencyController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final dataProvider = Provider.of<CurrencyProvider>(context, listen: false);

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      dataProvider.loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select date range',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                    child: DatePickerField(
                  controller: _startDateController,
                  labelText: 'Start date (YYYY-MM-DD)',
                )),
                const SizedBox(width: 16.0),
                Expanded(
                    child: DatePickerField(
                  controller: _endDateController,
                  labelText: 'End date (YYYY-MM-DD)',
                  isStart: false,
                ))
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Select currencies',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Expanded(child: DropDownButtonWidget()),
                SizedBox(width: 16.0),
                Expanded(
                    child: DropDownButtonWidget(
                  isFrom: false,
                )),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (_startDateController.text.isNotEmpty &&
                    _endDateController.text.isNotEmpty) {
                  context.read<CurrencyProvider>().fetchData(
                      startDate: _startDateController.text,
                      endDate: _endDateController.text);
                }
              },
              child: const Center(child: Text('Get exchange rates')),
            ),
            if (context.watch<CurrencyProvider>().displayedData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount:
                      context.watch<CurrencyProvider>().displayedData.length ,
                  itemBuilder: (context, index) {
                    if (index ==
                        context
                            .watch<CurrencyProvider>()
                            .displayedData
                            .length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final item =
                        context.watch<CurrencyProvider>().displayedData[index];
                    return ListTile(
                      title: Text(DateFormat('yyyy-MM-dd').format(item.date)),
                      subtitle: Text('${item.exchangeRate} LE'),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
