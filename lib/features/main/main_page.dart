import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/messages/pages/list_messages_page.dart';
import 'package:wemu_team_app/features/Trips/trips_page.dart';
import 'package:wemu_team_app/features/settings/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    ListMessagesPage(),
    TripsPage(),
    SettingsPage(),
  ];

  Widget _navIcon({String? svgAsset, IconData? iconData, required bool isActive}) {
  final Color color = isActive ? AppColors.navActive : AppColors.gray;
  const double iconSize = 30; 

  final Widget iconWidget;
  if (svgAsset != null) {
    iconWidget = SvgPicture.asset(
      svgAsset,
      width: iconSize,
      height: iconSize,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  } else if (iconData != null) {
    iconWidget = Icon(
      iconData,
      color: color,
      size: iconSize,
    );
  } else {
    iconWidget = const SizedBox.shrink();
  }
  return iconWidget;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: _navIcon(svgAsset: AppVector.message, isActive: _currentIndex == 0), label: ""),
          BottomNavigationBarItem(
              icon: _navIcon(svgAsset: AppVector.trip, isActive: _currentIndex == 1), label: ""),
          BottomNavigationBarItem(
              icon: _navIcon(svgAsset: AppVector.setting, isActive: _currentIndex == 2), label: ""),
        ],
      ),
    );
  }
}
