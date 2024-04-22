import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InnerTileAccounts extends StatelessWidget {
  InnerTileAccounts({
    super.key,
    required this.heading,
    required this.description,
    required this.onTap,
  });

  final String heading;
  final String description;
  final void Function(BuildContext) onTap;
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          onTap(context);
        } catch (e) {
          print('Error occurred: $e');
          // show a snackbar or dialog to notify the user about the error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. Please try again later.'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  heading,
                  style: GoogleFonts.inter(
                    fontSize: 16.5,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                heading == 'Verify Email' && user.emailVerified ? Icons.verified : Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
