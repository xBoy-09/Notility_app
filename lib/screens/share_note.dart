import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notility/server/mongodb.dart';

class ShareNote extends StatefulWidget {
  final String noteId; // Added noteId parameter
  final List<String> emails; // list of emails

  ShareNote({Key? key, required this.noteId, required this.emails})
      : super(key: key);

  @override
  _ShareNoteState createState() => _ShareNoteState();
}

class _ShareNoteState extends State<ShareNote> {
  final User user = FirebaseAuth.instance.currentUser!;
  String? emailCurrent = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // go back
                },
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
              ),
              Text(
                // title text
                'Share Notes',
                style: TextStyle(
                  fontFamily: 'Amiko',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.2,
                  color: Colors.grey[600],
                ),
              ),
              Divider(
                // line
                height: 1,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.emails.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (widget.emails[index] != emailCurrent) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.grey[100],
                                ),
                                onPressed: () async {
                                  String lol =
                                      await MongoDatabase.addSharedNoteId(
                                          widget.emails[index], widget.noteId);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        titleTextStyle: const TextStyle(
                                            color: Colors.white),
                                        contentTextStyle: const TextStyle(
                                            color: Colors.white),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        title: const Text('Alert'),
                                        content: Text(lol),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child:
                                    Text("Share with ${widget.emails[index]}"),
                              ),
                            ),
                            // Second button
                            SizedBox(width: 10), // Adjust as needed for spacing
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.grey),
                                ),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.grey[100],
                              ),
                              onPressed: () async {
                                // Handle second button tap
                                String lol =
                                    await MongoDatabase.removeSharedNoteId(
                                        widget.emails[index], widget.noteId);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      titleTextStyle:
                                          const TextStyle(color: Colors.white),
                                      contentTextStyle:
                                          const TextStyle(color: Colors.white),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      title: const Text('Alert'),
                                      content: Text(lol),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                  "Unshare"), // Change to desired icon
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
