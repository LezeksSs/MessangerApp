import 'package:flutter/material.dart';
import 'package:messanger_app/auth/auth_service.dart';
import 'package:messanger_app/components/drawer_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: MyDrawer(),
    );
  }
}