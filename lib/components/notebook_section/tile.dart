import 'package:flutter/material.dart';
import 'package:notility/models/note.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.heading,
    required this.toggleIsExpanded,
    required this.openANote,
    required this.note,
    required this.isNotebookNull,
    required this.isNoteBook,
    required this.expand,
    required this.isExpanded,
  });

  final String heading;
  final void Function() toggleIsExpanded;
  final void Function({Note? note})? openANote;
  final Note? note;
  final bool isNotebookNull;
  final bool isNoteBook;
  final bool expand;
  final bool isExpanded;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () {
          expand ? toggleIsExpanded() : openANote?.call(note: note);
        },
        child: Row(
          children: [
            if (!isNotebookNull) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                transform: isExpanded
                    ? Matrix4.rotationZ(3.14 / 2)
                    : Matrix4.rotationZ(0),
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[500],
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Image.asset(
              isNoteBook
                  ? 'assets/images/notebook_icon.png'
                  : note == null
                      ? 'assets/images/section_icon.png'
                      : 'assets/images/note_icon.png',
              height: 22,
            ),
            const SizedBox(width: 16),
            Text(
              heading.length > 20
                  ? heading.substring(0, 20) + '...'
                  : heading,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
