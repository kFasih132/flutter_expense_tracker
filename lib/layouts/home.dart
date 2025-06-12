import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/provider/user_provider.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: CustomScrollView(
        slivers: [
          MySliverAppeBar(name: userProvider.currentUser.name),
          SliverToBoxAdapter(child: StatsCard()),
          SliverAnimatedList(
            initialItemCount: 10, // Example item count
            itemBuilder: (context, index, animation) {
              return const TransactionListTile();
            },
          ),
        ],
      ),
    ); // Using MySliverAppeBar
  }
}

// This widget is used to create a SliverAppBar with a flexible space that includes a title.
// The title is a RichText widget that displays a greeting and the name passed to the widget.
class MySliverAppeBar extends StatelessWidget {
  const MySliverAppeBar({super.key, this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0, // Adjust the height as needed
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(16.0),
        title: RichText(
          text: TextSpan(
            text: 'Hello \n',
            style: Theme.of(context).textTheme.displaySmall,
            children: [
              //TODO : add real name from database
              TextSpan(
                text: name ?? 'Unknown',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  // making function to remove  the boilerplate code for BarChartGroupData

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
    Color? barBackgroundColor,
    Color? touchedBarColor,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: const BorderSide(color: Colors.white, width: 0),
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: false,
          //   toY: 20,
          //   color: barBackgroundColor,
          // ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  //TODO: add real data from database
  // This function generates a list of BarChartGroupData for the bar chart.
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    var barColor = Theme.of(context).colorTheme.orangeColor;

    switch (i) {
      case 0:
        return makeGroupData(
          0,
          5,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 1:
        return makeGroupData(
          1,
          6.5,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 2:
        return makeGroupData(
          2,
          5,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 3:
        return makeGroupData(
          3,
          7.5,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 4:
        return makeGroupData(
          4,
          9,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 5:
        return makeGroupData(
          5,
          11.5,
          barColor: barColor,

          isTouched: i == touchedIndex,
        );
      case 6:
        return makeGroupData(
          6,
          6.5,
          barColor: barColor,
          isTouched: i == touchedIndex,
        );
      default:
        return throw Error();
    }
  });
  //TODO: add real data from database and handle the bar chart data
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
            switch (group.x) {
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
                throw Error();
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
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
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
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorTheme.lightGreyColor,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('outcome', style: Theme.of(context).textTheme.titleMedium),
            Text(
              '120000',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
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

// Below is the getTitles function that provides titles for the bottom axis of the bar chart.
Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('M', style: style);
      break;
    case 1:
      text = const Text('T', style: style);
      break;
    case 2:
      text = const Text('W', style: style);
      break;
    case 3:
      text = const Text('T', style: style);
      break;
    case 4:
      text = const Text('F', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(meta: meta, space: 16, child: text);
}

//TODO: add real data from database and handle the transaction list
// This widget represents a list tile for displaying a transaction.

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.monetization_on, size: 32)),
      title: const Text('Transaction Title'),
      subtitle: const Text('Transaction Description'),
      trailing: Column(spacing: 2, children: [Text('data'), Text('data')]),
      onTap: () {
        // Handle tap event
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tapped on Transaction')));
      },
    );
  }
}
