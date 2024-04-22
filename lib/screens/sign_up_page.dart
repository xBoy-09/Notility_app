import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/sign_in_button.dart';
import 'package:notility/components/main_page/square_tile.dart';
import 'package:notility/server/auth_service.dart';
import 'package:notility/server/mongodb.dart';
import 'package:notility/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();

  bool passwordSame = true;
  bool errorMessage = false;
  late String text;

  void onSignUpTap() async {
    if (fullNameController.text.isEmpty) {
      throw FirebaseAuthException(code: 'empty-name');
    }

    // show loading circle
    setState(() {
      errorMessage = false;
      passwordSame = true;
    });

    try {
      // check if passwords are same
      if (passwordController.text == confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          FirebaseAuth.instance.currentUser!
              .updateDisplayName(fullNameController.text);
          Navigator.pop(context);
        });
        await createNewuserData(FirebaseAuth.instance.currentUser!.uid);
        MongoDatabase.createNewEntry(
            emailController.text, FirebaseAuth.instance.currentUser!.uid);
      } else {
        // show error message
        setState(() {
          passwordSame = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        text = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        text = "The account already exists for that email.";
      } else if (e.code == 'empty-name') {
        text = "Your Name cannot be empty";
      } else if (e.code == 'invalid-email') {
        text = 'Sorry, enter valid email';
      } else {
        text = e.code;
      }

      Navigator.pop(context);
      setState(() {
        errorMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(12, 16, 0, 0),
          child: Text('Notility', style: TextStyle(fontSize: 68),),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 0),
                child: Text(
                  'Your new AI-powered note-taking assistant',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Email and password feilds
            const SizedBox(height: 68),
            InputFeild(hintText: 'Email', controller: emailController),
            const SizedBox(height: 12),
            InputFeild(
              hintText: 'Full Name',
              controller: fullNameController,
            ),
            const SizedBox(height: 12),
            InputFeild(
              hintText: 'Password',
              controller: passwordController,
              obsecureFeild: true,
            ),
            const SizedBox(height: 12),
            InputFeild(
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
              obsecureFeild: true,
            ),

            // Password not same error
            if (!passwordSame)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 48, top: 3),
                  child: Text(
                    '* Password do not match',
                    style: TextStyle(fontSize: 13, color: Colors.red[600]),
                  ),
                ),
              ),

            if (errorMessage)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 48, top: 3),
                  child: Text(
                    "* $text",
                    style: TextStyle(fontSize: 13, color: Colors.red[600]),
                  ),
                ),
              ),

            // Forgot Password Button
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     margin: const EdgeInsets.only(right: 48, top: 8),
            //     child: Text(
            //       'Forgot Password?',
            //       style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 24),
            SignInButton(
              onTap: onSignUpTap,
              text: 'Sign Up',
            ),
            const SizedBox(height: 50),

            // Ui Element (Devider)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or Continue with ',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  )
                ],
              ),
            ),

            // Google + Facebook Button
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Button
                SquareTile(
                  imagePath: 'assets/images/google.png',
                  onTap: () => AuthServoce().signInWithGoogle(),
                ),

              ],
            ),

            const SizedBox(height: 25),
            // SignUp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                    onTap: () {
                      widget.onTap!();
                    },
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

// For email and password
class InputFeild extends StatelessWidget {
  const InputFeild({
    super.key,
    required this.hintText,
    required this.controller,
    this.obsecureFeild = false,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obsecureFeild;

  @override
  Widget build(context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 48),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: TextField(
            obscureText: obsecureFeild,
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              contentPadding: const EdgeInsets.only(left: 12),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
