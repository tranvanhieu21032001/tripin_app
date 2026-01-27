import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

class ProfileRemoteException implements Exception {
  final String message;

  const ProfileRemoteException(this.message);

  @override
  String toString() => message;
}

@lazySingleton
class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> getBusinessInfo() async {
    final response = await _dio.get('/businesses/show');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const ProfileRemoteException('Invalid business info response.');
    }

    final dataField = data['data'];
    if (dataField is Map<String, dynamic>) {
      final business = dataField['business'];
      if (business is Map) {
        return Map<String, dynamic>.from(business as Map);
      }
    }

    throw const ProfileRemoteException('Business info not found in response.');
  }

  Future<void> changePassword({
    required String oldPasswordMd5,
    required String newPasswordMd5,
  }) async {
    try {
      final response = await _dio.put(
        '/change-pass',
        data: {
          'oldPassword': oldPasswordMd5,
          'newPassword': newPasswordMd5,
          'confirmPassword': newPasswordMd5,
        },
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ProfileRemoteException('Invalid change password response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        return;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw ProfileRemoteException(message);
      }
      throw const ProfileRemoteException('Failed to change password.');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        throw ProfileRemoteException(data['message'] as String);
      }
      throw const ProfileRemoteException('Network error. Please try again.');
    }
  }
}


