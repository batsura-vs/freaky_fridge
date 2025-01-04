import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  Future<Map<DateTime, Map<String, dynamic>>> _fetchData() async {
    return await ProductDatabase.instance
        .getProductTransactionsForPeriod(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Usage Statistics'),
      ),
      body: Column(
        children: [
          _buildDateRangePicker(),
          Expanded(
            child: ListView(
              children: [
                FutureBuilder<Map<DateTime, Map<String, dynamic>>>(
                  future: _fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      return _buildChart(snapshot.data!);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  _startDate = selectedDate;
                });
              }
            },
            child:
                Text('From: ${_startDate.toIso8601String().substring(0, 10)}'),
          ),
          ElevatedButton(
            onPressed: () async {
              var selectedDate = await showDatePicker(
                context: context,
                initialDate: _endDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                selectedDate = selectedDate
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59));
                setState(() {
                  _endDate = selectedDate!;
                });
              }
            },
            child: Text('To: ${_endDate.toIso8601String().substring(0, 10)}'),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Map<DateTime, Map<String, dynamic>> data) {
    List<Widget> charts = [];
    List<String> transactionTypes = ['replenishment', 'deletion', 'expense'];

    for (var transactionType in transactionTypes) {
      List<Map<String, dynamic>> chartData = [];
      List<String> productNames = [];

      data.forEach((date, productTransactions) {
        DateTime transactionDate = date;
        productTransactions.forEach((productName, transactions) {
          if (transactions[transactionType] != null) {
            chartData.add({
              'date': transactionDate,
              'amount': transactions[transactionType],
              'productName': productName,
            });
            if (!productNames.contains(productName)) {
              productNames.add(productName);
            }
          }
        });
      });

      List<CartesianSeries> series = [];

      for (var productName in productNames) {
        List<Map<String, dynamic>> productChartData = [];
        for (var dataPoint in chartData) {
          if (dataPoint['productName'] == productName) {
            productChartData.add(dataPoint);
          }
        }

        if (productChartData.isNotEmpty) {
          final color = Color((productName.hashCode * 0xFFFFFF).toInt());
          series.add(
            LineSeries<Map<String, dynamic>, DateTime>(
              dataSource: productChartData,
              xValueMapper: (Map<String, dynamic> data, _) => data['date'],
              yValueMapper: (Map<String, dynamic> data, _) => data['amount'],
              name: productName,
              color: color,
            ),
          );
        }
      }

      charts.add(
        SfCartesianChart(
          title: ChartTitle(text: transactionType),
          primaryXAxis: const DateTimeAxis(),
          primaryYAxis: const NumericAxis(
            axisLine: AxisLine(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelFormat: '{value}',
            majorTickLines: MajorTickLines(size: 0),
          ),
          series: series,
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      );
    }

    return Column(children: charts);
  }
}
