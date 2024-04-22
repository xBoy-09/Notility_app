// for main tab (First letter of the name at the top)

import 'package:flutter/material.dart';

class SquareLetter extends StatelessWidget {
  const SquareLetter({super.key, required this.user});

  final user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          user.displayName?.substring(0, 1) ?? '',
          style: TextStyle(
            fontFamily: 'Sofia Sans',
            fontSize: 24,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
