import 'package:flutter/material.dart';

class HeadingNewNote extends StatefulWidget {
  const HeadingNewNote({super.key, required this.headingController});

  final TextEditingController headingController;

  @override
  State<HeadingNewNote> createState() => _HeadingNewNoteState();
}

class _HeadingNewNoteState extends State<HeadingNewNote> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin:const  EdgeInsets.symmetric(horizontal: 8),
        // width: MediaQuery.of(context).size.width * 0.70,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: 0,
            ),
            child: TextField(
              autocorrect: true,
              onChanged: (text) {
                setState(() {});
              },
              autofocus: true,
              maxLines: 1,
              // expands: true,
              controller: widget.headingController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                isDense: true,
                // contentPadding: EdgeInsets.fromLTRB(16, 8,
                //     MediaQuery.of(context).size.width * 0.4, 8),
                border: InputBorder.none,
                hintText: "${"Type your Heading"} ...",
                hintStyle: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
            )));
  }
}
