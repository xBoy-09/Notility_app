import 'package:flutter/material.dart';
import 'package:notility/models/note.dart';
import 'package:notility/utils.dart';

class InnerContentsSearchPage extends StatelessWidget {
  const InnerContentsSearchPage({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Align(
      // alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading icon
          Container(
            width: 52,
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/images/note_icon.png',
              scale: 42,
            ),
          ),

          // Main body
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                note.heading!,
                style: TextStyle(color: Colors.grey[300], fontSize: 15),
              ),
          
              //Route
              Text(
                'in ${parseSectionName(note.route)} - ${parseNotebookName(note.route)}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11.5,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
