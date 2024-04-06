import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:messanger_app/config/constants.dart';

import '../../data/database.dart';

class AuthService {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  Future<void> authenticateUser(String nickname, String password,
      bool rememberMe, BuildContext context) async {
    final url = Uri.parse(authBaseUrl);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nickname': nickname,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];
        await prefs.setString('token', token);
        await prefs.setBool('rememberMe', rememberMe);

        db.createInitialData(token);

        print(prefs.getString('token') ?? 'no token');
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        print('Ошибка аутентификации: ${response.body}');
      }
    } catch (error) {
      print('Ошибка сети: $error');
    }
  }

  // singup

  Future<void> signUp(String nickname, String email, String password,
      BuildContext context) async {
    final url = Uri.parse(registerBaseUrl);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nickname': nickname,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];
        await prefs.setString('token', token);

        db.createInitialData(token);

        print(prefs.getString('token') ?? 'no token');
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        print('Ошибка аутентификации: ${response.body}');
      }
    } catch (error) {
      print('Ошибка сети: $error');
    }
  }

  // signout
  Future<void> signOut(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('rememberMe');

    db.deleteData();

    Navigator.of(context).pushReplacementNamed('/login');
  }

}
