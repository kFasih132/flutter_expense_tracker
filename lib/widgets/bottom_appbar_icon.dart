import 'package:flutter/material.dart';

class BottomAppbarIcon extends StatefulWidget {
  const BottomAppbarIcon({
    super.key,
    required this.icon,
    this.color,
    this.selectedColor,
    this.size,
    this.isfocused = false,
    this.duration = const Duration(milliseconds: 300),
  });
  final IconData icon;
  final Color? color;
  final Color? selectedColor;
  final double? size;
  final bool isfocused;
  final Duration duration;

  @override
  State<BottomAppbarIcon> createState() => _BottomAppbarIconState();
}

class _BottomAppbarIconState extends State<BottomAppbarIcon> {
  @override
  void didUpdateWidget(covariant BottomAppbarIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isfocused != widget.isfocused) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: widget.duration,
      scale: widget.isfocused ? 1.3 : 1.0,
      child: Icon(
        widget.icon,
        color: widget.isfocused ? widget.selectedColor : widget.color,
        size: widget.size,
      ),
    );
  }
}
