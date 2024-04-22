import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DropDownMain extends StatefulWidget {
  const DropDownMain({super.key});

  @override
  State<DropDownMain> createState() => _DropDownMainState();
}

class _DropDownMainState extends State<DropDownMain> {
  void _handleLogOut(ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey[100])),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: const Text('LogOut', style: TextStyle(color: Colors.red)),
          )
        ],
        title: Text(
          'Confirm Logout',
          style: TextStyle(color: Colors.grey[100]),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Text('You sure you want to LogOut. Your data and notes will be saved online.',
            style: TextStyle(color: Colors.grey[500])),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<Object>>[

          // Item 1
          PopupMenuItem(
            onTap: () => _handleLogOut(context),
            value: 2,
            child: Row(
              children: [
                const SizedBox(width: 4),
                const Icon(Icons.logout_rounded,
                    color: Color.fromARGB(255, 184, 18, 7)),
                const SizedBox(width: 8),
                Text("Logout", style: TextStyle(color: Colors.grey[100])),
              ],
            ),
          ),
        ];
      },

      // Icon for DropDown
      icon: Icon(
        Icons.more_vert_rounded,
        color: Colors.grey[300],
      ),
      color: Colors.grey[800],
    );
  }
}
