import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/main_page/drop_down_main_button.dart';
import 'package:notility/components/main_page/main_menu_app_bar.dart';
import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/widgets/notebook_section.dart';
import 'package:notility/widgets/recent_pinned_section.dart';

class LastNotes extends StatefulWidget {
  const LastNotes({
    super.key,
    required this.userId,
    required this.pinnedNotes,
    required this.recentNotes,
    required this.sharedNotes,
    required this.allNotes,
    required this.noteBooks,
    required this.addNewNoteBook,
    required this.loading,
  });

  final List<Note> pinnedNotes;
  final List<Note> recentNotes;
  final List<Note> sharedNotes;
  final List<Note> allNotes;
  final List<NoteBook> noteBooks;
  final void Function(NoteBook) addNewNoteBook;
  final bool loading;

  final String userId;
  @override
  State<LastNotes> createState() => LastNotesState();
}

class LastNotesState extends State<LastNotes> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: MainMenuAppBar(),
        actions: const [DropDownMain()],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Column(
            children: [
              RecentOrPinnedSection(
                listNotes: widget.recentNotes,
                text: 'Recent Notes',
                loading: widget.loading,
              ),
              const SizedBox(height: 25),
              RecentOrPinnedSection(
                listNotes: widget.pinnedNotes,
                text: 'Pinned Notes',
                loading: widget.loading,
              ),
              const SizedBox(height: 25),
              RecentOrPinnedSection(
                listNotes: widget.sharedNotes,
                text: 'Shared Notes',
                loading: widget.loading,
              ),
              const SizedBox(height: 25),
              NotebookSection(
                listNoteBooks: widget.noteBooks,
                allNotes: widget.allNotes,
                text: 'Your NoteBooks',
                addNoteBook: widget.addNewNoteBook,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
