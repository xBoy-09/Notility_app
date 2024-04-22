import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/components/new_note/drop_down_move.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/screens/chatbot.dart';
import 'package:notility/screens/share_note.dart';
import 'package:notility/server/mongodb.dart' as mongo;
import 'package:notility/utils.dart';
import 'package:notility/server/chatgpt.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AppBarNewNote extends StatelessWidget implements PreferredSizeWidget {
  AppBarNewNote({
    super.key,
    required this.onPressedBackButton,
    required this.headingController,
    required this.contentController,
    required this.deleteNote,
    required this.route,
    required this.setnewNotebookSection,
    required this.noteID,
    required this.isNewNote,
    required this.isParent,
    required this.isPinned,
    required this.updateText,
    required this.setIsPinned,
  });

  final TextEditingController headingController;
  final TextEditingController contentController;
  final void Function(BuildContext) onPressedBackButton;
  final void Function()? deleteNote;
  String route;
  final void Function({required String notebook, required String section})
      setnewNotebookSection;
  final String? noteID;
  final bool isNewNote;
  final bool isParent;
  late List<String> currentSectionNames;
  late NoteBook currentNotebookObj;
  late String? currentSectionName; // Name to show when a notebook is selected
  final Future<void> Function() updateText;
  final bool isPinned;
  final void Function(bool) setIsPinned;
  final User user = FirebaseAuth.instance.currentUser!;

  final openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 25)),
      enableLog: true);

  void giveHeadings() async {
    String prompt =
        "Give this text headings, while keeping the original text the same. return the original text with headings applied: \n";
    String contento = prompt + contentController.text;
    // String contento = contentController.text;
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": contento}),
    ], maxToken: 3000, model: GptTurbo0301ChatModel());

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
      contentController.text = element.message?.content ?? '';
      // responso = element.message?.content;
    }
  }

  void giveTitle() async {
    String prompt = "\n give this text a title";
    String contento = contentController.text + prompt;
    // String contento = contentController.text;
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": contento}),
    ], maxToken: 200, model: GptTurbo0301ChatModel());

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
      headingController.text = element.message?.content ?? '';
      // responso = element.message?.content;
    }
  }

  void showSummaryDialog(BuildContext context, String summary) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Summary"),
          content: Text(summary),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Disregard the response
              },
              child: Text("Disregard"),
            ),
            TextButton(
              onPressed: () {
                // for saving, append the summary to the end of the content
                String summer = "\n\nSummary \n$summary";
                contentController.text = contentController.text + summer;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void summaryGenerator(context) async {
    String prompt = "\n summarize this text.";
    String contento = contentController.text + prompt;
    // String contento = contentController.text;
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": contento}),
    ], maxToken: 500, model: GptTurbo0301ChatModel());

    try {
      final response = await openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        String summary = element.message?.content ?? '';
        print("data -> $summary");
        showSummaryDialog(context, summary);
        // responso = element.message?.content;
      }
    } catch (e) {
      print('Error in summary generator : $e');
    }
  }

  void setCurrentSectionNames(
    String notebookName,
    List<NoteBook> notebookList,
    List<NoteBook> sectionList,
  ) {
    print('Setting current section names for notebook: $notebookName');
    for (final name in notebookList) {
      print(name.name);
    }
    currentNotebookObj =
        notebookList.firstWhere((notebook) => notebook.name == notebookName);

    currentSectionNames = sectionList
        .where(
            (section) => currentNotebookObj.listChildIds.contains(section.id))
        .map((e) => e.name)
        .toList();

    currentSectionNames.isEmpty ? currentSectionNames.add('No sections') : null;
    currentSectionName = currentSectionNames.first;

    printNames(currentSectionNames);
  }

  void printNames(List<String> names) {
    for (var name in names) {
      print(name);
    }
  }

  onTapChangeLocation(ctx) async {
    if (isNewNote) {
      route = 'Notes \\ School';
    }
    final notebookList = await mongo.MongoDatabase.getNoteBookOrSectionForUser(
        userId: user.uid, type: mongo.Type.notebook);

    final notebookNames =
        notebookList.map((notebook) => notebook.name).toList();

    final sectionList = await mongo.MongoDatabase.getNoteBookOrSectionForUser(
        userId: user.uid, type: mongo.Type.section);

    final sectionNames = sectionList.map((section) => section.name).toList();

    final currentNotebook;

    currentNotebook = parseNotebookName(route);
    // print(' ROUTE:   $route');
    print(' Current notebook setting to:   $currentNotebook');
    setCurrentSectionNames(currentNotebook, notebookList, sectionList);
    // print(' seclistooo:   $currentSectionName');
    // print(' notlistooo:   $notebookList');
    String finalSection = '';
    String finalNotebook = '';

    void setNoteBookSection(String name, bool isNotebook) {
      if (isNotebook) {
        finalNotebook = name;
      } else {
        finalSection = name;
      }
    }

    showDialog(
      context: ctx,
      builder: ((context) => StatefulBuilder(builder: (context, setState) {
            void reloadSections(notebookname) {
              setState(() {
                setCurrentSectionNames(notebookname, notebookList, sectionList);
                // printNames(currentSectionNames);
              });
            }

            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change location',
                    style: TextStyle(color: Colors.grey[100], fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Move to another notebook and section',
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                  const SizedBox(height: 12),

                  // NOTEBOOK
                  Text(
                    'Notebook',
                    style: TextStyle(color: Colors.grey[100], fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  DropDownMove(
                    route: route,
                    listNames: notebookNames,
                    isNotebook: true,
                    setSections: reloadSections,
                    setNoteBookSection: setNoteBookSection,
                  ),
                  const SizedBox(height: 12),
                  // SECTION
                  Text(
                    'Section',
                    style: TextStyle(color: Colors.grey[100], fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  DropDownMove(
                    route: route,
                    listNames: currentSectionNames,
                    setSections: reloadSections,
                    currentSectionName: currentSectionName,
                    setNoteBookSection: setNoteBookSection,
                  ),

                  // ACTIONS
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey[100]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (!currentSectionNames.contains('No sections')) {
                            print(
                                'Setting notebook : $finalNotebook and section : $finalSection');
                            if (finalNotebook.isNotEmpty &&
                                finalSection.isNotEmpty) {
                              setnewNotebookSection(
                                notebook: finalNotebook,
                                section: finalSection,
                              );
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Move',
                          style: TextStyle(
                              color: currentSectionNames.contains('No sections')
                                  ? Colors.grey[600]
                                  : Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: Colors.grey[800],
          height: 0.8,
          margin: const EdgeInsets.only(bottom: 8),
        ),
      ),
      scrolledUnderElevation: 0,
      toolbarHeight: 48,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: IconButton(
        // Pressing the back button
        onPressed: () => onPressedBackButton(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
      leadingWidth: 48, // Size after leading
      titleSpacing: 0, // Size before text
      title: Text(
        headingController.text.isEmpty
            ? 'Heading'
            : headingController.text.length > 18
                ? '${headingController.text.substring(0, 18)}...'
                : headingController.text,
        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuEntry<Object>>[
              PopupMenuItem(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatbotMode(
                            content: contentController.text,
                          )),
                ),
                value: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.chat_bubble, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      "Ask GPT",
                      style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => giveHeadings(),
                value: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.edit_document, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      "AI Topics",
                      style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => giveTitle(),
                value: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.title, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      "AI Title",
                      style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => summaryGenerator(context),
                value: 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.summarize, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      "AI Summary",
                      style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 7,
                onTap: () {
                  updateText();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.mic_sharp, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Text(
                      "Audio Transcription",
                      style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
                    ),
                  ],
                ),
              ),
            ];
          },
          icon: Image.asset('assets/images/chat-gpt.png', width: 24),
          color: Colors.grey[800],
        ),
        if (isParent || noteID == null)
          IconButton(
            onPressed: () async {
              if (noteID != null) {
                List<String> emails = await mongo.MongoDatabase.getAllEmails();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShareNote(noteId: noteID!, emails: emails),
                  ),
                );
              } else {
                // if no noteID meaning that its a newNote
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      titleTextStyle: const TextStyle(color: Colors.white),
                      contentTextStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      title: const Text('Alert'),
                      content: const Text("Cannot share a new note!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          itemBuilder: (ctx) {
            return <PopupMenuEntry<Object>>[
              if (isParent)
                PopupMenuItem(
                  onTap: () {
                    setIsPinned(!isPinned);
                  },
                  value: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                          color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text(
                        isPinned ? "Unpin Note" : "Pin Note",
                        style:
                            TextStyle(color: Colors.grey[100], fontSize: 15.5),
                      ),
                    ],
                  ),
                ),
              if (isParent ||
                  noteID == null) // show share only if you are note author
                PopupMenuItem(
                  onTap: () => onTapChangeLocation(ctx),
                  value: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.move_up, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text(
                        "Change location",
                        style:
                            TextStyle(color: Colors.grey[100], fontSize: 15.5),
                      ),
                    ],
                  ),
                ),
              if (isParent ||
                  noteID == null) // show delete button if you are note author
                PopupMenuItem(
                  onTap: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: ((context) =>
                            const Center(child: CircularProgressIndicator())),
                      );
                      await mongo.MongoDatabase.deleteNote(noteId: noteID!)
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context, {
                          'isNewNote': isNewNote,
                          'delete': true,
                          'id': noteID,
                        });
                      });
                      print('deleted successfully');
                    } catch (e) {
                      print("not deleted");
                    }
                  },
                  value: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.delete_outlined, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text(
                        "Delete",
                        style:
                            TextStyle(color: Colors.grey[100], fontSize: 15.5),
                      ),
                    ],
                  ),
                ),
              if (!isParent &&
                  noteID !=
                      null) // show Lose Access button if the note is shared
                PopupMenuItem(
                  onTap: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: ((context) =>
                            const Center(child: CircularProgressIndicator())),
                      );
                      await mongo.MongoDatabase.removeSharedNoteId(
                              user.email!, noteID!)
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context, {
                          'isNewNote': isNewNote,
                          'delete': true,
                          'id': noteID,
                        });
                      });
                      print('deleted successfully');
                    } catch (e) {
                      print("not deleted");
                    }
                  },
                  value: 9,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.delete_outlined, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text(
                        "Lose Parent Access",
                        style:
                            TextStyle(color: Colors.grey[100], fontSize: 15.5),
                      ),
                    ],
                  ),
                ),
              // PopupMenuItem(
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ChatbotMode(
              //               content: contentController.text,
              //             )),
              //   ),
              //   value: 3,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Icon(Icons.chat_bubble, color: Colors.grey[400]),
              //       const SizedBox(width: 12),
              //       Text(
              //         "Ask GPT",
              //         style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
              //       ),
              //     ],
              //   ),
              // ),
              // PopupMenuItem(
              //   onTap: () => giveHeadings(),
              //   value: 4,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Icon(Icons.edit_document, color: Colors.grey[400]),
              //       const SizedBox(width: 12),
              //       Text(
              //         "AI Topics",
              //         style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
              //       ),
              //     ],
              //   ),
              // ),
              // PopupMenuItem(
              //   onTap: () => giveTitle(),
              //   value: 5,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Icon(Icons.title, color: Colors.grey[400]),
              //       const SizedBox(width: 12),
              //       Text(
              //         "AI Title",
              //         style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
              //       ),
              //     ],
              //   ),
              // ),
              // PopupMenuItem(
              //   onTap: () => summaryGenerator(context),
              //   value: 6,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Icon(Icons.summarize, color: Colors.grey[400]),
              //       const SizedBox(width: 12),
              //       Text(
              //         "AI Summary",
              //         style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
              //       ),
              //     ],
              //   ),
              // ),
              // PopupMenuItem(
              //   value: 7,
              //   onTap: () {
              //     updateText();
              //   },
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Icon(Icons.mic_sharp, color: Colors.grey[400]),
              //       const SizedBox(width: 12),
              //       Text(
              //         "Audio Transcription",
              //         style: TextStyle(color: Colors.grey[100], fontSize: 15.5),
              //       ),
              //     ],
              //   ),
              // ),
            ];
          },
          icon: Icon(
            Icons.more_vert_rounded,
            color: Colors.grey[300],
          ),
          color: Colors.grey[800],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
