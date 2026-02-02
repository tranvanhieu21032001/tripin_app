import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Avatar + name
            const CircleAvatar(
              radius: 40,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/200?img=8'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Billy Jeans',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 32),
            // Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _settingRow(
                    icon: SvgPicture.asset(AppVector.user),
                    label: 'Edit Profile',
                    showChevron: true,
                  ),
                  const SizedBox(height: 16),
                  _settingRow(
                    icon: null,
                    label: 'Notifications',
                    showChevron: true,
                  ),
                  const SizedBox(height: 16),
                  _settingRow(
                    icon: null,
                    label: 'Need Help',
                    showChevron: true,
                  ),
                  const SizedBox(height: 16),
                  _settingRow(
                    icon: null,
                    label: 'Share',
                    showChevron: true,
                  ),
                  const SizedBox(height: 24),
                  _settingRow(
                    icon: null,
                    label: 'Log out',
                    showChevron: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _settingRow({
  required String label,
  Widget? icon,
  bool showChevron = false,
}) {
  return Row(
    children: [
      if (icon != null) ...[
        icon,
        const SizedBox(width: 10),
      ],
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      if (showChevron)
       SvgPicture.asset(AppVector.next),
    ],
  );
}


