import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';

@lazySingleton
class AuthHeaderInterceptor extends Interceptor {
  AuthHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getIt<AuthRepository>().getCachedToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
