import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/notebook_section/show_add_option.dart';
import 'package:notility/components/notebook_section/show_add_option_empty.dart';
import 'package:notility/components/notebook_section/tile.dart';
import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/screens/new_note.dart';
import 'package:notility/screens/tabs_screen.dart';
import 'package:notility/server/mongodb.dart' as mongo;
import 'package:notility/animations/slide_page.dart';

class AnimatedListSection extends StatefulWidget {
  const AnimatedListSection({
    super.key,
    required this.isExpanded,
    required this.toggleIsExpanded,
    required this.listNoteBooksOrSections,
    required this.addNewNoteBook,
    required this.allNotes,
    this.isNotebook = false,
    this.isNotesSection = false,
    this.noteBookName = "",
  });

  final bool isExpanded;
  final void Function() toggleIsExpanded;
  final List<NoteBook> listNoteBooksOrSections;
  final void Function() addNewNoteBook;
  final bool isNotebook;
  final bool isNotesSection;
  final String noteBookName;
  final List<Note> allNotes;

  @override
  State<AnimatedListSection> createState() => _AnimatedListSectionState();
}

class _AnimatedListSectionState extends State<AnimatedListSection> {
  void addANote({
    Note? note,
    bool isNewNote = false,
  }) {
    Navigator.of(context)
        .push(
      SlidePageRoute(
        page: NewNote(
          isNewNote: isNewNote,
          note: note,
          route: widget.noteBookName,
        ),
      ),
    )
        .then((value) {
      if (value['isNew'] == true) {
        // Add note to the start of the list
        print('After then new note is added');
        TabsScreen.of(context)!.addNewNote(value['note']);
      } else {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: widget.isExpanded
          ? null //(50 * widget.listNoteBooksOrSections.length).toDouble() + 40
          : 0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.listNoteBooksOrSections.isEmpty) ...[
              // Goes in if there are no notebooks or sections to show (only notes)
              if (widget.allNotes.isEmpty) ...[
                // When nothing is there even when no notes there
                ShowAddOptionEmpty(
                    isNoteBook: widget.isNotebook,
                    isNotesSection: widget.isNotesSection,
                    addNewNoteBook: widget.addNewNoteBook,
                    addANote: addANote),
                const SizedBox(height: 20)
              ] // End if
              else ...[
                // Show all notes of the section
                for (final note in widget.allNotes) ...[
                  ShowNoteBooks(
                    isNoteBook: false,
                    noteBookName: widget.noteBookName,
                    allNotes: widget.allNotes,
                    note: note,
                    expand: false,
                    openANote: addANote,
                  )
                ], // End for
                ShowAddOption(
                    isNotebook: widget.isNotebook,
                    isNotesSection: widget.isNotesSection,
                    addNewNoteBook: widget.addNewNoteBook,
                    addANote: addANote),
              ] // End else
            ] // End If
            else ...[
              // If there are any notebooks or sections
              for (final noteBookOrSections
                  in widget.listNoteBooksOrSections) ...[
                ShowNoteBooks(
                    allNotes: widget.allNotes
                        .where((note) =>
                            noteBookOrSections.name ==
                            (widget.isNotebook ? note.notebook : note.section))
                        .toList(),
                    noteBook: noteBookOrSections,
                    isNoteBook: widget.isNotebook,
                    isNote: widget.isNotebook,
                    noteBookName: widget.noteBookName +
                        (widget.noteBookName.isNotEmpty ? ' \\ ' : '') +
                        noteBookOrSections.name),
              ], // end for

              ShowAddOption(
                  isNotebook: widget.isNotebook,
                  isNotesSection: widget.isNotesSection,
                  addNewNoteBook: widget.addNewNoteBook,
                  addANote: addANote),
            ], // end else
          ],
        ),
      ),
    );
  }
}

