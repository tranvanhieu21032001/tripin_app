import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import '../presentation/bloc/tasks_cubit.dart';

class TaskDatePicker extends StatefulWidget {
  const TaskDatePicker({super.key, required this.initialDate, required this.onSelected});

  final DateTime initialDate;
  final void Function(DateTime) onSelected;

  @override
  State<TaskDatePicker> createState() => _TaskDatePickerState();
}

class _TaskDatePickerState extends State<TaskDatePicker> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    final tasksPerDay = tasksCubit.tasksPerDay;

    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blue,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blue,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final String key = DateFormat('yyyy-MM-dd').format(day);
          final bool hasTasks = tasksPerDay[key] != null && tasksPerDay[key]! > 0;

          final text = Text(
            '${day.day}',
            style: const TextStyle(color: Colors.black),
          );

          if (hasTasks) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.blue, width: 2),
                ),
              ),
              alignment: Alignment.center,
              child: text,
            );
          }
          return Center(child: text);
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onSelected(selectedDay);
      },
    );
  }
}
