// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:wemu_team_app/core/di/di_module.dart' as _i512;
import 'package:wemu_team_app/core/network/auth_header_interceptor.dart'
    as _i107;
import 'package:wemu_team_app/core/network/business_header_interceptor.dart'
    as _i531;
import 'package:wemu_team_app/core/network/chat_socket_service.dart' as _i315;
import 'package:wemu_team_app/features/login/data/datasources/auth_local_data_source.dart'
    as _i336;
import 'package:wemu_team_app/features/login/data/datasources/auth_remote_data_source.dart'
    as _i523;
import 'package:wemu_team_app/features/login/data/repositories/auth_repository_impl.dart'
    as _i134;
import 'package:wemu_team_app/features/login/domain/repositories/auth_repository.dart'
    as _i602;
import 'package:wemu_team_app/features/login/domain/usecases/login_usecase.dart'
    as _i984;
import 'package:wemu_team_app/features/login/presentation/bloc/login_cubit.dart'
    as _i208;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i107.AuthHeaderInterceptor>(
      () => _i107.AuthHeaderInterceptor(),
    );
    gh.lazySingleton<_i531.BusinessHeaderInterceptor>(
      () => _i531.BusinessHeaderInterceptor(),
    );
    gh.lazySingleton<_i315.ChatSocketService>(() => _i315.ChatSocketService());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i107.AuthHeaderInterceptor>(),
        gh<_i531.BusinessHeaderInterceptor>(),
      ),
    );
    gh.lazySingleton<_i336.AuthLocalDataSource>(
      () => _i336.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i523.AuthRemoteDataSource>(
      () => _i523.AuthRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i602.AuthRepository>(
      () => _i134.AuthRepositoryImpl(
        gh<_i523.AuthRemoteDataSource>(),
        gh<_i336.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i984.LoginUseCase>(
      () => _i984.LoginUseCase(gh<_i602.AuthRepository>()),
    );
    gh.factory<_i208.LoginCubit>(
      () => _i208.LoginCubit(
        gh<_i984.LoginUseCase>(),
        gh<_i602.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i512.RegisterModule {}
