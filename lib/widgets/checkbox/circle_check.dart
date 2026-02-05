import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

/// New circular checkbox style, based on the InviteFriends selection dot.
class CircleCheck extends StatelessWidget {
  final bool done;
  final VoidCallback? onTap;
  final double size;

  const CircleCheck({
    super.key,
    required this.done,
    this.onTap,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: done ? AppColors.primary : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );

    if (onTap == null) return child;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: child,
    );
  }
}

