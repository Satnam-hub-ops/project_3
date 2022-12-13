import 'package:flutter/material.dart';
import 'package:todoapp/auth/authforms.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: AuthForm(),
    );
  }
}
