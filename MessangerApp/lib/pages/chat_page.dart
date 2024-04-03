import 'package:flutter/material.dart';
import 'package:messanger_app/components/textfield_template.dart';
import 'package:messanger_app/services/auth/auth_service.dart';
import 'package:messanger_app/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String name;
  final int id;

  ChatPage({
    super.key,
    required this.name,
    required this.id,
  });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(id, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name + " ${id}"),
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return FutureBuilder(
      future: _chatService.getMessages(id),
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
    // display all chats
    return Text(userData["text"]);
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
        IconButton(
          onPressed: sendMessage,
          icon: Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}
