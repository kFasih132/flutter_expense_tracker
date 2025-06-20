import 'package:flutter/material.dart';

class MyBadge extends StatelessWidget {
  const MyBadge({
    super.key,
    required this.svgAsset,
    required this.size,
  });
  final String svgAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: Image.asset(svgAsset)),
    );
  }
}
