import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
import 'package:flutter_expense_traker/layouts/profile.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart'; // Ensure your Transactions model is imported
// You might also need to import your custom theme if 'colorTheme' is a custom extension
// import 'package:flutter_expense_traker/theme/my_custom_theme.dart'; // Example

class StatsCard2 extends StatefulWidget {
  const StatsCard2({super.key});

  @override
  State<StatsCard2> createState() => _StatsCard2State();
}

class _StatsCard2State extends State<StatsCard2> {
  // IMPORTANT: Replace with the actual current user's ID.
  // This could come from a UserProvider, arguments passed to the widget, or an auth service.
  final String currentUserId = userId; // TODO: Get actual user ID

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  // Map to store daily expenses: Key is date string (YYYY-MM-DD), Value is total expense
  Map<String, double> _dailyExpenses = {};
  double _totalOutcome = 0.0; // To store the sum of expenses for display
  double _totalBalance = 0.0; // To store the total remaining balance
  bool _isLoading = true; // To show a loading indicator

  @override
  void initState() {
    super.initState();
    _loadChartData(); // Load data when the widget initializes
  }

  // Helper function to format DateTime to a consistent date string (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Function to fetch and process all necessary data for the chart and totals
  Future<void> _loadChartData() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    final DbService dbService = DbService();
    List<Transactions> allTransactions = await dbService.getAllTransactions();

    // 1. Process data for the bar chart (last 7 days expenses)
    DateTime today = DateTime.now();
    Map<String, double> expensesByDay = {};

    // Initialize daily expenses for the last 7 days to 0.0
    for (int i = 6; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      String formattedDate = _formatDate(date);
      expensesByDay[formattedDate] = 0.0;
    }

    double currentTotalOutcome = 0.0;
    double totalIncome = 0.0;

    for (var transaction in allTransactions) {
      // Ensure transactionDate is not null and it belongs to the current user
      if (transaction.date != null && transaction.userId == currentUserId) {
        DateTime transactionDay = transaction.date!;
        String formattedTransactionDate = _formatDate(transactionDay);

        if (transaction.transactionType == 'expense') {
          // Aggregate for bar chart (only if within the last 7 days)
          if (expensesByDay.containsKey(formattedTransactionDate)) {
            expensesByDay[formattedTransactionDate] =
                (expensesByDay[formattedTransactionDate] ?? 0.0) +
                transaction.amount!;
          }
          // Aggregate for overall total outcome (all expenses for the user)
          currentTotalOutcome += transaction.amount!;
        } else if (transaction.transactionType == 'income') {
          // Aggregate for total income (all income for the user)
          totalIncome += transaction.amount!;
        }
        // Add other transaction types (e.g., 'transfer') if they affect balance
      }
    }

    // You might need to fetch the user's initial balance to calculate the total balance
    // For a more complete solution, fetch the User object and its initialBalance
    // User? user = await dbService.getUserById(currentUserId);
    // double initialUserBalance = user?.initialBalance ?? 0.0;
    // _totalBalance = initialUserBalance + totalIncome - currentTotalOutcome;
    _totalBalance = totalIncome - currentTotalOutcome; // Simplified example

    setState(() {
      _dailyExpenses = expensesByDay;
      _totalOutcome = currentTotalOutcome;
      _isLoading = false; // Data loaded, turn off loading state
    });
  }

  // Helper function to create a single BarChartGroupData
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
    Color? barBackgroundColor, // This parameter is now used
    Color? touchedBarColor, // This parameter is now used
  }) {
    // Default colors if not provided, or fallback to Theme colors
    barColor ??= Theme.of(context).colorScheme.primary;
    touchedBarColor ??= Colors.lightBlueAccent;
    barBackgroundColor ??= Colors.grey.withOpacity(
      0.2,
    ); // Default for background rod

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY:
              isTouched
                  ? y + (y * 0.1)
                  : y, // Slightly increase height on touch
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide:
              isTouched
                  ? const BorderSide(
                    color: Colors.yellow,
                    width: 2,
                  ) // Yellow border on touch
                  : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            // BackDrawRodData is now active
            show: true,
            toY:
                _dailyExpenses.values.isEmpty
                    ? 20.0 // Default background height if no data
                    : (_dailyExpenses.values.reduce((a, b) => a > b ? a : b) *
                        1.2), // Dynamic background height
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  // This function generates a list of BarChartGroupData for the bar chart from actual data.
  List<BarChartGroupData> showingGroups() {
    if (_isLoading) {
      return []; // Return empty if data is still loading
    }

    // Get the dates for the last 7 days, ensuring the order for the x-axis
    DateTime today = DateTime.now();
    List<DateTime> last7Days = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    // Assuming Theme.of(context).colorTheme is defined as a custom ThemeExtension
    var barColor = Theme.of(context).colorTheme.orangeColor;
    // You might define a touchedBarColor here as well, or let it fallback in makeGroupData
    var touchedBarColor = Colors.lightBlueAccent;

    return List.generate(7, (i) {
      String dateKey = _formatDate(last7Days[i]);
      double yValue =
          _dailyExpenses[dateKey] ??
          0.0; // Get expense for the day, default to 0.0

      return makeGroupData(
        i, // x-axis index
        yValue, // y-axis value
        barColor: barColor,
        touchedBarColor: touchedBarColor,
        isTouched: i == touchedIndex,
      );
    });
  }

  // This function returns the main BarChartData object that contains all the configurations for the bar chart.
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            // Map the x-axis index to a day name (adjust if your week starts on Sunday)
            switch (group.x.toInt()) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error(); // Should not happen with 0-6 indices
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY).toStringAsFixed(
                    2,
                  ), // Format to 2 decimal places
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                getBottomTitles, // Now refers to the new getBottomTitles function
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(), // This now uses your Hive data
      gridData: const FlGridData(show: false),
      maxY:
          _dailyExpenses.values.isEmpty
              ? 10.0 // Default max Y if no data
              : _dailyExpenses.values.reduce((a, b) => a > b ? a : b) *
                  1.2, // Dynamic max Y
    );
  }

  // Function to provide titles for the bottom axis (days of the week)
  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    // Adjust these labels if your week starts on Sunday (e.g., case 0: 'SUN')
    switch (value.toInt()) {
      case 0:
        text = const Text('MON', style: style);
        break;
      case 1:
        text = const Text('TUE', style: style);
        break;
      case 2:
        text = const Text('WED', style: style);
        break;
      case 3:
        text = const Text('THU', style: style);
        break;
      case 4:
        text = const Text('FRI', style: style);
        break;
      case 5:
        text = const Text('SAT', style: style);
        break;
      case 6:
        text = const Text('SUN', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(meta: meta, space: 16, child: text);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
          child: CircularProgressIndicator(),
        ) // Show loading spinner while fetching data
        : Card(
          // Assuming Theme.of(context).colorTheme is defined as a custom ThemeExtension
          color:
              Theme.of(
                context,
              ).colorTheme.lightGreyColor, // Retained your custom theme color
          margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Outcome', style: Theme.of(context).textTheme.titleMedium),
                // Display the total outcome (sum of expenses)
                Text(
                  _totalOutcome.toStringAsFixed(
                    2,
                  ), // Display with 2 decimal places
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16), // Changed to const for efficiency
                Text(
                  'Remaining Balance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Display the calculated total remaining balance
                Text(
                  _totalBalance.toStringAsFixed(
                    2,
                  ), // Display with 2 decimal places
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16), // Changed to const for efficiency
                SizedBox(
                  height: 200,
                  child: BarChart(
                    mainBarData(),
                    duration: animDuration,
                    curve: Curves.decelerate,
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
