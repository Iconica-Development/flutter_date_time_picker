import 'package:flutter/material.dart';

/// `MarkedIcon` is a StatelessWidget that represents a marked icon.
/// It provides a colored circular icon that can be used to indicate a marked state.
class MarkedIcon extends StatelessWidget {
  /// Creates a new instance of `MarkedIcon`.
  ///
  /// The [width] and [height] parameters must not be null.
  ///
  /// * [width]: The width of the icon.
  /// * [height]: The height of the icon.
  /// * [color]: The color of the icon. If null, the indicator color from the current theme is used.
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
