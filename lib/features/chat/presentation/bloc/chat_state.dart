import 'package:equatable/equatable.dart';
import '../../data/models/chat_message.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatMessage> messages;
  final String? errorMessage;
  final String reservationId;
  final bool isUploadingImage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
    required this.reservationId,
    this.isUploadingImage = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? errorMessage,
    String? reservationId,
    bool? isUploadingImage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
      reservationId: reservationId ?? this.reservationId,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage, reservationId, isUploadingImage];
}


