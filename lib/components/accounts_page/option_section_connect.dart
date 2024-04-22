import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notility/components/accounts_page/inner_tile_connect.dart';
import 'package:notility/screens/login-or-register.dart';
import 'package:notility/server/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notility/screens/splash_screen.dart';

class OptoinSectionConnect extends StatelessWidget {
  const OptoinSectionConnect({super.key});

  final int colorVal = 41;

  void onTapGoogle() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Connect',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ),
        const SizedBox(height: 0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Connect your account for easy login, to enhance security and enable additional features.',
            style: GoogleFonts.inter(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[800]!,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Color.fromARGB(255, colorVal, colorVal, colorVal),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InnerTileConnect(
                onTap: () => AuthServoce().signInWithGoogle(),
                heading: 'Google',
              ),
            ],
          ),
        ),
        const SizedBox( height: 16.0), // Added space between the Google button and the delete button
              ElevatedButton(
                onPressed: () {
                  // Delete user from Firebase
                  FirebaseAuth.instance.currentUser?.delete();

                  // Navigate back to the login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => false, // Remove all routes until this one
                  );
                },
                child: const Text('Delete User and Logout'),
              ),
      ],
    );
  }
}
