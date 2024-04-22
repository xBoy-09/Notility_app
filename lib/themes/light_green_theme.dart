import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color.fromARGB(255, 239, 249, 245);



var kLightGreenScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  onSecondaryContainer: const Color.fromARGB(255, 134, 161, 152),
);

final kLightGreenTheme = ThemeData().copyWith(
  colorScheme: kLightGreenScheme,
  primaryColor: primaryColor,
  primaryColorDark: Color.fromARGB(255, 63, 172, 116),
  primaryColorLight: Color.fromARGB(255, 71, 211, 155), // gradient for login
  disabledColor:  Color.fromARGB(255, 147, 198, 172), // signup color
  highlightColor: Color.fromARGB(48, 88, 250, 193), //box shadow on signin form
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
      color: Color.fromARGB(255, 95, 148, 121),
    ),
    backgroundColor: primaryColor,
    unselectedItemColor: Color.fromARGB(255, 147, 191, 168), // Selected tags color theme
    selectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData( // Tags color + tabs selected background
      color: Color.fromARGB(255, 171, 233, 202),
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
            return Color.fromARGB(255, 33, 243, 138).withOpacity(0.4); // Set your desired hover color
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
