import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  /// Title style (e.g. "Earnings", "Hours", "Tasks")
  final TextStyle? titleStyle;

  /// Value style (e.g. "\$3,232.00", "36", "7")
  final TextStyle? valueStyle;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    this.height = 115,
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}

