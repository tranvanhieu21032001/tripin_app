import '../../data/models/timesheet_item.dart';

abstract class TimesheetRepository {
  Future<List<TimesheetItem>> fetchTimesheets({
    required List<String> branchIds,
    required DateTime start,
    required DateTime end,
    String mode = 'daily',
    int page = 0,
    String timezone = 'Asia/Saigon',
  });

  List<TimesheetItem> getCachedTimesheets();

  Future<void> createTimesheet({
    required String employeeId,
    required DateTime clockInTime,
    DateTime? clockOutTime,
    DateTime? breakStart,
    DateTime? breakEnd,
    String? notes,
    String? branchId,
    String status = 'approved',
  });
}
