import 'dart:io';

import '../../data/models/employee_salary.dart';
import '../../data/models/task_item.dart';
import '../../data/models/task_summary.dart';

abstract class TasksRepository {
  Future<List<TaskItem>> fetchTasks({
    required String employeeId,
    List<String>? branchIds,
    int limit = 10,
    int page = 0,
  });

  List<TaskItem> getCachedTasks();

  Future<String> uploadPhoto(File photoFile);

  Future<TaskItem> addTask({
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
  });

  Future<List<Map<String, dynamic>>> fetchEmployees({
    List<String>? branchIds,
    String? status,
    int limit = 20,
  });

  Future<List<Map<String, dynamic>>> searchCustomers({
    String? searchQuery,
    int limit = 100,
  });

  Future<List<Map<String, dynamic>>> searchServices({
    required String employeeId,
    String? keyword,
    int limit = 20,
  });

  Future<TaskItem> updateTask({
    required String taskId,
    required Map<String, dynamic> params,
  });

  Future<void> changeStatusTask({
    required String taskId,
    required String status,
  });

  Future<List<String>> getAvailableTimes({
    required String taskId,
    required DateTime date,
  });

  Future<TaskItem> updateTimeTask({
    required String taskId,
    required DateTime startAt,
  });

  Future<TaskSummary> fetchTaskSummary({
    required String employeeId,
    List<String>? branchIds,
    DateTime? fromDate,
    DateTime? toDate,
    String? type,
  });

  Future<List<EmployeeSalary>> fetchEmployeeSalary({
    List<String>? branchIds,
    required DateTime date,
    String type,
    int page,
  });
}
