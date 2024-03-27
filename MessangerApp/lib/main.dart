import 'package:flutter/material.dart';
import 'package:messanger_app/pages/home_page.dart';
import 'package:messanger_app/themes/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth/login_or_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final jwtToken = prefs.getString('token');
  final rememberMe = prefs.getBool('rememberMe') ?? false;

  if (rememberMe && jwtToken != null) {
    final isValidToken = await validateToken(jwtToken);
    if (isValidToken) {
      runApp( const MyApp(isAuthenticated: true,));
    } else {
      await prefs.remove('token');
      await prefs.remove('rememberMe');
      runApp( const MyApp(isAuthenticated: false,));
    }
  } else {
    runApp( const MyApp(isAuthenticated: false,));
  }
}

Future<bool> validateToken(String token) async {
  final response = await http.get(
    // Uri.parse('http://192.168.1.150:8080/token/validate?token=$token}'),
    Uri.parse('http://192.168.93.152:8080/token/validate?token=$token}'),
  );

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    print(responseJson['isValid']);
    return responseJson['isValid'];
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginOrRegister()
      },
      debugShowCheckedModeBanner: false,
      home: isAuthenticated ? HomePage() : LoginOrRegister(),
      theme: lightMode,
    );
  }
}

