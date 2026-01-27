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
import 'package:wemu_team_app/features/chat/data/datasources/chat_remote_data_source.dart'
    as _i313;
import 'package:wemu_team_app/features/chat/data/repositories/chat_repository_impl.dart'
    as _i784;
import 'package:wemu_team_app/features/chat/domain/repositories/chat_repository.dart'
    as _i886;
import 'package:wemu_team_app/features/chat/domain/usecases/get_chat_history_usecase.dart'
    as _i924;
import 'package:wemu_team_app/features/chat/presentation/bloc/chat_cubit.dart'
    as _i169;
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
import 'package:wemu_team_app/features/profile/data/datasources/profile_remote_data_source.dart'
    as _i227;
import 'package:wemu_team_app/features/profile/data/repositories/profile_repository_impl.dart'
    as _i1070;
import 'package:wemu_team_app/features/profile/domain/repositories/profile_repository.dart'
    as _i805;
import 'package:wemu_team_app/features/profile/domain/usecases/change_password_usecase.dart'
    as _i682;
import 'package:wemu_team_app/features/profile/domain/usecases/get_branches_usecase.dart'
    as _i902;
import 'package:wemu_team_app/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i140;
import 'package:wemu_team_app/features/profile/domain/usecases/get_selected_branch_usecase.dart'
    as _i170;
import 'package:wemu_team_app/features/profile/domain/usecases/logout_usecase.dart'
    as _i496;
import 'package:wemu_team_app/features/profile/domain/usecases/select_branch_usecase.dart'
    as _i390;
import 'package:wemu_team_app/features/profile/presentation/bloc/profile_cubit.dart'
    as _i151;
import 'package:wemu_team_app/features/tasks/data/datasources/tasks_local_data_source.dart'
    as _i630;
import 'package:wemu_team_app/features/tasks/data/datasources/tasks_remote_data_source.dart'
    as _i840;
import 'package:wemu_team_app/features/tasks/data/repositories/tasks_repository_impl.dart'
    as _i1006;
import 'package:wemu_team_app/features/tasks/domain/repositories/tasks_repository.dart'
    as _i303;
import 'package:wemu_team_app/features/tasks/domain/usecases/add_task_usecase.dart'
    as _i571;
import 'package:wemu_team_app/features/tasks/domain/usecases/change_task_status_usecase.dart'
    as _i121;
import 'package:wemu_team_app/features/tasks/domain/usecases/get_available_times_usecase.dart'
    as _i129;
import 'package:wemu_team_app/features/tasks/domain/usecases/load_employee_salary_usecase.dart'
    as _i1027;
import 'package:wemu_team_app/features/tasks/domain/usecases/load_task_summary_usecase.dart'
    as _i386;
import 'package:wemu_team_app/features/tasks/domain/usecases/load_tasks_usecase.dart'
    as _i550;
import 'package:wemu_team_app/features/tasks/domain/usecases/search_customers_usecase.dart'
    as _i444;
import 'package:wemu_team_app/features/tasks/domain/usecases/search_services_usecase.dart'
    as _i329;
import 'package:wemu_team_app/features/tasks/domain/usecases/update_task_usecase.dart'
    as _i200;
import 'package:wemu_team_app/features/tasks/domain/usecases/update_time_task_usecase.dart'
    as _i742;
import 'package:wemu_team_app/features/tasks/domain/usecases/upload_photo_usecase.dart'
    as _i918;
import 'package:wemu_team_app/features/tasks/presentation/bloc/tasks_cubit.dart'
    as _i723;
import 'package:wemu_team_app/features/timesheet/data/datasources/timesheet_local_data_source.dart'
    as _i905;
import 'package:wemu_team_app/features/timesheet/data/datasources/timesheet_remote_data_source.dart'
    as _i399;
import 'package:wemu_team_app/features/timesheet/data/repositories/timesheet_repository_impl.dart'
    as _i29;
import 'package:wemu_team_app/features/timesheet/domain/repositories/timesheet_repository.dart'
    as _i631;
import 'package:wemu_team_app/features/timesheet/domain/usecases/create_timesheet_usecase.dart'
    as _i663;
import 'package:wemu_team_app/features/timesheet/domain/usecases/load_timesheet_members_usecase.dart'
    as _i604;
import 'package:wemu_team_app/features/timesheet/domain/usecases/load_timesheets_usecase.dart'
    as _i721;
