import 'package:flutter/material.dart';
import 'package:notility/screens/splash_screen.dart';
import 'package:notility/server/mongodb.dart';
import 'package:notility/themes/light_blue_theme.dart';
import 'package:notility/themes/light_green_theme.dart';
import 'package:notility/themes/light_pink_theme.dart';
import 'package:notility/themes/light_purple_theme.dart';
import 'package:notility/themes/light_red_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'whisper_api.dart';
import 'chatgpt_api.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Map<String, ThemeData> themes = {
  'lightBlue': kLightBlueTheme,
  'lightPurple': kLightPurpleTheme,
  'lightGreen': kLightGreenTheme,
  'lightRed': kLightRedTheme,
  'lightPink': kLightPinkTheme,
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MongoDatabase.connect();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = kLightBlueTheme;

  void changeTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  ThemeData getTheme() {
    return _currentTheme;
  }

  @override
  void initState() {
    // seeSetTheme();
    super.initState();
  }

  // void seeSetTheme() async {
  //   var sharedPref = await SharedPreferences.getInstance();
  //   bool isSetTheme = sharedPref.getBool("Theme") ?? false;
  //   _currentTheme =
  //       isSetTheme ? themes[sharedPref.getString("setTheme")]! : kLightBlueTheme;
  //   sharedPref.setBool("Theme", true);
  //   sharedPref.setString("setTheme", sharedPref.getString("setTheme")!);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kLightBlueTheme,
      home: const SplashScreen(),
    );
  }
}
