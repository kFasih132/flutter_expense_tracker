import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:flutter_expense_traker/widgets/round_container.dart';

class RoundPercentageBar extends StatefulWidget {
  const RoundPercentageBar({
    super.key,
    required this.percentage,
    required this.color,
    required this.width,
  });
  final double percentage;
  final Color color;
  final double width;
  double get getPecentage => percentage;

  @override
  State<RoundPercentageBar> createState() => _RoundPercentageBarState();
}

class _RoundPercentageBarState extends State<RoundPercentageBar> {
  @override
  Widget build(BuildContext context) {
    var percentage = widget.percentage / 100;

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: widget.width * percentage,
            child: RoundContainer(
              height: double.infinity,
              color: widget.color,
              radius: 8,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.percentage}',
              style: TextStyle(
                color: Theme.of(context).colorTheme.lightGreyColor,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${100 - widget.percentage}'),
          ),
        ),
      ],
    );
  }
}
