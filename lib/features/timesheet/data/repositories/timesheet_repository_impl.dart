import 'package:injectable/injectable.dart';

import '../../domain/repositories/timesheet_repository.dart';
import '../datasources/timesheet_local_data_source.dart';
import '../datasources/timesheet_remote_data_source.dart';
import '../models/timesheet_item.dart';

@LazySingleton(as: TimesheetRepository)
class TimesheetRepositoryImpl implements TimesheetRepository {
  final TimesheetRemoteDataSource _remote;
  final TimesheetLocalDataSource _local;

  TimesheetRepositoryImpl(this._remote, this._local);

  @override
  Future<List<TimesheetItem>> fetchTimesheets({
    required List<String> branchIds,
    required DateTime start,
    required DateTime end,
    String mode = 'daily',
    int page = 0,
    String timezone = 'Asia/Saigon',
  }) async {
    final timesheets = await _remote.fetchTimesheets(
      branchIds: branchIds,
      start: start,
      end: end,
      mode: mode,
      page: page,
      timezone: timezone,
    );
    await _local.saveTimesheets(timesheets);
    return timesheets;
  }

  @override
  List<TimesheetItem> getCachedTimesheets() => _local.getCachedTimesheets();

  @override
  Future<void> createTimesheet({
    required String employeeId,
    required DateTime clockInTime,
    DateTime? clockOutTime,
    DateTime? breakStart,
    DateTime? breakEnd,
    String? notes,
    String? branchId,
    String status = 'approved',
  }) {
    return _remote.createTimesheet(
      employeeId: employeeId,
      clockInTime: clockInTime,
      clockOutTime: clockOutTime,
      breakStart: breakStart,
      breakEnd: breakEnd,
      notes: notes,
      branchId: branchId,
      status: status,
    );
  }
}
