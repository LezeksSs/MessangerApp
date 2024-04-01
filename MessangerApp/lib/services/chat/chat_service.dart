import 'dart:convert';

import 'package:messanger_app/services/web_socket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  // get chat stream
  /*
  List<Map<String,dynamic>> =
  [
    {
      'id': ..
      'name': ..
    },
    {
      'id': ..
      'name': ..
    },
  ]
   */

  Stream<List<Map<String, dynamic>>> getChatsStream() {
    WebSocketManager webSocketManager = WebSocketManager();
    return webSocketManager.dataStream;
  }

// send message

// get messages
}
