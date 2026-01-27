enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? errorMessage;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == ChangePasswordStatus.loading;

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
