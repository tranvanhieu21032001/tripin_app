import 'package:injectable/injectable.dart';

import '../../data/models/task_summary.dart';
import '../repositories/tasks_repository.dart';

@injectable
class LoadTaskSummaryUseCase {
  final TasksRepository _repository;

  LoadTaskSummaryUseCase(this._repository);

  Future<TaskSummary> call({
    required String employeeId,
    List<String>? branchIds,
    DateTime? fromDate,
    DateTime? toDate,
    String? type,
  }) {
    return _repository.fetchTaskSummary(
      employeeId: employeeId,
      branchIds: branchIds,
      fromDate: fromDate,
      toDate: toDate,
      type: type,
    );
  }
}

