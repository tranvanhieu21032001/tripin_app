import 'package:injectable/injectable.dart';

import '../../../tasks/domain/repositories/tasks_repository.dart';

@injectable
class LoadTimesheetMembersUseCase {
  final TasksRepository _tasksRepository;

  LoadTimesheetMembersUseCase(this._tasksRepository);

  Future<List<Map<String, dynamic>>> call({
    required List<String> branchIds,
    int limit = 50,
    String? status,
  }) {
    return _tasksRepository.fetchEmployees(
      branchIds: branchIds,
      status: status,
      limit: limit,
    );
  }
}
