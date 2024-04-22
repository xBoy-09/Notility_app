import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> updateDisplayName(String displayName) async {
  // firebase code to update user
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      print('Display name updated successfully');
    } else {
      print('User not found');
    }
  } catch (e) {
    print('Failed to update display name: $e');
  }
}

class UpdateUser extends StatelessWidget {
  UpdateUser({super.key});
  
  final User user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _confirmUsernameController =
      TextEditingController();

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
              Text(
                'Change Username',
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
                controller: _newUsernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 138, 138, 138)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmUsernameController,
                decoration: const InputDecoration(
                  hintText: 'Confirm new username',
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
                onPressed: () async {
                  String newUsername = _newUsernameController.text.trim();
                  String confirmUsername =
                      _confirmUsernameController.text.trim();

                  if (newUsername.isEmpty || confirmUsername.isEmpty) {
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
                          content:
                              const Text('Username fields cannot be empty.'),
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
                  if (newUsername != confirmUsername) {
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
                          content: const Text('New usernames do not match.'),
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
                  if (newUsername != user.displayName) {
                    try {
                      updateDisplayName(newUsername);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            titleTextStyle:
                                const TextStyle(color: Colors.white),
                            contentTextStyle:
                                const TextStyle(color: Colors.white),
                            title: const Text('Success'),
                            content:
                                const Text('Username successfully updated.'),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); // go back to accounts screen
                                  Navigator.pop(
                                      context); // go back to accounts screen
                                },
                                child: const Text('Go to Home'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            titleTextStyle:
                                const TextStyle(color: Colors.white),
                            contentTextStyle:
                                const TextStyle(color: Colors.white),
                            title: const Text('Failed'),
                            content: Text('$error'),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); // go back to accounts screen
                                },
                                child: const Text('Go to Home'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // if new username is same as the old
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          titleTextStyle: const TextStyle(color: Colors.white),
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          title: const Text('Error'),
                          content: const Text(
                              'New username must be different from current username.'),
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
                child: const Text('Update Username'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
