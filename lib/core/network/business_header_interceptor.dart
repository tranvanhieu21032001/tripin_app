import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:wemu_team_app/core/di/injection.dart';
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart';

@lazySingleton
class BusinessHeaderInterceptor extends Interceptor {
  BusinessHeaderInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final permissions = getIt<AuthRepository>().getCachedPermissions();
    final businessId = permissions.isNotEmpty
        ? permissions.first.business?.id ?? ''
        : '';
    if (businessId.isNotEmpty) {
      options.headers['Business'] = businessId;
    }
    handler.next(options);
  }
}
