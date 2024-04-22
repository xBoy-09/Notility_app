import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color.fromARGB(255, 240, 249, 255);



var kLightBlueScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  onSecondaryContainer: const Color.fromARGB(255, 194, 227, 253),
  background: Colors.grey[900]
);

final kLightBlueTheme = ThemeData().copyWith(
  colorScheme: kLightBlueScheme,
  primaryColor: primaryColor,
  primaryColorDark: const Color.fromARGB(255, 14, 116, 199),
  primaryColorLight: const Color.fromARGB(255, 68, 170, 238), // gradient for login
  disabledColor:  const Color.fromARGB(255, 144, 172, 192), // signup color
  highlightColor: Colors.grey[800], // Divider Lines
  // backgroundColor: Colors.white,

  


  appBarTheme: const AppBarTheme().copyWith(

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
      color: Color.fromARGB(255, 118, 118, 118),
    ),
    backgroundColor: primaryColor,
    unselectedItemColor: Color.fromARGB(255, 150, 175, 194), // Selected tags color theme
    selectedItemColor: Color.fromARGB(255, 210, 210, 210),
    selectedIconTheme: IconThemeData( // Tags color + tabs selected background
      color: Color.fromARGB(255, 194, 227, 253),
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
            return Colors.blue.withOpacity(0.4); // Set your desired hover color
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
