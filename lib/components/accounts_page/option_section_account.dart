import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notility/components/accounts_page/inner_tile.dart';
import 'package:notility/screens/account_page.dart';

class OptoinSectionAccount extends StatelessWidget {
  OptoinSectionAccount({super.key, required this.heading});
  final String heading;
  final int colorVal = 41;
  final User user = FirebaseAuth.instance.currentUser!;

  void onTapName(BuildContext context) {
    // code to update name
    final TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (value) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Row(
              children: [
                Text('Update Name',
                    style: GoogleFonts.inter(
                        color: Colors.grey[300], fontSize: 24)),
                // const SizedBox(width: 32),
                // if (loading) const CircularProgressIndicator(strokeWidth: 3)
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Name',
                    style: GoogleFonts.inter(
                        color: Colors.grey[500], fontSize: 18)),
                const SizedBox(height: 4),
                Text(user.displayName!,
                    style: GoogleFonts.inter(
                        color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 12),
                Text('New Name',
                    style: GoogleFonts.inter(
                        color: Colors.grey[500], fontSize: 18)),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(bottom: 3),
                    hintText: 'Enter new name',
                    hintStyle: GoogleFonts.inter(
                        color: Colors.grey[700], fontSize: 14),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // code to update name
                  if (user.displayName! != nameController.text) {
                    try {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      await user
                          .updateDisplayName(nameController.text)
                          .then((value) {
                        AccountScreen.resetScreen(context);
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      print('Failed to update display name: $e');
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  void onTapEmail(BuildContext context) {
    // code to update email

    final TextEditingController emailController = TextEditingController();
    final TextEditingController confirmEmailController =
        TextEditingController();
    bool showError = false;
    String error = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update Email',
                  style:
                      GoogleFonts.inter(color: Colors.grey[300], fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                'Important : You will be logged out on confirming the email address.',
                style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Email',
                  style:
                      GoogleFonts.inter(color: Colors.grey[500], fontSize: 18)),
              const SizedBox(height: 4),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  hintText: 'Enter old email to confirm',
                  hintStyle:
                      GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              Text('New Email',
                  style:
                      GoogleFonts.inter(color: Colors.grey[500], fontSize: 18)),
              const SizedBox(height: 4),
              TextField(
                controller: confirmEmailController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  hintText: 'Enter new email',
                  hintStyle:
                      GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              if (showError)
                Text(
                  error,
                  style:
                      GoogleFonts.inter(color: Colors.red[500], fontSize: 12),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // code to update email
                print('Updating email');
                if (user.email! != emailController.text) {
                  print('Not same');
                  error = '* Old email not correct. Please enter correct email';
                  setState(() {
                    showError = true;
                  });
                } else {
                  if (confirmEmailController.text.isEmpty) {
                    error = '* Please enter a valid email';
                    setState(() {
                      showError = true;
                    });
                  } else {
                    try {
                      print(
                          'Updating email to : ${confirmEmailController.text}');
                      user.verifyBeforeUpdateEmail(confirmEmailController.text);
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut(); // Log out the user
                    } catch (e) {
                      print('Failed to update email: $e');
                    }
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void onTapPassword(BuildContext context) {
    // code to update password
    final auth = FirebaseAuth.instance;
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password',
                  style:
                      GoogleFonts.inter(color: Colors.grey[300], fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                'Enter current email to receive reset email.\nNote: You will be logged out.',
                style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Email',
                  style:
                      GoogleFonts.inter(color: Colors.grey[500], fontSize: 18)),
              const SizedBox(height: 4),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  hintText: 'Enter current email',
                  hintStyle:
                      GoogleFonts.inter(color: Colors.grey[700], fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (emailController.text ==
                    FirebaseAuth.instance.currentUser?.email) {
                  _sendVerificationCode(auth, emailController);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          title: const Text('Success'),
                          content: const Text(
                              'Password Reset Email Sent. Please check your Inbox.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // Navigator.pop(context);
                                FirebaseAuth.instance
                                    .signOut(); // Log out the user
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          title: const Text('Error'),
                          content: const Text(
                              'Invalid Email Provided. Please reenter and try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                }
              },
              child: const Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode(
      var auth, TextEditingController emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
    } catch (e) {
      // if failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            heading,
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
            'Update your account info to your profile',
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
              InnerTileAccounts(
                heading: 'Change Email',
                description: 'Update your email address',
                onTap: onTapEmail,
              ),
              Divider(
                color: Colors.grey[800],
                height: 0,
                thickness: 0.7,
              ),
              InnerTileAccounts(
                heading: 'Change Name',
                description: 'Update your Name',
                onTap: onTapName,
              ),
              Divider(
                color: Colors.grey[800],
                height: 0,
                thickness: 0.7,
              ),
              InnerTileAccounts(
                heading: 'Change Password',
                description: 'Update your Password',
                onTap: onTapPassword,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
