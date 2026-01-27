import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/features/home/home_page.dart';
import 'package:wemu_team_app/features/timesheet/pages/timesheet_page.dart';
import 'package:wemu_team_app/features/timesheet/widgets/timesheet_action_sheet.dart';
import 'package:wemu_team_app/features/tasks/widgets/add_task_sheet.dart';
import 'package:wemu_team_app/features/tasks/pages/tasks_page.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _openAddTaskModal() async {
    final created = await AddTaskSheet.show(context: context);
    if (created == true) {
      // Refresh tasks page data after creating a task
      if (!mounted) return;
      final tasksCubit = getIt<TasksCubit>();
      await tasksCubit.loadTasks();
    }
  }

  final List<Widget> _pages = [
    const HomePage(),
    const TasksPage(),
    const TimesheetPage(),
  ];

  Widget _navIcon(String asset, bool isActive) {
    final bool isTaskOrTimesheet = asset == AppVector.task || asset == AppVector.timesheet;

    final String iconAsset = (isActive && isTaskOrTimesheet) ? AppVector.addGreen : asset;
    final bool showUnderline = isActive && !isTaskOrTimesheet;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconAsset),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 5,
          width: showUnderline ? 35 : 0,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
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
          // When user is already on Task page and taps the green add icon, open Add Task modal
          if (_currentIndex == 1 && index == 1) {
            _openAddTaskModal();
            return;
          }
          if (_currentIndex == 2 && index == 2) {
            TimesheetActionSheet.show(context);
            return;
          }
          setState(() => _currentIndex = index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed, // Important for more than 3 items
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: _navIcon(AppVector.home, _currentIndex == 0), label: ""),
          BottomNavigationBarItem(icon: _navIcon(AppVector.task, _currentIndex == 1), label: ""),
          BottomNavigationBarItem(icon: _navIcon(AppVector.timesheet, _currentIndex == 2), label: ""),
        ],
      ),
    );
  }
}
