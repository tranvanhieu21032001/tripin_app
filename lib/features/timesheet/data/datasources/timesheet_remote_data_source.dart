import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/timesheet_item.dart';

class TimesheetException implements Exception {
  final String message;

  const TimesheetException(this.message);

  @override
  String toString() => message;
}

@lazySingleton
class TimesheetRemoteDataSource {
  final Dio _dio;

  TimesheetRemoteDataSource(this._dio);

  Future<void> createTimesheet({
    required String employeeId,
    required DateTime clockInTime,
    DateTime? clockOutTime,
    DateTime? breakStart,
    DateTime? breakEnd,
    String? notes,
    String? branchId,
    String status = 'approved',
  }) async {
    try {
      final payload = <String, dynamic>{
        'employee': employeeId,
        'clockinTime': clockInTime.toUtc().toIso8601String(),
        'status': status,
        if (clockOutTime != null) 'clockoutTime': clockOutTime.toUtc().toIso8601String(),
        if (breakStart != null) 'breakStart': breakStart.toUtc().toIso8601String(),
        if (breakEnd != null) 'breakEnd': breakEnd.toUtc().toIso8601String(),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (branchId != null && branchId.isNotEmpty) 'branch': branchId,
      };

      final response = await _dio.post('/timesheets', data: payload);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TimesheetException('Invalid timesheet response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        return;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TimesheetException(message);
      }
      throw const TimesheetException('Failed to create timesheet.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TimesheetException(message['message'] as String);
      }
      throw const TimesheetException('Network error. Please try again.');
    }
  }

  Future<List<TimesheetItem>> fetchTimesheets({
    required List<String> branchIds,
    required DateTime start,
    required DateTime end,
    String mode = 'daily',
    int page = 0,
    String timezone = 'Asia/Saigon',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'branches': branchIds.join(','),
        'start': start.toUtc().toIso8601String(),
        'end': end.toUtc().toIso8601String(),
        'mode': mode,
        'page': page,
        'timezone': timezone,
      };

      final response = await _dio.get(
        '/timesheets',
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const TimesheetException('Invalid timesheet response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        final payload = data['data'];
        if (payload is! Map<String, dynamic>) {
          return const <TimesheetItem>[];
        }
        final items = payload['data'];
        if (items is! List) {
          return const <TimesheetItem>[];
        }
        return items
            .whereType<Map>()
            .map((e) => TimesheetItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw TimesheetException(message);
      }
      throw const TimesheetException('Failed to load timesheets.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw TimesheetException(message['message'] as String);
      }
      throw const TimesheetException('Network error. Please try again.');
    }
  }
}
