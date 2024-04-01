
import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.150:8080/ws/topic/chat'));
  final StreamController<List<Map<String, dynamic>>> _dataStreamController = StreamController.broadcast();

  Stream<List<Map<String,dynamic>>> get dataStream => _dataStreamController.stream;

  WebSocketManager() {
    channel.stream.listen((message) {
      final List<dynamic> decodedList = jsonDecode(message);

      final List<Map<String, dynamic>> dataList = decodedList
          .map((dynamic item) => item as Map<String, dynamic>)
          .toList();
      _dataStreamController.add(dataList);
    });
  }
  void dispose() {
    _dataStreamController.close();
    channel.sink.close();
  }
}