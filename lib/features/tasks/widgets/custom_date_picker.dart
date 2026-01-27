import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Map<String, int> monthlyTasks; // Map of date (YYYY-MM-DD) to task count

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.monthlyTasks = const {},
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();

  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    Map<String, int> monthlyTasks = const {},
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        monthlyTasks: monthlyTasks,
      ),
    );
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasTasks(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final count = widget.monthlyTasks[dateStr] ?? 0;
    return count > 0;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday

    final days = <DateTime>[];

    // Add days from previous month to fill the first week
    final daysBefore = (firstWeekday - 1) % 7;
    if (daysBefore > 0) {
      final prevMonth = DateTime(month.year, month.month - 1);
      final prevMonthLastDay = DateTime(month.year, month.month, 0).day;
      for (int i = prevMonthLastDay - daysBefore + 1; i <= prevMonthLastDay; i++) {
        days.add(DateTime(prevMonth.year, prevMonth.month, i));
      }
    }

    // Add days of current month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Add days from next month to fill the last week
    final totalDays = days.length;
    final remainingDays = 42 - totalDays; // 6 weeks * 7 days
    if (remainingDays > 0) {
      for (int i = 1; i <= remainingDays; i++) {
        days.add(DateTime(month.year, month.month + 1, i));
      }
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_currentMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Weekday headers
            Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final date = days[index];
                final isCurrentMonthDay = date.month == _currentMonth.month;
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());
                final hasTasks = _hasTasks(date);

                final isEnabled = date.isAfter(widget.firstDate.subtract(const Duration(days: 1))) &&
                    date.isBefore(widget.lastDate.add(const Duration(days: 1)));

                return GestureDetector(
                  onTap: isEnabled && isCurrentMonthDay
                      ? () {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue
                          : isToday
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonthDay
                                    ? Colors.black
                                    : Colors.grey,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (hasTasks && isCurrentMonthDay)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 2,
                            width: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFACC15), // Yellow color like web
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_selectedDate),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

