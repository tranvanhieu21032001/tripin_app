import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 64,
    this.height = 32,
    this.showOffLabel = true,
    this.offLabel = 'OFF',
    this.offLabelStyle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// Total width of the switch track.
  final double width;

  /// Total height of the switch track.
  final double height;

  /// Show "OFF" label when [value] is false.
  final bool showOffLabel;

  final String offLabel;
  final TextStyle? offLabelStyle;

  @override
  Widget build(BuildContext context) {
    final trackColor = value ? AppColors.primary : const Color(0xFFE6E6E6);
    final borderColor = value ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFCCCCCC);

    final padding = height * 0.12; // keeps thumb nicely centered for various sizes
    final thumbSize = height - (padding * 2);

    return Semantics(
      toggled: value,
      button: true,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: width,
          height: height,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(height),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Stack(
            children: [
              if (!value && showOffLabel)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: padding * 0.8),
                      child: Text(
                        offLabel,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: offLabelStyle ??
                            const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                              letterSpacing: 0.4,
                            ),
                      ),
                    ),
                  ),
                ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



