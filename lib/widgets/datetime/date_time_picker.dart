import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class DateTimePicker extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final DateTime? minDate;
  final bool isOutLine;
  final bool showIcons;

  const DateTimePicker({
    super.key,
    required this.label,
    this.labelColor,
    required this.date,
    required this.time,
    required this.onDateChanged,
    this.onTimeChanged,
    this.minDate,
    this.isOutLine = false,
    this.showIcons = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: minDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (onTimeChanged == null) return;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null) {
      onTimeChanged!(picked);
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: labelColor ?? AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicWidth(
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  decoration: isOutLine
                      ? BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: AppColors.lightGrey),
                          ),
                        )
                      : BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate(date),
                        style: const TextStyle(
                          color: AppColors.black,
                        ),
                      ),
                      if (showIcons)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.calendar_today, size: 18, color: AppColors.grey),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: GestureDetector(
                onTap: onTimeChanged != null ? () => _selectTime(context) : null,
                child: Opacity(
                  opacity: onTimeChanged != null ? 1.0 : 0.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: isOutLine
                        ? BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(color: AppColors.lightGrey),
                            ),
                          )
                        : BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.lightGrey),
                          ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(time),
                          style: TextStyle(
                            color: AppColors.black,
                          ),
                        ),
                        if (showIcons)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.access_time, size: 18, color: AppColors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

