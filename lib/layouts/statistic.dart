import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
import 'package:flutter_expense_traker/provider/trrasaction_provider.dart';
import 'package:flutter_expense_traker/provider/user_provider.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:flutter_expense_traker/widgets/badge_widget.dart';
import 'package:flutter_expense_traker/widgets/round_percentage_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateTime today = DateTime.now();
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Handle the day selection logic here
    setState(() {
      // Update the selected day and focused day
      // This is where you can implement your logic to handle the selected day
      today = selectedDay;
      print('Selected day: $selectedDay, Focused day: $focusedDay');
    });
    print('Selected day: $selectedDay');
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              //Calendar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorTheme.lightGreyColor,
                ),
                padding: const EdgeInsets.all(12.0),
                child: TableCalendar(
                  locale: 'en_US',
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(Icons.chevron_left),
                    rightChevronIcon: Icon(Icons.chevron_right),
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: today,
                  firstDay: DateTime.utc(2000),
                  lastDay: DateTime.utc(2100),
                  onDaySelected: onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  pageAnimationEnabled: true,
                  pageAnimationDuration: Duration(milliseconds: 200),
                  formatAnimationCurve: Curves.bounceIn,
                ),
              ),

              const SizedBox(height: 20),

              // Statistics Section
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     RoundContainer(
              //       color: Theme.of(context).colorTheme.lightBlueColor,
              //       radius: 16,
              //       padding: 20,
              //       child: Column(
              //         spacing: 8,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [Text('Total Income'), Text('10000')],
              //       ),
              //     ),
              //     RoundContainer(
              //       color: Theme.of(context).colorTheme.orangeColor,
              //       radius: 16,
              //       padding: 20,
              //       child: Column(
              //         spacing: 8,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [Text('Total Expence'), Text('10000')],
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 30),

              PercentageWidget(),
              const SizedBox(height: 60),
              PieChartWidget(), const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: Implement the PercentageWidget to show a percentage of income vs expense
class PercentageWidget extends StatelessWidget {
  const PercentageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpense = 0;

    var transactionProvider = context.watch<TransactionProvider>();
    transactionProvider.loadTransactionsForCurrentMonth();
    transactionProvider.transactions.forEach((element) {
      if (element.transactionType == Transactions.income) {
        totalIncome += element.amount ?? 0;
      } else if (element.transactionType == Transactions.expense) {
        totalExpense += element.amount ?? 0;
      }
    });
    var percentage = (totalExpense / totalIncome) * 100;
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorTheme.lightGreyColor,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: 'You have spend ',
                style: TextStyle(
                  color: Theme.of(context).colorTheme.darkPurpleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '${totalExpense.toStringAsFixed(1)}\n',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorTheme.orangeColor,
                    ),
                  ),
                  TextSpan(text: 'this month'),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              DateFormat.yMMM().format(DateTime.now()),
              style: TextStyle(
                color: Theme.of(context).colorTheme.darkGreyColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              height: 32,
              child: RoundPercentageBar(
                color: Theme.of(context).colorTheme.lightBlueColor,
                percentage: percentage,
                width: 335,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = 0;
  void onPieTouchCallback(FlTouchEvent event, pieTouchResponse) {
    setState(() {
      if (!event.isInterestedForInteractions ||
          pieTouchResponse == null ||
          pieTouchResponse.touchedSection == null) {
        touchedIndex = -1;
        return;
      }
      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(touchCallback: onPieTouchCallback),
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(context),
          ),
        ),
      ),
    );
  }

  //TODO: add realDAta to the pie chart and remove the hardcoded values also add badge into it
  showingSections(BuildContext context) {
    return List.generate(5, (i) {
      double totalIncome = 0;
      double totalExpense = 0;

      var transactionProvider = context.watch<TransactionProvider>();
      transactionProvider.loadTransactionsForCurrentMonth();
      transactionProvider.transactions.forEach((element) {
        if (element.transactionType == Transactions.income) {
          totalIncome += element.amount ?? 0;
        } else if (element.transactionType == Transactions.expense) {
          totalExpense += element.amount ?? 0;
        }
      });
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 140.0 : 130.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      double foodPercentage = getCategoryPercentage(
        transactions: transactionProvider.transactions,
        categoryId: 'cat_food',
        totalExpence: totalExpense,
      );
      double transportPercentage = getCategoryPercentage(
        transactions: transactionProvider.transactions,
        categoryId: 'cat_transport',
        totalExpence: totalExpense,
      );
       double utilitiesPercentage = getCategoryPercentage(
        transactions: transactionProvider.transactions,
        categoryId:  'cat_utilities',
        totalExpence: totalExpense,
      );
      double entertainmentPercentage = getCategoryPercentage(
        transactions: transactionProvider.transactions,
        categoryId:  'cat_entertainment',
        totalExpence: totalExpense,
      );
      double otherPercentage = getCategoryPercentage(
        transactions: transactionProvider.transactions,
        categoryId:  'cat_other',
        totalExpence: totalExpense,
      );

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorTheme.lightBlueColor,
            value: foodPercentage,
            title: '${foodPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: MyBadge(size: 36, svgAsset: 'assets/popcorn.png'),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorTheme.orangeColor,
            value: transportPercentage,
            title: '${transportPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: MyBadge(
              size: 36,
              svgAsset: 'assets/delivery-truck.png',
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.lightBlue,
            value: utilitiesPercentage,
            title: '${utilitiesPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: MyBadge(size: 36, svgAsset: 'assets/utility.png'),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.indigoAccent,
            value: entertainmentPercentage,
            title: '${entertainmentPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: MyBadge(size: 36, svgAsset: 'assets/content.png'),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purpleAccent,
            value: otherPercentage,
            title: '${otherPercentage.toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: MyBadge(size: 36, svgAsset: 'assets/delivery-box.png'),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Error();
      }
    });
  }
}

double getCategoryPercentage({
  required List<Transactions> transactions,
  required String categoryId,
  required double totalExpence,
}) {
  double amount = 0;
  transactions.forEach((element) {
    if (element.categoryId == categoryId) {
      if (element.transactionType == Transactions.expense) {
        amount += element.amount ?? 0;
      }
    }
  });
  
  return (amount / totalExpence) * 100;
}
