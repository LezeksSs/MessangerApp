import 'package:flutter/material.dart';

import 'package:messanger_app/components/button_template.dart';
import 'package:messanger_app/components/textfield_template.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // email and pw text controllers
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _rememberMe = false;

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value!;
      print(_rememberMe);
    });
  }

  // login method
  void login(BuildContext context) {
    final authService = AuthService();

    try {
      authService.authenticateUser(_loginController.text, _pwController.text, _rememberMe, context);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 50),
            // welcome back message
            Text(
              "Welcome back",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            // login text field
            MyTextField(
              hintText: "Login",
              obscureText: false,
              controller: _loginController,
            ),

            SizedBox(height: 10),
            // password text field
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Text(
                    "Remember me?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
                  ),
                  Checkbox(
                    checkColor: Colors.black,
                    activeColor: Colors.grey[400],
                    value: _rememberMe,
                    onChanged: _toggleRememberMe,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // sign in button
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            SizedBox(height: 25),

            // sing up button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
