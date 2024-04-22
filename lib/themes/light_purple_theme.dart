import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color.fromARGB(255, 245, 239, 249);



var kLightPurpleScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  onSecondaryContainer: Color.fromARGB(255, 159, 134, 161),
);

final kLightPurpleTheme = ThemeData().copyWith(
  colorScheme: kLightPurpleScheme,
  primaryColor: primaryColor,
  primaryColorDark: const Color.fromARGB(255, 130, 63, 172),
  primaryColorLight: const Color.fromARGB(255, 185, 101, 241), // gradient for login
  disabledColor:  const Color.fromARGB(255, 188, 147, 198), // signup color
  highlightColor: const Color.fromARGB(49, 250, 88, 236), //box shadow on signin form
  backgroundColor: Colors.white,




  appBarTheme: const AppBarTheme().copyWith(
    toolbarHeight: 68,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    titleTextStyle: GoogleFonts.rem(
      color: Colors.black,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedIconTheme: IconThemeData(
      color: Color.fromARGB(255, 142, 95, 148),
    ),
    backgroundColor: primaryColor,
    unselectedItemColor: Color.fromARGB(255, 172, 147, 191), // Selected tags color theme
    selectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData( // Tags color + tabs selected background
      color: Color.fromARGB(255, 240, 194, 255),
    ),
  ),

  textTheme: const TextTheme().copyWith(

    // headings on Last_Notes + Card headline
    headlineSmall: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Colors.black,
    ),

    // Card content
    bodyMedium: const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),

  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Set your desired border radius
        ),),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color.fromARGB(255, 142, 33, 243).withOpacity(0.4); // Set your desired hover color
          } else if (states.contains(MaterialState.pressed)){
            return primaryColor;
          }
          return null; // Use default value
        },
      ),
    )
  ),

  cardTheme: const CardTheme(
    color: primaryColor,
  )

);
