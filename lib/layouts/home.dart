import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/database/db.dart';
import 'package:flutter_expense_traker/widgets/round_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          MySliverAppeBar(name: 'Flutter'),
          SliverToBoxAdapter(child: _StatsCard()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text('List item $index')),
            ),
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
        titlePadding: const EdgeInsets.all(0.0),
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

class _StatsCard extends StatefulWidget {
  const _StatsCard({super.key});

  @override
  State<_StatsCard> createState() => __StatsCardState();
}

class __StatsCardState extends State<_StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('outcome', style: Theme.of(context).textTheme.titleMedium),
            Text('120000', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: 200,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 120,
                          color: Colors.red,
                          width: 20,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ],
                  gridData: FlGridData(show: false),
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.decelerate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
