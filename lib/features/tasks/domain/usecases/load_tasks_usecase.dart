import 'package:injectable/injectable.dart';

import '../../data/models/task_item.dart';
import '../repositories/tasks_repository.dart';

@injectable
class LoadTasksUseCase {
  final TasksRepository _repository;

  LoadTasksUseCase(this._repository);

  Future<List<TaskItem>> call({
    required String employeeId,
    List<String>? branchIds,
    int limit = 10,
    int page = 0,
  }) {
    return _repository.fetchTasks(
      employeeId: employeeId,
      branchIds: branchIds,
      limit: limit,
      page: page,
    );
  }
}
