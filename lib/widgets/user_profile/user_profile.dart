import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';

class UserProfile extends StatelessWidget {
  final String? name;
  final double radius;
  final double fontSize;
  final String? backgroundUrl;
  final EdgeInsetsGeometry padding;
  final bool showClose;
  final VoidCallback? onClose;
  final Color? closeColor;

  const UserProfile({
    super.key,
    this.name,
    this.radius = 18,
    this.fontSize = 16,
    this.backgroundUrl,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.showClose = false,
    this.onClose,
    this.closeColor,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (backgroundUrl != null && backgroundUrl!.startsWith('http')) {
      backgroundImage = NetworkImage(backgroundUrl!);
    } else {
      backgroundImage = const AssetImage(AppImages.avatar);
    }

    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: backgroundImage,
        ),
        if (showClose)
          Positioned(
            right: -2,
            top: -2,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: radius * 0.72,
                height: radius * 0.72,
                decoration: BoxDecoration(
                  color: closeColor ?? Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );

    return Padding(
      padding: padding,
      child: Row(
        children: [
          avatar,
          if (name != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name!,
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
