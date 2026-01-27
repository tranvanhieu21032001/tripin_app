import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wemu_team_app/core/network/auth_header_interceptor.dart';
import 'package:wemu_team_app/core/network/business_header_interceptor.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(
    AuthHeaderInterceptor authHeaderInterceptor,
    BusinessHeaderInterceptor businessHeaderInterceptor,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-prod.wemu.co',
        headers: const {'api-version': 'v2'},
        contentType: Headers.jsonContentType,
      ),
    );
    dio.interceptors.add(authHeaderInterceptor);
    dio.interceptors.add(businessHeaderInterceptor);
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();
}
