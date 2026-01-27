import 'package:injectable/injectable.dart';

import '../../data/models/task_item.dart';
import '../repositories/tasks_repository.dart';

@injectable
class UpdateTimeTaskUseCase {
  final TasksRepository _repository;

  UpdateTimeTaskUseCase(this._repository);

  Future<TaskItem> call({
    required String taskId,
    required DateTime startAt,
  }) {
    return _repository.updateTimeTask(taskId: taskId, startAt: startAt);
  }
}

