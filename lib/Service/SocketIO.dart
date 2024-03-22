import 'package:chat_app/Utils/UtilLink.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOCaller {
  static SocketIOCaller _socketCaller = SocketIOCaller();
  IO.Socket ?socket;
  static SocketIOCaller getInstance() {
    if (_socketCaller == null) {
      _socketCaller = SocketIOCaller();
    }
    return _socketCaller;
  }

  void connectToServer() {
    socket = IO.io(UtilLink.BASE_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();
  }
}
