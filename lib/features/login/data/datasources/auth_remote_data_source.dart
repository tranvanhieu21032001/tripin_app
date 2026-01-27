import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/login_response.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

@lazySingleton
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponse> login({
    required String email,
    required String passwordMd5,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': passwordMd5},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AuthException('Invalid login response.');
      }
      final success = data['success'];
      if (success is bool && success) {
        return LoginResponse.fromJson(data);
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        throw AuthException(message);
      }
      throw const AuthException('Login failed.');
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw AuthException(message['message'] as String);
      }
      throw const AuthException('Network error. Please try again.');
    }
  }
}
