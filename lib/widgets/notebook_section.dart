import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/widgets/animated_list.dart';
import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/server/mongodb.dart' as mongo;

class NotebookSection extends StatefulWidget {
  const NotebookSection({
    super.key,
    required this.listNoteBooks,
    required this.text,
    required this.addNoteBook,
    required this.allNotes,
  });

  final List<NoteBook> listNoteBooks;
  final List<Note> allNotes;
  final void Function(NoteBook noteBook) addNoteBook;
  final String text;

  @override
  State<NotebookSection> createState() => _NotebookSectionState();
}

class _NotebookSectionState extends State<NotebookSection> {
  bool _isExpanded = false;
  bool _showCreate = false;

  final TextEditingController _notebookController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  // The dialog that will show for adding new Notebook
  void _addNewNoteBook() {
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
                            'Create a new notebook',
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
                            controller: _notebookController,
                            onChanged: (content) {
                              if (_notebookController.text.isEmpty &&
                                  _showCreate) {
                                setState(() {
                                  _showCreate = false;
                                });
                              } else if (_notebookController.text.isNotEmpty &&
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
                              hintText: 'Notebook name',
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
                                _notebookController.clear();
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
                                      var newNoteBook = NoteBook(
                                        userId: user.uid,
                                        type: Type.notebook,
                                        name: _notebookController.text,
                                      );
                                      var result = await mongo.MongoDatabase
                                          .addNewNoteBookOrSection(
                                              noteBook: newNoteBook);
                                      Navigator.pop(context);
                                      if (result == 'Successfull') {
                                        widget.addNoteBook(newNoteBook);
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
        }).then((value) => _notebookController.clear());
  }

  void toggleIsExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            toggleIsExpanded();
          },
          child: Row(
            children: [
              Text(
                widget.text,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                transform: _isExpanded
                    ? Matrix4.rotationZ(3.14 / 2)
                    : Matrix4.rotationZ(0),
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[500],
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.grey[700],
        ),

        // NoteBook list
        AnimatedListSection(
          allNotes : widget.allNotes,
          isExpanded: _isExpanded,
          addNewNoteBook: _addNewNoteBook,
          listNoteBooksOrSections: widget.listNoteBooks,
          toggleIsExpanded: toggleIsExpanded,
          isNotebook: true,
          isNotesSection: false,
        ),
        const SizedBox(height: 36)
      ],
    );
  }
}
