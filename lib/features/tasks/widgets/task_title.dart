import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  final String title;
  final int? checked;
  final int? total;
  final bool done;
  final VoidCallback? onTap;
  final double fontSize;

  const TaskTitle({
    super.key,
    required this.title,
    required this.done,
    this.checked,
    this.total,
    this.onTap,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final String display = (checked != null && total != null)
        ? '$title (${checked!}/$total)'
        : title;

    final text = Text(
      display,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        decoration: done ? TextDecoration.lineThrough : null,
      ),
    );

    if (onTap == null) return text;

    return InkWell(
      onTap: onTap,
      child: text,
    );
  }
}

