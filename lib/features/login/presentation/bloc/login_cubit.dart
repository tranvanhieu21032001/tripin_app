import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthRepository _repository;

  LoginCubit(this._loginUseCase, this._repository) : super(const LoginState());

  void loadSavedCredentials() {
    final saved = _repository.getSavedCredentials();
    if (saved == null) {
      return;
    }
    emit(
      state.copyWith(
        savedEmail: saved.email,
        savedPassword: saved.password,
      ),
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));
    try {
      await _loginUseCase(email: email, password: password);
      if (rememberMe) {
        await _repository.saveCredentials(email: email, password: password);
      } else {
        await _repository.clearCredentials();
      }
      emit(state.copyWith(status: LoginStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
