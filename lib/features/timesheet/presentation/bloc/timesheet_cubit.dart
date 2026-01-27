import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../login/domain/repositories/auth_repository.dart';
import '../../domain/usecases/create_timesheet_usecase.dart';
import '../../domain/usecases/load_timesheet_members_usecase.dart';
import '../../domain/usecases/load_timesheets_usecase.dart';
import 'timesheet_state.dart';

@injectable
class TimesheetCubit extends Cubit<TimesheetState> {
  final LoadTimesheetsUseCase _loadTimesheetsUseCase;
  final LoadTimesheetMembersUseCase _loadTimesheetMembersUseCase;
  final CreateTimesheetUseCase _createTimesheetUseCase;
  final AuthRepository _authRepository;

  TimesheetCubit(
    this._loadTimesheetsUseCase,
    this._loadTimesheetMembersUseCase,
    this._createTimesheetUseCase,
    this._authRepository,
  ) : super(const TimesheetState());

  Future<void> loadTimesheets({
    required DateTime start,
    required DateTime end,
    String mode = 'daily',
    int page = 0,
    String timezone = 'Asia/Bangkok',
  }) async {
    if (state.status == TimesheetStatus.loading) {
      return;
    }
    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchIds = firstPermission?.branches.map((b) => b.id).where((id) => id.isNotEmpty).toList() ?? [];
    if (branchIds.isEmpty) {
      emit(state.copyWith(
        status: TimesheetStatus.failure,
        errorMessage: 'Missing branch ids.',
      ));
      return;
    }

    emit(state.copyWith(status: TimesheetStatus.loading, errorMessage: null, warningMessage: null));
    try {
      final timesheets = await _loadTimesheetsUseCase(
        branchIds: branchIds,
        start: start,
        end: end,
        mode: mode,
        page: page,
        timezone: timezone,
      );
      emit(state.copyWith(status: TimesheetStatus.success, timesheets: timesheets));
    } catch (error) {
      emit(state.copyWith(status: TimesheetStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> loadMembers({
    int limit = 50,
    String? status,
  }) async {
    if (state.membersStatus == TimesheetMembersStatus.loading) {
      return;
    }

    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchIds = firstPermission?.branches.map((b) => b.id).where((id) => id.isNotEmpty).toList() ?? [];
    if (branchIds.isEmpty) {
      emit(state.copyWith(
        membersStatus: TimesheetMembersStatus.failure,
        membersErrorMessage: 'Missing branch ids.',
        members: const [],
      ));
      return;
    }

    emit(state.copyWith(
      membersStatus: TimesheetMembersStatus.loading,
      membersErrorMessage: null,
    ));

    try {
      final members = await _loadTimesheetMembersUseCase(
        branchIds: branchIds,
        status: status,
        limit: limit,
      );
      emit(state.copyWith(
        membersStatus: TimesheetMembersStatus.success,
        members: members,
      ));
    } catch (e) {
      emit(state.copyWith(
        membersStatus: TimesheetMembersStatus.failure,
        membersErrorMessage: e.toString(),
        members: const [],
      ));
    }
  }

  Future<void> createTimesheetApproved({
    required String employeeId,
    required DateTime clockInTime,
    DateTime? clockOutTime,
    DateTime? breakStart,
    DateTime? breakEnd,
    String? notes,
  }) async {
    if (state.createStatus == TimesheetCreateStatus.loading) {
      return;
    }

    final permissions = _authRepository.getCachedPermissions();
    final firstPermission = permissions.isNotEmpty ? permissions.first : null;
    final branchId = firstPermission?.branches.firstOrNull?.id ?? '';

    emit(state.copyWith(
      createStatus: TimesheetCreateStatus.loading,
      createErrorMessage: null,
    ));

    try {
      await _createTimesheetUseCase(
        employeeId: employeeId,
        clockInTime: clockInTime,
        clockOutTime: clockOutTime,
        breakStart: breakStart,
        breakEnd: breakEnd,
        notes: notes,
        branchId: branchId.isNotEmpty ? branchId : null,
        status: 'approved',
      );

      emit(state.copyWith(
        createStatus: TimesheetCreateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        createStatus: TimesheetCreateStatus.failure,
        createErrorMessage: e.toString(),
      ));
    }
  }
}
