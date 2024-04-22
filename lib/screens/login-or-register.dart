import 'package:flutter/material.dart';
import 'package:notility/screens/login_page.dart';
import 'package:notility/screens/sign_up_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({
    super.key,
  });

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(context) {
    print(showLoginPage);
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return SignUpPage(
        onTap: togglePages,
      );
    }
  }
}