import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/assets/app_images.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;
  final String? backgroundUrl;
  final EdgeInsetsGeometry padding;

  const UserProfile({
    super.key,
    required this.name,
    this.radius = 18,
    this.fontSize = 16,
    this.backgroundUrl,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (backgroundUrl != null && backgroundUrl!.startsWith('http')) {
      backgroundImage = NetworkImage(backgroundUrl!);
    } else {
      backgroundImage = const AssetImage(AppImages.avatar);
    }

    return Padding(
      padding: padding,
      child: Row(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: backgroundImage,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
