import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class BasicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  /// Use [child] for custom text styles (e.g. multiple lines/sizes).
  /// If you just need a simple label, pass `child: Text('...')`.
  ///
  /// NOTE: `title` is kept for backward compatibility.
  final String? title;
  final double? height;

  /// Text color of the button label.
  /// If null, it will fallback to theme/default.
  final Color? textColor;

  /// Background color of the button.
  /// If null, it will fallback to theme/default.
  final Color? backgroundColor;

  /// Icon to display before the text.
  final IconData? icon;

  /// Custom icon widget to display before the text (e.g. SvgPicture).
  /// If provided, it takes precedence over [icon].
  final Widget? iconWidget;

  /// Icon size. Defaults to 24.
  final double? iconSize;

  /// Border radius of the button. Defaults to 4.
  final double? borderRadius;

  const BasicButton({
    required this.onPressed,
    required this.height,
    this.title,
    this.child = const SizedBox.shrink(),
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconWidget,
    this.iconSize,
    this.borderRadius,
    super.key,
  }) : assert(title != null || child is! SizedBox,
            'Provide either title or child to BasicButton');

  @override
  Widget build(BuildContext context) {
    final hasIcon = iconWidget != null || icon != null;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 45),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 40),
        ),
        elevation: 0,
      ),
      child: hasIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconWidget != null) iconWidget! else Icon(icon, size: iconSize ?? 24),
                const SizedBox(width: 12),
                title != null
                    ? Text(
                        title!,
                        style: TextStyle(color: textColor ?? AppColors.white),
                      )
                    : DefaultTextStyle.merge(
                        style: TextStyle(color: textColor ?? AppColors.white),
                        child: child,
                      ),
              ],
            )
          : title != null
              ? Text(
                  title!,
                  style: TextStyle(color: textColor ?? AppColors.white),
                )
              : DefaultTextStyle.merge(
                  style: TextStyle(color: textColor ?? AppColors.white),
                  child: child,
                ),
    );
  }
}
