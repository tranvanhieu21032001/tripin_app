import 'package:injectable/injectable.dart';

import '../../data/models/employee_salary.dart';
import '../repositories/tasks_repository.dart';

@injectable
class LoadEmployeeSalaryUseCase {
  final TasksRepository _repository;

  LoadEmployeeSalaryUseCase(this._repository);

  Future<List<EmployeeSalary>> call({
    List<String>? branchIds,
    required DateTime date,
    String type = 'weekly',
    int page = 0,
  }) {
    return _repository.fetchEmployeeSalary(
      branchIds: branchIds,
      date: date,
      type: type,
      page: page,
    );
  }
}

