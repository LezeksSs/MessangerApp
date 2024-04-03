import 'package:flutter/material.dart';
import 'package:messanger_app/components/drawer_template.dart';
import 'package:messanger_app/services/auth/auth_service.dart';
import 'package:messanger_app/services/chat/chat_service.dart';

import '../components/chat_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: MyDrawer(),
      body: _buildChatList(),
    );
  }

  // build a list of chats
  Widget _buildChatList() {
    return FutureBuilder(
      future: _chatService.getChats(),
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
              .map<Widget>((userData) => _buildChatListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildChatListItem(Map<String, dynamic> userData,
      BuildContext context) {
    // display all chats
    return ChatTile(
      text: userData["name"],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatPage(name: userData["name"], id: userData["id"],),));
      },
    );
  }
}
