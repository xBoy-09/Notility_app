import 'package:flutter/material.dart';

class ShowAddOption extends StatelessWidget {
  const ShowAddOption({
    super.key,
    required this.isNotebook,
    required this.isNotesSection,
    required this.addNewNoteBook,
    required this.addANote,
  });

  final bool isNotebook;
  final bool isNotesSection;
  final void Function() addNewNoteBook;
  final void Function({bool isNewNote}) addANote;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: InkWell(
          onTap: () {
            !isNotebook && isNotesSection
                ? addANote(isNewNote: true)
                : addNewNoteBook();
          },
          child: Text(
            isNotebook
                ? 'Add notebook'
                : isNotesSection
                    ? 'Add Note'
                    : 'Add Section',
            style: TextStyle(color: Colors.blue.shade400),
          ),
        ),
      ),
    );
  }
}
