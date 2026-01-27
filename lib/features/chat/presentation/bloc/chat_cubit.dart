import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wemu_team_app/core/network/chat_socket_service.dart';
import '../../../login/domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../../tasks/domain/usecases/upload_photo_usecase.dart';
import 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final ChatSocketService _socketService;
  final AuthRepository _authRepository;
  final UploadPhotoUseCase _uploadPhotoUseCase;

  ChatCubit(
    this._getChatHistoryUseCase,
    this._socketService,
    this._authRepository,
    this._uploadPhotoUseCase,
  ) : super(const ChatState(reservationId: ''));

  void initialize(String reservationId) {
    if (state.reservationId == reservationId && state.messages.isNotEmpty) {
      return;
    }

    emit(state.copyWith(reservationId: reservationId, status: ChatStatus.loading));

    final token = _authRepository.getCachedToken();
    if (token != null && token.isNotEmpty && !_socketService.isConnected) {
      _socketService.connectToSocket(token);
    }

    _setupSocketListeners();

    _socketService.readReservationMessage(reservationId);
    _loadHistory(reservationId);
  }

  void _setupSocketListeners() {
    _socketService.onSentSuccess((_) {
      if (state.reservationId.isNotEmpty) {
        _loadHistory(state.reservationId);
      }
    });

    _socketService.onNewMessage((_) {
      if (state.reservationId.isNotEmpty) {
        _loadHistory(state.reservationId);
      }
    });
  }

  Future<void> _loadHistory(String reservationId) async {
    try {
      final messages = await _getChatHistoryUseCase(reservationId);
      emit(state.copyWith(
        status: ChatStatus.success,
        messages: messages,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ChatStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.reservationId.isEmpty) return;

    await _socketService.sendMessage({
      'reservationId': state.reservationId,
      'type': 'text',
      'content': content,
      'isBusiness': true,
    });

    _socketService.readReservationMessage(state.reservationId);
  }

  Future<void> sendImage(File imageFile) async {
    if (state.reservationId.isEmpty) return;

    try {
      emit(state.copyWith(isUploadingImage: true));

      final photoName = await _uploadPhotoUseCase(imageFile);

      await _socketService.sendMessage({
        'reservationId': state.reservationId,
        'type': 'image',
        'content': photoName,
        'isBusiness': true,
      });

      _socketService.readReservationMessage(state.reservationId);
      
      emit(state.copyWith(isUploadingImage: false));
    } catch (error) {
      emit(state.copyWith(
        isUploadingImage: false,
        errorMessage: error.toString(),
      ));
      rethrow;
    }
  }

  void markAsRead() {
    if (state.reservationId.isNotEmpty) {
      _socketService.readReservationMessage(state.reservationId);
    }
  }

  @override
  Future<void> close() {
    _socketService.offSentSuccess((_) {});
    _socketService.offNewMessage((_) {});
    return super.close();
  }
}

