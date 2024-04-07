

import 'package:flutter/material.dart';

import 'package:messanger_app/components/drawer_template.dart';
import 'package:messanger_app/services/auth/auth_service.dart';
import 'package:messanger_app/services/chat/chat_service.dart';

import '../components/chat_tile.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final _controller = TextEditingController();

  void _createChat() async{
    if (_controller.text.isNotEmpty) {
      await _chatService.createChat(_controller.text);
      _controller.clear();
    }
    setState(() {
      build(context);
    });
  }

  void _deleteChat(int chatId) {
    _chatService.deleteChat(chatId);
    setState(() {
      build(context);
    });
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // get user input
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Input username",
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // save button
                    MaterialButton(
                      onPressed: _createChat,
                      child: Text("Create"),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    // cancel button
                    MaterialButton(
                      onPressed: () {
                        _controller.clear();
                        return Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                )
                // buttons -> save + cancel
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAlertDialog(context),
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _buildChatList(),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
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

  Widget _buildChatListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all chats
    return ChatTile(
      text: userData["name"],
      deleteFunction: (context) => _deleteChat(userData["id"]),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                name: userData["name"],
                id: userData["id"],
              ),
            ));
      },
    );
  }
}
