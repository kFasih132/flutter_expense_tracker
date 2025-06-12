import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    super.key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.margin,
    this.border,
    this.radius = 43,
    this.padding = 8,
  });
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final double radius;
  final double padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: child,
    );
  }
}

class RoundContainer2 extends StatelessWidget {
  const RoundContainer2({
    super.key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.margin,
    this.border,
    this.radius = 43, // Default radius for rounded corners
    this.padding = 8, // Default internal padding
    this.onTap, // Callback function for tap events
    this.isSelected =
        false, // Flag to indicate if the container is currently selected
  });

  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final double radius;
  final double padding;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on selection status.
    final effectiveColor =
        isSelected
            ? Colors.deepOrangeAccent
            : Theme.of(context).colorTheme.lightGreyColor;

    // Determine the text color based on selection status.
    final effectiveTextColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap, // Attach the tap handler
      child: Container(
        width: width,
        height: height,
        margin:
            margin ??
            const EdgeInsets.all(4.0), // Default margin around the container
        padding: EdgeInsets.symmetric(
          horizontal: padding * 1.5,
          vertical: padding * 0.75,
        ), // Adjust padding for pill shape
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(radius), // Apply rounded corners
          // Apply border
          boxShadow: [
            // Add a subtle shadow for elevation and visual depth
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: effectiveTextColor,
            fontWeight: FontWeight.w500, // Medium font weight
            fontSize: 16, // Font size for category text
          ),
          child:
              child ??
              const SizedBox.shrink(), // Render the child with the determined text style
        ),
      ),
    );
  }
}
