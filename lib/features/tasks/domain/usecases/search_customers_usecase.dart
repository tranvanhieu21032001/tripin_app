import 'package:injectable/injectable.dart';

import '../repositories/tasks_repository.dart';

@injectable
class SearchCustomersUseCase {
  final TasksRepository _repository;

  SearchCustomersUseCase(this._repository);

  Future<List<Map<String, dynamic>>> call({
    String? searchQuery,
    int limit = 100,
  }) {
    return _repository.searchCustomers(
      searchQuery: searchQuery,
      limit: limit,
    );
  }
}

