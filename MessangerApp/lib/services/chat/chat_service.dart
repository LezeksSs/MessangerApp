import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:messanger_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<Map<String, dynamic>>> getChats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.get(Uri.parse(getChatsBaseUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData
          .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

// send message
  Future<void> sendMessage(int chatId, message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.post(Uri.parse(getChatsBaseUrl + "/${chatId}/message"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'text': message,
        }));
  }

// get messages
  Future<List<Map<String, dynamic>>> getMessages(int chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.get(Uri.parse(getChatsBaseUrl + "/${chatId}/message"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData
          .map<Map<String, dynamic>>((item) => item as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception("Failed to load data");
    }
  }
}
