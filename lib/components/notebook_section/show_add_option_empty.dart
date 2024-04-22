import 'package:flutter/material.dart';

class ShowAddOptionEmpty extends StatelessWidget {
  const ShowAddOptionEmpty({
    super.key,
    required this.isNoteBook,
    required this.isNotesSection,
    required this.addNewNoteBook,
    required this.addANote,
  });

  final bool isNoteBook;
  final bool isNotesSection;
  final void Function() addNewNoteBook;
  final void Function({bool isNewNote}) addANote;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: isNoteBook ? 0 : 24),
        child: Row(
          children: [
            Text(
                isNoteBook
                    ? 'There are no NoteBooks.'
                    : isNotesSection
                        ? 'There are no Notes.'
                        : 'There are no Sections',
                style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            const SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                !isNotesSection || isNoteBook
                    ? addNewNoteBook() // Creates a new section or a notebook
                    : addANote(isNewNote: true);
              },
              child: Text(
                isNoteBook
                    ? 'Add NoteBook'
                    : (isNotesSection ? 'Add a Note' : 'Add Section'),
                style: TextStyle(color: Colors.blue[700], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
