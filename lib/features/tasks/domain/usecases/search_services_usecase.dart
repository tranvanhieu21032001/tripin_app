import 'package:injectable/injectable.dart';

import '../repositories/tasks_repository.dart';

@injectable
class SearchServicesUseCase {
  final TasksRepository _repository;

  SearchServicesUseCase(this._repository);

  Future<List<Map<String, dynamic>>> call({
    required String employeeId,
    String? keyword,
    int limit = 20,
  }) {
    return _repository.searchServices(
      employeeId: employeeId,
      keyword: keyword,
      limit: limit,
    );
  }
}

