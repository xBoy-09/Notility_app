import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notility/components/note_card/cancel_button.dart';
import 'package:notility/components/note_card/delete_button.dart';
import 'package:notility/models/note.dart';
import 'package:notility/screens/main_screen.dart';
import 'package:notility/screens/new_note.dart';
import 'package:notility/animations/slide_page.dart';
import 'package:notility/screens/tabs_screen.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  double blurVal = 3.0;
  bool isLongPressed = false;

  // Shows Delete option on long press of the card
  void _showDeleteNoteOption() {
    setState(() {
      isLongPressed = true;
      blurVal = 3.0;
    });
  }

  void _cancelDeleteNoteOption() {
    setState(() {
      isLongPressed = false;
      blurVal = 0;
    });
  }

  void onTapDelete() {
    TabsScreen.of(context)!.deleteNote(widget.note.id);
    _cancelDeleteNoteOption();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteNoteOption();
      },
      onTap: () {
        Navigator.of(context)
            .push(
          SlidePageRoute(
            page: NewNote(
              note: widget.note,
              route: widget.note.route,
            ),
          ),
        )
            .then((value) {
          if (value['delete']) {
            TabsScreen.of(context)!.deleteNote(value['id']);
          } else {
            TabsScreen.of(context)!.updateNote(
              id: value['updateId'],
              content: value['content'],
              heading: value['heading'],
              route: value['route'],
              isPinned: value['isPinned'],
            );
          }
        });
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
            color: Colors.grey[850],
            border: Border.all(
                color: const Color.fromARGB(255, 75, 75, 75), width: 1),
            borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(0, 12, 18, 12),
        child: Stack(
          children: [
            // Content
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Text(
                  widget.note.content.length > 20
                      ? '${widget.note.content.substring(0, 20)}...'
                      : widget.note.content,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ),

            // Black background
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),

            // heading
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 88, 12, 0),
                child: Text(
                  widget.note.heading!.length > 25
                      ? '${widget.note.heading!.substring(0, 20)}...'
                      : widget.note.heading!,
                  style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Sans Lao Looped'),
                ),
              ),
            ),

            // Note Icon
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 0, top: 4),
                child: Image.asset(
                  'assets/images/note_icon.png',
                  height: 30,
                ),
              ),
            ),

            // Long Pressed Delete Option
            if (isLongPressed) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurVal, sigmaY: blurVal),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(),
                  ),
                ),
              ),

              // Delete Button
              DeleteButton(
                onTapDelete: onTapDelete,
              ),

              // Cancel button
              CancelButton(cancelDeleteNoteOption: _cancelDeleteNoteOption)
            ],
          ],
        ),
      ),
    );
  }
}
