import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class CircleCheck extends StatelessWidget {
  final bool done;
  final VoidCallback onTap;
  final double size;
  final double borderWidth;

  const CircleCheck({
    super.key,
    required this.done,
    required this.onTap,
    this.size = 24,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? const Color(0xFFBFEBCB) : Colors.transparent,
          border: Border.all(color: const Color(0xFF9E9E9E), width: borderWidth),
        ),
        child: done
            ? const Icon(Icons.check, color: AppColors.black, size: 14)
            : null,
      ),
    );
  }
}

