import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messanger_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:messanger_app/pages/home_page.dart';
import 'package:messanger_app/services/auth/login_or_register.dart';
import 'package:messanger_app/themes/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final jwtToken = prefs.getString('token');
  final rememberMe = prefs.getBool('rememberMe') ?? false;

  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');

  if (rememberMe && jwtToken != null) {
    final isValidToken = await validateToken(jwtToken);
    if (isValidToken) {
      runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(
          isAuthenticated: true,
        ),
      ));
    } else {
      await prefs.remove('token');
      await prefs.remove('rememberMe');
      runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(
          isAuthenticated: false,
        ),
      ));
    }
  } else {
    runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(
        isAuthenticated: false,
      ),
    ));
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
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
