import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_local_data_source.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../models/employee_salary.dart';
import '../models/task_item.dart';
import '../models/task_summary.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource _remote;
  final TasksLocalDataSource _local;

  TasksRepositoryImpl(this._remote, this._local);

  @override
  Future<List<TaskItem>> fetchTasks({
    required String employeeId,
    List<String>? branchIds,
    int limit = 10,
    int page = 0,
  }) async {
    final tasks = await _remote.fetchTasks(
      employeeId: employeeId,
      branchIds: branchIds,
      limit: limit,
      page: page,
    );
    await _local.saveTasks(tasks);
    return tasks;
  }

  @override
  List<TaskItem> getCachedTasks() => _local.getCachedTasks();

  @override
  Future<String> uploadPhoto(File photoFile) async {
    return await _remote.uploadPhoto(photoFile);
  }

  @override
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
  }) async {
    return await _remote.addTask(
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

  @override
  Future<List<Map<String, dynamic>>> fetchEmployees({
    List<String>? branchIds,
    String? status,
    int limit = 20,
  }) async {
    return await _remote.fetchEmployees(
      branchIds: branchIds,
      status: status,
      limit: limit,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> searchCustomers({
    String? searchQuery,
    int limit = 100,
  }) async {
    return await _remote.searchCustomers(
      searchQuery: searchQuery,
      limit: limit,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> searchServices({
    required String employeeId,
    String? keyword,
    int limit = 20,
  }) async {
    return await _remote.searchServices(
      employeeId: employeeId,
      keyword: keyword,
      limit: limit,
    );
  }

  @override
  Future<TaskItem> updateTask({
    required String taskId,
    required Map<String, dynamic> params,
  }) {
    return _remote.updateTask(taskId: taskId, params: params);
  }

  @override
  Future<void> changeStatusTask({
    required String taskId,
    required String status,
  }) async {
    await _remote.changeStatusTask(taskId: taskId, status: status);
  }

  @override
  Future<List<String>> getAvailableTimes({
    required String taskId,
    required DateTime date,
  }) {
    return _remote.getAvailableTimes(taskId: taskId, date: date);
  }

  @override
  Future<TaskItem> updateTimeTask({
    required String taskId,
    required DateTime startAt,
  }) {
    return _remote.updateTimeTask(taskId: taskId, startAt: startAt);
  }

  @override
  Future<TaskSummary> fetchTaskSummary({
    required String employeeId,
    List<String>? branchIds,
    DateTime? fromDate,
    DateTime? toDate,
    String? type,
  }) async {
    return await _remote.fetchTaskSummary(
      employeeId: employeeId,
      branchIds: branchIds,
      fromDate: fromDate,
      toDate: toDate,
      type: type,
    );
  }

  @override
  Future<List<EmployeeSalary>> fetchEmployeeSalary({
    List<String>? branchIds,
    required DateTime date,
    String type = 'weekly',
    int page = 0,
  }) {
    return _remote.fetchEmployeeSalary(
      branchIds: branchIds,
      date: date,
      type: type,
      page: page,
    );
  }
}
