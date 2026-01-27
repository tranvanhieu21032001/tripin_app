import 'package:injectable/injectable.dart';

import '../repositories/timesheet_repository.dart';

@injectable
class CreateTimesheetUseCase {
  final TimesheetRepository _repository;

  CreateTimesheetUseCase(this._repository);

  Future<void> call({
    required String employeeId,
    required DateTime clockInTime,
    DateTime? clockOutTime,
    DateTime? breakStart,
    DateTime? breakEnd,
    String? notes,
    String? branchId,
    String status = 'approved',
  }) {
    return _repository.createTimesheet(
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

