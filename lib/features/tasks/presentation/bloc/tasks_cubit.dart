import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../login/domain/repositories/auth_repository.dart';
import '../../data/models/task_item.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/change_task_status_usecase.dart';
import '../../domain/usecases/load_tasks_usecase.dart';
import '../../domain/usecases/search_customers_usecase.dart';
import '../../domain/usecases/search_services_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/update_time_task_usecase.dart';
import '../../domain/usecases/get_available_times_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';
import '../../domain/usecases/load_employee_salary_usecase.dart';
import '../../domain/usecases/load_task_summary_usecase.dart';
import 'tasks_state.dart';

@lazySingleton
class TasksCubit extends Cubit<TasksState> {
  final LoadTasksUseCase _loadTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final SearchCustomersUseCase _searchCustomersUseCase;
  final SearchServicesUseCase _searchServicesUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final UpdateTimeTaskUseCase _updateTimeTaskUseCase;
  final GetAvailableTimesUseCase _getAvailableTimesUseCase;
  final ChangeTaskStatusUseCase _changeTaskStatusUseCase;
  final LoadTaskSummaryUseCase _loadTaskSummaryUseCase;
  final LoadEmployeeSalaryUseCase _loadEmployeeSalaryUseCase;
  final TasksRepository _tasksRepository;
  final AuthRepository _authRepository;

  TasksCubit(
    this._loadTasksUseCase,
    this._addTaskUseCase,
    this._searchCustomersUseCase,
    this._searchServicesUseCase,
    this._uploadPhotoUseCase,
    this._updateTaskUseCase,
    this._updateTimeTaskUseCase,
    this._getAvailableTimesUseCase,
    this._changeTaskStatusUseCase,
    this._loadTaskSummaryUseCase,
    this._loadEmployeeSalaryUseCase,
    this._tasksRepository,
    this._authRepository,
  ) : super(const TasksState());

  // Map of YYYY-MM-DD -> count of tasks on that day
  Map<String, int> get tasksPerDay {
    final Map<String, int> m = {};
    for (final t in state.tasks) {
      final d = DateFormat('yyyy-MM-dd').format(t.startAt ?? DateTime.now());
      m[d] = (m[d] ?? 0) + 1;
    }
    return m;
  }

