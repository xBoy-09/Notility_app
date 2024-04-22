import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/main_page/square_letter.dart';

class MainMenuAppBar extends StatelessWidget {
  MainMenuAppBar({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          // horizontal: 8,
          ),
      child: Row(
        children: [
          SquareLetter(user: user),
          const SizedBox(width: 12),

          // Name and email
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      user.displayName ?? '',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      user.email!,
                      style: TextStyle(
                          fontFamily: 'Amiko',
                          fontSize: 12,
                          color: Colors.grey[600]),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Name and email

          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 12),
          //     child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(
          //         Icons.more_vert,
          //         color: Colors.grey[200],
          //         size: 32,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
