import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:flutter_expense_traker/widgets/round_percentage_bar.dart';
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
                    text: '100\n',
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
              //TODO : Replace with actual month and year
              'april 2020',
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
                percentage: 80,
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
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  //TODO: add realDAta to the pie chart and remove the hardcoded values also add badge into it
  showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 140.0 : 130.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorTheme.lightBlueColor,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorTheme.orangeColor,
            value: 20,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.lightBlue,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.indigoAccent,
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purpleAccent,
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