  Future<void> loadTasks() async {
    if (state.status == TasksStatus.loading) {
      return;
    }
    final user = _authRepository.getCachedUser();
    final employeeId = user?.id ?? '';
    if (employeeId.isEmpty) {
      emit(state.copyWith(
        status: TasksStatus.failure,
        errorMessage: 'Missing employee id.',
      ));
      return;
    }

    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchIds = firstPermission?.branches.map((b) => b.id).where((id) => id.isNotEmpty).toList();

    emit(state.copyWith(status: TasksStatus.loading, errorMessage: null, warningMessage: null));
    try {
      final tasks = await _loadTasksUseCase(
        employeeId: employeeId,
        branchIds: branchIds,
        limit: 10,
        page: 0,
      );
      emit(state.copyWith(status: TasksStatus.success, tasks: tasks));
    } catch (error) {
      final cached = _tasksRepository.getCachedTasks();
      if (cached.isNotEmpty) {
        emit(
          state.copyWith(
            status: TasksStatus.success,
            tasks: cached,
            warningMessage: error.toString(),
          ),
        );
      } else {
        emit(state.copyWith(status: TasksStatus.failure, errorMessage: error.toString()));
      }
    }
  }

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
    return await _addTaskUseCase(
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

  Future<List<Map<String, dynamic>>> searchCustomers({
    String? searchQuery,
    int limit = 100,
  }) async {
    return await _searchCustomersUseCase(
      searchQuery: searchQuery,
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> searchServices({
    required String employeeId,
    String? keyword,
    int limit = 20,
  }) async {
    return await _searchServicesUseCase(
      employeeId: employeeId,
      keyword: keyword,
      limit: limit,
    );
  }

  Future<String> uploadPhoto(File photoFile) async {
    return await _uploadPhotoUseCase(photoFile);
  }

  Future<void> toggleTaskComplete({
    required TaskItem task,
    required bool isChecked,
  }) async {
    if (task.status.toLowerCase() == 'canceled') {
      return;
    }

    final statusToUpdate = isChecked ? 'completed' : 'pending';

    final originalTasks = state.tasks;

    final optimisticTasks = originalTasks.map((t) {
      if (t.id != task.id) return t;

      final updatedSubTasks = t.isServiceTask
          ? t.subTasks
          : t.subTasks
              .map(
                (s) => TaskSubTask(
                  name: s.name,
                  status: isChecked ? 'done' : 'new',
                ),
              )
              .toList();

      return TaskItem(
        id: t.id,
        status: statusToUpdate,
        confirmationStatus: t.confirmationStatus,
        startAt: t.startAt,
        endAt: t.endAt,
        relatedServiceName: t.relatedServiceName,
        branchName: t.branchName,
        contactName: t.contactName,
        userName: t.userName,
        userAvatarUrl: t.userAvatarUrl,
        employeeName: t.employeeName,
        employeeAvatarUrl: t.employeeAvatarUrl,
        notes: t.notes,
        subTasks: updatedSubTasks,
        services: t.services,
      );
    }).toList();

    emit(state.copyWith(tasks: optimisticTasks));

    try {
      if (task.subTasks.isNotEmpty) {
        final updatedSubTasksPayload = task.subTasks
            .map((s) => {'name': s.name, 'status': isChecked ? 'done' : 'new'})
            .toList();

        await _updateTaskUseCase(
          taskId: task.id,
          params: {
            'services': const [],
            'subTasks': updatedSubTasksPayload,
            'photos': const [],
          },
        );
      }

      await _changeTaskStatusUseCase(
        taskId: task.id,
        status: statusToUpdate,
      );

      await loadTasks();
    } catch (e) {
      emit(state.copyWith(tasks: originalTasks, warningMessage: e.toString()));
    }
  }

  Future<void> toggleSubTask({
    required TaskItem task,
    required int subTaskIndex,
    required bool isChecked,
  }) async {
    if (task.status.toLowerCase() == 'canceled' || subTaskIndex >= task.subTasks.length) {
      return;
    }

    final originalTasks = state.tasks;

    final optimisticTasks = originalTasks.map((t) {
      if (t.id != task.id) return t;

      final updatedSubTasks = List<TaskSubTask>.from(t.subTasks);
      final subTaskToUpdate = updatedSubTasks[subTaskIndex];
      updatedSubTasks[subTaskIndex] = TaskSubTask(
        name: subTaskToUpdate.name,
        status: isChecked ? 'done' : 'new',
      );

      return TaskItem(
        id: t.id,
        status: t.status,
        confirmationStatus: t.confirmationStatus,
        startAt: t.startAt,
        endAt: t.endAt,
        relatedServiceName: t.relatedServiceName,
        branchName: t.branchName,
        contactName: t.contactName,
        userName: t.userName,
        userAvatarUrl: t.userAvatarUrl,
        employeeName: t.employeeName,
        employeeAvatarUrl: t.employeeAvatarUrl,
        notes: t.notes,
        subTasks: updatedSubTasks,
        services: t.services,
      );
    }).toList();

    emit(state.copyWith(tasks: optimisticTasks));

    try {
      final taskToUpdate = optimisticTasks.firstWhere((t) => t.id == task.id);
      final subTasksPayload = taskToUpdate.subTasks.map((s) => {'name': s.name, 'status': s.status}).toList();

      await _updateTaskUseCase(
        taskId: task.id,
        params: {
          'services': const [],
          'subTasks': subTasksPayload,
          'photos': const [],
        },
      );
    } catch (e) {
      emit(state.copyWith(tasks: originalTasks, warningMessage: e.toString()));
    }
  }

  Future<List<String>> getAvailableTimes({
    required String taskId,
    required DateTime date,
  }) {
    return _getAvailableTimesUseCase(taskId: taskId, date: date);
  }

  Future<TaskItem> updateTaskTime({
    required TaskItem task,
    required DateTime startAt,
  }) async {
    final originalTasks = state.tasks;

    final originalStartAt = task.startAt;
    final originalEndAt = task.endAt;
    final duration = (originalStartAt != null && originalEndAt != null)
        ? originalEndAt.difference(originalStartAt)
        : Duration.zero;

    final optimisticTasks = originalTasks.map((t) {
      if (t.id != task.id) return t;

      return TaskItem(
        id: t.id,
        status: t.status,
        confirmationStatus: t.confirmationStatus,
        startAt: startAt,
        endAt: duration == Duration.zero ? t.endAt : startAt.add(duration),
        relatedServiceName: t.relatedServiceName,
        branchName: t.branchName,
        contactName: t.contactName,
        userName: t.userName,
        userAvatarUrl: t.userAvatarUrl,
        employeeName: t.employeeName,
        employeeAvatarUrl: t.employeeAvatarUrl,
        notes: t.notes,
        subTasks: t.subTasks,
        services: t.services,
      );
    }).toList();

    emit(state.copyWith(tasks: optimisticTasks));

    try {
      final updated = await _updateTimeTaskUseCase(taskId: task.id, startAt: startAt);

      final mergedTasks = state.tasks.map((t) => t.id == updated.id ? updated : t).toList();
      emit(state.copyWith(tasks: mergedTasks));

      return updated;
    } catch (e) {
      emit(state.copyWith(tasks: originalTasks, warningMessage: e.toString()));

      String message = e.toString();
      final prefixIndex = message.indexOf(': ');
      if (prefixIndex != -1) {
        final stripped = message.substring(prefixIndex + 2).trim();
        if (stripped.isNotEmpty) {
          message = stripped;
        }
      }

      throw Exception(message);
    }
  }

  Future<void> changeStatusTask({
    required String taskId,
    required String status,
  }) async {
    final originalTasks = state.tasks;

    final optimisticTasks = originalTasks.map((t) {
      if (t.id != taskId) return t;
      return TaskItem(
        id: t.id,
        status: status,
        confirmationStatus: t.confirmationStatus,
        startAt: t.startAt,
        endAt: t.endAt,
        relatedServiceName: t.relatedServiceName,
        branchName: t.branchName,
        contactName: t.contactName,
        userName: t.userName,
        userAvatarUrl: t.userAvatarUrl,
        employeeName: t.employeeName,
        employeeAvatarUrl: t.employeeAvatarUrl,
        notes: t.notes,
        subTasks: t.subTasks,
        services: t.services,
      );
    }).toList();

    emit(state.copyWith(tasks: optimisticTasks));

    try {
      await _changeTaskStatusUseCase(
        taskId: taskId,
        status: status,
      );
    } catch (e) {
      // Revert on failure and surface backend message if present.
      emit(state.copyWith(tasks: originalTasks, warningMessage: e.toString()));

      String message = e.toString();
      // Common case: "TasksException: Cannot update to the same status"
      final prefixIndex = message.indexOf(': ');
      if (prefixIndex != -1) {
        final stripped = message.substring(prefixIndex + 2).trim();
        if (stripped.isNotEmpty) {
          message = stripped;
        }
      }

      throw Exception(message);
    }
  }

  Future<void> loadTaskSummary({
    DateTime? fromDate,
    DateTime? toDate,
    String? type,
  }) async {
    final user = _authRepository.getCachedUser();
    final employeeId = user?.id ?? '';
    if (employeeId.isEmpty) {
      return;
    }

    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchIds = firstPermission?.branches.map((b) => b.id).where((id) => id.isNotEmpty).toList();

    try {
      final summary = await _loadTaskSummaryUseCase(
        employeeId: employeeId,
        branchIds: branchIds,
        fromDate: fromDate,
        toDate: toDate,
        type: type,
      );
      emit(state.copyWith(summary: summary));
    } catch (error) {
      // Silently fail for summary, don't block UI
    }
  }

  Future<void> loadWeeklyHours({
    required DateTime date,
  }) async {
    final user = _authRepository.getCachedUser();
    final myName = (user?.displayNameOrGuest ?? '').trim();
    if (myName.isEmpty) {
      emit(state.copyWith(weeklyHours: 0));
      return;
    }

    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchIds = firstPermission?.branches.map((b) => b.id).where((id) => id.isNotEmpty).toList();

    try {
      final salaries = await _loadEmployeeSalaryUseCase(
        branchIds: branchIds,
        date: date,
        type: 'weekly',
        page: 0,
      );

      final normalizedMyName = myName.toLowerCase();
      final match = salaries.where((e) => e.name.trim().toLowerCase() == normalizedMyName).toList();
      final hours = match.isNotEmpty ? match.first.hours : 0;
      emit(state.copyWith(weeklyHours: hours));
    } catch (_) {
      emit(state.copyWith(weeklyHours: 0));
    }
  }
}
