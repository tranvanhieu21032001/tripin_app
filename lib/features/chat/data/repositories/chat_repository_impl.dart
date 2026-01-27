import 'package:injectable/injectable.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;

  ChatRepositoryImpl(this._remote);

  @override
  Future<List<ChatMessage>> getChatBoxReservation(String reservationId) {
    return _remote.getChatBoxReservation(reservationId);
  }
}


