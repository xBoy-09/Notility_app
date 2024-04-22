import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoProfile extends StatelessWidget {
  UserInfoProfile({super.key});

  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.displayName!,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.email!,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8),
            user.emailVerified
                ? Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.green.shade700,
                  )
                : Text(
                    '<not verified>',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.red[500],
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
