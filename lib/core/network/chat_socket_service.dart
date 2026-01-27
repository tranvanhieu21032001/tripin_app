import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatSocketService {
  static const _wssEndpoint = 'wss://discovery-api-prod.wemu.co';

  io.Socket? _socket;
  bool _isConnected = false;
  bool _initialised = false;

  bool get isConnected => _isConnected;
  io.Socket? get socket => _socket;

  void connectToSocket(String token, {void Function()? onConnectSuccess}) {
    // print('[SOCKET] try connect | token=${token.substring(0, token.length > 6 ? 6 : token.length)}***');
    if (_isConnected) return;

    final options = <String, dynamic>{
      'transports': ['websocket'],
      'reconnection': true,
      'query': {
        'token': token,
        'isBusiness': true,
        'requestFrom': 'business_web',
      },
    };

    _socket = io.io(_wssEndpoint, options);
    _socket!.on('connect', (_) {
      // ignore: avoid_print
      print('[SOCKET] connected');
      _isConnected = true;
      if (!_initialised && onConnectSuccess != null) {
        onConnectSuccess();
        _initialised = true;
      }
    });
    _socket!.on('disconnect', (_) {
      // ignore: avoid_print
      print('[SOCKET] disconnected');
      _isConnected = false;
    });
    _socket!.on('connect_error', (error) {
      // ignore: avoid_print
      print('[SOCKET] connect_error: $error');
    });
    _socket!.on('connect_timeout', (error) {
      // ignore: avoid_print
      print('[SOCKET] connect_timeout: $error');
    });
    _socket!.on('error', (error) {
      // ignore: avoid_print
      print('[SOCKET] error: $error');
    });
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    if (_isConnected) {
      // ignore: avoid_print
      print('[SOCKET] emit single-message $data');
      _socket!.emit('single-message', data);
    } else {
      // ignore: avoid_print
      print('[SOCKET] emit failed, not connected');
    }
  }

  Future<void> readReservationMessage(String reservationId) async {
    if (_isConnected) {
      // ignore: avoid_print
      print('[SOCKET] emit viewed-reservation $reservationId');
      _socket!.emit('viewed-reservation', reservationId);
    }
  }

  void onSentSuccess(Function(dynamic) listener) {
    _socket?.on('sent-single-message', (data) {
      // ignore: avoid_print
      print('[SOCKET] on sent-single-message $data');
      listener(data);
    });
  }

  void offSentSuccess(Function(dynamic) listener) {
    _socket?.off('sent-single-message', listener);
  }

  void onNewMessage(Function(dynamic) listener) {
    _socket?.on('incoming-single-message', (data) {
      // ignore: avoid_print
      print('[SOCKET] on incoming-single-message $data');
      listener(data);
    });
  }

  void offNewMessage(Function(dynamic) listener) {
    _socket?.off('incoming-single-message', listener);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _isConnected = false;
    _initialised = false;
  }
}

