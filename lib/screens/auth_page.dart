import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/screens/login-or-register.dart';
import 'package:notility/screens/tabs_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });


  @override
  Widget build(context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          // user is logged in
            if (snapshot.hasData){
              return const TabsScreen();
            }
          // user is not logged in
            else {
              return const LoginOrRegisterPage();
            }

        }),
      ),
    );
  }
}