class ShowNoteBooks extends StatefulWidget {
  const ShowNoteBooks({
    super.key,
    this.noteBook,
    required this.isNoteBook,
    this.isNote = false,
    required this.noteBookName,
    required this.allNotes,
    this.expand = true,
    this.note,
    this.openANote,
  });

  final NoteBook? noteBook;
  final bool isNoteBook;
  final bool isNote;
  final String noteBookName;
  final List<Note> allNotes;
  final bool expand;
  final Note? note;
  final void Function({Note? note})? openANote;

  @override
  State<ShowNoteBooks> createState() => ShowNoteBooksState();
}

class ShowNoteBooksState extends State<ShowNoteBooks> {
  bool _isExpanded = false;
  List<NoteBook> sections = <NoteBook>[];
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _sectionController = TextEditingController();
  bool _showCreate = false;

  void toggleIsExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void getSections() async {
    // print('getting Sections');
    sections = await mongo.MongoDatabase.getNoteBookOrSectionForUser(
        userId: user.uid.toString(),
        type: mongo.Type.section,
        sections: widget.noteBook!.listChildIds);
    // print('got sections for notebook : ${widget.noteBook!.name}');
    setState(() {});
  }

  void _addSectionInList(NoteBook newSection) {
    sections.insert(0, newSection);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.isNoteBook) getSections();
  }

  void _addNewSection() {
    // Make a dialog box to add a new section
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Center(
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 94),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    // height: 180,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Create a new section',
                            style: TextStyle(
                                fontFamily: 'Noto Sans Ol Chiki ',
                                color: Colors.grey[300],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Feild for adding the name
                        Flexible(
                          child: TextField(
                            controller: _sectionController,
                            onChanged: (content) {
                              if (_sectionController.text.isEmpty &&
                                  _showCreate) {
                                setState(() {
                                  _showCreate = false;
                                });
                              } else if (_sectionController.text.isNotEmpty &&
                                  !_showCreate) {
                                setState(() {
                                  _showCreate = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(bottom: 3),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]!)),
                              hintText: 'Section name',
                              hintStyle: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                              isCollapsed: true,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Adding Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _sectionController.clear();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'CANCEL',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: _showCreate
                                  ? () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator()));
                                      var newSection = NoteBook(
                                        userId: user.uid,
                                        type: Type.section,
                                        name: _sectionController.text,
                                      );
                                      var result = await mongo.MongoDatabase
                                          .addNewNoteBookOrSection(
                                              noteBook: newSection,
                                              noteBookId: widget.noteBook!.id);
                                      Navigator.pop(context);
                                      if (result == 'Successfull') {
                                        _addSectionInList(newSection);
                                      }
                                      Navigator.pop(context);
                                      print(result);
                                    }
                                  : null,
                              child: Text(
                                'CREATE',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _showCreate
                                      ? Colors.blue
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).then((value) => _sectionController.clear());
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     'With isNoteBook : ${widget.isNoteBook} => name : ${widget.noteBookName}');
    // for (var note in widget.allNotes) {
    //   print('Note : ${note.heading}');
    // }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isNoteBook ? 12 : 18,
      ),
      child: Column(
        children: [
          Tile(
            heading: widget.noteBook?.name ?? widget.note!.heading!,
            toggleIsExpanded: toggleIsExpanded,
            note: widget.note,
            isNotebookNull: widget.noteBook == null,
            expand: widget.expand,
            isExpanded: _isExpanded,
            isNoteBook: widget.isNoteBook,
            openANote: widget.openANote,
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey[800],
          ),
          if (widget.expand) // Stops at notes
            AnimatedListSection(
              isExpanded: _isExpanded,
              toggleIsExpanded: toggleIsExpanded,
              listNoteBooksOrSections: sections,
              addNewNoteBook: _addNewSection,
              isNotesSection: !widget.isNoteBook,
              noteBookName: widget.noteBookName,
              allNotes: widget.allNotes,
            )
        ],
      ),
    );
  }
}
