import 'package:flutter/material.dart';
import 'package:wemu_team_app/core/configs/theme/app_colors.dart';

class DateTimeStartEnd extends StatelessWidget {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;
  final DateTime? minDate;

  final bool isOutLine;
  final bool showIcons;

  const DateTimeStartEnd({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.onDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
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

  Future<void> _selectTime(
    BuildContext context, {
    required TimeOfDay current,
    required ValueChanged<TimeOfDay> onChanged,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: current,
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          children: [
            Expanded(
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  color: AppColors.black,
                ),
              ),
            ),
            if (showIcons)
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
    BuildContext context, {
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return GestureDetector(
      onTap: () => _selectTime(context, current: time, onChanged: onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          children: [
            Expanded(
              child: Text(
                _formatTime(time),
                style: const TextStyle(
                  color: AppColors.black,
                ),
              ),
            ),
            if (showIcons)
              const Icon(
                Icons.access_time,
                size: 18,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              flex: 4,
              child: Text(
                'Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                'Start',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                'End',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 4, // 2/5 width approximately
              child: _buildDateField(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3, // part of remaining 3/5
              child: _buildTimeField(
                context,
                time: startTime,
                onChanged: onStartTimeChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3, // part of remaining 3/5
              child: _buildTimeField(
                context,
                time: endTime,
                onChanged: onEndTimeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


