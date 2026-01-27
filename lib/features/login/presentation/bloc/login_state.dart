import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final String? savedEmail;
  final String? savedPassword;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.savedEmail,
    this.savedPassword,
  });

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? savedEmail,
    String? savedPassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      savedEmail: savedEmail ?? this.savedEmail,
      savedPassword: savedPassword ?? this.savedPassword,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, savedEmail, savedPassword];
}
