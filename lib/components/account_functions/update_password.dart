import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  String verificationCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); // go back
              },
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              'Change Password',
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
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Account Email',
                hintStyle: TextStyle(color: Color.fromARGB(255, 138, 138, 138)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Background color
                foregroundColor: Colors.black, // Text color
              ),
              onPressed: () {
                if (emailController.text ==
                    FirebaseAuth.instance.currentUser?.email) {
                  _sendVerificationCode();
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
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
    } catch (e) {
      // if failed
    }
  }
}
