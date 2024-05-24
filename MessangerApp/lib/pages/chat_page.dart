import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:messanger_app/components/chat_bubble.dart';
import 'package:messanger_app/components/textfield_template.dart';
import 'package:messanger_app/config/constants.dart';
import 'package:messanger_app/services/auth/auth_service.dart';
import 'package:messanger_app/services/chat/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../data/database.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final int id;

  ChatPage({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final ScrollController _scrollController = ScrollController();

  late StompClient stompClient;

  ToDoDataBase db = ToDoDataBase();

  List<Map<String, dynamic>>? messages;

  Future<void> setData() async {
    List<Map<String, dynamic>> data = await _chatService.getMessages(widget.id);
    setState(() {
      messages = data;
    });
  }


  @override
  void initState() {
    setData();
    stompClient = StompClient(
      config: StompConfig(
        url: "ws://10.0.2.2:8080/ws/websocket",
        // url: "ws://192.168.1.150:8080/ws",
        onConnect: onConnectCallback,
        beforeConnect: () async {
          print(db.getToken());
          print('Waiting to connect...');
          await Future.delayed(Duration(seconds: 1));
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer ${db.getToken()}'},
        webSocketConnectHeaders: {'Authorization': 'Bearer ${db.getToken()}'},
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/${widget.id}/messages',
      // headers: {'Authorization': 'Bearer ${db.getToken()}'},
      callback: (frame) {
        if (frame.body != null) {

          Map<String, dynamic> obj = json.decode(frame.body!);
          setState(() {
            messages!.add(obj);
            _scrollController.animateTo(
                -_scrollController.position.maxScrollExtent - 300,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut
            );
          });
          // print(obj['text']);
          // print(obj);
          // messages.add(obj["text"]);
          // print(messages);
        }
      },
    );
  }

  // send message
  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      stompClient.send(
        destination: '/app/${widget.id}/message',
        // headers: {'Authorization': 'Bearer ${db.getToken()}'},
        body: jsonEncode(
          <String, String>{
            'text': _messageController.text,
          },
        ),
      );
      _messageController.clear();
    }
  }

  // send message
  // void sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     await _chatService.sendMessage(widget.id, _messageController.text);
  //     _messageController.clear();
  //     setState(() {
  //       build(context);
  //     });
  //   }
  // }

  int getCurrentUserId() {
    Map<String, dynamic> payload = Jwt.parseJwt(db.getToken());

    int userId = payload["id"];

    return userId;
  }

  @override
  Widget build(BuildContext context) {
    if (messages != null) {
      return Scaffold(
            appBar: AppBar(
              title: Text(widget.name + " ${widget.id}"),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.grey,
              elevation: 0,
            ),
            body: Column(
              children: [
                // display all messages
                Expanded(
                  child:
                  ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: _buildMessageItem(messages!.reversed.toList()[index], context),
                      );
                    },
                  ),
                ),

                // user input
                _buildUserInput(),
              ],
            ),
          );
    } else {
      return CircularProgressIndicator();
    }
  }

  // build message list
  Widget _buildMessageList() {
    return FutureBuilder(
      future: _chatService.getMessages(widget.id),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildMessageItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build messsage item
  Widget _buildMessageItem(
      Map<String, dynamic> userData, BuildContext context) {
    // is current user
    bool isCurrentUser = userData["user"]["id"] == getCurrentUserId();

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // display all chats
    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: userData["text"],
        isCurrentUser: isCurrentUser,
      ),
      // child: Text(userData["user"]["id"].toString()),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: "Type a message",
            obscureText: false,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(right: 25),
          child: IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    _messageController.dispose();
    super.dispose();
  }
}
