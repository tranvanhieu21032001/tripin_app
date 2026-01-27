import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wemu_team_app/core/configs/assets/app_vector.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';
import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/timesheet/data/models/timesheet_item.dart';
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_cubit.dart';
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_state.dart';

class TimesheetPage extends StatefulWidget {
  const TimesheetPage({super.key});

  @override
  State<TimesheetPage> createState() => _TimesheetPageState();
}

class _TimesheetPageState extends State<TimesheetPage> {
  DateTime _startDate = DateTime(2024, 1, 5);
  DateTime _endDate = DateTime(2024, 1, 11);
  late final TimesheetCubit _cubit;

  DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday; // 1=Mon..7=Sun
    final d = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
    return DateTime(d.year, d.month, d.day);
  }

  DateTime _endOfWeek(DateTime date) {
    final weekday = date.weekday; // 1=Mon..7=Sun
    final d = DateTime(date.year, date.month, date.day)
        .add(Duration(days: 7 - weekday));
    return DateTime(d.year, d.month, d.day);
  }

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TimesheetCubit>();

    final now = DateTime.now();
    _startDate = _startOfWeek(now);
    _endDate = _endOfWeek(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadTimesheets(
        start: _startOfDay(_startDate),
        end: _endOfDay(_endDate),
        mode: 'weekly',
      );
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final startFormat = DateFormat('MMM d').format(start);
    final endFormat = DateFormat('d').format(end);
    return '$startFormat - $endFormat';
  }

  String _formatDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    }
    return DateFormat('EEE').format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = _startOfWeek(picked);
        _endDate = _endOfWeek(picked);
      });
      _cubit.loadTimesheets(
        start: _startOfDay(_startDate),
        end: _endOfDay(_endDate),
        mode: 'weekly',
      );
    }
  }

  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  TimesheetEntryStatus _statusFromTimesheet(TimesheetItem item) {
    switch (item.status.toLowerCase()) {
      case 'completed':
        return TimesheetEntryStatus.completed;
      case 'ongoing':
        return TimesheetEntryStatus.ongoing;
      case 'off':
        return TimesheetEntryStatus.off;
      default:
        return TimesheetEntryStatus.pending;
    }
  }

  String _timeRangeFromTimesheet(TimesheetItem item) {
    final start = item.clockinTime;
    final end = item.clockoutTime;
    if (start == null) {
      return '';
    }
    final timeFormat = DateFormat('h:mm a');
    if (end == null) {
      return timeFormat.format(start);
    }
    return '${timeFormat.format(start)} - ${timeFormat.format(end)}';
  }

  String _hoursFromTimesheet(TimesheetItem item) {
    if (item.total <= 0) {
      return '';
    }
    final hours = item.total.toDouble();
    return '${hours.toStringAsFixed(2)} hours';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<TimesheetCubit, TimesheetState>(
        listener: (context, state) {
          if (state.warningMessage != null && state.warningMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.warningMessage!)),
            );
          }
          if (state.status == TimesheetStatus.failure) {
            final message = state.errorMessage ?? 'Failed to load timesheets.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Timesheet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectDateRange(context),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppVector.task,
                                width: 24,
                                height: 24,
                                color: AppColors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _formatDateRange(_startDate, _endDate),
                                style: const TextStyle(fontSize: 16, color: AppColors.black),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.keyboard_arrow_down, size: 15, color: AppColors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Timesheet List
                  Expanded(
                    child: state.status == TimesheetStatus.loading && state.timesheets.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: state.timesheets
                                .map((item) => _buildTimesheetEntry(
                                      date: item.clockinTime ?? item.createdAt ?? DateTime.now(),
                                      timeRange: _timeRangeFromTimesheet(item),
                                      hours: _hoursFromTimesheet(item),
                                      status: _statusFromTimesheet(item),
                                    ))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimesheetEntry({
    required DateTime date,
    String? timeRange,
    String? hours,
    required TimesheetEntryStatus status,
  }) {
    final day = _formatDay(date);
    final dateStr = _formatDate(date);

    Color backgroundColor;
    Widget? statusIcon;
    Widget? content;

    switch (status) {
      case TimesheetEntryStatus.completed:
        backgroundColor = AppColors.primaryPurple;
        statusIcon = const Icon(Icons.check_box, color: AppColors.green, size: 24);
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeRange ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5340EE),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(hours ?? '', style: TextStyle(fontSize: 16, color: Color(0xFF5340EE), fontWeight: FontWeight.w700)),
          ],
        );
        break;
      case TimesheetEntryStatus.ongoing:
        backgroundColor = AppColors.amber;
        statusIcon = const Text("⏳", style: TextStyle(fontSize: 15));
        content = Text(
          timeRange ?? '',
          style: const TextStyle(fontSize: 16, color: AppColors.orange, fontWeight: FontWeight.w500),
        );
        break;
      case TimesheetEntryStatus.pending:
        backgroundColor = Colors.transparent;
        content = Text('Pending', style: TextStyle(fontSize: 16, color: AppColors.grey, fontWeight: FontWeight.w500));
        break;
      case TimesheetEntryStatus.off:
        backgroundColor = AppColors.black.withOpacity(0.2);
        content = Text('Off', style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500));
        break;
    }

    // For pending status only, show datetime above and content below (no container)
    if (status == TimesheetEntryStatus.pending) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, top:8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$day, $dateStr',
              style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500),
            ),
            content ?? const SizedBox(),
          ],
        ),
      );
    }

    // For completed, ongoing, and off, show with container
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$day, $dateStr',
            style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: content),
                if (statusIcon != null) statusIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TimesheetEntryStatus { completed, ongoing, pending, off }
