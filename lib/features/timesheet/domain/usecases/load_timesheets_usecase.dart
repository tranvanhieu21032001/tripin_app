import 'package:injectable/injectable.dart';

import '../../data/models/timesheet_item.dart';
import '../repositories/timesheet_repository.dart';

@injectable
class LoadTimesheetsUseCase {
  final TimesheetRepository _repository;

  LoadTimesheetsUseCase(this._repository);

  Future<List<TimesheetItem>> call({
    required List<String> branchIds,
    required DateTime start,
    required DateTime end,
    String mode = 'daily',
    int page = 0,
    String timezone = 'Asia/Saigon',
  }) {
    return _repository.fetchTimesheets(
      branchIds: branchIds,
      start: start,
      end: end,
      mode: mode,
      page: page,
      timezone: timezone,
    );
  }
}
