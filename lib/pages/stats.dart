import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;
  String _selectedUnitType = 'weight'; // 'weight', 'volume', or 'pieces'
  String? _selectedProduct;
  Future<Map<DateTime, Map<String, Map<String, dynamic>>>>? _dataFuture;

  final Map<String, String> _unitLabels = {
    'weight': 'Вес (г)',
    'volume': 'Объем (мл)',
    'pieces': 'Штуки',
  };

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _dataFuture = AppDatabase.instance.getProductTransactionsForPeriod(
        _startDate,
        _endDate,
        productId: null,
      );
    });
    await _dataFuture;
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'Фильтры',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  _buildDateRangePicker(),
                  _buildProductPicker(),
                  _buildUnitTypePicker(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilledButton(
                      onPressed: () {
                        _refreshData();
                        Navigator.pop(context);
                      },
                      child: const Text('Применить'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Статистика'),
            centerTitle: true,
            floating: true,
            snap: true,
            elevation: 2,
            forceElevated: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFiltersBottomSheet,
                tooltip: 'Фильтры',
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd.MM.yyyy').format(_startDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Text(' - '),
                        Text(
                          DateFormat('dd.MM.yyyy').format(_endDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (_selectedProduct != null) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.shopping_basket,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedProduct!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_isLoading)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    FutureBuilder<
                        Map<DateTime, Map<String, Map<String, dynamic>>>>(
                      future: _dataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Произошла ошибка при загрузке данных',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.error.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            !snapshot.data!.values.any((dateData) =>
                                dateData.containsKey(_selectedUnitType))) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.analytics_outlined,
                                    size: 64,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha((255 * 0.5).toInt()),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Нет данных за выбранный период',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Text(
                                      'Попробуйте выбрать другой временной интервал или тип единиц измерения',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return _buildStats(snapshot.data!);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите период',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    label: 'От',
                    date: _startDate,
                    onPressed: () => _selectDate(true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateButton(
                    label: 'До',
                    date: _endDate,
                    onPressed: () => _selectDate(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickDateChip('7 дней', 7),
                  _buildQuickDateChip('30 дней', 30),
                  _buildQuickDateChip('3 месяца', 90),
                  _buildQuickDateChip('6 месяцев', 180),
                  _buildQuickDateChip('1 год', 365),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd.MM.yyyy').format(date),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateChip(String label, int days) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        onPressed: () {
          setState(() {
            _endDate = DateTime.now();
            _startDate = _endDate.subtract(Duration(days: days));
          });
          _refreshData();
        },
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate =
              picked.add(const Duration(hours: 23, minutes: 59, seconds: 59));
        }
      });
      _refreshData();
    }
  }

  Widget _buildProductPicker() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите продукт',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: AppDatabase.instance.getUniqueProductsWithTransactions(
                _startDate,
                _endDate,
              ),
              builder: (context, historicalProductsSnapshot) {
                if (!historicalProductsSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final historicalProducts = historicalProductsSnapshot.data!;

                return DropdownButtonFormField<String?>(
                  value: _selectedProduct,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  hint: const Text('Все продукты'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Все продукты'),
                    ),
                    ...historicalProducts.map((product) {
                      return DropdownMenuItem<String?>(
                        value: product['name'] as String,
                        child: Text(product['name'] as String),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProduct = newValue;
                    });
                    _refreshData();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitTypePicker() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Тип измерения',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              key: ValueKey(_selectedUnitType),
              segments: _unitLabels.entries.map((entry) {
                return ButtonSegment<String>(
                  value: entry.key,
                  label: Text(entry.value),
                );
              }).toList(),
              selected: {_selectedUnitType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedUnitType = newSelection.first;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withAlpha((255 * 0.2).toInt());
                    }
                    return null;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.primary;
                    }
                    return Theme.of(context).colorScheme.onSurface;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Map<DateTime, Map<String, Map<String, dynamic>>> data) {
    final Map<String, String> transactionLabels = {
      'replenishment': 'Пополнение',
      'deletion': 'Удаление',
      'expense': 'Расход',
    };

    final String titleSuffix =
        _selectedProduct != null ? ' - $_selectedProduct' : '';

    return Column(
      children: [
        _buildSummaryCards(data, titleSuffix),
        ...transactionLabels.entries.map((entry) {
          return _buildChartCard(
            data,
            entry.key,
            '${entry.value}$titleSuffix',
          );
        }),
      ],
    );
  }

  Widget _buildSummaryCards(
    Map<DateTime, Map<String, Map<String, dynamic>>> data,
    String titleSuffix,
  ) {
    final summary = _calculateSummary(data);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Общая статистика$titleSuffix (${_unitLabels[_selectedUnitType]})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Пополнение',
                  summary['replenishment']?.toStringAsFixed(1) ?? '0',
                  Icons.add_circle_outline,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Удаление',
                  summary['deletion']?.toStringAsFixed(1) ?? '0',
                  Icons.remove_circle_outline,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Расход',
                  summary['expense']?.toStringAsFixed(1) ?? '0',
                  Icons.shopping_cart_outlined,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateSummary(
      Map<DateTime, Map<String, Map<String, dynamic>>> data) {
    final Map<String, double> summary = {
      'replenishment': 0,
      'deletion': 0,
      'expense': 0,
    };

    data.forEach((_, unitTypeData) {
      if (unitTypeData.containsKey(_selectedUnitType)) {
        final transactionData = unitTypeData[_selectedUnitType]!;
        transactionData.forEach((type, amount) {
          summary[type] = (summary[type] ?? 0) + (amount as double);
        });
      }
    });

    return summary;
  }

  Widget _buildChartCard(
    Map<DateTime, Map<String, Map<String, dynamic>>> data,
    String transactionType,
    String title,
  ) {
    List<Map<String, dynamic>> chartData = [];

    data.forEach((date, unitTypeData) {
      if (unitTypeData.containsKey(_selectedUnitType)) {
        final amount =
            unitTypeData[_selectedUnitType]![transactionType] as double;
        chartData.add({
          'date': date,
          'amount': amount,
        });
      }
    });

    if (chartData.isEmpty) return const SizedBox.shrink();

    // Sort data by date
    chartData.sort((a, b) => (a['date'] as DateTime).compareTo(b['date']));

    // Define colors for different transaction types
    final Color chartColor = switch (transactionType) {
      'replenishment' => Colors.green,
      'deletion' => Colors.red,
      'expense' => Colors.orange,
      _ => Colors.blue,
    };

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  intervalType: DateTimeIntervalType.auto,
                  dateFormat: DateFormat('dd.MM'),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: const NumericAxis(
                  axisLine: AxisLine(width: 0),
                  labelFormat: '{value}',
                  majorTickLines: MajorTickLines(size: 0),
                ),
                series: [
                  LineSeries<Map<String, dynamic>, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['date'],
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        data['amount'],
                    name: title,
                    color: chartColor,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      height: 8,
                      width: 8,
                      color: chartColor,
                      borderColor: chartColor,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(color: chartColor),
                    ),
                  ),
                ],
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                  alignment: ChartAlignment.center,
                  toggleSeriesVisibility: true,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x: point.y ${_unitLabels[_selectedUnitType]}',
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
