import '../../data/models/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getChatBoxReservation(String reservationId);
}


