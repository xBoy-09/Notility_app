import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/screens/account_page.dart';
import 'package:notility/screens/main_screen.dart';
import 'package:notility/screens/search_screen.dart';
import 'package:notility/screens/new_note.dart';
import 'package:notility/server/mongodb.dart' as mongo;
import 'package:notility/animations/slide_page.dart';
import 'package:notility/utils.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
    this.newUser = false,
  });

  final bool newUser;

  @override
  State<TabsScreen> createState() => TabsScreenState();
  static TabsScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<TabsScreenState>();
}

class TabsScreenState extends State<TabsScreen> {
  List<Note> pinnedNotes = <Note>[];
  List<Note> recentNotes = <Note>[];
  List<Note> sharedNotes = <Note>[];
  List<Note> allNotes = <Note>[];
  List<NoteBook> noteBooks = <NoteBook>[];
  int _selectpageIndex = 0;
  bool loading = true;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // createNewuserData(userId);
    getRecentAndPinnedNotesAndNoteBooks();
    getSharedNotes();
    print(FirebaseAuth.instance.currentUser!);
    if (FirebaseAuth.instance.currentUser!.displayName == null) {
      reloadIn2();
    }
  }

  void reloadIn2() {
    Future.delayed(const Duration(seconds: 4), () {
      getRecentAndPinnedNotesAndNoteBooks();
      getSharedNotes();
      setState(() {});
    });
  }

  void getRecentAndPinnedNotesAndNoteBooks() async {
    recentNotes = await mongo.MongoDatabase.getRecentNotesForUser(
        userId: userId, limit: 8);
    pinnedNotes =
        await mongo.MongoDatabase.getPinnedNotesForUser(userId: userId);
    noteBooks = await mongo.MongoDatabase.getNoteBookOrSectionForUser(
        userId: userId, type: mongo.Type.notebook);
    allNotes = await mongo.MongoDatabase.getAllNotesForUser(
        userId: userId, sort: 'modifiedAt');
    if (allNotes.length == 0) {
      await createNewuserData(userId).then((value) async {
        getRecentAndPinnedNotesAndNoteBooks();
        setState(() {});
      });
    }
    setState(() {
      loading = false;
    });
  }

  void getSharedNotes() async {
    sharedNotes = await mongo.MongoDatabase.getSharedNotes(uid: userId);
    setState(() {
      loading = false;
    });
  }

  void addNewNoteBook(NoteBook noteBook) {
    noteBooks.insert(0, noteBook);
    setState(() {});
  }

  void addNewNote(Note note) {
    allNotes.insert(0, note);
    if (recentNotes.length < 8) {
      recentNotes.insert(0, note);
    }
    setState(() {});
  }

  void deleteNote(String noteId) {
    print('deleting locally');
    allNotes.removeWhere((note) => note.id == noteId);
    recentNotes.removeWhere((note) => note.id == noteId);
    pinnedNotes.removeWhere((note) => note.id == noteId);
    sharedNotes.removeWhere((note) => note.id == noteId);
    setState(() {});
  }

  void changeNoteRoute(String id, String route, String oldRoute) async {
    String section = parseSectionName(route);
    String oldSection = parseSectionName(oldRoute);
    await mongo.MongoDatabase.chnageSectionForNote(
      noteId: id,
      oldSectionName: oldSection,
      newSectionName: section,
    ).then((value) => setState(() {}));
  }

  void updateNote({
    delete,
    heading,
    content,
    required id,
    route,
    isPinned,
  }) {
    // Updating notes locally instead of fetching from database online everytime

    Note? removedNote;
    Note? removedPinnedNote;
    Note? removedRecentNote;
    Note? removedSharedNote;

    allNotes.removeWhere((note) {
      if (note.id == id) {
        removedNote = note;
        return true;
      }
      return false;
    });

    if (removedNote != null) {
      recentNotes.removeWhere((note) {
        if (note.id == id) {
          removedRecentNote = note;
          return true;
        }
        return false;
      });

      pinnedNotes.removeWhere((note) {
        if (note.id == id) {
          removedPinnedNote = note;
          return true;
        }
        return false;
      });

      if (removedNote!.route != route) {
        changeNoteRoute(id, route, removedNote!.route);
      }

      // Update removed notes
      removedNote!.content = content;
      removedNote!.heading = heading;
      removedNote!.route = route;
      removedNote!.notebook = parseNotebookName(route);
      removedNote!.section = parseSectionName(route);
      removedNote!.modifiedAt = DateTime.now();
      removedNote!.isPinned = isPinned;

      if (isPinned) {
        removedPinnedNote = removedNote;
      } else {
        removedPinnedNote = null;
      }

      if (removedRecentNote != null) {
        // If recent note founded, replace it to the start else remove last and add the new updated one to the start
        recentNotes.insert(0, removedNote!);
      } else {
        print('Inserting new recent note');
        recentNotes.removeLast();
        recentNotes.insert(0, removedNote!);
      }

      if (removedPinnedNote != null) {
        pinnedNotes.insert(0, removedNote!);
      }

      allNotes.insert(0, removedNote!);
      setState(() {});
    } else {
      // if shared note
      sharedNotes.removeWhere((note) {
        if (note.id == id) {
          removedSharedNote = note;
          // print("removed.");
          return true;
        }

        return false;
      });

      // Update removed notes
      removedSharedNote!.content = content;
      removedSharedNote!.heading = heading;
      removedSharedNote!.modifiedAt = DateTime.now();

      if (removedSharedNote != null) {
        sharedNotes.insert(0, removedSharedNote!);
        // print("added new.");
      }
    }

    setState(() {});
  }

  void addNotePage() {
    Navigator.of(context)
        .push(
      SlidePageRoute(
        page: NewNote(isNewNote: true),
      ),
    )
        .then((returnedVal) {
      print("returned val: ${returnedVal}");
      if (returnedVal.containsKey('no save') && returnedVal['no save']) {
      } else {
        if (returnedVal['isNew'] == true) {
          // Add note to the start of the list
          print('Reached');
          addNewNote(
            returnedVal['note'],
          );
        } else {
          TabsScreen.of(context)!.updateNote(
              id: returnedVal['updateId'],
              content: returnedVal['content'],
              heading: returnedVal['heading'],
              route: returnedVal['route']);
        }
      }
    });
  }

  @override
  Widget build(context) {
    List<Widget> pages = [
      // List for pages (Added same page for now)
      LastNotes(
        userId: userId,
        pinnedNotes: pinnedNotes,
        recentNotes: recentNotes,
        sharedNotes: sharedNotes,
        allNotes: allNotes,
        noteBooks: noteBooks,
        addNewNoteBook: addNewNoteBook,
        loading: loading,
      ),
      SearchScreen(listNotes: allNotes),

      // Change when account page is added

      const AccountScreen(),

      // Change when account page is added
      LastNotes(
        userId: userId,
        pinnedNotes: pinnedNotes,
        recentNotes: recentNotes,
        sharedNotes: sharedNotes,
        allNotes: allNotes,
        noteBooks: noteBooks,
        addNewNoteBook: addNewNoteBook,
        loading: loading,
      ),
    ];
    Widget activePage = pages.elementAt(_selectpageIndex);
    if (_selectpageIndex == 3 || _selectpageIndex == 0) {
      _selectpageIndex = 0;
    }
    return PopScope(
      onPopInvoked: (didPop) => SystemNavigator.pop(),
      child: Scaffold(
        body: Stack(
          children: [
            activePage,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // Handle all Bottom navigation bar
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                    // Light grey Outline
                    border: Border(
                        top: BorderSide(color: Colors.grey[800]!, width: 0.6))),
                child: GNav(
                  onTabChange: (index) => setState(() {
                    _selectpageIndex = index;
                  }),
                  selectedIndex: _selectpageIndex,
                  haptic: true,
                  duration: const Duration(
                      milliseconds: 500), // Animated change in tab
                  backgroundColor: Theme.of(context).colorScheme.background,
                  activeColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor, // Selected item color
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedIconTheme!
                      .color, // In active icon colors
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  gap: 8,
                  iconSize: 30,
                  tabs: [
                    // Settings up icons and buttons
                    const GButton(icon: Icons.menu, text: 'Menu'),
                    const GButton(icon: Icons.search_rounded, text: 'Search'),
                    const GButton(icon: Icons.person, text: 'Account'),
                    GButton(
                      icon: Icons.add_circle_outline_sharp,
                      text: 'New Note',
                      onPressed: addNotePage,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        // bottomNavigationBar:
      ),
    );
  }
}
