import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/new_note/appbar.dart';
import 'package:notility/components/new_note/drop_down_move.dart';
import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/screens/audio_transcription.dart';
import 'package:notility/widgets/tags_functionality.dart';
import 'package:notility/server/mongodb.dart' as mongo;
import 'package:notility/utils.dart';


class NewNote extends StatefulWidget {
  NewNote({
    super.key,
    this.isNewNote = false,
    this.route = '',
    this.note,
    this.isParent = false,
  });

  final bool isNewNote;
  String route;
  final Note? note;
  bool isParent;

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _headingController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  final FocusNode _contentNode = FocusNode();
  String? _selectedNotebook;
  String? _selectedSection;

  Future<void> updateText() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const AudioTranscriber(title: "Audio Transcription")),
    );

    if (result != null) {
      print("transcried: $result");
      _contentController.text = "${_contentController.text}\n\n $result";
      // setState(() {});
    }
  }

  void _showNoSavingWarning(BuildContext ctx) {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text(
              'Your Note will not be saved.',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Yout current Note will not be saved as there is no ${_headingController.text.isEmpty ? 'heading' : 'content'} to your note',
              style: TextStyle(color: Colors.grey[500]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    'Return to Main',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Retry')),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      updateControllers();
      if (widget.note!.userId == user.uid) {
        widget.isParent = true;
      }
    }
    _selectedSection =
        widget.route.isEmpty ? null : parseSectionName(widget.route);
    if (widget.isNewNote && widget.route.isEmpty) {
      widget.route = 'My Notebook \\ General';
    }
  }

  void updateControllers() {
    // Called when an old note is opened
    print('Controllers being updated');
    _contentController.text = widget.note!.content;
    _headingController.text = widget.note!.heading!;
    _contentNode.requestFocus();
    setState(() {});
  }

  void onTapBackButton(BuildContext context) {
    print('Called');
    //creating route using notebook and section
    if (_headingController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      // If content is updated

      // Save in mongoDb

      widget.isNewNote
          ? mongo.MongoDatabase.insertNote(
              // If new note
              Note(
                heading: _headingController.text,
                content: _contentController.text,
                userId: FirebaseAuth.instance.currentUser!.uid,
                route: widget.route,
                notebook: parseNotebookName(widget.route),
                section: parseSectionName(widget.route),
              ),
              _selectedSection = parseSectionName(widget.route),
            )
          : mongo.MongoDatabase.updateNote(
              // If its just updated note
              noteId: widget.note!.id,
              route: widget.route,
              notebook: parseNotebookName(widget.route),
              section: parseSectionName(widget.route),
              heading: _headingController.text,
              content: _contentController.text,
            );



      Navigator.pop(
        context,
        widget.isNewNote
            ? {
                'note': Note(
                  heading: _headingController.text,
                  content: _contentController.text,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  //setting route using notebook and section
                  route: widget.route,
                  notebook: parseNotebookName(widget.route),
                  section: parseSectionName(widget.route),
                ),
                'isNew': widget.isNewNote,
              }
            : {
                'updateId': widget.note!.id,
                'heading': _headingController.text,
                'notebook': parseNotebookName(widget.route),
                'section': parseSectionName(widget.route),
                'content': _contentController.text,
                'isNew': widget.isNewNote,
                'route': widget.route,
                'delete': false,
                'isPinned': widget.note!.isPinned,
              },
      );
    } else if (_headingController.text.isEmpty &&
        _contentController.text.isEmpty) {
      // Exit as there is nothing to save
      Navigator.pop(context, {'no save': true});
    } else if (_headingController.text.isEmpty ||
        _contentController.text.isEmpty) {
      // Give warning
      _showNoSavingWarning(context);
    }
  }

  void setNewNoteBookSection({
    required String notebook,
    required String section,
  }) {
    setState(() {
      widget.route = '$notebook \\ $section';
    });
  }

  void deleteNote() {
    try {
      mongo.MongoDatabase.deleteNote(noteId: widget.note!.id);
      Navigator.pop(context);
      print('deleted successfully');
    } catch (e) {
      print("not deleted");
    }
  }

  void setIsPinned(bool isPinned) {
    widget.note!.isPinned = isPinned;
    mongo.MongoDatabase.updateNote(
      noteId: widget.note!.id,
      isPinned: isPinned,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarNewNote(
          onPressedBackButton: onTapBackButton,
          headingController: _headingController,
          contentController: _contentController,
          deleteNote: deleteNote,
          setnewNotebookSection: setNewNoteBookSection,
          route: widget.route,
          noteID: widget.note?.id,
          isNewNote: widget.isNewNote,
          isParent: widget.isParent,
          updateText: updateText,
          isPinned: widget.note != null ? widget.note!.isPinned : false,
          setIsPinned: setIsPinned,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 60),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align children to the left
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // heading
                        Container(
                          // margin:const  EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 6,
                              bottom: 6,
                            ),
                            child: TextField(
                              autocorrect: true,
                              onChanged: (text) {
                                setState(() {});
                              },
                              autofocus: true,
                              maxLines: 1,
                              // expands: true,
                              controller: _headingController,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                // have a blue border all around
                                border: InputBorder.none,
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
      
                        // content
                        Container(
                          // For content editing
                          // margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 0,
                              bottom: 40,
                            ),
                            child: TextFormField(
                              focusNode: _contentNode,
                              minLines: 40,
                              maxLines: null,
                              // expands: true,
                              controller: _contentController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Note",
                                hintStyle: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, right: 2),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            widget.route,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              // backgroundColor: Colors.grey[900],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!widget.isNewNote)
              Positioned(
                bottom: 10,
                left: 30,
                child: TagsFunctionality(
                  note: widget.note!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
