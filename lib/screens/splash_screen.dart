import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notility/screens/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 100.0,
                width: 100.0,
                image: AssetImage(
                  isDarkMode ? "assets/images/icon_light.png": "assets/images/icon.png",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Notility",
                style: GoogleFonts.rem(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[300] : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void whereToGo() async {
    // var sharedPref = await SharedPreferences.getInstance();
    // var isLoggedIn = sharedPref.getBool("Login");
    // var userId = sharedPref.getString("userId");

    Timer(const Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => AuthPage()));
    });
  }
}
