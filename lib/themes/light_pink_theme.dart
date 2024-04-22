import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color.fromARGB(255, 249, 239, 245);



var kLightPinkScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  onSecondaryContainer: const Color.fromARGB(255, 161, 134, 148),
  background: Colors.white
);

final kLightPinkTheme = ThemeData().copyWith(
  colorScheme: kLightPinkScheme,
  primaryColor: primaryColor,
  primaryColorDark: const Color.fromARGB(255, 172, 63, 141),
  primaryColorLight: const Color.fromARGB(255, 211, 71, 185), // gradient for login
  disabledColor:  const Color.fromARGB(255, 198, 147, 182), // signup color
  highlightColor: const Color.fromARGB(47, 250, 88, 209), //box shadow on signin form
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
      color: Color.fromARGB(255, 148, 95, 133),
    ),
    backgroundColor: primaryColor,
    unselectedItemColor: Color.fromARGB(255, 191, 147, 186), // Selected tags color theme
    selectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData( // Tags color + tabs selected background
      color: Color.fromARGB(255, 233, 171, 228),
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
            return const Color.fromARGB(255, 243, 33, 163).withOpacity(0.4); // Set your desired hover color
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
