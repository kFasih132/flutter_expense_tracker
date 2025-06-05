import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.radius = 43,
    this.padding = 8,
  });
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final double radius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
