import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notility/screens/auth_page.dart';

Future<void> updateEmailHelp(String newEmail) async {
  try {
    await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
    FirebaseAuth.instance.signOut(); // Log out the user
  } catch (e) {
    // if
  }
}

// ignore: must_be_immutable
class UpdateEmail extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _oldEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  String? email = FirebaseAuth.instance.currentUser!.email;

  UpdateEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // go back
                },
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              // Text("$email"),
              Text(
                'Change Email',
                style: TextStyle(
                  fontFamily: 'Amiko',
                  fontWeight: FontWeight.normal,
                  fontSize: 20.2,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                // text box for user to enter
                controller: _oldEmailController,
                decoration: const InputDecoration(
                  hintText: 'Enter old email',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 138, 138, 138)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newEmailController,
                decoration: const InputDecoration(
                  hintText: 'Enter new email',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 138, 138, 138)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Background color
                  foregroundColor: Colors.black, // Text color
                ),
                onPressed: () {
                  String oldEmail = _oldEmailController.text.trim();
                  String newEmail = _newEmailController.text.trim();

                  if (newEmail.isEmpty || oldEmail.isEmpty) {
                    // if both fields are not filled
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
                          content: const Text('Email fields cannot be empty.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // Check if the new username and confirm username match
                  if (oldEmail != FirebaseAuth.instance.currentUser?.email) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          content: const Text('Old email is incorrect.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  // Check if the new username is different from the current displayName
                  if (newEmail != oldEmail) {
                    updateEmailHelp(newEmail);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          title: const Text('Success'),
                          content: const Text(
                              'Verification Email sent to new email address. You have been logged out.'),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthPage())); // go back to accounts screen
                              },
                              child: const Text('Go to Home'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // if new email is same as the old
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          title: const Text('Error'),
                          content: const Text(
                              'New email must be different from current email.'),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Update Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
