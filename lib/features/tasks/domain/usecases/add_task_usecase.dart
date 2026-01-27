import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../data/models/task_item.dart';
import '../repositories/tasks_repository.dart';

@injectable
class AddTaskUseCase {
  final TasksRepository _repository;

  AddTaskUseCase(this._repository);

  Future<TaskItem> call({
    required String employeeId,
    String? userId,
    required List<Map<String, dynamic>> subTasks,
    List<String>? serviceIds,
    Map<String, String>? contactInfo,
    required DateTime startAt,
    required DateTime endAt,
    String? notes,
    List<String>? photos,
    String? branchId,
  }) {
    return _repository.addTask(
      employeeId: employeeId,
      userId: userId,
      subTasks: subTasks,
      serviceIds: serviceIds,
      contactInfo: contactInfo,
      startAt: startAt,
      endAt: endAt,
      notes: notes,
      photos: photos,
      branchId: branchId,
    );
  }
}

