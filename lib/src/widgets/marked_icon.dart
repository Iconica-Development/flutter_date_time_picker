import 'package:flutter/material.dart';

class MarkedIcon extends StatelessWidget {
  const MarkedIcon({
    super.key,
    this.color,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IgnorePointer(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).indicatorColor,
            borderRadius: BorderRadius.circular((width) * 2),
          ),
        ),
      ),
    );
  }
}
