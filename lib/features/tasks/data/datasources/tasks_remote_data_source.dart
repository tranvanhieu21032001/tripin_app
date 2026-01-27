import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';


import '../models/employee_salary.dart';
import '../models/task_item.dart';
import '../models/task_summary.dart';

class TasksException implements Exception {
  final String message;

  const TasksException(this.message);

  @override
  String toString() => message;
}

@lazySingleton
class TasksRemoteDataSource {
  final Dio _dio;

  TasksRemoteDataSource(this._dio);

  Future<List<TaskItem>> fetchTasks({
    required String employeeId,
    List<String>? branchIds,
    int limit = 10,
    int page = 0,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        //'employeeIds': employeeId,
        'limit': limit,
        'page': page,
      };
      if (branchIds != null && branchIds.isNotEmpty) {
        queryParameters['branches'] = branchIds.join(',');
      }

      final response = await _dio.get(
        '/tasks/flat',
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid tasks response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! Map<String, dynamic>) {
          return const <TaskItem>[];
        }
        final items = payload['data'];
        if (items is! List) {
          return const <TaskItem>[];
        }
        return items
            .whereType<Map>()
            .map((e) => TaskItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load tasks.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<String> uploadPhoto(File photoFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photoFile.path),
      });

      final response = await _dio.post('/photos', data: formData);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid photo upload response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        final photoData = data['data'];
        if (photoData is! Map<String, dynamic>) {
          throw const TasksException('Invalid photo data.');
        }
        final photo = photoData['photo'];
        if (photo is! Map<String, dynamic>) {
          throw const TasksException('Invalid photo object.');
        }
        final photoName = photo['name'];
        if (photoName is! String || photoName.isEmpty) {
          throw const TasksException('Photo name is missing.');
        }
        return photoName;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to upload photo.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
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
    try {
      final payload = <String, dynamic>{
        'employees': [employeeId],
        'subTasks': subTasks,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
      };

      if (userId != null) {
        payload['user'] = userId;
      }

      if (contactInfo != null) {
        final sanitizedContactInfo = <String, String>{};
        final email = (contactInfo['email'] ?? '').trim();
        final phone = (contactInfo['phone'] ?? '').trim();
        if (email.isNotEmpty) sanitizedContactInfo['email'] = email;
        if (phone.isNotEmpty) sanitizedContactInfo['phone'] = phone;
        payload['contactInfo'] = sanitizedContactInfo;
      }

      payload['services'] = serviceIds ?? [];

      if (notes != null && notes.isNotEmpty) {
        payload['notes'] = notes;
      }

      if (photos != null && photos.isNotEmpty) {
        payload['photos'] = photos;
      }

      if (branchId != null && branchId.isNotEmpty) {
        payload['branch'] = branchId;
      }

      payload.removeWhere((key, value) {
        if (key == 'services') return false;
        if (value == null) return true;
        if (value is List && value.isEmpty) return true;
        if (value is Map && value.isEmpty) return true;
        if (value is String && value.isEmpty) return true;
        return false;
      });

      final response = await _dio.post('/tasks', data: payload);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid add task response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        final taskData = data['data'];
        if (taskData is! Map<String, dynamic>) {
          throw const TasksException('Invalid task data.');
        }
        final task = taskData['task'];
        if (task is! Map<String, dynamic>) {
          throw const TasksException('Invalid task object.');
        }
        return TaskItem.fromJson(task);
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to add task.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchEmployees({
    List<String>? branchIds,
    String? status,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': limit,
      };
      if (branchIds != null && branchIds.isNotEmpty) {
        queryParameters['branches'] = branchIds.join(',');
      }
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await _dio.get(
        '/employees',
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid employees response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! Map<String, dynamic>) {
          return const <Map<String, dynamic>>[];
        }
        final employees = payload['data'];
        if (employees is! List) {
          return const <Map<String, dynamic>>[];
        }
        return employees
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load employees.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> searchServices({
    String? employeeId,
    String? keyword,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'limit': limit};
      if (employeeId != null && employeeId.isNotEmpty) {
        queryParameters['employee'] = employeeId;
      }
      if (keyword != null && keyword.isNotEmpty) {
        queryParameters['keyword'] = keyword;
      }

      final response = await _dio.get(
        '/services/business',
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid services response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        var services = data['data'];
        if (services is Map<String, dynamic> && services.containsKey('data')) {
          services = services['data'];
        }

        if (services is! List) {
          return const <Map<String, dynamic>>[];
        }
        return services
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load services.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<List<Map<String, dynamic>>> searchCustomers({
    String? searchQuery,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['keyword'] = searchQuery;
        queryParameters['limit'] = limit;
      }

      final response = await _dio.get(
        '/businesses/customers',
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid customers response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        var customers = data['data'];

        if (customers is Map<String, dynamic> && customers.containsKey('data')) {
          customers = customers['data'];
        }

        if (customers is! List) {
          return const <Map<String, dynamic>>[];
        }

        return customers
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load customers.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<TaskItem> updateTask({
    required String taskId,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await _dio.put(
        '/tasks/$taskId',
        data: params,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid update task response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! Map<String, dynamic>) {
          throw const TasksException('Invalid task data.');
        }
        final task = payload['task'];
        if (task is Map<String, dynamic>) {
          return TaskItem.fromJson(task);
        }
        // Some endpoints might return the updated task directly
        if (payload['_id'] != null) {
          return TaskItem.fromJson(payload);
        }
        throw const TasksException('Invalid task object.');
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to update task.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<Map<String, dynamic>> changeStatusTask({
    required String taskId,
    required String status,
    int? toPos,
  }) async {
    try {
      final payload = <String, dynamic>{'status': status};
      if (toPos != null) {
        payload['toPos'] = toPos;
      }

      final response = await _dio.patch(
        '/tasks/$taskId',
        data: payload,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid change status response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final respData = data['data'];
        if (respData is Map<String, dynamic>) {
          return respData;
        }
        return <String, dynamic>{};
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to change task status.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<List<String>> getAvailableTimes({
    required String taskId,
    required DateTime date,
  }) async {
    try {
      final response = await _dio.get(
        '/tasks/availableTime',
        queryParameters: {
          'task': taskId,
          'date': date.toIso8601String(),
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid available time response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! List) {
          return const <String>[];
        }

        final times = <String>[];
        for (final item in payload) {
          if (item is String) {
            times.add(item);
            continue;
          }
          if (item is Map<String, dynamic>) {
            final t = item['time'];
            if (t != null) {
              times.add(t.toString());
            }
            continue;
          }
          if (item is Map) {
            final t = item['time'];
            if (t != null) {
              times.add(t.toString());
            }
          }
        }

        return times;
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load available times.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<TaskItem> updateTimeTask({
    required String taskId,
    required DateTime startAt,
  }) async {
    try {
      final response = await _dio.patch(
        '/tasks/$taskId/startAt',
        data: {
          'startAt': startAt.toIso8601String(),
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid update time response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];

        // Backend may return updated task under different keys, e.g.
        // { data: { status: { ...task } } }
        if (payload is Map<String, dynamic>) {
          final task = payload['task'];
          if (task is Map<String, dynamic>) {
            return TaskItem.fromJson(task);
          }

          final statusObj = payload['status'];
          if (statusObj is Map<String, dynamic>) {
            return TaskItem.fromJson(statusObj);
          }

          if (payload['_id'] != null) {
            return TaskItem.fromJson(payload);
          }
        }

        if (payload is Map<String, dynamic>) {
          return TaskItem.fromJson(payload);
        }

        throw const TasksException('Invalid task object.');
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to update task time.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<List<EmployeeSalary>> fetchEmployeeSalary({
    List<String>? branchIds,
    required DateTime date,
    String type = 'weekly',
    int page = 0,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'date': DateFormat('dd-MM-yyyy').format(date),
        'type': type,
        'page': page,
      };

      if (branchIds != null && branchIds.isNotEmpty) {
        queryParameters['branches'] = branchIds.join(',');
      }

      final response = await _dio.get(
        '/businesses/reports/employees/salary',
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid employee salary response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! Map<String, dynamic>) {
          return const <EmployeeSalary>[];
        }
        final items = payload['data'];
        if (items is! List) {
          return const <EmployeeSalary>[];
        }
        return items
            .whereType<Map>()
            .map((e) => EmployeeSalary.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load employee salary.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }

  Future<TaskSummary> fetchTaskSummary({
    required String employeeId,
    List<String>? branchIds,
    DateTime? fromDate,
    DateTime? toDate,
    String? type,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (branchIds != null && branchIds.isNotEmpty) {
        queryParameters['branches'] = branchIds.join(',');
      }
      if (fromDate != null) {
        // Format: YYYY-MM-DDTHH:mm:ss.SSS (match web format)
        final formatted = '${fromDate.year.toString().padLeft(4, '0')}-'
            '${fromDate.month.toString().padLeft(2, '0')}-'
            '${fromDate.day.toString().padLeft(2, '0')}T'
            '${fromDate.hour.toString().padLeft(2, '0')}:'
            '${fromDate.minute.toString().padLeft(2, '0')}:'
            '${fromDate.second.toString().padLeft(2, '0')}.'
            '${fromDate.millisecond.toString().padLeft(3, '0')}';
        queryParameters['fromDate'] = formatted;
      }
      if (toDate != null) {
        // Format: YYYY-MM-DDTHH:mm:ss.SSS (match web format)
        final formatted = '${toDate.year.toString().padLeft(4, '0')}-'
            '${toDate.month.toString().padLeft(2, '0')}-'
            '${toDate.day.toString().padLeft(2, '0')}T'
            '${toDate.hour.toString().padLeft(2, '0')}:'
            '${toDate.minute.toString().padLeft(2, '0')}:'
            '${toDate.second.toString().padLeft(2, '0')}.'
            '${toDate.millisecond.toString().padLeft(3, '0')}';
        queryParameters['toDate'] = formatted;
      }
      if (type != null && type.isNotEmpty) {
        queryParameters['type'] = type;
      }

      final response = await _dio.get(
        '/reports/employees/earning/$employeeId/summary',
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TasksException('Invalid task summary response.');
      }

      final success = data['success'];
      if (success is bool && success) {
        final summaryData = data['data'];
        if (summaryData is! Map<String, dynamic>) {
          throw const TasksException('Invalid summary data.');
        }
        return TaskSummary.fromJson(summaryData);
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TasksException(message);
      }
      throw const TasksException('Failed to load task summary.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TasksException(message['message'] as String);
      }
      throw const TasksException('Network error. Please try again.');
    }
  }
}