import 'package:wemu_team_app/features/timesheet/presentation/bloc/timesheet_cubit.dart'
    as _i991;

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
    gh.lazySingleton<_i630.TasksLocalDataSource>(
      () => _i630.TasksLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i905.TimesheetLocalDataSource>(
      () => _i905.TimesheetLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i313.ChatRemoteDataSource>(
      () => _i313.ChatRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i523.AuthRemoteDataSource>(
      () => _i523.AuthRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i227.ProfileRemoteDataSource>(
      () => _i227.ProfileRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i840.TasksRemoteDataSource>(
      () => _i840.TasksRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i399.TimesheetRemoteDataSource>(
      () => _i399.TimesheetRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i303.TasksRepository>(
      () => _i1006.TasksRepositoryImpl(
        gh<_i840.TasksRemoteDataSource>(),
        gh<_i630.TasksLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i602.AuthRepository>(
      () => _i134.AuthRepositoryImpl(
        gh<_i523.AuthRemoteDataSource>(),
        gh<_i336.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i571.AddTaskUseCase>(
      () => _i571.AddTaskUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i121.ChangeTaskStatusUseCase>(
      () => _i121.ChangeTaskStatusUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i129.GetAvailableTimesUseCase>(
      () => _i129.GetAvailableTimesUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i1027.LoadEmployeeSalaryUseCase>(
      () => _i1027.LoadEmployeeSalaryUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i386.LoadTaskSummaryUseCase>(
      () => _i386.LoadTaskSummaryUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i550.LoadTasksUseCase>(
      () => _i550.LoadTasksUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i444.SearchCustomersUseCase>(
      () => _i444.SearchCustomersUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i329.SearchServicesUseCase>(
      () => _i329.SearchServicesUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i200.UpdateTaskUseCase>(
      () => _i200.UpdateTaskUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i742.UpdateTimeTaskUseCase>(
      () => _i742.UpdateTimeTaskUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i918.UploadPhotoUseCase>(
      () => _i918.UploadPhotoUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i604.LoadTimesheetMembersUseCase>(
      () => _i604.LoadTimesheetMembersUseCase(gh<_i303.TasksRepository>()),
    );
    gh.factory<_i984.LoginUseCase>(
      () => _i984.LoginUseCase(gh<_i602.AuthRepository>()),
    );
    gh.lazySingleton<_i886.ChatRepository>(
      () => _i784.ChatRepositoryImpl(gh<_i313.ChatRemoteDataSource>()),
    );
    gh.lazySingleton<_i631.TimesheetRepository>(
      () => _i29.TimesheetRepositoryImpl(
        gh<_i399.TimesheetRemoteDataSource>(),
        gh<_i905.TimesheetLocalDataSource>(),
      ),
    );
    gh.factory<_i208.LoginCubit>(
      () => _i208.LoginCubit(
        gh<_i984.LoginUseCase>(),
        gh<_i602.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i723.TasksCubit>(
      () => _i723.TasksCubit(
        gh<_i550.LoadTasksUseCase>(),
        gh<_i571.AddTaskUseCase>(),
        gh<_i444.SearchCustomersUseCase>(),
        gh<_i329.SearchServicesUseCase>(),
        gh<_i918.UploadPhotoUseCase>(),
        gh<_i200.UpdateTaskUseCase>(),
        gh<_i742.UpdateTimeTaskUseCase>(),
        gh<_i129.GetAvailableTimesUseCase>(),
        gh<_i121.ChangeTaskStatusUseCase>(),
        gh<_i386.LoadTaskSummaryUseCase>(),
        gh<_i1027.LoadEmployeeSalaryUseCase>(),
        gh<_i303.TasksRepository>(),
        gh<_i602.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i805.ProfileRepository>(
      () => _i1070.ProfileRepositoryImpl(
        gh<_i602.AuthRepository>(),
        gh<_i460.SharedPreferences>(),
        gh<_i227.ProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i924.GetChatHistoryUseCase>(
      () => _i924.GetChatHistoryUseCase(gh<_i886.ChatRepository>()),
    );
    gh.factory<_i169.ChatCubit>(
      () => _i169.ChatCubit(
        gh<_i924.GetChatHistoryUseCase>(),
        gh<_i315.ChatSocketService>(),
        gh<_i602.AuthRepository>(),
        gh<_i918.UploadPhotoUseCase>(),
      ),
    );
    gh.factory<_i663.CreateTimesheetUseCase>(
      () => _i663.CreateTimesheetUseCase(gh<_i631.TimesheetRepository>()),
    );
    gh.factory<_i721.LoadTimesheetsUseCase>(
      () => _i721.LoadTimesheetsUseCase(gh<_i631.TimesheetRepository>()),
    );
    gh.factory<_i682.ChangePasswordUseCase>(
      () => _i682.ChangePasswordUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i902.GetBranchesUseCase>(
      () => _i902.GetBranchesUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i140.GetProfileUseCase>(
      () => _i140.GetProfileUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i170.GetSelectedBranchUseCase>(
      () => _i170.GetSelectedBranchUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i496.LogoutUseCase>(
      () => _i496.LogoutUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i390.SelectBranchUseCase>(
      () => _i390.SelectBranchUseCase(gh<_i805.ProfileRepository>()),
    );
    gh.factory<_i991.TimesheetCubit>(
      () => _i991.TimesheetCubit(
        gh<_i721.LoadTimesheetsUseCase>(),
        gh<_i604.LoadTimesheetMembersUseCase>(),
        gh<_i663.CreateTimesheetUseCase>(),
        gh<_i602.AuthRepository>(),
      ),
    );
    gh.factory<_i151.ProfileCubit>(
      () => _i151.ProfileCubit(
        gh<_i140.GetProfileUseCase>(),
        gh<_i902.GetBranchesUseCase>(),
        gh<_i170.GetSelectedBranchUseCase>(),
        gh<_i390.SelectBranchUseCase>(),
        gh<_i496.LogoutUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i512.RegisterModule {}
