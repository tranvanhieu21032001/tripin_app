import 'package:injectable/injectable.dart';

import '../repositories/tasks_repository.dart';

@injectable
class GetAvailableTimesUseCase {
  final TasksRepository _repository;

  GetAvailableTimesUseCase(this._repository);

  Future<List<String>> call({
    required String taskId,
    required DateTime date,
  }) {
    return _repository.getAvailableTimes(taskId: taskId, date: date);
  }
}

