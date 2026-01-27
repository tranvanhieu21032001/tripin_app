import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wemu_team_app/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:wemu_team_app/features/profile/presentation/bloc/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _useCase;

  ChangePasswordCubit(this._useCase) : super(const ChangePasswordState());

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading, errorMessage: null));
    try {
      await _useCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(state.copyWith(status: ChangePasswordStatus.success, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: ChangePasswordStatus.failure, errorMessage: e.toString()));
    }
  }

  void reset() => emit(const ChangePasswordState());
}