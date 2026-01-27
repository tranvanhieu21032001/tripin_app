import 'package:injectable/injectable.dart';

import '../../data/models/task_item.dart';
import '../repositories/tasks_repository.dart';

@injectable
class UpdateTaskUseCase {
  final TasksRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<TaskItem> call({
    required String taskId,
    required Map<String, dynamic> params,
  }) {
    return _repository.updateTask(
      taskId: taskId,
      params: params,
    );
  }
}

