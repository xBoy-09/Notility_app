import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptoinSectionVerifyEmail extends StatelessWidget {
  OptoinSectionVerifyEmail({super.key});

  final int colorVal = 41;
  final User user = FirebaseAuth.instance.currentUser!;

  void onTap() {
    if (!user.emailVerified) {
      print('Verifying email');
      user.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              GestureDetector(
                onTap: onTap,
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
                            'Verify Email',
                            style: GoogleFonts.inter(
                              fontSize: 16.5,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            user.emailVerified
                                ? 'Your email is verified'
                                : 'Verify your email address',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: !user.emailVerified
                                  ? Colors.red
                                  : Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          user.emailVerified
                              ? Icons.verified
                              : Icons.arrow_forward_ios,
                          color: user.emailVerified
                              ? Colors.green[700]
                              : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
