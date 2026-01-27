import 'package:injectable/injectable.dart';
import '../../data/models/chat_message.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetChatHistoryUseCase {
  final ChatRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<List<ChatMessage>> call(String reservationId) {
    return _repository.getChatBoxReservation(reservationId);
  }
}


