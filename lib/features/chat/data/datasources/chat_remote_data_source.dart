import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/chat_message.dart';

class ChatException implements Exception {
  final String message;
  const ChatException(this.message);

  @override
  String toString() => message;
}

@lazySingleton
class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource(this._dio);

  Future<List<ChatMessage>> getChatBoxReservation(String reservationId) async {
    try {
      final response = await _dio.get('/reservations/$reservationId/activities', queryParameters: {'limit': 50});
      final data = response.data;

      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      if (data is Map<String, dynamic>) {
        var payload = data['data'];
        if (payload is Map<String, dynamic> && payload['data'] != null) {
          payload = payload['data'];
        }

        if (payload is List) {
          return payload
              .whereType<Map>()
              .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }

      return const <ChatMessage>[];
    } on DioException catch (error) {
      final message = error.response?.data;
      if (message is Map<String, dynamic> && message['message'] is String) {
        throw ChatException(message['message'] as String);
      }
      throw const ChatException('Network error. Please try again.');
    }
  }
}

