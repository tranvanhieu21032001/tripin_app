import 'package:injectable/injectable.dart';

import '../repositories/tasks_repository.dart';

@injectable
class ChangeTaskStatusUseCase {
  final TasksRepository _repository;

  ChangeTaskStatusUseCase(this._repository);

  Future<void> call({
    required String taskId,
    required String status,
  }) {
    return _repository.changeStatusTask(
      taskId: taskId,
      status: status,
    );
  }
}

